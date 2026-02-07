# Contributing to CompAir.jl

We welcome contributions to CompAir.jl! This guide will help you get started with contributing to the project.

## Getting Started

### Prerequisites

- Julia 1.11 or later
- Git
- GitHub account

### Setting Up the Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/CompAir.jl.git
   cd CompAir.jl
   ```

3. **Set up the development environment**:
   ```julia
   using Pkg
   Pkg.activate(".")
   Pkg.instantiate()
   ```

4. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/seawhanlee/CompAir.jl.git
   ```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Use descriptive branch names:
- `feature/add-real-gas-effects`
- `bugfix/fix-atmospheric-indexing`
- `docs/improve-examples`

### 2. Make Your Changes

- Write clean, readable code
- Follow Julia naming conventions
- Add docstrings to new functions
- Include appropriate error handling

### 3. Test Your Changes

Run the test suite to ensure nothing is broken:

```julia
using Pkg
Pkg.test()
```

Add tests for new functionality:

```julia
# Add tests to test/ directory
# Follow existing test patterns
```

### 4. Update Documentation

If you've added new functions or changed existing ones:

- Update docstrings with proper formatting
- Add examples to the documentation
- Update API reference if needed

### 5. Commit Your Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "Add real gas effects to shock calculations

- Implement virial equation of state
- Add temperature-dependent specific heats
- Update shock wave relations for real gas
- Add validation tests against experimental data"
```

### 6. Submit a Pull Request

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a pull request on GitHub
3. Fill out the pull request template
4. Link any related issues

## Code Style Guidelines

### Julia Style

Follow the [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/):

- Use `snake_case` for function and variable names
- Use `PascalCase` for types and modules
- Use descriptive names: `calculate_shock_angle` not `calc_beta`
- Keep lines under 92 characters when practical

### Docstring Format

Use the following format for docstrings:

```julia
"""
    function_name(arg1, arg2; keyword=default)

Brief description of what the function does.

# Arguments
- `arg1::Type`: Description of first argument
- `arg2::Type`: Description of second argument
- `keyword::Type=default`: Description of keyword argument

# Returns
- `result::Type`: Description of return value

# Examples
```jldoctest
julia> function_name(1.5, 2.0)
3.5
```

# Notes
Any additional notes about the function behavior, limitations, or theory.
"""
function function_name(arg1, arg2; keyword=default)
    # Implementation
end
```

### Error Handling

- Use appropriate exception types
- Provide helpful error messages
- Check input validity early

```julia
function example_function(M::Real)
    if M <= 0
        throw(ArgumentError("Mach number must be positive, got M = $M"))
    end
    if M < 1
        throw(DomainError(M, "Function only valid for supersonic flow (M ≥ 1)"))
    end
    
    # Function implementation
end
```

## Testing Guidelines

### Test Organization

Tests are organized in the `test/` directory:

```
test/
├── runtests.jl          # Main test runner
├── test_isentropic.jl   # Isentropic relation tests
├── test_shocks.jl       # Shock wave tests
├── test_atmosphere.jl   # Atmospheric model tests
└── test_utilities.jl    # Helper function tests
```

### Writing Tests

Use the `Test` standard library:

```julia
using Test
using CompAir

@testset "Isentropic Relations" begin
    @testset "Temperature Ratio" begin
        # Test known values
        @test t0_over_t(0.0) ≈ 1.0
        @test t0_over_t(1.0) ≈ 1.2
        @test t0_over_t(2.0) ≈ 1.8
        
        # Test error conditions
        @test_throws DomainError t0_over_t(-1.0)
    end
    
    @testset "Pressure Ratio" begin
        # Test consistency with temperature ratio
        M = 1.5
        T_ratio = t0_over_t(M)
        p_ratio = p0_over_p(M)
        @test p_ratio ≈ T_ratio^(1.4/0.4) rtol=1e-10
    end
end
```

### Test Coverage

- Test normal operation with typical values
- Test edge cases and boundary conditions
- Test error conditions and input validation
- Include regression tests for bug fixes
- Test different gas properties when applicable

## Documentation Guidelines

### API Documentation

- All public functions must have docstrings
- Include mathematical background when relevant
- Provide practical examples
- Document limitations and assumptions

### Examples

When adding examples:

- Use realistic engineering values
- Show complete workflows
- Include physical interpretation of results
- Explain the engineering significance

### Building Documentation

Build documentation locally to test changes:

```julia
cd docs/
julia --project
using Pkg; Pkg.instantiate()
include("make.jl")
```

## Submitting Issues

### Bug Reports

When reporting bugs, include:

- Julia version and CompAir.jl version
- Minimal reproducible example
- Expected vs. actual behavior
- Error messages (if any)
- System information (OS, etc.)

### Feature Requests

For feature requests, include:

- Clear description of the proposed feature
- Use cases and motivation
- Suggested API design
- References to relevant theory or literature

## Code Review Process

### What We Look For

- **Correctness**: Does the code work as intended?
- **Performance**: Are there obvious performance issues?
- **Style**: Does it follow our style guidelines?
- **Documentation**: Are functions properly documented?
- **Tests**: Are there adequate tests?
- **Maintainability**: Is the code readable and well-organized?

### Review Timeline

- Initial review within 1-2 weeks
- Follow-up reviews within a few days
- Merge after approval from maintainers

## Performance Considerations

### Optimization Guidelines

- Profile before optimizing
- Avoid unnecessary allocations
- Use appropriate data types
- Consider numerical stability
- Benchmark performance-critical changes

### Benchmarking

Use BenchmarkTools.jl for performance testing:

```julia
using BenchmarkTools

@benchmark your_function(args...)
```

## Release Process

### Version Numbers

We follow [Semantic Versioning](https://semver.org/):

- **Major** (x.0.0): Breaking changes
- **Minor** (1.x.0): New features, backward compatible
- **Patch** (1.1.x): Bug fixes, backward compatible

### Release Checklist

Before releasing:

- [ ] All tests pass
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Version number is bumped
- [ ] Examples work correctly
- [ ] Performance regressions are addressed

## Community

### Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Julia Discourse**: For broader Julia community support

### Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please be:

- **Respectful**: Treat others with courtesy and respect
- **Constructive**: Provide helpful feedback and suggestions
- **Collaborative**: Work together towards common goals
- **Professional**: Maintain a professional tone in all interactions

## Recognition

Contributors will be acknowledged in:

- README.md contributors section
- Release notes for significant contributions
- Academic citations when appropriate

## License and Attribution

By contributing to CompAir.jl, you agree that your contributions will be licensed under the same **CC BY-NC-SA 4.0** license as the project.

### Important Notes

- This project is based on the original Python CompAir module by Inha University AADL
- All contributions must comply with the NonCommercial (NC) terms of the license
- Your contributions will be attributed in the project's commit history and release notes
- Significant contributions may be acknowledged in the README and documentation

Please ensure that any code, documentation, or other materials you contribute:
- Do not violate any third-party copyrights or licenses
- Are your original work or properly attributed
- Comply with the project's license terms

## Questions?

If you have any questions about contributing, please:

1. Check existing documentation and issues
2. Ask in GitHub Discussions
3. Contact the maintainers directly

Thank you for contributing to CompAir.jl!