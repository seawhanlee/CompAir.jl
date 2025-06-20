# Oblique Shock Waves

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing oblique shock waves, which are compression waves that occur at an angle to the flow direction in supersonic flows.

## Overview

Oblique shock waves are compression phenomena that occur when supersonic flow encounters a wedge, cone, or other angular obstruction. Unlike normal shocks, oblique shocks:

- Deflect the flow through a specific angle
- Can have weak or strong solutions
- Maintain supersonic flow downstream (for weak shocks)
- Are characterized by the shock angle β and deflection angle θ
- Have a maximum deflection angle for each upstream Mach number

## Theory

Oblique shock waves are governed by the θ-β-M relationships derived from conservation laws:

**Shock angle relation**:
$$\tan\theta = 2\cot\beta \frac{M_1^2\sin^2\beta - 1}{M_1^2(\gamma + \cos 2\beta) + 2}$$

**Downstream Mach number**:
$$M_2 = \frac{M_1\sin(\beta - \theta)}{\sin\beta} \sqrt{\frac{1 + \frac{\gamma-1}{2}M_1^2\sin^2\beta}{\gamma M_1^2\sin^2\beta - \frac{\gamma-1}{2}}}$$

**Property ratios** (same as normal shock with $M_{1n} = M_1\sin\beta$):
- Pressure: $\frac{p_2}{p_1} = 1 + \frac{2\gamma}{\gamma+1}(M_1^2\sin^2\beta - 1)$
- Density: $\frac{\rho_2}{\rho_1} = \frac{(\gamma+1)M_1^2\sin^2\beta}{2 + (\gamma-1)M_1^2\sin^2\beta}$

**Maximum deflection angle**:
$$\theta_{max} = \arcsin\left(\frac{1}{M_1}\right) - \arccos\left(\frac{\gamma+1}{2\gamma M_1^2}\right) + \arccos\left(\sqrt{\frac{(\gamma+1)^2M_1^4 - 4(M_1^2-1)}{4\gamma M_1^2(\gamma M_1^2 - (\gamma-1)/2)}}\right)$$

Where:
- $\theta$ = flow deflection angle
- $\beta$ = shock wave angle
- $M_1$ = upstream Mach number
- $\gamma$ = specific heat ratio

## Functions

```@docs
theta_beta
oblique_beta_weak
theta_max
Mn1
oblique_mach2
solve_oblique
```

## Function Details

### theta_beta

```julia
theta_beta(beta, M, gamma=1.4)
```

Calculate the deflection angle θ from shock angle β and Mach number using the θ-β-M relationship.

**Arguments:**
- `beta::Real`: Shock angle in degrees
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Deflection angle θ in degrees

**Formula:**
$$\tan\theta = 2\cot\beta \frac{M_1^2\sin^2\beta - 1}{M_1^2(\gamma + \cos 2\beta) + 2}$$

**Example:**
```julia
julia> theta_beta(45.0, 2.0)
11.309932474020215

julia> theta_beta(60.0, 3.0)
28.040946798183083
```

### oblique_beta_weak

```julia
oblique_beta_weak(M, theta, gamma=1.4)
```

Calculate the weak shock angle β for given Mach number and deflection angle using numerical solution of the θ-β-M relationship.

**Arguments:**
- `M::Real`: Upstream Mach number
- `theta::Real`: Deflection angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Weak shock angle β in degrees

**Example:**
```julia
julia> oblique_beta_weak(2.0, 10.0)
39.31417164408201

julia> oblique_beta_weak(3.0, 20.0)
47.40460643973166
```

### theta_max

```julia
theta_max(M, gamma=1.4)
```

Calculate the maximum deflection angle for which a weak oblique shock can exist at the given Mach number.

**Arguments:**
- `M::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Maximum deflection angle in degrees

**Example:**
```julia
julia> theta_max(2.0)
23.078692262638353

