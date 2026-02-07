# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-08
**Commit:** 9979ade
**Branch:** main

## OVERVIEW

Julia package for compressible flow / gas dynamics calculations. Port of Python [CompAir](https://gitlab.com/aadl_inha/CompAir) by Inha AADL. Provides isentropic relations, shock wave analysis (normal/oblique/cone), Prandtl-Meyer expansion, nozzle flow, US Standard Atmosphere 1976, and multi-stage intake ramp analysis.

## STRUCTURE

```
CompAir/
├── src/
│   ├── CompAir.jl          # Module entry — includes + exports only
│   ├── isentropic.jl       # T0/T, p0/p, ρ0/ρ ratios
│   ├── normal_shock.jl     # Normal shock relations + solve_normal
│   ├── oblique_shock.jl    # θ-β-M relations + solve_oblique (uses Roots, Optim)
│   ├── prandtl_expand.jl   # Prandtl-Meyer ν(M), expansion solver (uses Roots)
│   ├── cone_shock.jl       # Taylor-Maccoll ODE integration (uses DiffEqBase, OrdinaryDiffEq)
│   ├── nozzle.jl           # A/A*, mdot, Mach from area ratio (uses Roots)
│   ├── atmos1976.jl        # 7-layer atmosphere model, Sutherland viscosity
│   └── intake.jl           # Multi-stage ramp intake (chains solve_oblique)
├── test/                   # 1:1 mirror of src/ — one test file per module
│   └── runtests.jl         # Entry — nested @testset per module
├── docs/                   # Documenter.jl — make.jl builds to GitHub Pages
└── .github/workflows/
    ├── CI.yml              # Julia 1.11/1.12/pre × linux/mac/win
    ├── documentation.yml   # Documenter.jl deploy
    ├── docker.yml          # GHCR Alpine image
    ├── CompatHelper.yml    # Auto dependency PRs
    └── TagBot.yml          # Auto release tags
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new flow relation | `src/new_module.jl` → `include()` + `export` in `src/CompAir.jl` | Follow existing pattern |
| Fix a formula | `src/{module}.jl` | Each file is self-contained for its domain |
| Add tests | `test/{module}_tests.jl` → add `@testset` include in `test/runtests.jl` | Use `isapprox(..., rtol=1e-3)` |
| Update docs | `docs/src/api/{module}.md` → add page to `docs/make.jl` `pages` | Uses `@docs` blocks |
| Modify CI matrix | `.github/workflows/CI.yml` | Matrix: version × os × arch |
| Docker image | `Dockerfile` | Alpine + musl Julia binary |

## CODE MAP

### Public API (all exported from `CompAir` module)

| Function | File | Returns | Domain |
|----------|------|---------|--------|
| `t0_over_t(M, γ)` | isentropic.jl | Float64 | T₀/T |
| `p0_over_p(M, γ)` | isentropic.jl | Float64 | p₀/p |
| `rho0_over_rho(M, γ)` | isentropic.jl | Float64 | ρ₀/ρ |
| `ns_mach2(M, γ)` | normal_shock.jl | Float64 | Post-shock Mach |
| `ns_rho2_over_rho1(M, γ)` | normal_shock.jl | Float64 | Normal shock density ratio |
| `ns_p2_over_p1(M, γ)` | normal_shock.jl | Float64 | Normal shock pressure ratio |
| `ns_t2_over_t1(M, γ)` | normal_shock.jl | Float64 | Normal shock temperature ratio |
| `ns_p02(M, γ)` | normal_shock.jl | Float64 | Post-shock total pressure |
| `ns_p02_over_p01(M, γ)` | normal_shock.jl | Float64 | Total pressure ratio |
| `solve_normal(M, γ)` | normal_shock.jl | NamedTuple `(M2, rho2_ratio, p2_ratio, p0_ratio)` | Normal shock |
| `theta_from_beta(M, β, γ)` | oblique_shock.jl | Float64 | Deflection from shock angle |
| `beta_from_theta(M, θ, γ)` | oblique_shock.jl | Float64 | Weak shock angle |
| `mn1(M, β)` | oblique_shock.jl | Float64 | Normal Mach component |
| `os_mach2(M, θ, γ)` | oblique_shock.jl | Float64 | Post-oblique-shock Mach |
| `theta_max(M, γ)` | oblique_shock.jl | Float64 | Max wedge angle |
| `solve_oblique(M, θ, γ)` | oblique_shock.jl | NamedTuple `(M2, rho2_ratio, p2_ratio, p0_ratio, beta)` | Oblique shock |
| `prandtl_meyer(M, γ)` | prandtl_expand.jl | Float64 (degrees) | ν(M) |
| `pm_mach2(M1, θ, γ)` | prandtl_expand.jl | Float64 | Post-expansion M |
| `pm_p1_over_p2(M1, θ, γ)` | prandtl_expand.jl | Float64 | Expansion pressure ratio |
| `pm_theta_from_pratio(M1, p_ratio, γ)` | prandtl_expand.jl | Float64 | Turning angle from p ratio |
| `cone_theta_eff(M, angle, γ)` | cone_shock.jl | Float64 | Effective cone half-angle |
| `cone_beta(M, angle, γ)` | cone_shock.jl | Float64 | Cone shock angle |
| `solve_cone(M, angle, γ)` | cone_shock.jl | NamedTuple | Cone shock via Taylor-Maccoll |
| `solve_cone_properties(M, angle; psi, γ)` | cone_shock.jl | Tuple (5 or 6 values) | Cone surface properties |
| `mdot(M, area, p0, t0, γ, R)` | nozzle.jl | Float64 | Mass flow rate |
| `a_over_astar(M, γ)` | nozzle.jl | Float64 | A/A* |
| `mach_from_area_ratio(A, γ, x0)` | nozzle.jl | Float64 | M from A/A* (x0 < 1 → subsonic) |
| `mach_after_exit_shock(M, A, γ)` | nozzle.jl | Float64 | Mach after exit shock |
| `pressure_after_exit_shock(M, A, γ)` | nozzle.jl | Float64 | Pressure after exit shock |
| `atmos(alt)` | atmos1976.jl | Tuple (ρ, p, T, a, μ) | US Std Atmos 1976 |
| `geo_to_geopot(alt)` | atmos1976.jl | Float64 | Geometric → geopotential alt |
| `geopot_to_geo(alt)` | atmos1976.jl | Float64 | Geopotential → geometric alt |
| `sutherland_viscosity(θ)` | atmos1976.jl | Float64 | Dynamic viscosity |
| `intake_ramp(M∞, angles, γ)` | intake.jl | NamedTuple `(M, rho2_ratio, p2_ratio, p0_ratio, beta)` | Multi-stage ramp |

### Internal helpers (not exported, prefixed with `_`)

`_tangent_theta`, `_beta_weak`, `_Mn1`, `_taylor_maccoll`, `_integrate_tm`, `_cone_mach`, `_air1976`, `_mdot`, `_area_ratio_at`, `_mach_by_area_ratio`, `_subsonic_mach_from_area_ratio`, `_subsonic_pressure_from_area_ratio`, `_mach_after_shock_at_exit`, `_pressure_after_shock_at_exit`, `_intake_ramp`, etc.

## CONVENTIONS

- **Default gamma**: All functions default `gamma=1.4` (air)
- **Angles**: Degrees at API boundary, radians internally. Internal functions use `_r` suffix or `deg2rad`/`rad2deg`.
- **Type dispatch pattern**: Public functions accept `::Real`, convert to `Float64`, delegate to internal `_function(::Float64)`. See `nozzle.jl` for canonical example.
- **No custom types**: API is purely functions → `Float64` or `NamedTuple`. No structs.
- **NamedTuple returns**: Multi-value solvers (`solve_normal`, `solve_oblique`, `intake_ramp`) return NamedTuples. Access fields with dot syntax: `result.M2`.
- **Root finding**: Uses `Roots.find_zero` throughout (Newton-Raphson default).
- **Optimization**: Uses `Optim.optimize` with `Brent()` for 1D problems.
- **ODE integration**: `DiffEqBase.ODEProblem` + `OrdinaryDiffEq.solve` for Taylor-Maccoll.
- **Imports**: `import Package` (not `using`) in source files — explicit namespace.
- **Tests**: `isapprox` with `rtol=1e-3` against textbook/reference values.
- **Korean comments**: Some inline comments in `cone_shock.jl` and `nozzle.jl` are in Korean (한국어). This is intentional — do not translate or remove.
- **Style rules** (from `docs/src/dev/contributing.md`): `snake_case` functions/variables, `PascalCase` types/modules, ~92 char line limit. Docstrings required for all public functions.
- **Type signature inconsistency**: `isentropic.jl`, `oblique_shock.jl`, `intake.jl` use `::Real` in public signatures; `normal_shock.jl` uses `::Float64` directly. New code should use `::Real` (see nozzle.jl pattern).
- **No formatter config**: No `.JuliaFormatter.toml`. No enforced style beyond Julia defaults.
- **License**: CC-BY-NC-SA-4.0 (non-commercial).

## ANTI-PATTERNS (THIS PROJECT)

- **Do NOT add `using` in source files** — use `import Package` to avoid namespace pollution
- **Do NOT change public API signatures** — backward compatibility with Python CompAir users
- **Do NOT remove Korean comments** — they are part of the original author's documentation
- **Do NOT use `Float64` in public function signatures** — use `::Real` for flexibility, convert internally
- **`solve_oblique` prints to stdout on bow shock** — this is known behavior (line 201), not a bug
- **Backward compatibility**: All 25 renamed functions have `@deprecate` entries in `src/deprecated.jl`. Old names still work but emit deprecation warnings.

## COMMANDS

```bash
# Test
julia --project=. -e 'using Pkg; Pkg.test()'

# REPL with package loaded
julia --project=.
# then: using CompAir

# Build docs locally
julia --project=docs docs/make.jl

# Docker
docker build -t compair .
docker run -it compair
```

## DEPENDENCIES

| Package | Purpose | Version |
|---------|---------|---------|
| DiffEqBase + OrdinaryDiffEq | Taylor-Maccoll ODE (cone_shock.jl) | 6.152.1 / 6.98.0 |
| Optim | 1D optimization for θ_max (oblique_shock.jl) | 1.12.0 |
| Roots | Root finding everywhere | 2.2.7 |
| LinearAlgebra | Vector norm in cone_shock.jl | stdlib |

**Julia compat**: ≥ 1.11

## NOTES

- **Port origin**: Faithful port of Python CompAir by Inha AADL. Algorithms match original; improvements in type safety and numerical stability.
- **Atmosphere model**: 7-layer model valid up to 86 km. Uses geopotential altitude internally. Layer selection is index-based (fixed in v1.1.0).
- **`solve_cone_properties`** returns different tuple lengths depending on `psi` kwarg (5 without, 6 with) — not a NamedTuple, just positional values.
- **`mach_from_area_ratio` initial guess matters**: `x0 < 1` → subsonic solution, `x0 ≥ 1` → supersonic solution. Two valid roots exist for any A/A* > 1.
- **`sutherland_viscosity` signature mismatch**: Docstring says `mu0=1.458e-6` but implementation uses `mu0=1.716e-5`. Implementation is correct (standard Sutherland constant).
- **GEMINI.md exists**: Contains prior session context and project overview. Not authoritative — this file supersedes it for AI agent use.
