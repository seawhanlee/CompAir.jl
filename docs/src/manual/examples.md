# Examples

This page provides comprehensive examples demonstrating practical use cases and workflows with CompAir.jl.

## Example 1: Supersonic Wind Tunnel Design

Design a supersonic wind tunnel to achieve Mach 2.5 test conditions.

```julia
using CompAir

# Design requirements
M_test = 2.5  # Test section Mach number
p0 = 500000   # Stagnation pressure (Pa)
T0 = 300      # Stagnation temperature (K)

println("=== Supersonic Wind Tunnel Design ===")
println("Target test Mach number: $M_test")

# Calculate nozzle area ratio
area_ratio = area_ratio_at(M_test)
println("Required nozzle area ratio A/A*: $(round(area_ratio, digits=2))")

# Calculate test section conditions
T_ratio = total_to_static_temperature_ratio(M_test)
p_ratio = total_to_static_pressure_ratio(M_test)
rho_ratio = total_to_static_density_ratio(M_test)

T_test = T0 / T_ratio
p_test = p0 / p_ratio
rho_test = 1.225 * p_test / (287 * T_test)  # Using ideal gas law

println("\nTest Section Conditions:")
println("Temperature: $(round(T_test, digits=1)) K")
println("Pressure: $(round(p_test/1000, digits=1)) kPa")
println("Density: $(round(rho_test, digits=3)) kg/m³")

# Calculate Reynolds number per meter
mu = sutherland_viscosity(T_test / 288.15)  # theta = T/T0
Re_per_m = rho_test * M_test * sqrt(1.4 * 287 * T_test) / mu

println("Dynamic viscosity: $(round(mu*1e6, digits=2)) μPa·s")
println("Reynolds number per meter: $(round(Re_per_m/1e6, digits=2)) million/m")
```

## Example 2: Shock Wave Interaction Analysis

Analyze the interaction of an oblique shock with a normal shock.

```julia
using CompAir

# Initial conditions
M1 = 3.0      # Initial Mach number
theta1 = 20.0 # First oblique shock angle (degrees)

println("=== Shock Wave Interaction Analysis ===")
println("Initial Mach number: $M1")

# First oblique shock
M2, rho21, p21, p021, beta1 = solve_oblique(M1, theta1)

println("\nFirst Oblique Shock (θ = $(theta1)°):")
println("Shock angle β₁ = $(round(beta1, digits=1))°")
println("M₂ = $(round(M2, digits=3))")
println("p₂/p₁ = $(round(p21, digits=3))")

# Second oblique shock with different angle
theta2 = 15.0
M3, rho32, p32, p032, beta2 = solve_oblique(M2, theta2)

println("\nSecond Oblique Shock (θ = $(theta2)°):")
println("Shock angle β₂ = $(round(beta2, digits=1))°")
println("M₃ = $(round(M3, digits=3))")
println("p₃/p₂ = $(round(p32, digits=3))")

# Total pressure ratios and losses
total_p_ratio = p21 * p32
total_p0_ratio = p021 * p032

println("\nOverall Results:")
println("Total deflection: $(theta1 + theta2)°")
println("Final Mach number: $(round(M3, digits=3))")
println("Total pressure ratio p₃/p₁: $(round(total_p_ratio, digits=3))")
println("Total pressure loss: $(round((1-total_p0_ratio)*100, digits=1))%")

# Compare with single shock at same total angle
theta_total = theta1 + theta2
M_single, rho_single, p_single, p0_single, beta_single = solve_oblique(M1, theta_total)

println("\nComparison with Single Shock (θ = $(theta_total)°):")
println("Single shock β = $(round(beta_single, digits=1))°")
println("Single shock M₂ = $(round(M_single, digits=3))")
println("Single shock pressure loss: $(round((1-p0_single)*100, digits=1))%")
```

## Example 3: Nozzle Flow with Back Pressure Effects

Analyze nozzle performance under different back pressure conditions.

