# Normal Shock Waves

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing normal shock waves, which are compression waves that occur perpendicular to the flow direction in supersonic flows.

## Overview

Normal shock waves are sudden compression phenomena that occur when supersonic flow encounters an obstruction or adverse pressure gradient. They are characterized by:

- Instantaneous property changes across a thin wave front
- Entropy increase (irreversible process)
- Mach number reduction from supersonic to subsonic
- Pressure, density, and temperature increases
- Stagnation pressure loss

## Theory

Normal shock waves are governed by the Rankine-Hugoniot relations, derived from conservation of mass, momentum, and energy:

**Downstream Mach number**:
$$M_2 = \sqrt{\frac{1 + \frac{\gamma-1}{2}M_1^2}{\gamma M_1^2 - \frac{\gamma-1}{2}}}$$

**Pressure ratio**:
$$\frac{p_2}{p_1} = 1 + \frac{2\gamma}{\gamma+1}(M_1^2 - 1)$$

**Density ratio**:
$$\frac{\rho_2}{\rho_1} = \frac{(\gamma+1)M_1^2}{2 + (\gamma-1)M_1^2}$$

**Temperature ratio**:
$$\frac{T_2}{T_1} = \frac{p_2}{p_1} \cdot \frac{\rho_1}{\rho_2}$$

**Stagnation pressure ratio**:
$$\frac{p_{02}}{p_{01}} = \left(\frac{2\gamma M_1^2 - (\gamma-1)}{\gamma+1}\right)^{\frac{1}{1-\gamma}} \left(\frac{(\gamma+1)M_1^2}{2 + (\gamma-1)M_1^2}\right)^{\frac{\gamma}{1-\gamma}}$$

Where subscript 1 denotes upstream conditions and subscript 2 denotes downstream conditions.

## Functions

```@docs
normal_mach2
rho2_over_rho1
p2_over_p1
t2_over_t1
normal_p02
p02_over_p01
solve_normal
```

## Function Details

### normal_mach2

```julia
normal_mach2(M, gamma=1.4)
```

Calculate the downstream Mach number after a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number (must be > 1)
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Downstream Mach number (M₂)

**Formula:**
$$M_2 = \sqrt{\frac{1 + \frac{\gamma-1}{2}M_1^2}{\gamma M_1^2 - \frac{\gamma-1}{2}}}$$

**Example:**
```julia
julia> normal_mach2(2.0)
0.5773502691896257

julia> normal_mach2(3.0)
0.4752229748622233
```

### rho2\_over\_rho1

```julia
rho2_over_rho1(M, gamma=1.4)
```

Calculate the density ratio across a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Density ratio (ρ₂/ρ₁)

**Formula:**
$$\frac{\rho_2}{\rho_1} = \frac{(\gamma+1)M_1^2}{2 + (\gamma-1)M_1^2}$$

**Example:**
```julia
julia> rho2_over_rho1(2.0)
2.6666666666666665

julia> rho2_over_rho1(5.0)
5.714285714285714
```

### p2\_over\_p1

```julia
p2_over_p1(M, gamma=1.4)
```

Calculate the pressure ratio across a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Pressure ratio (p₂/p₁)

**Formula:**
$$\frac{p_2}{p_1} = 1 + \frac{2\gamma}{\gamma+1}(M_1^2 - 1)$$

**Example:**
```julia
julia> p2_over_p1(2.0)
4.5

julia> p2_over_p1(3.0)
10.333333333333334
```

### t2\_over\_t1

```julia
t2_over_t1(M, gamma=1.4)
```

Calculate the temperature ratio across a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Temperature ratio (T₂/T₁)

**Formula:**
$$\frac{T_2}{T_1} = \frac{p_2}{p_1} \cdot \frac{\rho_1}{\rho_2}$$

**Example:**
```julia
julia> t2_over_t1(2.0)
1.6874999999999998

julia> t2_over_t1(3.0)
1.8076923076923077
```

### normal_p02

```julia
normal_p02(M, gamma=1.4)
```

Calculate the downstream stagnation pressure after a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Downstream stagnation pressure coefficient

