import Roots
import Optim
import Optim: Brent

"""
    _tangent_theta(beta_r::Real, M::Real, gamma::Real=1.4)

Internal function to calculate the tangent of the wedge angle `θ` using the oblique shock wave angle `β` and Mach number `M`.

# Arguments
- `beta_r::Real`: Oblique shock wave angle (radians)
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Float64`: Value of tan(θ)
"""
function _tangent_theta(beta_r::Real, M::Real, gamma::Real=1.4)
    return 2 / tan(beta_r) * ((M * sin(beta_r))^2 - 1) / (M^2 * (gamma + cos(2 * beta_r)) + 2)
end

"""
    theta_beta(beta::Real, M::Real, gamma::Real=1.4)

Calculates the wedge angle `θ` using the `θ-β-M` relation given the shock angle `β` and Mach number `M`.

# Arguments
- `beta::Real`: Oblique shock wave angle (degrees)
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `theta::Float64`: Wedge angle (degrees)
"""
function theta_beta(beta::Real, M::Real, gamma::Real=1.4)
    # Input validation
    if beta == 0.0 || beta == 90.0
        throw(DomainError(beta, "beta must be between 0 and 90 degrees, exclusive."))
    end
    if M <= 0.0
        throw(DomainError(M, "Mach number M must be positive."))
    end

    # Convert deg to rad
    beta_r = deg2rad(beta)

    # With Theta-Beta-M
    tan_theta = _tangent_theta(beta_r, M, gamma)

    return rad2deg(atan(tan_theta))
end

"""
    _beta_weak(M::Real, theta::Real, gamma::Real=1.4)

Internal function to calculate the weak oblique shock wave angle `β` using the Mach number `M` and wedge angle `θ`.
Solves numerically using the Newton-Raphson method.

# Arguments
- `M::Real`: Upstream Mach number
- `theta::Real`: Wedge angle (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Float64`: Oblique shock wave angle (radians)
"""
function _beta_weak(M::Real, theta::Real, gamma::Real=1.4)
    # Convert deg to rad
    theta_r = deg2rad(theta)

    beta_objective(beta_angle) = _tangent_theta(beta_angle, M, gamma) - tan(theta_r)

    # Solve theta-beta-M using Newton-Raphson method
    return Roots.find_zero(beta_objective, 1e-3)
end

"""
    oblique_beta_weak(M::Real, theta::Real, gamma::Real=1.4)

Numerically calculates the weak oblique shock wave angle `β` using the `θ-β-M` relation
for a given Mach number `M` and wedge angle `θ`.

# Arguments
- `M::Real`: Upstream Mach number
- `theta::Real`: Wedge angle (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `beta::Float64`: Oblique shock wave angle (degrees)
"""
function oblique_beta_weak(M::Real, theta::Real, gamma::Real=1.4)
    # Convert rad to deg
    return rad2deg(_beta_weak(M, theta, gamma))
end

"""
    theta_max(M::Real, gamma::Real=1.4)

Calculates the maximum wedge angle `θ` for which a weak shock solution exists in the `θ-β-M` relation
for a given Mach number `M`.

# Arguments
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `theta::Float64`: Maximum wedge angle (degrees)
"""
function theta_max(M::Real, gamma::Real=1.4)
    # Maximize tangent theta
    negative_tan_theta(beta_angle) = -_tangent_theta(beta_angle, M, gamma)

    # Optimization using Optim package
    # Use Brent's method for 1D optimization
    optimization_result = Optim.optimize(negative_tan_theta, 0.0, pi/2, Brent())

    # Get the maximum value of tangent theta
    tan_theta_max = -Optim.minimum(optimization_result)

    return rad2deg(atan(tan_theta_max))
end

function _Mn1(M::Real, beta_r::Real, gamma::Real=1.4)
    return M * sin(beta_r)
end

"""
    Mn1(M::Real, theta::Real, gamma::Real=1.4)

Calculates the Mach number component normal to the oblique shock wave for a given
Mach number `M` and wedge angle `θ`.

# Arguments
- `M::Real`: Upstream Mach number
- `theta::Real`: Wedge angle (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Mn1::Float64`: Normal component of Mach number upstream of the shock
"""
function Mn1(M::Real, theta::Real, gamma::Real=1.4)
    # Get beta in rad
    beta_r = _beta_weak(M, theta, gamma)

    return _Mn1(M, beta_r, gamma)
end

"""
    oblique_mach2(M::Real, theta::Real, gamma::Real=1.4)

Calculates the Mach number downstream of an oblique shock wave for a given
upstream Mach number `M` and wedge angle `θ`.

# Arguments
- `M::Real`: Upstream Mach number
- `theta::Real`: Wedge angle (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `M2::Float64`: Downstream Mach number
"""
function oblique_mach2(M::Real, theta::Real, gamma::Real=1.4)
    # Get beta in rad
    beta_r = _beta_weak(M, theta, gamma)

    # Normal component of M1
    Mn1 = _Mn1(M, beta_r, gamma)

    # Normal shock relation
    Mn2 = mach_after_normal_shock(Mn1, gamma)

    theta_r = deg2rad(theta)

    # Compute M2
    return Mn2 / sin(beta_r - theta_r)
end

"""
    solve_oblique(M::Real, theta::Real, gamma::Real=1.4)

Calculates the flow properties downstream of an oblique shock wave for a given
upstream Mach number `M` and wedge angle `θ`.

# Arguments
- `M::Real`: Upstream Mach number
- `theta::Real`: Wedge angle (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
A `NamedTuple` containing:
- `M2::Float64`: Downstream Mach number
- `rho2_ratio::Float64`: Density ratio across the shock (ρ₂/ρ₁)
- `p2_ratio::Float64`: Pressure ratio across the shock (p₂/p₁)
- `p0_ratio::Float64`: Total pressure ratio across the shock (p₀₂/p₀₁)
- `beta::Float64`: Oblique shock wave angle (degrees)
"""
function solve_oblique(M::Real, theta::Real, gamma::Real=1.4)
    if theta < theta_max(M, gamma)
        beta_r = _beta_weak(M, theta, gamma)
    else
        println("Bow shock occured at M=$(round(M, digits=3)), theta=$(round(theta, digits=3))")
        beta_r = pi / 2
    end
    # Get beta in rad
    beta = rad2deg(beta_r)

    # Normal component of M1
    Mn1 = _Mn1(M, beta_r, gamma)

    # Normal shock relation
    sol = solve_normal(Mn1, gamma)
    Mn2, rho2, p2, p0ratio = sol.M2, sol.rho2_ratio, sol.p2_ratio, sol.p0_ratio

    # Compute M2
    theta_r = deg2rad(theta)
    M2 = Mn2 / sin(beta_r - theta_r)

    return (M2=M2, rho2_ratio=rho2, p2_ratio=p2, p0_ratio=p0ratio, beta=beta)
end