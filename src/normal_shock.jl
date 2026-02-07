"""
    ns_mach2(M::Float64, gamma::Float64=1.4)

Calculates the Mach number after a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `mach::Float64`: Downstream Mach number
"""
function ns_mach2(M::Float64, gamma::Float64=1.4)
    return sqrt((1 + 0.5 * (gamma - 1) * M^2) / (gamma * M^2 - 0.5 * (gamma - 1)))
end

"""
    ns_rho2_over_rho1(M::Float64, gamma::Float64=1.4)

Calculates the density ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `rho2/rho1::Float64`: Density ratio
"""
function ns_rho2_over_rho1(M::Float64, gamma::Float64=1.4)
    return (gamma + 1) * M^2 / (2 + (gamma - 1) * M^2)
end

"""
    ns_p2_over_p1(M::Float64, gamma::Float64=1.4)

Calculates the pressure ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p2/p1::Float64`: Pressure ratio
"""
function ns_p2_over_p1(M::Float64, gamma::Float64=1.4)
    return 1 + 2 * gamma / (gamma + 1) * (M^2 - 1)
end

"""
    ns_t2_over_t1(M::Float64, gamma::Float64=1.4)

Calculates the temperature ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `t2/t1::Float64`: Temperature ratio
"""
function ns_t2_over_t1(M::Float64, gamma::Float64=1.4)
    return ns_p2_over_p1(M, gamma) / ns_rho2_over_rho1(M, gamma)
end

"""
    ns_p02(M::Float64, gamma::Float64=1.4)

Calculates the total pressure after a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p02::Float64`: Total pressure after the shock
"""
function ns_p02(M::Float64, gamma::Float64=1.4)
    p2 = ns_p2_over_p1(M, gamma)
    M2 = ns_mach2(M, gamma)
    return p0_over_p(M2, gamma) * p2
end

"""
    ns_p02_over_p01(M::Float64, gamma::Float64=1.4)

Calculates the total pressure ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p02/p01::Float64`: Total pressure ratio
"""
function ns_p02_over_p01(M::Float64, gamma::Float64=1.4)
    p01 = p0_over_p(M, gamma)
    p02 = ns_p02(M, gamma)
    return p02 / p01
end

"""
    solve_normal(M::Float64, gamma::Float64=1.4)

Calculates the flow properties after a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
A `NamedTuple` containing:
- `M2::Float64`: Downstream Mach number
- `rho2_ratio::Float64`: Density ratio across the shock (ρ₂/ρ₁)
- `p2_ratio::Float64`: Pressure ratio across the shock (p₂/p₁)
- `p0_ratio::Float64`: Total pressure ratio across the shock (p₀₂/p₀₁)
"""
function solve_normal(M::Float64, gamma::Float64=1.4)
    M2 = ns_mach2(M, gamma)
    rho2, p2 = ns_rho2_over_rho1(M, gamma), ns_p2_over_p1(M, gamma)
    p0ratio = ns_p02_over_p01(M, gamma)
    return (M2=M2, rho2_ratio=rho2, p2_ratio=p2, p0_ratio=p0ratio)
end
