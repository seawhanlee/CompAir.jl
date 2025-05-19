# CompAir.jl

A Julia package for computational aerodynamics and compressible flow calculations.

## Features

- US Standard Atmosphere 1976 model
- Cone shock calculations
- Isentropic flow analysis
- Normal shock wave calculations
- Nozzle flow analysis
- Oblique shock wave calculations
- Prandtl-Meyer expansion waves

## Installation

```julia
using Pkg
Pkg.add("https://github.com/yourusername/CompAir.jl.git")
```

## Usage

```julia
using CompAir

# Example: Calculate normal shock properties
M1 = 2.0  # Upstream Mach number
properties = normal_shock(M1)

# Example: Calculate atmospheric properties
altitude = 10000  # meters
atmos = atmos1976(altitude)
```

## Dependencies

- DifferentialEquations.jl
- LinearAlgebra
- Optim.jl
- Roots.jl

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