```julia
using CompAir

# Nozzle geometry
A_ratio_exit = 3.0  # Exit area ratio A_e/A*

println("=== Nozzle Back Pressure Analysis ===")
println("Nozzle exit area ratio: $A_ratio_exit")

# Find design exit Mach number
M_design = mach_by_area_ratio(A_ratio_exit, 1.4, 2.0)  # Supersonic solution
println("Design exit Mach number: $(round(M_design, digits=3))")

# Design exit pressure ratio
p_design = total_to_static_pressure_ratio(M_design)
println("Design exit pressure ratio p₀/pₑ: $(round(p_design, digits=2))")

# Operating conditions
p0 = 300000  # Stagnation pressure (Pa)
p_design_exit = p0 / p_design

println("\nOperating Analysis:")
println("Stagnation pressure: $(p0/1000) kPa")
println("Design exit pressure: $(round(p_design_exit/1000, digits=1)) kPa")

# Different back pressure scenarios
back_pressures = [0.5, 0.8, 1.0, 1.2, 1.5] .* p_design_exit

println("\nBack Pressure Effects:")
println("pb/p₀\t\tpb (kPa)\tFlow Condition")
println("-----\t\t--------\t--------------")

for pb in back_pressures
    pb_ratio = pb / p0
    
    if pb < p_design_exit
        condition = "Overexpanded (design)"
        M_exit = M_design
    elseif pb_ratio > 1/total_to_static_pressure_ratio(1.0)  # Critical pressure ratio
        condition = "Subsonic throughout"
        M_exit = mach_by_area_ratio(A_ratio_exit, 1.4, 0.1)  # Subsonic solution
    else
        condition = "Shock in nozzle"
        M_exit = "Complex"
    end
    
    println("$(round(pb_ratio, digits=3))\t\t$(round(pb/1000, digits=1))\t\t$condition")
end
```

## Example 4: Atmospheric Flight Analysis

Calculate flight conditions at different altitudes and speeds.

```julia
using CompAir

# Flight envelope analysis
altitudes = [0.0, 5.0, 11.0, 20.0, 30.0]  # km
velocities = [200, 300, 400, 500]          # m/s

println("=== Atmospheric Flight Analysis ===")
println("Alt(km)\tV(m/s)\tM\tT(K)\tp(kPa)\tρ(kg/m³)\tRe/m(×10⁶)")
println("------\t------\t-----\t-----\t------\t--------\t----------")

for alt in altitudes
    # Get atmospheric properties
    rho, p, T, a, mu = atmosphere_properties_at(alt)
    
    for V in velocities
        # Calculate flight Mach number
        M = V / a
        
        # Calculate Reynolds number per meter
        Re_per_m = rho * V / mu
        
        # Only print if subsonic or low supersonic (practical range)
        if M < 3.0
            println("$(alt)\t$(V)\t$(round(M, digits=2))\t$(round(T, digits=1))\t$(round(p/1000, digits=1))\t$(round(rho, digits=3))\t\t$(round(Re_per_m/1e6, digits=2))")
        end
    end
end

# High-altitude supersonic analysis
println("\n=== High-Altitude Supersonic Flight ===")
alt_cruise = 18.0  # km (typical supersonic cruise altitude)
M_cruise = 2.0     # Cruise Mach number

rho, p, T, a, mu = atmosphere_properties_at(alt_cruise)
V_cruise = M_cruise * a

println("Cruise conditions at $(alt_cruise) km altitude:")
println("Mach number: $M_cruise")
println("True airspeed: $(round(V_cruise, digits=1)) m/s")
println("Temperature: $(round(T, digits=1)) K")
println("Pressure: $(round(p/1000, digits=1)) kPa")
println("Density: $(round(rho, digits=3)) kg/m³")

# Calculate stagnation conditions
T0 = T * total_to_static_temperature_ratio(M_cruise)
p0 = p * total_to_static_pressure_ratio(M_cruise)

println("\nStagnation conditions:")
println("Stagnation temperature: $(round(T0, digits=1)) K")
println("Stagnation pressure: $(round(p0/1000, digits=1)) kPa")
```

## Example 5: Shock-Expansion Method for Airfoil Analysis

Analyze supersonic flow over a diamond airfoil using shock-expansion theory.

```julia
using CompAir

# Diamond airfoil geometry
half_angle = 5.0  # degrees
M_inf = 2.5       # Freestream Mach number

println("=== Diamond Airfoil Analysis ===")
println("Half angle: $(half_angle)°")
println("Freestream Mach: $M_inf")

# Upper surface analysis
println("\nUpper Surface:")

# Leading edge oblique shock
M2_upper, rho21_upper, p21_upper, p021_upper, beta1_upper = solve_oblique(M_inf, half_angle)
println("Leading edge shock:")
println("  Shock angle: $(round(beta1_upper, digits=1))°")
println("  M₂: $(round(M2_upper, digits=3))")
println("  p₂/p₁: $(round(p21_upper, digits=3))")

# Trailing edge expansion
M3_upper = expand_mach2(M2_upper, 2*half_angle)  # Turn back to freestream direction
p31_upper = expand_p2(M2_upper, 2*half_angle)    # Pressure ratio p2/p3

println("Trailing edge expansion:")
println("  M₃: $(round(M3_upper, digits=3))")
println("  p₂/p₃: $(round(p31_upper, digits=3))")

# Lower surface analysis  
println("\nLower Surface:")

# Leading edge expansion
M2_lower = expand_mach2(M_inf, half_angle)
p21_lower = expand_p2(M_inf, half_angle)

println("Leading edge expansion:")
println("  M₂: $(round(M2_lower, digits=3))")
println("  p₁/p₂: $(round(p21_lower, digits=3))")

# Trailing edge shock
M3_lower, rho32_lower, p32_lower, p032_lower, beta2_lower = solve_oblique(M2_lower, half_angle)

println("Trailing edge shock:")
println("  Shock angle: $(round(beta2_lower, digits=1))°")
println("  M₃: $(round(M3_lower, digits=3))")
println("  p₃/p₂: $(round(p32_lower, digits=3))")

# Pressure coefficient calculation
p_upper = p21_upper  # Pressure on upper surface relative to freestream
p_lower = 1.0 / p21_lower  # Pressure on lower surface relative to freestream

Cp_upper = 2/(1.4 * M_inf^2) * (p_upper - 1)
Cp_lower = 2/(1.4 * M_inf^2) * (p_lower - 1)

println("\nPressure Coefficients:")
println("Upper surface Cp: $(round(Cp_upper, digits=4))")
println("Lower surface Cp: $(round(Cp_lower, digits=4))")
println("ΔCp (lift): $(round(Cp_lower - Cp_upper, digits=4))")
```

