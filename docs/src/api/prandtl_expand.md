# Prandtl-Meyer Expansion

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing Prandtl-Meyer expansion waves, which occur when supersonic flow turns around a convex corner or expands through a diverging channel.

## Overview

Prandtl-Meyer expansion waves are isentropic compression waves that occur when supersonic flow encounters a convex corner or expansion. Unlike shock waves, expansion waves:

- Are isentropic (reversible process)
- Increase Mach number and velocity
- Decrease pressure, density, and temperature
- Maintain total temperature and pressure
- Can turn flow through large angles without losses
- Consist of infinitesimally weak waves (Mach waves)

## Theory

Prandtl-Meyer expansion is governed by the Prandtl-Meyer function ν(M), which relates the Mach number to the maximum turning angle:

**Prandtl-Meyer function**:
$$\nu(M) = \sqrt{\frac{\gamma+1}{\gamma-1}} \arctan\sqrt{\frac{\gamma-1}{\gamma+1}(M^2-1)} - \arctan\sqrt{M^2-1}$$

**Turning angle relationship**:
$$\theta_{12} = \nu(M_2) - \nu(M_1)$$

**Property ratios** (from isentropic relations):
- Pressure: ``\frac{p_2}{p_1} = \left(\frac{1 + \frac{\gamma-1}{2}M_1^2}{1 + \frac{\gamma-1}{2}M_2^2}\right)^{\frac{\gamma}{\gamma-1}}``
- Temperature: ``\frac{T_2}{T_1} = \frac{1 + \frac{\gamma-1}{2}M_1^2}{1 + \frac{\gamma-1}{2}M_2^2}``
- Density: ``\frac{\rho_2}{\rho_1} = \left(\frac{1 + \frac{\gamma-1}{2}M_1^2}{1 + \frac{\gamma-1}{2}M_2^2}\right)^{\frac{1}{\gamma-1}}``

Where:
- ``M_1``, ``M_2`` = upstream and downstream Mach numbers
- ``\theta_{12}`` = turning angle from state 1 to state 2
- ``\gamma`` = specific heat ratio

## Functions

```@docs
prandtl_meyer
pm_mach2
pm_p1_over_p2
pm_theta_from_pratio
```

## Function Details

### prandtl_meyer

```julia
prandtl_meyer(M, gamma=1.4)
```

Calculate the Prandtl-Meyer function ν(M) which represents the maximum turning angle from sonic conditions.

**Arguments:**
- `M::Real`: Mach number (must be ≥ 1)
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Prandtl-Meyer angle ν in degrees

**Formula:**
$$\nu(M) = \sqrt{\frac{\gamma+1}{\gamma-1}} \arctan\sqrt{\frac{\gamma-1}{\gamma+1}(M^2-1)} - \arctan\sqrt{M^2-1}$$

**Example:**
```julia
julia> prandtl_meyer(2.0)
26.379760813416906

julia> prandtl_meyer(3.0)
49.75681638417519

julia> prandtl_meyer(1.0)
0.0
```

### pm_mach2

```julia
pm_mach2(M1, theta, gamma=1.4)
```

Calculate the downstream Mach number after a Prandtl-Meyer expansion through angle θ.

**Arguments:**
- `M1::Real`: Upstream Mach number
- `theta::Real`: Turning angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Downstream Mach number

**Example:**
```julia
julia> pm_mach2(2.0, 20.0)
2.3848314132746953

julia> pm_mach2(1.5, 10.0)
1.7985676229179285
```

### pm_p1_over_p2

```julia
pm_p1_over_p2(M1, theta, gamma=1.4)
```

Calculate the pressure ratio (p₁/p₂) across a Prandtl-Meyer expansion.

**Arguments:**
- `M1::Real`: Upstream Mach number
- `theta::Real`: Turning angle in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Pressure ratio p₁/p₂

**Example:**
```julia
julia> pm_p1_over_p2(2.0, 20.0)
1.687094471207049

julia> pm_p1_over_p2(3.0, 15.0)
1.4720270270270274
```

### pm_theta_from_pratio

```julia
pm_theta_from_pratio(pratio, M1, gamma=1.4)
```

Calculate the turning angle required to achieve a specified pressure ratio across an expansion.

**Arguments:**
- `pratio::Real`: Desired pressure ratio p₁/p₂
- `M1::Real`: Upstream Mach number
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `Float64`: Required turning angle in degrees

**Example:**
```julia
julia> pm_theta_from_pratio(1.5, 2.0)
14.396394107665233

julia> pm_theta_from_pratio(2.0, 2.5)
22.69419642857143
```

