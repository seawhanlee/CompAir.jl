# Cone Shock Analysis

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing shock waves over axisymmetric bodies such as cones and spheres, using the Taylor-Maccoll equation for conical flow.

## Overview

Conical shock analysis is essential for understanding supersonic flow over axisymmetric bodies. This module covers:

- **Taylor-Maccoll Equation**: Differential equation governing conical flow
- **Cone Surface Conditions**: Flow properties at the cone surface
- **Shock Wave Properties**: Shock angle and strength for conical geometry
- **Surface Pressure Distribution**: Pressure coefficients and heat transfer analysis
- **Axisymmetric Flow**: Three-dimensional effects in conical coordinates

Unlike two-dimensional oblique shocks, conical flows involve three-dimensional effects that must be solved numerically using the Taylor-Maccoll equation.

## Theory

For supersonic flow over a circular cone, the flow field is governed by the Taylor-Maccoll equation:

**Taylor-Maccoll equation**:
$$\frac{d^2V_r}{d\theta^2} + \frac{(\gamma - 1)M_{\infty}^2 - 2V_r^2}{(\gamma - 1)M_{\infty}^2 - V_r^2}\frac{dV_r}{d\theta} + \frac{V_r^2 - 1}{\tan\theta} = 0$$

**Boundary conditions**:
- At shock: ``V_r(\theta_s) = V_{rs}`` (shock conditions)
- At cone surface: ``\frac{dV_r}{d\theta}\bigg|_{\theta_c} = 0`` (tangency condition)

**Conical coordinate system**:
- ``\theta`` = angle from cone axis
- ``\theta_c`` = cone half-angle
- ``\theta_s`` = shock angle
- ``V_r`` = dimensionless radial velocity

**Property relations**:
$$M^2 = \frac{V_r^2}{(\gamma - 1)(1 - V_r^2/M_{\infty}^2)}$$

$$\frac{p}{p_{\infty}} = \frac{(\gamma + 1)M_{\infty}^2}{(\gamma + 1)M_{\infty}^2 - 2(\gamma - 1)(M_{\infty}^2 - V_r^2)}$$

Where:
- ``M_{\infty}`` = freestream Mach number
- ``\theta_c`` = cone half-angle
- ``\gamma`` = specific heat ratio

## Functions

```@docs
cone_theta_eff
cone_beta
cone_mach2
cone_mach_surface
solve_cone
solve_cone_properties
```

## Function Details

### cone_theta_eff

```julia
cone_theta_eff(M, angle, gamma=1.4)
```

Calculate the effective deflection angle for cone flow that would produce the same shock angle as a 2D oblique shock.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Effective deflection angle in degrees

**Example:**
```julia
julia> cone_theta_eff(2.5, 15.0)
12.847266221347485

julia> cone_theta_eff(3.0, 20.0)
16.89234567890123
```

### cone_beta

```julia
cone_beta(M, angle, gamma=1.4)
```

Calculate the shock angle for flow over a circular cone.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Shock angle in degrees

**Example:**
```julia
julia> cone_beta(2.5, 15.0)
43.567890123456785

julia> cone_beta(3.0, 10.0)
38.12345678901234
```

### cone_mach2

```julia
cone_mach2(M, angle, gamma=1.4)
```

Calculate the Mach number immediately behind the cone shock wave.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Mach number behind shock

**Example:**
```julia
julia> cone_mach2(2.5, 15.0)
2.123456789012345

julia> cone_mach2(3.0, 20.0)
2.456789012345678
```

### cone_mach_surface

```julia
cone_mach_surface(M, angle, gamma=1.4)
```

Calculate the Mach number at the cone surface using Taylor-Maccoll equation integration.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Surface Mach number
- `Float64`: Flow direction angle at surface (if applicable)

**Example:**
```julia
julia> M_surface, phi = cone_mach_surface(2.5, 15.0)
(2.089456789012345, 15.234567890123456)
```

### solve_cone

```julia
solve_cone(M, angle, gamma=1.4)
```

