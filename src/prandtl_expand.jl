import Roots

"""
    prandtl_meyer(M, gamma=1.4)

Calculates the Prandtl-Meyer function ν for a given Mach number.

# Arguments
- `M::Float64`: Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `nu::Float64`: Prandtl-Meyer function value (degrees)
"""
function prandtl_meyer(M, gamma=1.4)
    gamma_ratio = sqrt((gamma + 1) / (gamma - 1))
    mach_squared_minus_one = sqrt(M^2 - 1)
    angle_radians = gamma_ratio * atan(mach_squared_minus_one / gamma_ratio) - atan(mach_squared_minus_one)
    return rad2deg(angle_radians)
end

"""
    expand_mach2(M1, theta, gamma=1.4)

Calculates the Mach number after a flow with Mach number M1 turns through an angle theta
via a Prandtl-Meyer expansion wave.

# Arguments
- `M1::Float64`: Initial Mach number
- `theta::Float64`: Flow turning angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `mach::Float64`: Mach number after the expansion wave
"""
function expand_mach2(M1, theta, gamma=1.4)
    initial_prandtl_meyer = prandtl_meyer(M1, gamma)
    final_prandtl_meyer = initial_prandtl_meyer + theta

    mach_objective(M) = prandtl_meyer(M, gamma) - final_prandtl_meyer
    return Roots.find_zero(mach_objective, M1)
end

"""
    expand_p2(M1, theta, gamma=1.4)

Calculates the pressure ratio after a flow with Mach number M1 turns through an angle theta
via a Prandtl-Meyer expansion wave.

# Arguments
- `M1::Float64`: Initial Mach number
- `theta::Float64`: Flow turning angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p::Float64`: Pressure ratio across the expansion wave (p₁/p₂)
"""
function expand_p2(M1, theta, gamma=1.4)
    M2 = expand_mach2(M1, theta, gamma)
    return total_to_static_pressure_ratio(M1, gamma) / total_to_static_pressure_ratio(M2, gamma)
end

"""
    theta_p(pratio, M1, gamma=1.4)

Calculates the flow turning angle that produces a given pressure ratio
through a Prandtl-Meyer expansion wave.

# Arguments
- `pratio::Float64`: Pressure ratio across the expansion wave (p₁/p₂)
- `M1::Float64`: Initial Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `theta::Float64`: Flow turning angle (degrees)
"""
function theta_p(pratio, M1, gamma=1.4)
    pressure_objective(turning_angle) = expand_p2(M1, turning_angle, gamma) - pratio
    return Roots.find_zero(pressure_objective, 0.1)
end
