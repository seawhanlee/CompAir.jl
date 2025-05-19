import Roots

"""
    mdot(M, area, p0, t0, gamma=1.4, R)

노즐 내 유량 계산

# Arguments
- `M::Float64`: 입구 마하수
- `area::Float64`: 입구 면적
- `p0::Float64`: 전압력
- `t0::Float64`: 전 온도
- `gamma::Float64=1.4`: 비열비
- `R::Float64`: Gas 상수

# Returns
- `Float64`: 질량 유량
"""
function mdot(M, area, p0, t0, gamma=1.4, R)
    mdot_a = sqrt(gamma/R/t0)*p0*M/(1+(gamma-1)/2*M^2)^((gamma+1)/2/(gamma-1))
    return mdot_a*area
end

"""
    area_ratio_at(M, gamma=1.4)

마하수 `M`일 때 목 면적 비율

# Arguments
- `M::Float64`: 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `Float64`: 목면적 대비 면적비
"""
function area_ratio_at(M, gamma=1.4)
    return 1/M*sqrt((2/(gamma+1)*t0_over_t(M, gamma))^((gamma+1)/(gamma-1)))
end

"""
    mach_by_area_ratio(area, gamma=1.4, x0=0.1)

면적비 `area` 일 때 마하수 계산

# Arguments
- `area::Float64`: 목면적 대비 면적비
- `gamma::Float64=1.4`: 비열비
- `x0::Float64=0.1`: 초기 예측 값, 1 이하면 아음속, 1 이상이면 초음속 계산

# Returns
- `Float64`: 마하수
"""
function mach_by_area_ratio(area, gamma=1.4, x0=0.1)
    f(M) = area_ratio_at(M, gamma) - area
    return Roots.find_zero(f, x0)
end

"""
    me6(area, gamma=1.4)

# Arguments
- `area::Float64`: 목면적 대비 면적비
- `gamma::Float64=1.4`: 비열비

# Returns
- `Float64`: 마하수
"""
function me6(area, gamma=1.4)
    return mach_by_area_ratio(area, gamma)
end

"""
    pe6(area, gamma=1.4, p0=1)

# Arguments
- `area::Float64`: 목면적 대비 면적비
- `gamma::Float64=1.4`: 비열비
- `p0::Float64=1`: 전압력

# Returns
- `Float64`: 압력
"""
function pe6(area, gamma=1.4, p0=1)
    Me6 = me6(area,gamma)
    return 1/p0_over_p(Me6, gamma)*p0
end

"""
    me5(area, gamma=1.4)

# Arguments
- `area::Float64`: 목면적 대비 면적비
- `gamma::Float64=1.4`: 비열비

# Returns
- `Float64`: 마하수
"""
function me5(area, gamma=1.4)
    Me = me6(area, gamma)
    return normal_mach2(Me, gamma)
end

"""
    pe5(area, gamma=1.4, p0=1)

# Arguments
- `area::Float64`: 목면적 대비 면적비
- `gamma::Float64=1.4`: 비열비
- `p0::Float64=1`: 전압력

# Returns
- `Float64`: 압력
"""
function pe5(area, gamma=1.4, p0=1)
    Me = me6(area, gamma)
    pe= pe6(area, gamma, p0)
    return pe*p2_over_p1(Me, gamma)
end