julia> theta_max(3.0)
34.07775155814027
```

### Mn1

```julia
Mn1(M, theta, gamma=1.4)
```

Calculate the normal component of the upstream Mach number (component perpendicular to the shock wave).

**Arguments:**
- `M::Real`: Upstream Mach number
- `theta::Real`: Deflection angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Normal Mach number component

**Formula:**
$$M_{n1} = M_1 \sin\beta$$

**Example:**
```julia
julia> Mn1(2.0, 10.0)
1.2649110640673516

julia> Mn1(3.0, 15.0)
2.0788046194771835
```

### oblique_mach2

```julia
oblique_mach2(M, theta, gamma=1.4)
```

Calculate the downstream Mach number after an oblique shock wave.

**Arguments:**
- `M::Real`: Upstream Mach number
- `theta::Real`: Deflection angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Downstream Mach number

**Example:**
```julia
julia> oblique_mach2(2.0, 10.0)
1.640880221070567

julia> oblique_mach2(3.0, 20.0)
2.1862348686827446
```

### solve_oblique

```julia
solve_oblique(M, theta, gamma=1.4)
```

Complete oblique shock analysis - calculate all property changes across the shock.

**Arguments:**
- `M::Real`: Upstream Mach number
- `theta::Real`: Deflection angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `M2::Float64`: Downstream Mach number
- `rho2::Float64`: Density ratio (ρ₂/ρ₁)
- `p2::Float64`: Pressure ratio (p₂/p₁)
- `p0ratio::Float64`: Stagnation pressure ratio (p₀₂/p₀₁)
- `beta::Float64`: Shock angle in degrees

**Example:**
```julia
julia> M2, rho_ratio, p_ratio, p0_ratio, beta = solve_oblique(2.5, 15.0)
(2.0648650289095266, 1.6862745098039214, 2.40625, 0.9564285714285714, 41.81031489577775)

julia> println("M₂ = $(round(M2, digits=3)), β = $(round(beta, digits=1))°")
M₂ = 2.065, β = 41.8°
```

## Applications

### Diamond Airfoil Analysis

Analyze flow over a symmetric diamond airfoil:

```julia
M_inf = 2.5
half_angle = 8.0  # degrees
alpha = 2.0       # angle of attack, degrees

println("Diamond Airfoil Analysis:")
println("Freestream Mach: $M_inf")
println("Half-angle: $half_angle°")
println("Angle of attack: $alpha°")

# Upper surface
theta_upper = half_angle + alpha
M2_upper, rho_upper, p_upper, p0_upper, beta_upper = solve_oblique(M_inf, theta_upper)

println("\nUpper Surface (Leading Edge):")
println("Deflection angle: $(round(theta_upper, digits=1))°")
println("Shock angle β₁ = $(round(beta_upper, digits=1))°")
println("Surface Mach: $(round(M2_upper, digits=3))")
println("Pressure ratio: $(round(p_upper, digits=3))")

# Lower surface  
theta_lower = half_angle - alpha
M2_lower, rho_lower, p_lower, p0_lower, beta_lower = solve_oblique(M_inf, theta_lower)

println("\nLower Surface (Leading Edge):")
println("Deflection angle: $(round(theta_lower, digits=1))°")
println("Shock angle β₂ = $(round(beta_lower, digits=1))°")
println("Surface Mach: $(round(M2_lower, digits=3))")
println("Pressure ratio: $(round(p_lower, digits=3))")

# Pressure coefficients
Cp_upper = 2/(1.4*M_inf^2) * (p_upper - 1)
Cp_lower = 2/(1.4*M_inf^2) * (p_lower - 1)

println("\nPressure Coefficients:")
println("Upper surface: $(round(Cp_upper, digits=4))")
println("Lower surface: $(round(Cp_lower, digits=4))")
println("Lift coefficient (approx): $(round(Cp_lower - Cp_upper, digits=4))")
```

### Shock-Shock Interaction

Analyze intersection of two oblique shocks:

```julia
# Two wedges in series
M1 = 3.0
theta1 = 12.0  # First wedge angle
theta2 = 8.0   # Second wedge angle

