# Isentropic relation (Anderson Book 8.4x)

"""
    t0_over_t(M::Real, gamma::Real=1.4)

마하수 M 일때 정체 온도비

# Arguments
- `M::Real`: 마하수
- `gamma::Real=1.4`: 비열비

# Returns
- `t0::Float64`: 정체 온도비
"""
function t0_over_t(M::Real, gamma::Real=1.4)
    return 1 + 0.5 * (gamma - 1) * M^2
end

"""
    p0_over_p(M::Real, gamma::Real=1.4)

마하수 `M` 일때 정체 압력비

# Arguments
- `M::Real`: 마하수
- `gamma::Real=1.4`: 비열비

# Returns
- `p0::Float64`: 정체 압력비
"""
function p0_over_p(M::Real, gamma::Real=1.4)
    t = t0_over_t(M, gamma)
    return t^(gamma / (gamma - 1))
end

"""
    rho0_over_rho(M::Real, gamma::Real=1.4)

마하수 `M` 일때 정체 밀도비

# Arguments
- `M::Real`: 마하수
- `gamma::Real=1.4`: 비열비

# Returns
- `rho0::Float64`: 정체 밀도비
"""
function rho0_over_rho(M::Real, gamma::Real=1.4)
    t = t0_over_t(M, gamma)
    return t^(1 / (gamma - 1))
end