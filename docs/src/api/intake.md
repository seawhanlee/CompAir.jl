# Intake Ramp Analysis

```@meta
CurrentModule = CompAir
```

This module provides functions for analyzing multi-ramp external-compression intakes. Each ramp is treated as an oblique shock and the downstream Mach number and property ratios are computed sequentially.

## Overview

A typical supersonic inlet uses one or more compression ramps to slow and compress the incoming flow. For an incoming Mach number $M_\infty$ and a list of ramp deflection angles $\theta_i$, the intake is modeled by applying the oblique-shock relations at each ramp. The function `intake_ramp` returns the Mach number after each shock along with density, pressure, and total-pressure ratios.

## Functions

```@docs
intake_ramp
```

## Function Details

### intake_ramp

```julia
intake_ramp(M_infty, ramp_angle, gamma=1.4)
```

Compute the flow properties across a series of intake ramps.

**Arguments:**
- `M_infty::Real`: Freestream Mach number
- `ramp_angle::Vector{<:Real}`: Ramp deflection angles in degrees
- `gamma::Real=1.4`: Specific heat ratio

**Returns:**
- `NamedTuple` containing:
  - `M`: Vector of Mach numbers at each stage (length `n+1`)
  - `rho2_ratio`: Density ratios across each shock (length `n`)
  - `p2_ratio`: Pressure ratios across each shock (length `n`)
  - `p0_ratio`: Total-pressure ratios across each shock (length `n`)
  - `beta`: Shock angles in degrees (length `n`)

**Algorithm:**
1. Initialize the Mach number array with `M_infty`.
2. For each ramp angle, call [`solve_oblique`](@ref) to obtain the downstream Mach number and property ratios.
3. Collect the results into vectors and return them as a `NamedTuple`.

**Example:**
```julia
julia> sol = intake_ramp(2.5, [10, 16])
(M = [2.5, 2.085, ...], rho2_ratio = [...], p2_ratio = [...], p0_ratio = [...], beta = [...])
```

## See Also
- [Oblique Shock Waves](oblique_shock.md)
```
