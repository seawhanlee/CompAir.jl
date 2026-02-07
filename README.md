# CompAir.jl

[![Build Status](https://github.com/seawhanlee/CompAir.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/seawhanlee/CompAir.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://seawhanlee.github.io/CompAir.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://seawhanlee.github.io/CompAir.jl/dev/)

A comprehensive Julia package for computational aerodynamics and compressible flow calculations. This package provides efficient and accurate implementations of fundamental gas dynamics equations and atmospheric models.

**This is a Julia port of the original Python CompAir module developed by Inha AADL.**
Original Python source: https://gitlab.com/aadl_inha/CompAir

This Julia implementation maintains full compatibility with the original Python version while leveraging Julia's performance advantages for numerical computing. The port includes significant improvements in numerical stability, type safety, and computational efficiency.



## Features

### Flow Analysis
- **Isentropic Flow Relations**: Temperature, pressure, and density ratios for compressible flow
- **Normal Shock Waves**: Complete shock wave analysis with property ratios and losses
- **Oblique Shock Waves**: Weak shock solutions with θ-β-M relationships
- **Prandtl-Meyer Expansion**: Expansion wave calculations for supersonic flows
- **Cone Shock Analysis**: Taylor-Maccoll equation solutions for axisymmetric flows

### Nozzle Analysis
- **Quasi-1D Nozzle Flow**: Area-Mach number relationships
- **Mass Flow Calculations**: Flow rate computations with choking conditions
- **Nozzle Performance**: Exit conditions and flow characteristics

### Atmospheric Modeling
- **US Standard Atmosphere 1976**: Complete atmospheric model up to 86km altitude
- **Atmospheric Properties**: Density, pressure, temperature, speed of sound, and viscosity
- **Sutherland Viscosity Law**: Temperature-dependent dynamic viscosity calculations
- **Geopotential Altitude**: Conversion between geometric and geopotential altitudes

## Installation

CompAir.jl is registered in the Julia General Registry. Install it using the standard package manager:

```julia
using Pkg
Pkg.add("CompAir")
```

Or alternatively, in the Julia REPL package mode (press `]`):

```
pkg> add CompAir
```

## Quick Start

```julia
using CompAir

# Isentropic flow properties at Mach 2.0
M = 2.0
T0_T = t0_over_t(M)      # Total to static temperature ratio
p0_p = p0_over_p(M)      # Total to static pressure ratio
rho0_rho = rho0_over_rho(M)  # Total to static density ratio

println("At M = $M:")
println("T₀/T = $(round(T0_T, digits=3))")
println("p₀/p = $(round(p0_p, digits=3))")
println("ρ₀/ρ = $(round(rho0_rho, digits=3))")
```

## Usage Examples

### Normal Shock Analysis

```julia
# Analyze normal shock at Mach 3.0
M1 = 3.0
result = solve_normal(M1)

println("Normal Shock Analysis (M₁ = $M1):")
println("M₂ = $(round(result.M2, digits=3))")
println("ρ₂/ρ₁ = $(round(result.rho2_ratio, digits=3))")
println("p₂/p₁ = $(round(result.p2_ratio, digits=3))")
println("p₀₂/p₀₁ = $(round(result.p0_ratio, digits=3))")
```

### Oblique Shock Analysis

```julia
# Calculate oblique shock for Mach 2.5 and wedge angle 15°
M1 = 2.5
theta = 15.0  # wedge angle in degrees

result = solve_oblique(M1, theta)

println("Oblique Shock Analysis:")
println("M₁ = $M1, θ = $(theta)°")
println("Shock angle β = $(round(result.beta, digits=1))°")
println("M₂ = $(round(result.M2, digits=3))")
```

### Prandtl-Meyer Expansion

```julia
# Expansion from Mach 2.0 through 20° turn
M1 = 2.0
theta = 20.0  # turning angle in degrees

M2 = pm_mach2(M1, theta)
p_ratio = pm_p1_over_p2(M1, theta)

println("Prandtl-Meyer Expansion:")
println("M₁ = $M1 → M₂ = $(round(M2, digits=3))")
println("p₁/p₂ = $(round(p_ratio, digits=3))")
```

### Atmospheric Properties

```julia
# Calculate atmospheric properties at various altitudes
altitudes = [0.0, 11.0, 20.0, 50.0]  # km

for alt in altitudes
    density, pressure, temperature, asound, viscosity = atmos(alt)

    println("Altitude: $(alt) km")
    println("  Density: $(round(density, digits=3)) kg/m³")
    println("  Pressure: $(round(pressure, digits=1)) Pa")
    println("  Temperature: $(round(temperature, digits=1)) K")
    println("  Speed of sound: $(round(asound, digits=1)) m/s")
    println()
end
```

### Nozzle Flow Analysis

```julia
# Calculate area ratio and exit Mach number
M_exit = 3.0
area_ratio = a_over_astar(M_exit)

println("Nozzle Design:")
println("Exit Mach number: $M_exit")
println("Area ratio A/A*: $(round(area_ratio, digits=2))")

# Find Mach number for given area ratio
A_ratio = 5.0
M_subsonic = mach_from_area_ratio(A_ratio, 1.4, 0.1)    # subsonic solution
M_supersonic = mach_from_area_ratio(A_ratio, 1.4, 2.0)  # supersonic solution

println("For A/A* = $A_ratio:")
println("Subsonic M = $(round(M_subsonic, digits=3))")
println("Supersonic M = $(round(M_supersonic, digits=3))")
```

## Recent Improvements

### Version 1.1.1 - Code Quality Improvements
- **Improved internal variable naming**: Enhanced code readability with more descriptive variable names in internal functions
  - Atmospheric model: `h` → `geopotential_altitude`, `dh` → `altitude_difference`
  - Nozzle analysis: `Me6` → `exit_mach`, `pe` → `exit_pressure`
  - Flow analysis: Better closure function names (e.g., `f(x)` → `beta_objective(beta_angle)`)
  - Cone shock: `vec` → `velocity_vector`, `v` → `velocity_magnitude`
  - Multi-stage intake: `n` → `num_stages`, `i` → `stage_index`
  - Note: Public API remains unchanged for backward compatibility

### Version 1.1.0 - Critical Bug Fixes
- **Fixed atmospheric model indexing**: Corrected layer selection algorithm in US Standard Atmosphere 1976
- **Improved Sutherland viscosity**: Updated constants and formula for accurate dynamic viscosity calculations
- **Enhanced parameter handling**: Fixed missing gamma parameters in multiple functions
- **Documentation updates**: Corrected units and improved function descriptions

### Julia Port Enhancements
- **Performance optimizations**: Leveraged Julia's numerical computing capabilities for faster execution
- **Type stability**: Improved type inference and reduced allocations
- **Native Julia integration**: Seamless integration with the Julia ecosystem
- **Enhanced error handling**: Better error messages and edge case management

## API Reference

### Isentropic Relations
- `t0_over_t(M, gamma=1.4)` - Total to static temperature ratio
- `p0_over_p(M, gamma=1.4)` - Total to static pressure ratio
- `rho0_over_rho(M, gamma=1.4)` - Total to static density ratio

### Shock Wave Analysis
- `solve_normal(M, gamma=1.4)` - Complete normal shock analysis
- `solve_oblique(M, theta, gamma=1.4)` - Oblique shock wave properties
- `theta_max(M, gamma=1.4)` - Maximum deflection angle for given Mach number

### Expansion Waves
- `prandtl_meyer(M, gamma=1.4)` - Prandtl-Meyer function ν(M)
- `pm_mach2(M1, theta, gamma=1.4)` - Mach number after expansion
- `pm_p1_over_p2(M1, theta, gamma=1.4)` - Pressure ratio across expansion

### Atmospheric Model
- `atmos(alt)` - Complete atmospheric properties at altitude
- `geo_to_geopot(alt)` - Convert geometric to geopotential altitude
- `sutherland_viscosity(theta)` - Dynamic viscosity from Sutherland's law

### Nozzle Analysis
- `a_over_astar(M, gamma=1.4)` - Area ratio A/A* for given Mach number
- `mach_from_area_ratio(A_ratio, gamma=1.4, x0=0.1)` - Mach number for area ratio
- `mdot(M, area, p0, t0, gamma, R)` - Mass flow rate calculation

## Dependencies

- [DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) - For Taylor-Maccoll equation integration
- [LinearAlgebra](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/) - Vector operations
- [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl) - Optimization routines
- [Roots.jl](https://github.com/JuliaMath/Roots.jl) - Root finding algorithms

## Testing

Run the test suite to verify installation:

```julia
using Pkg
Pkg.test("CompAir")
```

All tests should pass, confirming proper installation and functionality.

## About This Port

### Porting Details

This Julia package is a faithful port of the original Python CompAir module developed by Inha AADL. The porting process involved:

- **Algorithm Translation**: Converting Python numerical algorithms to idiomatic Julia code
- **Performance Optimization**: Leveraging Julia's just-in-time compilation for improved speed
- **Type System Enhancement**: Utilizing Julia's type system for better error detection and performance
- **Bug Fixes**: Identifying and correcting critical issues in the atmospheric model and parameter handling
- **Documentation Enhancement**: Improving function documentation and adding comprehensive examples

### Key Improvements Over Original

- **Numerical Accuracy**: Fixed critical indexing errors in the US Standard Atmosphere 1976 implementation
- **Parameter Consistency**: Resolved missing gamma parameters in multiple shock wave functions
- **Performance**: Achieved significant speed improvements through Julia's numerical computing optimizations
- **Type Safety**: Enhanced reliability through Julia's strong type system
- **Error Handling**: Improved error messages and edge case management

### Acknowledgments

This work builds upon the excellent foundation provided by the Inha AADL team. Their original Python implementation served as the reference for all algorithms and validation cases. We gratefully acknowledge their contribution to the computational aerodynamics community.

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests on [GitHub](https://github.com/seawhanlee/CompAir.jl).

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

## Citation

If you use CompAir.jl in your research, please cite both the original Python module and this Julia port:

```bibtex
@software{CompAir_jl,
  author = {Lee, Seawhan},
  title = {CompAir.jl: A Julia Port of CompAir for Computational Aerodynamics},
  url = {https://github.com/seawhanlee/CompAir.jl},
  version = {1.0.0},
  year = {2024},
  note = {Julia port of the original Python CompAir module by Inha AADL}
}

@software{CompAir_python,
  author = {Inha AADL},
  title = {CompAir: Computational Aerodynamics Module},
  url = {https://gitlab.com/aadl_inha/CompAir},
  year = {2024},
  note = {Original Python implementation}
}
```

## License

This project is licensed under the **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)** license, consistent with the original CompAir module.

**Original Work:**
- Copyright (c) 2022 Inha University AADL (Advanced Aerospace Development Laboratory)
- Source: https://gitlab.com/aadl_inha/CompAir

**Modified Work (CompAir.jl):**
- Copyright (c) 2025 Seawhan Lee
- Source: https://github.com/seawhanlee/CompAir.jl

### License Terms

You are free to:
- **Share** — copy and redistribute the material in any medium or format
- **Adapt** — remix, transform, and build upon the material

Under the following terms:
- **Attribution** — You must give appropriate credit to both the original work and this modified work
- **NonCommercial** — You may not use the material for commercial purposes
- **ShareAlike** — If you remix, transform, or build upon the material, you must distribute your contributions under the same license

See the [LICENSE](LICENSE) file for complete details or visit [Creative Commons](http://creativecommons.org/licenses/by-nc-sa/4.0/) for more information.