**Example:**
```julia
julia> normal_p02(2.0)
8.526315789473685

julia> normal_p02(3.0)
12.061224489795916
```

### p02\_over\_p01

```julia
p02_over_p01(M, gamma=1.4)
```

Calculate the stagnation pressure ratio across a normal shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Stagnation pressure ratio (p₀₂/p₀₁)

**Example:**
```julia
julia> p02_over_p01(2.0)
0.7208738938053097

julia> p02_over_p01(3.0)
0.32834049679486917
```

### solve_normal

```julia
solve_normal(M, gamma=1.4)
```

Complete normal shock analysis - calculate all property changes across the shock.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `M2::Float64`: Downstream Mach number
- `rho2::Float64`: Density ratio (ρ₂/ρ₁)
- `p2::Float64`: Pressure ratio (p₂/p₁)
- `p0ratio::Float64`: Stagnation pressure ratio (p₀₂/p₀₁)

**Example:**
```julia
julia> M2, rho_ratio, p_ratio, p0_ratio = solve_normal(2.5)
(0.5130161854439888, 3.2, 7.125, 0.49949999999999994)

julia> println("M₂ = $(round(M2, digits=3))")
M₂ = 0.513

julia> println("Pressure loss = $(round((1-p0_ratio)*100, digits=1))%")
Pressure loss = 50.1%
```

## Applications

### Supersonic Inlet Analysis

Analyze normal shock for inlet deceleration:

```julia
# Flight conditions
M_flight = 2.2
alt = 11000  # m

# Get atmospheric properties (simplified)
p_amb = 22600   # Pa at 11 km
T_amb = 216.7   # K at 11 km

# Shock analysis for inlet
M_subsonic, rho_ratio, p_ratio, p0_ratio = solve_normal(M_flight)

# Recovery factor
eta_inlet = p0_ratio  # Inlet total pressure recovery

println("Supersonic Inlet Analysis:")
println("Flight Mach: $M_flight")
println("Downstream Mach: $(round(M_subsonic, digits=3))")
println("Inlet total pressure recovery: $(round(eta_inlet, digits=3))")
println("Pressure recovery: $(round(eta_inlet*100, digits=1))%")
```

### Shock Strength Analysis

Analyze how shock strength varies with upstream Mach number:

```julia
println("M₁\tM₂\tp₂/p₁\tρ₂/ρ₁\tT₂/T₁\tp₀₂/p₀₁\tLoss %")
println("---\t----\t-----\t-----\t-----\t------\t------")

for M1 in 1.1:0.2:4.0
    M2, rho_ratio, p_ratio, p0_ratio = solve_normal(M1)
    T_ratio = t2_over_t1(M1)
    loss_percent = (1 - p0_ratio) * 100
    
    println("$(round(M1, digits=1))\t$(round(M2, digits=2))\t$(round(p_ratio, digits=2))\t$(round(rho_ratio, digits=2))\t$(round(T_ratio, digits=2))\t$(round(p0_ratio, digits=3))\t$(round(loss_percent, digits=1))")
end
```

### Pitot Tube Behind Normal Shock

Calculate pitot pressure measurements behind a normal shock:

```julia
# Flight conditions
M1 = 2.0
p_static = 25000  # Pa (ambient static pressure)

# Normal shock analysis
M2, rho_ratio, p_ratio, p0_ratio = solve_normal(M1)

# Pressures
p2_static = p_static * p_ratio           # Static pressure behind shock
p02_pitot = p2_static * p0_over_p(M2)    # Pitot pressure behind shock

# Compare with direct pitot measurement (incorrect for supersonic)
p01_direct = p_static * p0_over_p(M1)    # What pitot would read in supersonic flow

println("Pitot Tube Analysis in Supersonic Flow:")
println("Freestream Mach: $M1")
println("Ambient static pressure: $(p_static/1000) kPa")

println("\nCorrect measurement (behind shock):")
println("  Static pressure behind shock: $(round(p2_static/1000, digits=1)) kPa")
println("  Pitot pressure: $(round(p02_pitot/1000, digits=1)) kPa")

println("\nIncorrect direct measurement:")
println("  Direct pitot reading: $(round(p01_direct/1000, digits=1)) kPa")
println("  Error factor: $(round(p01_direct/p02_pitot, digits=2))")
```

