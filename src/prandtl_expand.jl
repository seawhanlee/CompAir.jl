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
    gratio = sqrt((gamma + 1) / (gamma - 1))
    fm = sqrt(M^2 - 1)
    rad = gratio * atan(fm / gratio) - atan(fm)
    return rad2deg(rad)
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
    nu1 = prandtl_meyer(M1, gamma)
    nu2 = nu1 + theta

    f(M) = prandtl_meyer(M, gamma) - nu2
    return Roots.find_zero(f, M1)
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
    f(theta) = expand_p2(M1, theta, gamma) - pratio
    return Roots.find_zero(f, 0.1)
end
