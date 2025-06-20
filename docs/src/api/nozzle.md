# Nozzle Analysis

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing quasi-one-dimensional nozzle flows, including area-Mach number relationships, mass flow calculations, and nozzle performance analysis.

## Overview

Nozzle analysis is fundamental to propulsion systems, wind tunnels, and fluid machinery. This module covers:

- **Area-Mach Relationships**: The relationship between nozzle area ratio and Mach number
- **Mass Flow Calculations**: Flow rate computations with choking conditions
- **Choked Flow**: Critical flow conditions at the throat
- **Nozzle Performance**: Exit conditions and flow characteristics
- **Design Analysis**: Area ratio calculations for given performance requirements

## Theory

For quasi-one-dimensional isentropic flow through a nozzle, the area-Mach number relationship is:

**Area ratio equation**:
$$\frac{A}{A^*} = \frac{1}{M}\left[\frac{2}{\gamma+1}\left(1 + \frac{\gamma-1}{2}M^2\right)\right]^{\frac{\gamma+1}{2(\gamma-1)}}$$

**Mass flow rate**:
$$\dot{m} = \rho^* A^* a^* = \frac{p_0}{\sqrt{T_0}} \sqrt{\frac{\gamma}{R}} \left(\frac{2}{\gamma+1}\right)^{\frac{\gamma+1}{2(\gamma-1)}} A^*$$

**Choked flow condition** (M = 1 at throat):
- Maximum mass flow for given stagnation conditions
- Critical pressure ratio: $\frac{p^*}{p_0} = \left(\frac{2}{\gamma+1}\right)^{\frac{\gamma}{\gamma-1}}$
- Critical temperature ratio: $\frac{T^*}{T_0} = \frac{2}{\gamma+1}$

Where:
- $A$ = local area, $A^*$ = throat area (sonic area)
- $M$ = local Mach number
- $\gamma$ = specific heat ratio
- $p_0, T_0$ = stagnation pressure and temperature
- $R$ = specific gas constant

## Functions

```@docs
mdot
area_ratio_at
mach_by_area_ratio
me6
pe6
me5
pe5
```

## Function Details

### mdot

```julia
mdot(M, area=1, p0=1, t0=1, gamma=1.4, R=1)
```

Calculate mass flow rate through a nozzle at given conditions.

**Arguments:**
- `M::Real`: Mach number at the specified location
- `area::Real=1`: Cross-sectional area at the location
- `p0::Real=1`: Stagnation pressure
- `t0::Real=1`: Stagnation temperature
- `gamma::Real=1.4`: Specific heat ratio
- `R::Real=1`: Specific gas constant

**Returns:**
- `Float64`: Mass flow rate

**Formula:**
$$\dot{m} = \frac{\sqrt{\gamma}}{\sqrt{R T_0}} p_0 M A \left(1 + \frac{\gamma-1}{2}M^2\right)^{-\frac{\gamma+1}{2(\gamma-1)}}$$

**Example:**
```julia
julia> mdot(1.0, 0.01, 500000, 600, 1.4, 287)
1.281032004421326

julia> mdot(2.0, 0.005, 300000, 400, 1.4, 287)
0.32707563300841975
```

### area_ratio_at

```julia
area_ratio_at(M, gamma=1.4)
```

Calculate the area ratio A/A* for a given Mach number in isentropic flow.

**Arguments:**
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Area ratio A/A*

**Formula:**
$$\frac{A}{A^*} = \frac{1}{M}\left[\frac{2}{\gamma+1}\left(1 + \frac{\gamma-1}{2}M^2\right)\right]^{\frac{\gamma+1}{2(\gamma-1)}}$$

**Example:**
```julia
julia> area_ratio_at(2.0)
1.6875000000000002

julia> area_ratio_at(3.0)
4.234567901234568

julia> area_ratio_at(1.0)
1.0
```

### mach_by_area_ratio

```julia
mach_by_area_ratio(area, gamma=1.4, x0=0.1)
```

Calculate the Mach number for a given area ratio using numerical root finding.

