# CompAir.jl Project Overview

This document provides a comprehensive overview of the `CompAir.jl` project, intended to be used as instructional context for an AI assistant.

## Project Purpose and Technologies

`CompAir.jl` is a Julia package for computational aerodynamics and compressible flow calculations. It provides implementations of fundamental gas dynamics equations and atmospheric models. The project is a Julia port of the original Python `CompAir` module, leveraging Julia's performance for numerical computing.

- **Language:** Julia
- **Key Dependencies:**
    - `DiffEqBase.jl` and `OrdinaryDiffEq.jl` for solving differential equations (specifically the Taylor-Maccoll equation for cone shocks).
    - `Optim.jl` for optimization routines.
    - `Roots.jl` for root-finding algorithms.
    - `LinearAlgebra.jl` for vector operations.
- **Project Status:** The project is well-established with version 1.0.1 released and registered in the Julia General Registry.

## Building, Running, and Testing

### Installation

The package is registered in the Julia General Registry. It can be installed using the Julia package manager:

```julia
using Pkg
Pkg.add("CompAir")
```

Or in the package manager REPL mode:

```
pkg> add CompAir
```

### Running the Code

The package is a library, so its functions are meant to be used within other Julia code. The `README.md` provides a "Quick Start" guide and several usage examples for various calculations.

For example, to use the isentropic flow relations:

```julia
using CompAir

M = 2.0
T0_T = t0_over_t(M)
println("T₀/T = $(round(T0_T, digits=3))")
```

### Testing

The project uses the standard Julia `Test` framework. The test suite is located in the `test/` directory, with `runtests.jl` as the main entry point. Tests can be run using the Julia package manager:

```julia
using Pkg
Pkg.test("CompAir")
```

The CI configuration in `.github/workflows/CI.yml` confirms that this is the standard testing procedure. The CI runs tests on multiple versions of Julia and across different operating systems (Linux, macOS, Windows).

## Development Conventions

- **Code Style:** The code is organized into modules, with a main `CompAir.jl` file that includes the other source files. The code is well-documented with comments and docstrings.
- **Testing:** The project has a comprehensive test suite, with tests for each major feature. This indicates a strong emphasis on code quality and correctness.
- **CI/CD:** The project uses GitHub Actions for continuous integration. The CI pipeline automatically builds and tests the package on every push and pull request.
- **Dependency Management:** The project uses `Project.toml` and `Manifest.toml` to manage dependencies. `CompatHelper.yml` is configured to automatically create pull requests for updating dependencies.
- **Release Management:** `TagBot.yml` is used to automatically create GitHub tags and releases when new versions are registered.
- **Documentation:** The project has a `docs` directory with `Documenter.jl` (`make.jl`) to generate documentation. The documentation is hosted on GitHub Pages.

## File Structure Overview

- **`.github/`**: Contains GitHub Actions workflows for CI, documentation, and dependency management.
- **`docs/`**: Contains the source files for the project's documentation.
- **`src/`**: Contains the main source code for the package, with each file corresponding to a specific feature.
- **`test/`**: Contains the test suite for the package.
- **`Project.toml`**: Defines the project's metadata, dependencies, and compatibility constraints.
- **`Manifest.toml`**: Records the exact versions of all dependencies used in the project.
- **`README.md`**: Provides a detailed overview of the project, installation instructions, and usage examples.