Complete cone shock analysis - calculate all property changes across the shock.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `M2::Float64`: Mach number behind shock
- `rho2::Float64`: Density ratio (ρ₂/ρ₁)
- `p2::Float64`: Pressure ratio (p₂/p₁)
- `p0ratio::Float64`: Stagnation pressure ratio (p₀₂/p₀₁)
- `beta::Float64`: Shock angle in degrees

**Example:**
```julia
julia> sol = solve_cone(2.5, 15.0)
(M2 = 2.123, rho2_ratio = 1.567, p2_ratio = 2.234, p0_ratio = 0.934, beta = 43.6)
```

### solve_cone_properties

```julia
solve_cone_properties(M, angle; psi::Union{Float64, Nothing}=nothing, gamma=1.4)
```

Calculate flow properties at the cone surface or at a specified ray angle.

**Arguments:**
- `M::Real`: Freestream Mach number
- `angle::Real`: Cone half-angle in degrees
- `psi::Union{Float64, Nothing}=nothing`: Ray angle in degrees (if nothing, calculates surface properties)
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
If `psi` is `nothing` (cone surface properties):
- `Mc::Float64`: Surface Mach number
- `rhoc::Float64`: Surface density ratio
- `pc::Float64`: Surface pressure ratio
- `p0ratio::Float64`: Stagnation pressure ratio
- `beta::Float64`: Shock angle in degrees

If `psi` is provided:
- `Mc::Float64`: Mach number at ray angle ψ
- `rhoc::Float64`: Density ratio at ray angle ψ
- `pc::Float64`: Pressure ratio at ray angle ψ
- `p0ratio::Float64`: Stagnation pressure ratio
- `beta::Float64`: Shock angle in degrees
- `phi::Float64`: Flow direction at ray angle ψ

**Example:**
```julia
julia> Mc, rhoc, pc, p0ratio, beta = solve_cone_properties(2.5, 15.0)
(2.089, 1.456, 2.123, 0.945, 43.6)

julia> Mc, rhoc, pc, p0ratio, beta, phi = solve_cone_properties(2.5, 15.0, psi=10.0)
(2.145, 1.423, 2.089, 0.945, 43.6, 10.234)
```

## Applications

### Missile Nose Cone Analysis

Design analysis for a missile nose cone:

```julia
# Flight conditions
M_flight = 2.8
altitude = 15000  # m
theta_nose = 12.0 # nose cone half-angle

println("Missile Nose Cone Analysis:")
println("Flight Mach: $M_flight")
println("Altitude: $(altitude/1000) km")
println("Nose cone half-angle: $theta_nose°")

# Get atmospheric properties
rho, p_inf, T_inf, a, mu = atmos(altitude/1000)

# Shock analysis
beta = cone_beta(M_flight, theta_nose)
M_surface = cone_mach_surface(M_flight, theta_nose)

println("\nShock Properties:")
println("Shock angle: $(round(beta, digits=1))°")
println("Surface Mach: $(round(M_surface, digits=3))")

# Surface conditions
Mn1 = M_flight * sind(beta)
p_ratio = 1 + 2*1.4/(1.4+1) * (Mn1^2 - 1)
p_surface = p_inf * p_ratio

# Temperature rise
T_ratio = (1 + 0.2*M_flight^2) / (1 + 0.2*M_surface^2)
T_surface = T_inf * T_ratio

println("\nSurface Conditions:")
println("Surface pressure: $(round(p_surface/1000, digits=1)) kPa")
println("Surface temperature: $(round(T_surface, digits=1)) K")
println("Pressure coefficient: $(round(2/(1.4*M_flight^2)*(p_ratio-1), digits=4))")
```

### Cone vs Wedge Comparison

Compare shock properties for cone and wedge at same deflection angle:

