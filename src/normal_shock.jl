"""
    mach_after_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the Mach number after a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `mach::Float64`: Downstream Mach number
"""
function mach_after_normal_shock(M::Float64, gamma::Float64=1.4)
    return sqrt((1 + 0.5 * (gamma - 1) * M^2) / (gamma * M^2 - 0.5 * (gamma - 1)))
end

"""
    density_ratio_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the density ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `rho2/rho1::Float64`: Density ratio
"""
function density_ratio_normal_shock(M::Float64, gamma::Float64=1.4)
    return (gamma + 1) * M^2 / (2 + (gamma - 1) * M^2)
end

"""
    pressure_ratio_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the pressure ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p2/p1::Float64`: Pressure ratio
"""
function pressure_ratio_normal_shock(M::Float64, gamma::Float64=1.4)
    return 1 + 2 * gamma / (gamma + 1) * (M^2 - 1)
end

"""
    temperature_ratio_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the temperature ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `t2/t1::Float64`: Temperature ratio
"""
function temperature_ratio_normal_shock(M::Float64, gamma::Float64=1.4)
    return pressure_ratio_normal_shock(M, gamma) / density_ratio_normal_shock(M, gamma)
end

"""
    total_pressure_after_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the total pressure after a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p02::Float64`: Total pressure after the shock
"""
function total_pressure_after_normal_shock(M::Float64, gamma::Float64=1.4)
    p2 = pressure_ratio_normal_shock(M, gamma)
    M2 = mach_after_normal_shock(M, gamma)
    return total_to_static_pressure_ratio(M2, gamma) * p2
end

"""
    total_pressure_ratio_normal_shock(M::Float64, gamma::Float64=1.4)

Calculates the total pressure ratio across a normal shock wave.

# Arguments
- `M::Float64`: Upstream Mach number
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `p02/p01::Float64`: Total pressure ratio
"""
function total_pressure_ratio_normal_shock(M::Float64, gamma::Float64=1.4)
    p01 = total_to_static_pressure_ratio(M, gamma)
    p02 = total_pressure_after_normal_shock(M, gamma)
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
    M2 = mach_after_normal_shock(M, gamma)
    rho2, p2 = density_ratio_normal_shock(M, gamma), pressure_ratio_normal_shock(M, gamma)
    p0ratio = total_pressure_ratio_normal_shock(M, gamma)
    return (M2=M2, rho2_ratio=rho2, p2_ratio=p2, p0_ratio=p0ratio)
end
