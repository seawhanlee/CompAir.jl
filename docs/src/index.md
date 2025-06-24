# CompAir.jl

A comprehensive Julia package for computational aerodynamics and compressible flow calculations.




## Overview

CompAir.jl provides efficient and accurate implementations of fundamental gas dynamics equations and atmospheric models. This package is a Julia port of the original Python CompAir module developed by Inha AADL, maintaining full compatibility while leveraging Julia's performance advantages for numerical computing.

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

## Quick Example

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

After installation, load the package:

```julia
using CompAir
```

See the [Installation Guide](manual/installation.md) for detailed instructions and troubleshooting.

## Getting Started

To get started with CompAir.jl:

1. **[Installation](manual/installation.md)**: Install the package and its dependencies
2. **[Quick Start](manual/quickstart.md)**: Basic usage patterns and simple examples
3. **[Examples](manual/examples.md)**: Comprehensive examples for different flow scenarios
4. **Function Reference**: Detailed function documentation in source code

## Table of Contents

```@contents
Pages = [
    "manual/installation.md",
    "manual/quickstart.md",
    "manual/examples.md",
    "dev/contributing.md",
    "dev/changelog.md"
]
Depth = 2
```

## Key Functions

CompAir.jl provides functions organized into several modules for different aspects of compressible flow analysis. See the API Reference for complete documentation.

### Core Functionality
- **Isentropic Relations**: `t0_over_t`, `p0_over_p`, `rho0_over_rho`
- **Shock Wave Analysis**: `solve_normal`, `solve_oblique`
- **Expansion Waves**: `expand_mach2`, `expand_p2`
- **Atmospheric Model**: `atmos1976_at`, `sutherland_mu`
- **Nozzle Analysis**: `area_ratio_at`, `mach_by_area_ratio`
- **Cone Shock Analysis**: `cone_beta_weak`, `cone_mach_surface`

## About This Package

This Julia package is a faithful port of the original Python CompAir module developed by Inha AADL. The porting process involved algorithm translation, performance optimization, type system enhancement, and critical bug fixes in the atmospheric model and parameter handling.

### Key Improvements
- **Numerical Accuracy**: Fixed critical indexing errors in the US Standard Atmosphere 1976 implementation
- **Parameter Consistency**: Resolved missing gamma parameters in shock wave functions
- **Performance**: Significant speed improvements through Julia's numerical computing optimizations
- **Type Safety**: Enhanced reliability through Julia's strong type system
- **Error Handling**: Improved error messages and edge case management

## Citation

If you use CompAir.jl in your research, please cite both the original Python module and this Julia port:

```bibtex
@software{CompAir_jl,
  author = {Lee, Seawhan},
  title = {CompAir.jl: A Julia Port of CompAir for Computational Aerodynamics},
  url = {https://github.com/seawhanlee/CompAir.jl},
  version = {1.0.0},
  year = {2025},
  note = {Julia port of the original Python CompAir module by Inha AADL}
}

@software{CompAir_python,
  author = {Inha AADL},
  title = {CompAir: Computational Aerodynamics Module},
  url = {https://gitlab.com/aadl_inha/CompAir},
  year = {2022},
  note = {Original Python implementation}
}
```

## License

This project is licensed under the MIT License.