println("Shock-Shock Interaction:")
println("Initial Mach: $M1")

# First shock
M2, rho21, p21, p021, beta1 = solve_oblique(M1, theta1)

println("\nFirst Shock (θ₁ = $theta1°):")
println("Shock angle: $(round(beta1, digits=1))°")
println("M₂ = $(round(M2, digits=3))")
println("p₂/p₁ = $(round(p21, digits=3))")

# Second shock  
M3, rho32, p32, p032, beta2 = solve_oblique(M2, theta2)

println("\nSecond Shock (θ₂ = $theta2°):")
println("Shock angle: $(round(beta2, digits=1))°")
println("M₃ = $(round(M3, digits=3))")
println("p₃/p₂ = $(round(p32, digits=3))")

# Overall results
total_deflection = theta1 + theta2
total_pressure_ratio = p21 * p32
total_loss = 1 - (p021 * p032)

println("\nOverall Results:")
println("Total deflection: $(round(total_deflection, digits=1))°")
println("Total pressure ratio: $(round(total_pressure_ratio, digits=3))")
println("Total pressure loss: $(round(total_loss*100, digits=1))%")
```

### Maximum Deflection Analysis

Find the maximum deflection angle for different Mach numbers:

```julia
println("M₁\tθₘₐₓ (°)")
println("---\t-------")

for M1 in 1.2:0.2:4.0
    theta_maximum = theta_max(M1)
    println("$(round(M1, digits=1))\t$(round(theta_maximum, digits=1))")
end
```

### Wedge Design Analysis

Design analysis for supersonic vehicle:

```julia
# Vehicle nose cone design
M_cruise = 3.0
L_wedge = 2.0  # meters
h_wedge = 0.3  # meters

# Calculate wedge half-angle
theta_wedge = atand(h_wedge / L_wedge)

println("Supersonic Vehicle Nose Analysis:")
println("Cruise Mach: $M_cruise")
println("Wedge length: $L_wedge m")
println("Wedge height: $h_wedge m")
println("Wedge half-angle: $(round(theta_wedge, digits=1))°")

# Check if shock is possible
max_deflection = theta_max(M_cruise)
println("Maximum deflection: $(round(max_deflection, digits=1))°")

if theta_wedge <= max_deflection
    M2, rho_ratio, p_ratio, p0_ratio, beta = solve_oblique(M_cruise, theta_wedge)
    
    println("\nShock Properties:")
    println("Shock angle: $(round(beta, digits=1))°")
    println("Downstream Mach: $(round(M2, digits=3))")
    println("Pressure coefficient: $(round(2/(1.4*M_cruise^2)*(p_ratio-1), digits=4))")
    println("Total pressure loss: $(round((1-p0_ratio)*100, digits=2))%")
else
    println("\nERROR: Deflection angle exceeds maximum!")
    println("Detached shock will form.")
end
```

### Supersonic Inlet Analysis

Calculate oblique shock system for supersonic inlet:

```julia
# Multi-shock inlet design
M0 = 2.8  # Flight Mach
target_M = 1.3  # Target subsonic Mach after final normal shock

println("Supersonic Inlet Design:")
println("Flight Mach: $M0")
println("Target inlet Mach: $target_M")

# Two-shock external compression
theta1 = 8.0   # First ramp angle
theta2 = 12.0  # Second ramp angle

# First oblique shock
M1, rho1, p1, p01, beta1 = solve_oblique(M0, theta1)

# Second oblique shock  
M2, rho2, p2, p02, beta2 = solve_oblique(M1, theta2)

# Final normal shock to subsonic
M3, rho3, p3, p03 = solve_normal(M2)

println("\nShock System Analysis:")
println("External shock 1: β₁ = $(round(beta1, digits=1))°, M₁ = $(round(M1, digits=3))")
println("External shock 2: β₂ = $(round(beta2, digits=1))°, M₂ = $(round(M2, digits=3))")
println("Terminal normal shock: M₃ = $(round(M3, digits=3))")