## Applications

### Supersonic Nozzle Design

Design the diverging section of a supersonic nozzle:

```julia
# Design requirements
M_exit = 3.5      # Exit Mach number
M_throat = 1.0    # Throat conditions
theta_max = 15.0  # Maximum wall angle

println("Supersonic Nozzle Design:")
println("Exit Mach: $M_exit")
println("Maximum wall angle: $theta_max°")

# Calculate required turning angle
nu_exit = prandtl_meyer(M_exit)
nu_throat = prandtl_meyer(M_throat)  # = 0 for M = 1
theta_required = nu_exit - nu_throat

println("Required turning angle: $(round(theta_required, digits=1))°")

# Check if design is feasible
if theta_required/2 <= theta_max
    println("Design feasible - wall angle: $(round(theta_required/2, digits=1))°")
    
    # Calculate area ratio
    area_ratio = a_over_astar(M_exit)
    println("Area ratio A_exit/A*: $(round(area_ratio, digits=2))")
else
    println("Design not feasible - requires curved walls or multiple sections")
    
    # Calculate required sections
    n_sections = ceil(theta_required / (2 * theta_max))
    println("Minimum sections required: $n_sections")
end
```

### Centered Expansion Fan

Analyze a centered expansion fan:

```julia
M1 = 1.5
theta_total = 30.0  # Total turning angle
n_waves = 6         # Number of Mach waves

println("Centered Expansion Fan Analysis:")
println("Initial Mach: $M1")
println("Total turning: $theta_total°")
println("Number of waves: $n_waves")

theta_step = theta_total / n_waves
println("\nWave\tθ (°)\tM\tμ (°)\tp/p₁")
println("----\t-----\t-----\t-----\t-----")

for i in 0:n_waves
    theta_current = i * theta_step
    
    if i == 0
        M_current = M1
        p_ratio = 1.0
    else
     M_current = pm_mach2(M1, theta_current)
     p_ratio = 1.0 / pm_p1_over_p2(M1, theta_current)
    end
    
    mu = asind(1/M_current)  # Mach angle
    
    println("$i\t$(round(theta_current, digits=1))\t$(round(M_current, digits=3))\t$(round(mu, digits=1))\t$(round(p_ratio, digits=3))")
end
```

### Flow Over Expansion Corner

Analyze flow over a sharp expansion corner:

```julia
# Supersonic flow over a backward-facing step
M1 = 2.2
step_angle = 12.0  # degrees

println("Flow Over Expansion Corner:")
println("Upstream Mach: $M1")
println("Corner angle: $step_angle°")

# Expansion analysis
M2 = pm_mach2(M1, step_angle)
p_ratio = pm_p1_over_p2(M1, step_angle)

# Calculate other properties
T_ratio = (1 + 0.2*M1^2) / (1 + 0.2*M2^2)
rho_ratio = (T_ratio)^(1/0.4)

println("\nDownstream conditions:")
println("Mach number: $(round(M2, digits=3))")
println("Pressure ratio p₁/p₂: $(round(p_ratio, digits=3))")
println("Temperature ratio T₁/T₂: $(round(T_ratio, digits=3))")
println("Density ratio ρ₁/ρ₂: $(round(rho_ratio, digits=3))")

# Wave angles
mu1 = asind(1/M1)  # Upstream Mach angle
mu2 = asind(1/M2)  # Downstream Mach angle

println("\nWave characteristics:")
println("Upstream Mach angle: $(round(mu1, digits=1))°")
println("Downstream Mach angle: $(round(mu2, digits=1))°")
```

### Method of Characteristics Application

Simple application showing characteristic line method concepts:

```julia
# Prandtl-Meyer expansion around a corner
M1 = 2.0
theta_total = 30.0  # Total turning angle
n_steps = 6         # Number of characteristic steps

println("Method of Characteristics Example:")
println("Initial Mach: $M1")
println("Total turning: $theta_total°")
println("Steps: $n_steps")

theta_step = theta_total / n_steps
M_current = M1

println("\nStep\tθ(°)\tM\tν(°)\tμ(°)")
println("----\t----\t-----\t-----\t-----")

for i in 0:n_steps
    theta_current = i * theta_step
    
    if i == 0
        nu_current = prandtl_meyer(M_current)
        mu_current = asind(1/M_current)  # Mach angle
        println("$i\t$(round(theta_current, digits=1))\t$(round(M_current, digits=3))\t$(round(nu_current, digits=2))\t$(round(mu_current, digits=1))")
     else
         M_current = pm_mach2(M1, theta_current)
         nu_current = prandtl_meyer(M_current)
         mu_current = asind(1/M_current)
         println("$i\t$(round(theta_current, digits=1))\t$(round(M_current, digits=3))\t$(round(nu_current, digits=2))\t$(round(mu_current, digits=1))")
     end
end

# Compare with exact solution
M_exact = pm_mach2(M1, theta_total)
println("\nExact solution M_final: $(round(M_exact, digits=3))")
println("Final step M: $(round(M_current, digits=3))")
println("Error: $(round(abs(M_exact - M_current)/M_exact * 100, digits=2))%")
```