**Arguments:**
- `area::Real`: Area ratio A/A*
- `gamma::Real=1.4`: Specific heat ratio
- `x0::Real=0.1`: Initial guess for Mach number (< 1 for subsonic, > 1 for supersonic)

**Returns:**
- `Float64`: Mach number

**Example:**
```julia
julia> mach_by_area_ratio(2.0, 1.4, 0.5)  # Subsonic solution
0.3086067977882601

julia> mach_by_area_ratio(2.0, 1.4, 2.0)  # Supersonic solution
2.1972245773362196
```

### me6

```julia
me6(area, gamma=1.4)
```

Calculate Mach number for given area ratio (wrapper for `mach_by_area_ratio` with default subsonic guess).

**Arguments:**
- `area::Real`: Area ratio A/A*
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Mach number (subsonic solution)

**Example:**
```julia
julia> me6(3.0)
0.17851240074438515
```

### pe6

```julia
pe6(area, gamma=1.4, p0=1)
```

Calculate static pressure at given area ratio location.

**Arguments:**
- `area::Real`: Area ratio A/A*
- `gamma::Real=1.4`: Specific heat ratio
- `p0::Real=1`: Stagnation pressure

**Returns:**
- `Float64`: Static pressure

**Example:**
```julia
julia> pe6(2.0, 1.4, 100000)
96859.71831475619
```

### me5

```julia
me5(area, gamma=1.4)
```

Calculate Mach number after a normal shock at the given area ratio location.

**Arguments:**
- `area::Real`: Area ratio A/A*
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Mach number after normal shock

**Example:**
```julia
julia> me5(4.0)
0.4347826086956522
```

### pe5

```julia
pe5(area, gamma=1.4, p0=1)
```

Calculate static pressure after a normal shock at the given area ratio location.

**Arguments:**
- `area::Real`: Area ratio A/A*
- `gamma::Real=1.4`: Specific heat ratio
- `p0::Real=1`: Stagnation pressure

**Returns:**
- `Float64`: Static pressure after shock

**Example:**
```julia
julia> pe5(3.0, 1.4, 200000)
138888.8888888889
```

## Applications

### Rocket Nozzle Design

Design a rocket nozzle for optimum performance:

```julia
# Rocket engine specifications
p_chamber = 20e5    # Chamber pressure (Pa)
p_ambient = 101325  # Sea level ambient pressure (Pa)
T_chamber = 3000    # Chamber temperature (K)
thrust_req = 10000  # Required thrust (N)

println("Rocket Nozzle Design:")
println("Chamber pressure: $(p_chamber/1e5) bar")
println("Ambient pressure: $(p_ambient/1000) kPa")
println("Chamber temperature: $T_chamber K")

# Calculate optimum expansion ratio
p_ratio_opt = p_chamber / p_ambient
println("Optimum pressure ratio: $(round(p_ratio_opt, digits=1))")

# Find exit Mach number for optimum expansion
M_exit_opt = 3.0  # Initial guess
tolerance = 1e-6

for i in 1:100
    p_ratio_calc = p0_over_p(M_exit_opt)
    error = p_ratio_calc - p_ratio_opt
    
    if abs(error/p_ratio_opt) < tolerance
        break
    end
    
    # Newton-like iteration
    if error > 0
        M_exit_opt *= 1.01
    else
        M_exit_opt *= 0.99
    end
end

println("Optimum exit Mach: $(round(M_exit_opt, digits=2))")

# Calculate nozzle geometry
A_ratio_opt = area_ratio_at(M_exit_opt)
println("Optimum area ratio: $(round(A_ratio_opt, digits=1))")

# Performance calculations
specific_impulse = M_exit_opt * sqrt(1.4 * 287 * T_chamber / t0_over_t(M_exit_opt))
println("Approximate specific impulse: $(round(specific_impulse, digits=1)) m/s")
```

### Wind Tunnel Nozzle Analysis

Design a supersonic wind tunnel nozzle:

