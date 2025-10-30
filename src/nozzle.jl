import Roots

# 내부 함수: Float64 타입으로 동작
function _mdot(M::Float64, area::Float64=1.0, p0::Float64=1.0, t0::Float64=1.0, gamma::Float64=1.4, R::Float64=1.0)
    mdot_a = sqrt(gamma/R/t0)*p0*M/(1+(gamma-1)/2*M^2)^((gamma+1)/2/(gamma-1))
    return mdot_a*area
end

"""
    mdot(M::Real, area::Real=1, p0::Real=1, t0::Real=1, gamma::Real=1.4, R::Real=1)

Calculates the mass flow rate through a nozzle.

# Arguments
- `M::Real`: Mach number
- `area::Real=1`: Cross-sectional area
- `p0::Real=1`: Total pressure
- `t0::Real=1`: Total temperature
- `gamma::Real=1.4`: Specific heat ratio
- `R::Real=1`: Gas constant

# Returns
- `Float64`: Mass flow rate
"""
function mdot(M::Real, area::Real=1, p0::Real=1, t0::Real=1, gamma::Real=1.4, R::Real=1)
    _mdot(Float64(M), Float64(area), Float64(p0), Float64(t0), Float64(gamma), Float64(R))
end

# 내부 함수
function _area_ratio_at(M::Float64, gamma::Float64=1.4)
    return 1/M*sqrt((2/(gamma+1)*total_to_static_temperature_ratio(M, gamma))^((gamma+1)/(gamma-1)))
end

"""
    area_ratio_at(M::Real, gamma::Real=1.4)

Calculates the area ratio (A/A*) for a given Mach number, where A* is the throat area.

# Arguments
- `M::Real`: Mach number
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Float64`: Area ratio (A/A*)
"""
function area_ratio_at(M::Real, gamma::Real=1.4)
    _area_ratio_at(Float64(M), Float64(gamma))
end

# 내부 함수
function _mach_by_area_ratio(area::Float64, gamma::Float64=1.4, x0::Float64=0.1)
    f(M) = _area_ratio_at(M, gamma) - area
    return Roots.find_zero(f, x0)
end

"""
    mach_by_area_ratio(area::Real, gamma::Real=1.4, x0::Real=0.1)

Calculates the Mach number for a given area ratio (A/A*).

# Arguments
- `area::Real`: Area ratio (A/A*)
- `gamma::Real=1.4`: Specific heat ratio
- `x0::Real=0.1`: Initial guess for the solver. If x0 < 1, solves for subsonic Mach number; 
  if x0 ≥ 1, solves for supersonic Mach number.

# Returns
- `Float64`: Mach number
"""
function mach_by_area_ratio(area::Real, gamma::Real=1.4, x0::Real=0.1)
    _mach_by_area_ratio(Float64(area), Float64(gamma), Float64(x0))
end

# 내부 함수
function _subsonic_mach_from_area_ratio(area::Float64, gamma::Float64=1.4)
    return _mach_by_area_ratio(area, gamma)
end

"""
    subsonic_mach_from_area_ratio(area::Real, gamma::Real=1.4)

Calculates the subsonic Mach number for a given nozzle area ratio.

# Arguments
- `area::Real`: Area ratio (A/A*)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Float64`: Subsonic Mach number
"""
function subsonic_mach_from_area_ratio(area::Real, gamma::Real=1.4)
    _subsonic_mach_from_area_ratio(Float64(area), Float64(gamma))
end

# 내부 함수
function _subsonic_pressure_from_area_ratio(area::Float64, gamma::Float64=1.4, p0::Float64=1.0)
    Me6 = _subsonic_mach_from_area_ratio(area, gamma)
    return 1/total_to_static_pressure_ratio(Me6, gamma)*p0
end

"""
    subsonic_pressure_from_area_ratio(area::Real, gamma::Real=1.4, p0::Real=1)

Calculates the subsonic pressure for a given nozzle area ratio, assuming isentropic flow.

# Arguments
- `area::Real`: Area ratio (A/A*)
- `gamma::Real=1.4`: Specific heat ratio
- `p0::Real=1`: Total pressure

# Returns
- `Float64`: Subsonic pressure
"""
function subsonic_pressure_from_area_ratio(area::Real, gamma::Real=1.4, p0::Real=1)
    _subsonic_pressure_from_area_ratio(Float64(area), Float64(gamma), Float64(p0))
end

# 내부 함수
function _mach_after_shock_at_exit(area::Float64, gamma::Float64=1.4)
    Me = _subsonic_mach_from_area_ratio(area, gamma)
    return mach_after_normal_shock(Me, gamma)
end

"""
    mach_after_shock_at_exit(area::Real, gamma::Real=1.4)

Calculates the Mach number after a normal shock at the nozzle exit.

# Arguments
- `area::Real`: Area ratio (A/A*)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
- `Float64`: Mach number after the shock
"""
function mach_after_shock_at_exit(area::Real, gamma::Real=1.4)
    _mach_after_shock_at_exit(Float64(area), Float64(gamma))
end

# 내부 함수
function _pressure_after_shock_at_exit(area::Float64, gamma::Float64=1.4, p0::Float64=1.0)
    Me = _subsonic_mach_from_area_ratio(area, gamma)
    pe = _subsonic_pressure_from_area_ratio(area, gamma, p0)
    return pe*pressure_ratio_normal_shock(Me, gamma)
end

"""
    pressure_after_shock_at_exit(area::Real, gamma::Real=1.4, p0::Real=1)

Calculates the pressure after a normal shock at the nozzle exit.

# Arguments
- `area::Real`: Area ratio (A/A*)
- `gamma::Real=1.4`: Specific heat ratio
- `p0::Real=1`: Total pressure

# Returns
- `Float64`: Pressure after the shock
"""
function pressure_after_shock_at_exit(area::Real, gamma::Real=1.4, p0::Real=1)
    _pressure_after_shock_at_exit(Float64(area), Float64(gamma), Float64(p0))
end