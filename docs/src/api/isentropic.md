# Isentropic Relations

```@meta
CurrentModule = CompAir
```

This module provides functions for calculating isentropic flow relations, which describe the relationships between flow properties in compressible flow without heat transfer or friction.

## Overview

Isentropic flow relations are fundamental to compressible flow analysis. They relate static and stagnation (total) properties through the Mach number for flows where entropy remains constant. These relationships are essential for:

- Nozzle design and analysis
- Pitot tube measurements
- Flow property calculations
- Wind tunnel calibration

## Theory

For an ideal gas undergoing isentropic flow, the relationships between stagnation and static properties are:

- **Temperature**: ``\frac{T_0}{T} = 1 + \frac{\gamma-1}{2}M^2``
- **Pressure**: ``\frac{p_0}{p} = \left(1 + \frac{\gamma-1}{2}M^2\right)^{\frac{\gamma}{\gamma-1}}``
- **Density**: ``\frac{\rho_0}{\rho} = \left(1 + \frac{\gamma-1}{2}M^2\right)^{\frac{1}{\gamma-1}}``

Where:
- ``M`` is mach number
- ``\gamma`` is specific heat ratio (1.4 for air at standard conditions)
- Subscript 0 denotes stagnation conditions

## Functions

```@docs
t0_over_t
p0_over_p
rho0_over_rho
```

## Function Details

### t0\_over\_t

```julia
t0_over_t(M, gamma=1.4)
```

Calculate the stagnation to static temperature ratio for isentropic flow.

**Arguments:**
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Stagnation to static temperature ratio (T₀/T)

**Formula:**
$$\frac{T_0}{T} = 1 + \frac{\gamma-1}{2}M^2$$

**Example:**
```julia
julia> t0_over_t(2.0)
1.8

julia> t0_over_t(1.5, 1.67)  # Helium
2.005
```

### p0\_over\_p

```julia
p0_over_p(M, gamma=1.4)
```

Calculate the stagnation to static pressure ratio for isentropic flow.

**Arguments:**
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Stagnation to static pressure ratio (p₀/p)

**Formula:**
$$\frac{p_0}{p} = \left(1 + \frac{\gamma-1}{2}M^2\right)^{\frac{\gamma}{\gamma-1}}$$

**Example:**
```julia
julia> p0_over_p(2.0)
7.824481684411352

julia> p0_over_p(1.0)
1.8929441933097926
```

### rho0\_over\_rho

```julia
rho0_over_rho(M, gamma=1.4)
```

Calculate the stagnation to static density ratio for isentropic flow.

**Arguments:**
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Stagnation to static density ratio (ρ₀/ρ)

**Formula:**
$$\frac{\rho_0}{\rho} = \left(1 + \frac{\gamma-1}{2}M^2\right)^{\frac{1}{\gamma-1}}$$

**Example:**
```julia
julia> rho0_over_rho(2.0)
4.346837646954653

julia> rho0_over_rho(3.0)
14.621473116765412
```

## Applications

### Wind Tunnel Calibration

Calculate test section conditions from stagnation measurements:

```julia
# Known stagnation conditions
p0_measured = 150000  # Pa
T0_measured = 300     # K
M_test = 1.8

# Calculate static conditions
p_static = p0_measured / p0_over_p(M_test)
T_static = T0_measured / t0_over_t(M_test)

println("Test section conditions:")
println("Static pressure: $(round(p_static/1000, digits=1)) kPa")
println("Static temperature: $(round(T_static, digits=1)) K")
```

### Pitot Tube Analysis

Calculate dynamic pressure coefficient:

```julia
M = 0.8  # Subsonic flow

# Pressure coefficient from pitot measurements
p0_p_ratio = p0_over_p(M)
q_coefficient = p0_p_ratio - 1

println("Dynamic pressure coefficient: $(round(q_coefficient, digits=3))")

# Compare with incompressible approximation
q_incompressible = 0.5 * 1.4 * M^2
error = abs(q_coefficient - q_incompressible) / q_coefficient * 100

println("Incompressible error: $(round(error, digits=1))%")
```

### Nozzle Exit Conditions

Calculate exit conditions for known stagnation state:

```julia
# Rocket nozzle conditions
p0_chamber = 2e6  # Pa (20 bar)
T0_chamber = 3000 # K
M_exit = 3.5

# Exit conditions
p_exit = p0_chamber / p0_over_p(M_exit)
T_exit = T0_chamber / t0_over_t(M_exit)
rho_ratio = rho0_over_rho(M_exit)

println("Rocket nozzle exit conditions:")
println("Exit pressure: $(round(p_exit/1000, digits=1)) kPa")
println("Exit temperature: $(round(T_exit, digits=1)) K")
println("Density ratio ρ₀/ρ: $(round(rho_ratio, digits=2))")
```

### Different Gases

Compare properties for different working fluids:

```julia
M = 1.5
gases = [
    ("Air", 1.4),
    ("Helium", 1.67),
    ("CO₂", 1.3),
    ("Steam", 1.33)
]

println("M\tGas\tγ\tT₀/T\tp₀/p\tρ₀/ρ")
println("---\t---\t----\t----\t----\t----")

for (gas, gamma) in gases
    T_ratio = t0_over_t(M, gamma)
    p_ratio = p0_over_p(M, gamma)
    rho_ratio = rho0_over_rho(M, gamma)
    
    println("$M\t$gas\t$gamma\t$(round(T_ratio, digits=2))\t$(round(p_ratio, digits=2))\t$(round(rho_ratio, digits=2))")
end
```

## Validation Examples

### Consistency Check

Verify thermodynamic consistency:

```julia
M = 2.5
gamma = 1.4

T_ratio = t0_over_t(M, gamma)
p_ratio = p0_over_p(M, gamma)
rho_ratio = rho0_over_rho(M, gamma)

# Check ideal gas law: p₀/p = (ρ₀/ρ)(T₀/T)
consistency = p_ratio - (rho_ratio * T_ratio)

println("Consistency check (should be ≈ 0): $(round(consistency, digits=10))")
```

### Mach Number Range

Analyze property variations:

```julia
println("M\tT₀/T\tp₀/p\tρ₀/ρ")
println("---\t----\t----\t----")

for M in 0.1:0.2:3.0
    T_ratio = t0_over_t(M)
    p_ratio = p0_over_p(M)
    rho_ratio = rho0_over_rho(M)
    
    println("$(M)\t$(round(T_ratio, digits=2))\t$(round(p_ratio, digits=2))\t$(round(rho_ratio, digits=2))")
end
```

## Limitations

1. **Ideal Gas Assumption**: Functions assume ideal gas behavior with constant specific heats
2. **Isentropic Process**: No heat transfer, friction, or shock waves
3. **Steady Flow**: Time-invariant conditions
4. **Calorically Perfect Gas**: Constant γ throughout the process

For real gas effects or non-isentropic processes, additional corrections may be necessary.

## See Also

- [Normal Shock Waves](normal_shock.md): For flows with entropy changes
- [Nozzle Analysis](nozzle.md): Applications in nozzle design
- [Atmospheric Model](atmos1976.md): Real gas properties at different conditions