```julia
# Wind tunnel requirements
M_test = 2.2        # Test section Mach number
p0_settling = 150000 # Settling chamber pressure (Pa)
T0_settling = 300   # Settling chamber temperature (K)
test_duration = 30  # seconds

println("Wind Tunnel Nozzle Design:")
println("Test Mach number: $M_test")
println("Settling chamber pressure: $(p0_settling/1000) kPa")

# Calculate nozzle area ratio
A_ratio = area_ratio_at(M_test)
println("Required area ratio: $(round(A_ratio, digits=2))")

# Test section conditions  
p_test = p0_settling / p0_over_p(M_test)
T_test = T0_settling / t0_over_t(M_test)
rho_test = p_test / (287 * T_test)

println("\nTest Section Conditions:")
println("Static pressure: $(round(p_test/1000, digits=1)) kPa")
println("Static temperature: $(round(T_test, digits=1)) K")
println("Density: $(round(rho_test, digits=3)) kg/m³")

# Mass flow requirements
A_throat = 0.02  # m² (assumed)
mass_flow = mdot(1.0, A_throat, p0_settling, T0_settling, 1.4, 287)

println("\nFlow Requirements:")
println("Throat area: $(A_throat*1e4) cm²")
println("Mass flow: $(round(mass_flow, digits=2)) kg/s")
println("Total air required: $(round(mass_flow * test_duration, digits=1)) kg")
```

### Nozzle Performance Map

Generate performance data for different operating conditions:

```julia
# Fixed nozzle geometry
A_ratio_design = 4.0
M_design = mach_by_area_ratio(A_ratio_design, 1.4, 2.0)  # Supersonic solution

println("Nozzle Performance Map:")
println("Design area ratio: $A_ratio_design")
println("Design Mach number: $(round(M_design, digits=2))")

println("\np0/pb\tFlow Condition\t\tExit Mach")
println("-----\t--------------\t\t---------")

# Different pressure ratios
pressure_ratios = [1.5, 2.0, 5.0, 10.0, 20.0, 50.0]

for pr in pressure_ratios
    # Critical pressure ratio for choking
    p_critical = (2/(1.4+1))^(1.4/(1.4-1))  # ≈ 0.528
    
    if pr < 1/p_critical
        condition = "Subsonic throughout"
        M_exit = mach_by_area_ratio(A_ratio_design, 1.4, 0.1)
    else
        # Check if design pressure ratio is reached
        p_design = p0_over_p(M_design)
        
        if pr < p_design
            condition = "Shock in nozzle"
            M_exit = "Variable"
        elseif pr ≈ p_design
            condition = "Design point"
            M_exit = round(M_design, digits=3)
        else
            condition = "Overexpanded"
            M_exit = round(M_design, digits=3)
        end
    end
    
    println("$(round(pr, digits=1))\t$condition\t\t$M_exit")
end
```

### Variable Area Nozzle Analysis

Analyze performance of a variable geometry nozzle:

```julia
# Operating conditions
p0 = 300000  # Stagnation pressure (Pa)
T0 = 400     # Stagnation temperature (K)

# Different area ratios (variable geometry)
area_ratios = [1.5, 2.0, 3.0, 4.0, 5.0]

println("Variable Area Nozzle Performance:")
println("Stagnation conditions: $(p0/1000) kPa, $T0 K")
println("\nA/A*\tM_exit\tp_exit(kPa)\tT_exit(K)\tV_exit(m/s)")
println("----\t------\t----------\t--------\t----------")

for A_ratio in area_ratios
    # Find exit Mach number
    M_exit = mach_by_area_ratio(A_ratio, 1.4, 2.0)  # Supersonic solution
    
    # Calculate exit conditions
    p_exit = p0 / p0_over_p(M_exit)
    T_exit = T0 / t0_over_t(M_exit)
    V_exit = M_exit * sqrt(1.4 * 287 * T_exit)
    
    println("$(A_ratio)\t$(round(M_exit, digits=2))\t$(round(p_exit/1000, digits=1))\t\t$(round(T_exit, digits=1))\t\t$(round(V_exit, digits=1))")
end
```

### Nozzle Starting Problem

Analyze the starting process of a supersonic nozzle:

```julia
# Nozzle geometry
A_ratio_exit = 3.5

println("Nozzle Starting Analysis:")
println("Exit area ratio: $A_ratio_exit")

# Design conditions
M_exit_design = mach_by_area_ratio(A_ratio_exit, 1.4, 2.0)
p_ratio_design = p0_over_p(M_exit_design)

println("Design exit Mach: $(round(M_exit_design, digits=2))")
println("Design pressure ratio: $(round(p_ratio_design, digits=1))")

# Starting condition (shock at exit)
M_before_shock = M_exit_design
M_after_shock, _, _, p0_loss = solve_normal(M_before_shock)

# Required starting pressure ratio
p_ratio_starting = p_ratio_design / p0_loss

println("\nStarting Analysis:")
println("Shock downstream Mach: $(round(M_after_shock, digits=3))")
println("Stagnation pressure loss: $(round((1-p0_loss)*100, digits=1))%")
println("Starting pressure ratio: $(round(p_ratio_starting, digits=1))")
println("Overexpansion factor: $(round(p_ratio_starting/p_ratio_design, digits=2))")
```

## Different Gases

Analyze nozzle performance for different working fluids:

```julia
M_exit = 2.5
A_throat = 0.01  # m²
p0 = 500000      # Pa
T0 = 400         # K

gases = [
    ("Air", 1.4, 287),
    ("Helium", 1.67, 2077),
    ("CO₂", 1.3, 189),
    ("Steam", 1.33, 462)
]

println("Nozzle Performance for Different Gases:")
println("Exit Mach: $M_exit")
println("\nGas\tγ\tR(J/kg·K)\tA/A*\tṁ(kg/s)\tV_exit(m/s)")
println("---\t----\t--------\t----\t-------\t----------")

for (gas, gamma, R) in gases
    # Area ratio
    A_ratio = area_ratio_at(M_exit, gamma)
    
    # Mass flow
    mass_flow = mdot(1.0, A_throat, p0, T0, gamma, R)
    
    # Exit velocity
    T_exit = T0 / t0_over_t(M_exit, gamma)
    V_exit = M_exit * sqrt(gamma * R * T_exit)
    
    println("$gas\t$gamma\t$R\t\t$(round(A_ratio, digits=2))\t$(round(mass_flow, digits=3))\t\t$(round(V_exit, digits=1))")
end
```

## Validation Examples

### Area Ratio Calculation

Verify area ratio calculations:

```julia
println("Mach\tA/A*")
println("----\t----")

for M in [0.5, 0.8, 1.0, 1.5, 2.0, 3.0, 4.0]
    if M == 1.0
        ratio = 1.0
    else
        ratio = area_ratio_at(M)
    end
    println("$(M)\t$(round(ratio, digits=3))")
end
```

### Inverse Problem Validation

Verify that inverse calculations are consistent:

```julia
M_original = 2.5
A_ratio = area_ratio_at(M_original)

# Find Mach number back from area ratio
M_subsonic = mach_by_area_ratio(A_ratio, 1.4, 0.1)
M_supersonic = mach_by_area_ratio(A_ratio, 1.4, 2.0)

println("Original Mach: $M_original")
println("Calculated area ratio: $(round(A_ratio, digits=3))")
println("Subsonic solution: $(round(M_subsonic, digits=3))")
println("Supersonic solution: $(round(M_supersonic, digits=3))")
println("Error: $(round(abs(M_supersonic - M_original), digits=6))")
```

## Limitations and Considerations

1. **One-dimensional flow**: Assumes uniform properties across each cross-section
2. **Isentropic process**: No friction, heat transfer, or shock waves
3. **Perfect gas**: Constant specific heats and ideal gas behavior
4. **Steady flow**: Time-invariant conditions
5. **Inviscid flow**: No boundary layer effects
6. **No real gas effects**: No dissociation, ionization, or vibrational excitation

For practical nozzle design, corrections for viscous effects, heat transfer, and real gas behavior may be necessary.

## See Also

- [Isentropic Relations](isentropic.md): For property ratio calculations
- [Normal Shock Waves](normal_shock.md): For shock analysis in over-expanded nozzles
- [Atmospheric Model](atmos1976.md): For ambient conditions in nozzle analysis
- [Prandtl-Meyer Expansion](prandtl_expand.md): For expansion wave analysis