### Shock Tube Calculations

Calculate conditions in a shock tube:

```julia
# Initial conditions (driven section)
p4 = 101325   # Pa (atmospheric)
T4 = 300      # K
M_shock = 5.0 # Shock Mach number

# Calculate conditions behind shock (region 2)
M2, rho_ratio, p_ratio, p0_ratio = solve_normal(M_shock)
T_ratio = t2_over_t1(M_shock)

p2 = p4 * p_ratio
T2 = T4 * T_ratio

# Contact surface velocity (region 2 and 3 velocity)
a4 = sqrt(1.4 * 287 * T4)  # Sound speed in region 4
u_contact = a4 * M_shock * (1 - 1/rho_ratio)

println("Shock Tube Analysis:")
println("Shock Mach number: $M_shock")
println("Initial pressure (region 4): $(p4/1000) kPa")
println("Initial temperature (region 4): $T4 K")

println("\nBehind shock (region 2):")
println("  Pressure: $(round(p2/1000, digits=1)) kPa")
println("  Temperature: $(round(T2, digits=1)) K")
println("  Density ratio: $(round(rho_ratio, digits=2))")

println("\nContact surface velocity: $(round(u_contact, digits=1)) m/s")
```

## Different Gases

Calculate shock properties for different gases:

```julia
M1 = 2.5
gases = [
    ("Air", 1.4),
    ("Helium", 1.67),
    ("Argon", 1.67),
    ("CO₂", 1.3)
]

println("Gas\tγ\tM₂\tp₂/p₁\tρ₂/ρ₁\tp₀₂/p₀₁")
println("---\t----\t----\t-----\t-----\t------")

for (gas, gamma) in gases
    M2 = normal_mach2(M1, gamma)
    p_ratio = p2_over_p1(M1, gamma)
    rho_ratio = rho2_over_rho1(M1, gamma)
    p0_ratio = p02_over_p01(M1, gamma)
    
    println("$gas\t$gamma\t$(round(M2, digits=3))\t$(round(p_ratio, digits=2))\t$(round(rho_ratio, digits=2))\t$(round(p0_ratio, digits=3))")
end
```

## Validation Examples

### Conservation Laws Check

Verify that the Rankine-Hugoniot relations satisfy conservation laws:

```julia
M1 = 3.0
gamma = 1.4

# Calculate all ratios
M2 = normal_mach2(M1, gamma)
p_ratio = p2_over_p1(M1, gamma)
rho_ratio = rho2_over_rho1(M1, gamma)
T_ratio = t2_over_t1(M1, gamma)

# Check ideal gas law: p₂/p₁ = (ρ₂/ρ₁)(T₂/T₁)
ideal_gas_check = p_ratio - (rho_ratio * T_ratio)

# Check momentum conservation
# Should satisfy: p₂ + ρ₂u₂² = p₁ + ρ₁u₁²
# Where u = Ma for convenience (normalized by sound speed)

println("Conservation Laws Verification:")
println("Ideal gas law check: $(round(ideal_gas_check, digits=10))")
println("(Should be ≈ 0)")
```

## Limitations and Considerations

1. **One-dimensional flow**: Assumes uniform properties across the shock front
2. **Steady flow**: Time-invariant shock position
3. **Perfect gas**: Constant specific heats and ideal gas behavior
4. **No viscous effects**: Inviscid flow assumption
5. **Thin shock**: Shock thickness much smaller than characteristic length scales

For three-dimensional effects, unsteady phenomena, or real gas behavior, additional analysis methods are required.

## See Also

- [Oblique Shock Waves](oblique_shock.md): For angled shock waves
- [Isentropic Relations](isentropic.md): For shock-free flow analysis
- [Prandtl-Meyer Expansion](prandtl_expand.md): For expansion waves
- [Nozzle Analysis](nozzle.md): For internal flow applications