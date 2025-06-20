import Roots

"""
    prandtl_meyer(M, gamma=1.4)

Prandtl Meyer 함수 nu 계산

# 인자
- `M::Float64`: 입구 마하수
- `gamma::Float64=1.4`: 비열비

# 반환값
- `nu::Float64`: Prandtl-Meyer 함수 (단위: 도)
"""
function prandtl_meyer(M, gamma=1.4)
    gratio = sqrt((gamma + 1) / (gamma - 1))
    fm = sqrt(M^2 - 1)
    rad = gratio * atan(fm / gratio) - atan(fm)
    return rad2deg(rad)
end

"""
    expand_mach2(M1, theta, gamma=1.4)

마하수 M1인 유동이 theta 만큼 회전했을 때 마하수 계산

# 인자
- `M1::Float64`: 입구 마하수
- `theta::Float64`: 유동 회전 각도 (단위: 도)
- `gamma::Float64=1.4`: 비열비

# 반환값
- `mach::Float64`: 팽창파를 지난 후 마하수
"""
function expand_mach2(M1, theta, gamma=1.4)
    nu1 = prandtl_meyer(M1, gamma)
    nu2 = nu1 + theta

    f(M) = prandtl_meyer(M, gamma) - nu2
    return Roots.find_zero(f, M1)
end

"""
    expand_p2(M1, theta, gamma=1.4)

마하수 M1인 유동이 theta 만큼 회전했을 때 압력 계산

# 인자
- `M1::Float64`: 입구 마하수
- `theta::Float64`: 유동 회전 각도 (단위: 도)
- `gamma::Float64=1.4`: 비열비

# 반환값
- `p::Float64`: 팽창파를 지난 후 압력비 (p1/p2)
"""
function expand_p2(M1, theta, gamma=1.4)
    M2 = expand_mach2(M1, theta, gamma)
    return p0_over_p(M1, gamma) / p0_over_p(M2, gamma)
end

"""
    theta_p(pratio, M1, gamma=1.4)

압력비를 만족하도록 발생하는 팽창파 각도 계산

# 인자
- `pratio::Float64`: 팽창파 전/후 압력비 (p1/p2)
- `M1::Float64`: 입구 마하수
- `gamma::Float64=1.4`: 비열비

# 반환값
- `theta::Float64`: 유동 회전 각도 (단위: 도)
"""
function theta_p(pratio, M1, gamma=1.4)
    f(theta) = expand_p2(M1, theta, gamma) - pratio
    return Roots.find_zero(f, 0.1)
end