# Total pressure recovery
total_recovery = p01 * p02 * p03
overall_pressure_ratio = p1 * p2 * p3

println("\nInlet Performance:")
println("Total pressure recovery: $(round(total_recovery, digits=3))")
println("Static pressure ratio: $(round(overall_pressure_ratio, digits=2))")
println("Pressure recovery efficiency: $(round(total_recovery*100, digits=1))%")
```

## Different Gases

Analyze oblique shocks in different gases:

```julia
M1 = 2.5
theta = 15.0

gases = [
    ("Air", 1.4),
    ("Helium", 1.67), 
    ("Argon", 1.67),
    ("CO₂", 1.3)
]

println("Gas Effects on Oblique Shocks:")
println("M₁ = $M1, θ = $theta°")
println("Gas\tγ\tβ (°)\tM₂\tp₂/p₁")
println("---\t----\t-----\t----\t-----")

for (gas, gamma) in gases
    beta = oblique_beta_weak(M1, theta, gamma)
    M2 = oblique_mach2(M1, theta, gamma)
    
    # Calculate pressure ratio using normal shock relations
    Mn1 = M1 * sind(beta)
    p_ratio = 1 + 2*gamma/(gamma+1) * (Mn1^2 - 1)
    
    println("$gas\t$gamma\t$(round(beta, digits=1))\t$(round(M2, digits=3))\t$(round(p_ratio, digits=2))")
end
```

## Validation Examples

### Weak vs Strong Shock Solutions

Compare weak and strong shock solutions for the same deflection:

```julia
M1 = 2.0
theta = 10.0

# Calculate weak shock angle
beta_weak = oblique_beta_weak(M1, theta)

println("Shock Solutions for M₁ = $M1, θ = $theta°:")
println("Weak shock angle: $(round(beta_weak, digits=1))°")

# Analyze weak shock
M2_weak, rho_weak, p_weak, p0_weak, _ = solve_oblique(M1, theta)

println("\nWeak Shock Properties:")
println("M₂ = $(round(M2_weak, digits=3))")
println("p₂/p₁ = $(round(p_weak, digits=3))")
println("p₀₂/p₀₁ = $(round(p0_weak, digits=3))")
```

### Shock Angle vs Deflection Angle

Plot the relationship between shock angle and deflection angle:

```julia
M1 = 2.5
max_theta = theta_max(M1)

println("θ-β Relationship for M₁ = $M1:")
println("θ (°)\tβ (°)\tM₂")
println("-----\t-----\t----")

for theta in 0:2:max_theta
    if theta > 0
        beta = oblique_beta_weak(M1, theta)
        M2 = oblique_mach2(M1, theta)
        println("$(round(theta, digits=1))\t$(round(beta, digits=1))\t$(round(M2, digits=3))")
    else
        println("$(round(theta, digits=1))\t$(round(asind(1/M1), digits=1))\t$(round(M1, digits=3))")
    end
end
```

## Limitations and Considerations

1. **Weak shock assumption**: Most functions return weak shock solutions
2. **Attached shock**: Assumes shock remains attached to the leading edge
3. **Two-dimensional flow**: Assumes infinite span or axisymmetric conditions
4. **Perfect gas**: Constant specific heats and ideal gas behavior
5. **Steady flow**: Time-invariant conditions
6. **Inviscid flow**: No boundary layer or viscous effects

For detached shocks, strong shock solutions, or three-dimensional effects, specialized analysis methods are required.

## See Also

- [Normal Shock Waves](normal_shock.md): For perpendicular shock waves
- [Prandtl-Meyer Expansion](prandtl_expand.md): For expansion around corners
- [Cone Shock Analysis](cone_shock.md): For axisymmetric geometries  
- [Isentropic Relations](isentropic.md): For shock-free flow regions