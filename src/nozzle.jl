import Roots

# 내부 함수: Float64 타입으로 동작
function _mdot(M::Float64, area::Float64=1.0, p0::Float64=1.0, t0::Float64=1.0, gamma::Float64=1.4, R::Float64=1.0)
    mdot_a = sqrt(gamma/R/t0)*p0*M/(1+(gamma-1)/2*M^2)^((gamma+1)/2/(gamma-1))
    return mdot_a*area
end

"""
    mdot(M::Real, area::Real=1, p0::Real=1, t0::Real=1, gamma::Real=1.4, R::Real=1)

노즐 내 유량 계산

# Arguments
- `M::Real`: 입구 마하수
- `area::Real`: 입구 면적
- `p0::Real`: 전압력
- `t0::Real`: 전 온도
- `R::Real`: Gas 상수
- `gamma::Real=1.4`: 비열비

# Returns
- `Float64`: 질량 유량
"""
function mdot(M::Real, area::Real=1, p0::Real=1, t0::Real=1, gamma::Real=1.4, R::Real=1)
    _mdot(Float64(M), Float64(area), Float64(p0), Float64(t0), Float64(gamma), Float64(R))
end

# 내부 함수
function _area_ratio_at(M::Float64, gamma::Float64=1.4)
    return 1/M*sqrt((2/(gamma+1)*t0_over_t(M, gamma))^((gamma+1)/(gamma-1)))
end

"""
    area_ratio_at(M::Real, gamma::Real=1.4)

마하수 `M`일 때 목 면적 비율

# Arguments
- `M::Real`: 마하수
- `gamma::Real=1.4`: 비열비

# Returns
- `Float64`: 목면적 대비 면적비
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

면적비 `area` 일 때 마하수 계산

# Arguments
- `area::Real`: 목면적 대비 면적비
- `gamma::Real=1.4`: 비열비
- `x0::Real=0.1`: 초기 예측 값, 1 이하면 아음속, 1 이상이면 초음속 계산

# Returns
- `Float64`: 마하수
"""
function mach_by_area_ratio(area::Real, gamma::Real=1.4, x0::Real=0.1)
    _mach_by_area_ratio(Float64(area), Float64(gamma), Float64(x0))
end

# 내부 함수
function _me6(area::Float64, gamma::Float64=1.4)
    return _mach_by_area_ratio(area, gamma)
end

"""
    me6(area::Real, gamma::Real=1.4)

# Arguments
- `area::Real`: 목면적 대비 면적비
- `gamma::Real=1.4`: 비열비

# Returns
- `Float64`: 마하수
"""
function me6(area::Real, gamma::Real=1.4)
    _me6(Float64(area), Float64(gamma))
end

# 내부 함수
function _pe6(area::Float64, gamma::Float64=1.4, p0::Float64=1.0)
    Me6 = _me6(area, gamma)
    return 1/p0_over_p(Me6, gamma)*p0
end

"""
    pe6(area::Real, gamma::Real=1.4, p0::Real=1)

# Arguments
- `area::Real`: 목면적 대비 면적비
- `gamma::Real=1.4`: 비열비
- `p0::Real=1`: 전압력

# Returns
- `Float64`: 압력
"""
function pe6(area::Real, gamma::Real=1.4, p0::Real=1)
    _pe6(Float64(area), Float64(gamma), Float64(p0))
end

# 내부 함수
function _me5(area::Float64, gamma::Float64=1.4)
    Me = _me6(area, gamma)
    return normal_mach2(Me, gamma)
end

"""
    me5(area::Real, gamma::Real=1.4)

# Arguments
- `area::Real`: 목면적 대비 면적비
- `gamma::Real=1.4`: 비열비

# Returns
- `Float64`: 마하수
"""
function me5(area::Real, gamma::Real=1.4)
    _me5(Float64(area), Float64(gamma))
end

# 내부 함수
function _pe5(area::Float64, gamma::Float64=1.4, p0::Float64=1.0)
    Me = _me6(area, gamma)
    pe= _pe6(area, gamma, p0)
    return pe*p2_over_p1(Me, gamma)
end

"""
    pe5(area::Real, gamma::Real=1.4, p0::Real=1)

# Arguments
- `area::Real`: 목면적 대비 면적비
- `gamma::Real=1.4`: 비열비
- `p0::Real=1`: 전압력

# Returns
- `Float64`: 압력
"""
function pe5(area::Real, gamma::Real=1.4, p0::Real=1)
    _pe5(Float64(area), Float64(gamma), Float64(p0))
end