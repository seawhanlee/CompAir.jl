# Installation

This guide covers how to install CompAir.jl and its dependencies.

## Requirements

- Julia 1.11 or later
- Internet connection for package downloads

## Installing Julia

If you don't have Julia installed, download it from [julialang.org](https://julialang.org/downloads/). CompAir.jl requires Julia 1.11 or later.

## Package Installation

### From Julia General Registry (Recommended)

CompAir.jl is now registered in the Julia General Registry. Install it using the standard package manager:

```julia
using Pkg
Pkg.add("CompAir")
```

### From GitHub (Development)

If you want to contribute to the package or need the latest development version:

```julia
using Pkg
Pkg.add(url="https://github.com/seawhanlee/CompAir.jl.git")
```

For development work, use:

```julia
using Pkg
Pkg.develop(url="https://github.com/seawhanlee/CompAir.jl.git")
```

This will clone the repository to your local Julia development directory (usually `~/.julia/dev/`).

## Dependencies

CompAir.jl automatically installs the following dependencies:

- **[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) v7.16.1+**: For solving the Taylor-Maccoll equation in cone shock analysis
- **[LinearAlgebra](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/)**: Standard library for vector operations
- **[Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl) v1.12.0+**: Optimization routines for iterative solutions
- **[Roots.jl](https://github.com/JuliaMath/Roots.jl) v2.2.7+**: Root finding algorithms for implicit equations

## Verification

After installation, verify that everything works correctly:

```julia
using CompAir

# Test basic functionality
M = 2.0
println("T₀/T at M=$M: ", t0_over_t(M))
println("Installation successful!")
```

You should see output similar to:
```
T₀/T at M=2.0: 1.8
Installation successful!
```

## Running Tests

To ensure the package is working correctly, run the test suite:

```julia
using Pkg
Pkg.test("CompAir")
```

All tests should pass. If you encounter any failures, please [report an issue](https://github.com/seawhanlee/CompAir.jl/issues).

## Troubleshooting

### Common Issues

#### Package Not Found
If you get an error like "package CompAir not found", ensure you have an internet connection and try updating your registry:

```julia
using Pkg
Pkg.Registry.update()
```

#### Dependency Conflicts
If you encounter dependency conflicts, try updating your Julia packages:

```julia
using Pkg
Pkg.update()
```

#### Permission Issues
On some systems, you might need to run Julia with appropriate permissions or check your firewall settings.

### Getting Help

If you encounter installation issues:

1. Check the [GitHub Issues](https://github.com/seawhanlee/CompAir.jl/issues) for similar problems
2. Ensure you're using Julia 1.11 or later
3. Try installing in a fresh Julia environment
4. Create a new issue with your error message and system information

## Next Steps

Once installation is complete, head to the [Quick Start](quickstart.md) guide to learn basic usage patterns, or browse the [Examples](examples.md) for comprehensive use cases.