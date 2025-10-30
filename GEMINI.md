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
T0_T = total_to_static_temperature_ratio(M)
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

---

# Session Summary (2025-10-30)

This session focused on fixing issues related to the GitHub Actions workflows, specifically the "Documentation" workflow.

1.  **Initial Check**: The user first asked to verify that the CI workflow included tests for Julia version 1.12. This was confirmed to be the case.

2.  **First "Documentation" Workflow Failure**: After a commit and push, it was observed that the "Documentation" workflow was failing. The error was due to a missing dependency (`MatrixFactorizations`) in the `docs/Manifest.toml` file.

3.  **First Fix Attempt**: To resolve the dependency issue, the `CompAir` dependency was removed from `docs/Project.toml`, and the `docs/Manifest.toml` file was regenerated. This fixed the initial error, and the workflow passed.

4.  **Versioning Warnings**: Despite the workflow passing, the user pointed out that there were still warnings related to documentation versioning. The logs showed warnings from `Documenter.jl` about how it was linking different versions of the documentation (`stable`, `v1.0`, `v1`).

5.  **Second Fix Attempt**: To address the versioning warnings, the `versions` argument in the `deploydocs` function in `docs/make.jl` was removed to let `Documenter.jl` handle versioning automatically. This resolved some of the warnings, but not all of them.

6.  **Third Fix Attempt**: A new git tag, `v1.1.0`, was created and pushed to the repository. This was done to ensure that `Documenter.jl` would correctly identify and link the `stable` version of the documentation to the latest release.

7.  **Final Fix**: The `versions` argument was added back to the `deploydocs` function in `docs/make.jl` with a more explicit configuration (`["stable" => "v^", "v#.#"]`). This, in combination with the new `v1.1.0` tag, resolved all the versioning warnings in the "Documentation" workflow.

After these steps, the "Documentation" workflow completed successfully with no warnings.