## Different Gases

Analyze Prandtl-Meyer expansion for different gases:

```julia
M1 = 2.0
theta = 20.0

gases = [
    ("Air", 1.4),
    ("Helium", 1.67),
    ("Argon", 1.67),
    ("CO₂", 1.3)
]

println("Gas Effects on Prandtl-Meyer Expansion:")
println("M₁ = $M1, θ = $theta°")
println("Gas\tγ\tM₂\tp₁/p₂\tν₁ (°)\tν₂ (°)")
println("---\t----\t----\t----- -----\t------\t------")

for (gas, gamma) in gases
     M2 = pm_mach2(M1, theta, gamma)
     p_ratio = pm_p1_over_p2(M1, theta, gamma)
    nu1 = prandtl_meyer(M1, gamma)
    nu2 = prandtl_meyer(M2, gamma)
    
    println("$gas\t$gamma\t$(round(M2, digits=3))\t$(round(p_ratio, digits=2))\t$(round(nu1, digits=1))\t$(round(nu2, digits=1))")
end
```

## Maximum Turning Angle

Find the maximum theoretical turning angle:

```julia
# For very high Mach numbers, ν approaches a maximum value
M_high = 100.0
nu_max = prandtl_meyer(M_high)

println("Maximum Prandtl-Meyer angle:")
println("ν(M→∞) ≈ $(round(nu_max, digits=1))°")

# Theoretical maximum for γ = 1.4
nu_theoretical = (sqrt((1.4+1)/(1.4-1)) - 1) * 90
println("Theoretical maximum: $(round(nu_theoretical, digits=1))°")
```

## Validation Examples

### Prandtl-Meyer Function Values

Calculate the Prandtl-Meyer function for different Mach numbers:

```julia
println("M\tν(M) (°)")
println("---\t-------")

for M in 1.0:0.2:4.0
    if M > 1.0  # Function only valid for M > 1
        nu = prandtl_meyer(M)
        println("$(round(M, digits=1))\t$(round(nu, digits=1))")
    else
        println("$(round(M, digits=1))\t0.0")
    end
end
```

### Inverse Problem - Find Mach from Turning Angle

Given a turning angle, find the required initial Mach number:

```julia
M2_target = 3.0
theta_given = 25.0  # degrees

# Calculate required upstream Mach number
nu2 = prandtl_meyer(M2_target)
nu1 = nu2 - theta_given

# Find M1 by inverse of Prandtl-Meyer function (iterative)
M1_estimate = 1.5  # Initial guess
tolerance = 1e-6

for i in 1:100
    nu_calc = prandtl_meyer(M1_estimate)
    error = nu_calc - nu1
    
    if abs(error) < tolerance
        break
    end
    
    # Simple Newton-like iteration
    M1_estimate -= error / 10.0
    M1_estimate = max(M1_estimate, 1.001)  # Keep supersonic
end

println("Inverse Prandtl-Meyer Problem:")
println("Target M₂: $M2_target")
println("Given turning angle: $theta_given°")
println("Required M₁: $(round(M1_estimate, digits=3))")

# Verify
M2_check = pm_mach2(M1_estimate, theta_given)
println("Verification M₂: $(round(M2_check, digits=3))")
```

## Limitations and Considerations

1. **Isentropic assumption**: Valid only for gradual expansions without shock waves
2. **Perfect gas**: Constant specific heats and ideal gas behavior
3. **Steady flow**: Time-invariant conditions
4. **Two-dimensional flow**: Assumes planar or axisymmetric geometry
5. **Gradual expansion**: Sharp corners may cause finite-strength waves
6. **Supersonic flow**: Functions only valid for M > 1

For viscous effects, unsteady phenomena, or real gas behavior, additional analysis methods are required.

## See Also

- [Oblique Shock Waves](oblique_shock.md): For compression processes
- [Isentropic Relations](isentropic.md): For property ratios
- [Normal Shock Waves](normal_shock.md): For normal compression
- [Nozzle Analysis](nozzle.md): For nozzle design applications