## Example 6: Converging-Diverging Nozzle Starting Problem

Analyze the starting process of a supersonic nozzle.

```julia
using CompAir

# Nozzle geometry
A_ratio_exit = 4.0  # Exit area ratio

println("=== CD Nozzle Starting Analysis ===")
println("Exit area ratio A_e/A*: $A_ratio_exit")

# Find required pressure ratios
M_exit_design = mach_by_area_ratio(A_ratio_exit, 1.4, 2.0)  # Supersonic
p_ratio_design = total_to_static_pressure_ratio(M_exit_design)

println("Design exit Mach: $(round(M_exit_design, digits=3))")
println("Required pressure ratio p₀/pb: $(round(p_ratio_design, digits=2))")

# Starting pressure ratio (when shock is at exit)
# At nozzle exit, we need the shock to just disappear
M_shock_upstream = M_exit_design
M_shock_downstream, _, _, p0_loss, _ = solve_normal(M_shock_upstream)

# The upstream stagnation pressure must account for the shock loss
p_ratio_starting = p_ratio_design / p0_loss

println("Starting pressure ratio: $(round(p_ratio_starting, digits=2))")
println("Overexpansion ratio: $(round(p_ratio_starting/p_ratio_design, digits=2))")

# Operating map
println("\nOperating Conditions:")
println("p₀/pb\t\tCondition\t\tExit Mach")
println("-----\t\t---------\t\t---------")

pressure_ratios = [1.0, 2.0, 5.0, 10.0, p_ratio_starting, p_ratio_design * 1.1]

for pr in pressure_ratios
    if pr < 1.89  # Critical pressure ratio for choking
        condition = "No choking"
        M_exit = "< 1"
    elseif pr < p_ratio_starting
        condition = "Shock in nozzle"
        M_exit = "Variable"
    elseif pr ≈ p_ratio_starting
        condition = "Shock at exit"
        M_exit = "$(round(M_shock_downstream, digits=3))"
    elseif pr < p_ratio_design
        condition = "Underexpanded"
        M_exit = "$(round(M_exit_design, digits=3))"
    else
        condition = "Design/Overexpanded"
        M_exit = "$(round(M_exit_design, digits=3))"
    end
    
    println("$(round(pr, digits=1))\t\t$condition\t\t$M_exit")
end
```

## Example 7: Method of Characteristics Application

Simple application showing characteristic line method concepts.

```julia
using CompAir

# Prandtl-Meyer expansion around a corner
M1 = 2.0
theta_total = 30.0  # Total turning angle
n_steps = 6         # Number of characteristic steps

println("=== Method of Characteristics Example ===")
println("Initial Mach: $M1")
println("Total turning: $(theta_total)°")
println("Steps: $n_steps")

theta_step = theta_total / n_steps

println("\nStep\tθ(°)\tM\tν(°)\tμ(°)")
println("----\t----\t-----\t-----\t-----")

for i in 0:n_steps
    theta_current = i * theta_step
    M_current = (i == 0) ? M1 : expand_mach2(M1, theta_current)
    nu_current = prandtl_meyer(M_current)
    mu_current = asind(1/M_current)  # Mach angle
    println("$i\t$(round(theta_current, digits=1))\t$(round(M_current, digits=3))\t$(round(nu_current, digits=2))\t$(round(mu_current, digits=1))")
end

# Compare with exact solution
M_exact = expand_mach2(M1, theta_total)
println("\nExact solution M_final: $(round(M_exact, digits=3))")
```

These examples demonstrate the versatility of CompAir.jl for solving practical compressible flow problems. Each example builds upon the basic functions to analyze complex scenarios encountered in aerospace engineering, propulsion systems, and wind tunnel design.