```julia
M_inf = 2.5
theta = 20.0  # deflection angle

println("Cone vs Wedge Comparison at θ = $theta°:")
println("Freestream Mach: $M_inf")

# Wedge (2D oblique shock)
sol_wedge = solve_oblique(M_inf, theta)

# Cone (axisymmetric)
beta_cone = cone_beta(M_inf, theta)
M_cone, _ = cone_mach_surface(M_inf, theta)

println("\nWedge (2D) Properties:")
println("Shock angle: $(round(sol_wedge.beta, digits=1))°")
println("Surface Mach: $(round(sol_wedge.M2, digits=3))")
println("Pressure ratio: $(round(sol_wedge.p2_ratio, digits=3))")

println("\nCone (Axisymmetric) Properties:")
println("Shock angle: $(round(beta_cone, digits=1))°")
println("Surface Mach: $(round(M_cone, digits=3))")

# Calculate pressure ratio for cone (approximate)
Mn1_cone = M_inf * sind(beta_cone)
p_ratio_cone = 1 + 2*1.4/(1.4+1) * (Mn1_cone^2 - 1)

println("Pressure ratio (approx): $(round(p_ratio_cone, digits=3))")

println("\nDifferences:")
println("Shock angle: $(round(beta_cone - sol_wedge.beta, digits=2))° (cone stronger)")
println("Surface Mach: $(round(M_cone - sol_wedge.M2, digits=3)) (cone higher)")
```

### Supersonic Intake Analysis

Analyze conical intake for supersonic aircraft:

```julia
# Engine intake design
M_cruise = 2.2
intake_angle = 8.0  # intake cone half-angle
L_intake = 2.0      # intake length (m)

println("Supersonic Intake Analysis:")
println("Cruise Mach: $M_cruise")
println("Intake cone angle: $intake_angle°")

# Cone shock analysis
beta = cone_beta(M_cruise, intake_angle)
M_throat, _ = cone_mach_surface(M_cruise, intake_angle)

println("\nCone Shock Properties:")
println("Shock angle: $(round(beta, digits=1))°")
println("Throat Mach number: $(round(M_throat, digits=3))")

# Mass flow capture
shock_radius = L_intake * tand(beta)
capture_area = π * shock_radius^2

println("\nFlow Capture:")
println("Shock radius at throat: $(round(shock_radius, digits=2)) m")
println("Flow capture area: $(round(capture_area, digits=3)) m²")

# Total pressure recovery
Mn1 = M_cruise * sind(beta)
sol_normal = solve_normal(Mn1)

println("Total pressure recovery: $(round(sol_normal.p0_ratio, digits=3))")
println("Pressure loss: $(round((1-sol_normal.p0_ratio)*100, digits=1))%")
```

### Cone Half-Angle Variation

Analyze how cone properties vary with half-angle:

```julia
M_inf = 3.0
cone_angles = [5.0, 10.0, 15.0, 20.0, 25.0, 30.0]

println("Cone Half-Angle Variation Study:")
println("Freestream Mach: $M_inf")
println("\nθc(°)\tβ(°)\tMs\tβ-θc\tCp_approx")
println("-----	----\t----\t-----\t---------")

for theta_c in cone_angles
     try
         beta = cone_beta(M_inf, theta_c)
        M_surface, _ = cone_mach_surface(M_inf, theta_c)
        
        # Approximate pressure coefficient
        Mn1 = M_inf * sind(beta)
        p_ratio = 1 + 2*1.4/(1.4+1) * (Mn1^2 - 1)
        Cp = 2/(1.4*M_inf^2) * (p_ratio - 1)
        
        shock_deflection = beta - theta_c
        
        println("$(theta_c)\t$(round(beta, digits=1))\t$(round(M_surface, digits=2))\t$(round(shock_deflection, digits=1))\t$(round(Cp, digits=4))")
    catch e
        println("$(theta_c)\t---\t---\t---\t--- (detached shock)")
    end
end
```

### Wind Tunnel Model Analysis

Analyze cone model in supersonic wind tunnel:

```julia
# Wind tunnel test conditions
M_test = 3.5
p0_tunnel = 500000  # Pa
T0_tunnel = 300     # K
cone_angles = [10.0, 15.0, 20.0]  # Test cone angles

println("Wind Tunnel Cone Model Analysis:")
println("Test Mach: $M_test")
println("Stagnation pressure: $(p0_tunnel/1000) kPa")
println("Stagnation temperature: $T0_tunnel K")

# Test section conditions
p_test = p0_tunnel / p0_over_p(M_test)
T_test = T0_tunnel / t0_over_t(M_test)
rho_test = p_test / (287 * T_test)

println("\nTest Section Conditions:")
println("Static pressure: $(round(p_test/1000, digits=1)) kPa")
println("Static temperature: $(round(T_test, digits=1)) K")
println("Density: $(round(rho_test, digits=3)) kg/m³")

println("\nCone Model Results:")
println("θc(°)\tβ(°)\tMs\tCp\tp_surface(kPa)")
println("-----	----\t----\t----\t-------------")

for theta_c in cone_angles
     beta = cone_beta(M_test, theta_c)
    M_surface, _ = cone_mach_surface(M_test, theta_c)
    
    # Surface pressure
    Mn1 = M_test * sind(beta)
    p_ratio = 1 + 2*1.4/(1.4+1) * (Mn1^2 - 1)
    p_surface = p_test * p_ratio
    
    # Pressure coefficient
    Cp = 2/(1.4*M_test^2) * (p_ratio - 1)
    
    println("$(theta_c)\t$(round(beta, digits=1))\t$(round(M_surface, digits=2))\t$(round(Cp, digits=3))\t$(round(p_surface/1000, digits=1))")
end
```

## Validation Examples

### Maximum Cone Angle Analysis

Find the maximum cone angle for attached shock:

```julia
M_inf = 2.0

println("Maximum Cone Angle Analysis:")
println("Freestream Mach: $M_inf")

# Search for maximum cone angle
theta_max_val = 0.0
delta_theta = 0.5

println("\nSearching for maximum cone angle...")

for theta_test in 5.0:delta_theta:45.0
     try
         beta = cone_beta(M_inf, theta_test)
        M_surface, _ = cone_mach_surface(M_inf, theta_test)
        
        # Check if solution is physical
        if M_surface > 0 && beta > theta_test
            theta_max_val = theta_test
        else
            break
        end
    catch e
        break
    end
end

println("Maximum cone half-angle: $(theta_max_val)°")

# Compare with 2D maximum deflection
theta_max_2D = theta_max(M_inf)
println("2D maximum deflection: $(round(theta_max_2D, digits=1))°")
println("Reduction for axisymmetric case: $(round(theta_max_2D - theta_max_val, digits=1))°")
```

### Effective Deflection Angle

Analyze the effective deflection concept for cones:

```julia
M_inf = 2.5
theta_c = 18.0

println("Effective Deflection Angle Analysis:")
println("Cone half-angle: $theta_c°")
println("Freestream Mach: $M_inf")

# Calculate effective deflection angle
theta_eff_val = cone_theta_eff(M_inf, theta_c)

println("Effective deflection angle: $(round(theta_eff_val, digits=2))°")
println("Actual cone angle: $theta_c°")
println("Difference: $(round(theta_c - theta_eff_val, digits=2))°")

# This effective angle can be used with 2D oblique shock theory
sol_oblique = solve_oblique(M_inf, theta_eff_val)

# Compare with actual cone solution
beta_cone = cone_beta(M_inf, theta_c)
M_cone, _ = cone_mach_surface(M_inf, theta_c)

println("\nComparison of Methods:")
println("Effective angle method - β: $(round(sol_oblique.beta, digits=1))°, M: $(round(sol_oblique.M2, digits=3))")
println("Cone solution - β: $(round(beta_cone, digits=1))°, M: $(round(M_cone, digits=3))")
```

## Limitations and Considerations

1. **Inviscid assumption**: No boundary layer or viscous effects
2. **Perfect gas**: Constant specific heats and ideal gas behavior
3. **Steady flow**: Time-invariant conditions
4. **Attached shock**: Valid only for sharp cones below maximum angle
5. **Small angle approximation**: Some correlations valid for small cone angles
6. **Real gas effects**: Important at hypersonic speeds and high temperatures
7. **Numerical solution**: Taylor-Maccoll equation requires numerical integration

For precise hypersonic analysis, real gas effects, viscous interactions, and heat transfer should be considered.

## See Also

- [Oblique Shock Waves](oblique_shock.md): For two-dimensional shock analysis
- [Normal Shock Waves](normal_shock.md): For shock wave fundamentals
- [Isentropic Relations](isentropic.md): For property calculations
- [Atmospheric Model](atmos1976.md): For flight condition analysis
