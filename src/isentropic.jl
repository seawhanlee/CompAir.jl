# Isentropic relation (Anderson Book 8.4x)

"""
    t0_over_t(M::Real, gamma::Real=1.4)

Calculates the total-to-static temperature ratio for a given Mach number.

# Arguments
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `t0/t::Float64`: Total-to-static temperature ratio
"""
function t0_over_t(M::Real, gamma::Real=1.4)
    return 1 + 0.5 * (gamma - 1) * M^2
end

"""
    p0_over_p(M::Real, gamma::Real=1.4)

Calculates the total-to-static pressure ratio for a given Mach number.

# Arguments
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `p0/p::Float64`: Total-to-static pressure ratio
"""
function p0_over_p(M::Real, gamma::Real=1.4)
    t = t0_over_t(M, gamma)
    return t^(gamma / (gamma - 1))
end

"""
    rho0_over_rho(M::Real, gamma::Real=1.4)

Calculates the total-to-static density ratio for a given Mach number.

# Arguments
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `rho0/rho::Float64`: Total-to-static density ratio
"""
function rho0_over_rho(M::Real, gamma::Real=1.4)
    t = t0_over_t(M, gamma)
    return t^(1 / (gamma - 1))
end