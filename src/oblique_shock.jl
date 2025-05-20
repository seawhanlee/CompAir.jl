import Roots
import Optim
import Optim: Brent

"""
    _tangent_theta(beta_r, M, gamma=1.4)

경사 충격파 각도 `β`와 마하수 `M`을 이용하여 쇄기 각도 `θ`의 탄젠트 값을 계산하는 내부 함수.

# Arguments
- `beta_r::Float64`: 경사 충격파 각도 (radian)
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `Float64`: tan(θ) 값
"""
function _tangent_theta(beta_r, M, gamma=1.4)
    return 2 / tan(beta_r) * ((M * sin(beta_r))^2 - 1) / (M^2 * (gamma + cos(2 * beta_r)) + 2)
end

"""
    theta_beta(beta, M, gamma=1.4)

`θ-β-M` 함수를 이용하여, `β`, `M`을 이용하여 `θ`를 계산한다.

# Arguments
- `beta::Float64`: 경사 충격파 각도 (degree)
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `theta::Float64`: 쇄기 각도 (degree)
"""
function theta_beta(beta, M, gamma=1.4)
    # Convert deg to rad
    beta_r = deg2rad(beta)

    # With Theta-Beta-M
    tan_theta = _tangent_theta(beta_r, M, gamma)

    return rad2deg(atan(tan_theta))
end

"""
    _beta_weak(M, theta, gamma=1.4)

마하수 `M`과 쇄기 각도 `θ`를 이용하여 약한 경사 충격파 각도 `β`를 계산하는 내부 함수.
Newton-Raphson 방법을 사용하여 수치적으로 해를 구한다.

# Arguments
- `M::Float64`: 충격파 전 마하수
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `Float64`: 경사 충격파 각도 (radian)
"""
function _beta_weak(M, theta, gamma=1.4)
    # Convert deg to rad
    theta_r = deg2rad(theta)

    f(x) = _tangent_theta(x, M, gamma) - tan(theta_r)

    # Solve theta-beta-M using Newton-Raphson method
    return Roots.find_zero(f, 1e-3)
end

"""
    oblique_beta_weak(M, theta, gamma=1.4)

`θ-β-M` 관계식을 수치적으로 계산하여 마하수 `M`, 쐐기 각도 `θ` 일 때
경사 충격파 각도 `β`를 계산한다.

# Arguments
- `M::Float64`: 충격파 전 마하수
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function oblique_beta_weak(M, theta, gamma=1.4)
    # Convert rad to deg
    return rad2deg(_beta_weak(M, theta, gamma))
end

"""
    theta_max(M, gamma=1.4)

주어진 마하수 `M`에 대해서 `θ-β-M` 관계식에서 Weak 해가 존재할 수 있는 최대 쇄기각 `θ`를 계산한다.

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `theta::Float64`: 최대 쇄기 각도 (degree)
"""
function theta_max(M, gamma=1.4)
    # Maximize tangent theta
    f(x) = -_tangent_theta(x, M, gamma)

    # Optimization using Optim package
    # Use Brent's method for 1D optimization
    res = Optim.optimize(f, 0.0, pi/2, Brent())

    # Get the maximum value of tangent theta
    tan_theta = -Optim.minimum(res)

    return rad2deg(atan(tan_theta))
end

function _Mn1(M, beta_r, gamma=1.4)
    return M * sin(beta_r)
end

"""
    Mn1(M, theta, gamma=1.4)

마하수 `M`, 쐐기각 `θ` 일때 발생한 경사충격파에 수직인 마하수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `Mn1::Float64`: 경사 충격파에 수직인 마하수
"""
function Mn1(M, theta, gamma=1.4)
    # Get beta in rad
    beta_r = _beta_weak(M, theta, gamma)

    return _Mn1(M, beta_r, gamma)
end

"""
    oblique_mach2(M, theta, gamma=1.4)

마하수 `M`, 쐐기각 `θ` 일때 발생한 경사충격파를 지난 후 마하수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 경사 충격파후 마하수
"""
function oblique_mach2(M, theta, gamma=1.4)
    # Get beta in rad
    beta_r = _beta_weak(M, theta, gamma)

    # Normal component of M1
    Mn1 = _Mn1(M, beta_r)

    # Normal shock relation
    Mn2 = normal_mach2(Mn1, gamma)

    theta_r = deg2rad(theta)

    # Compute M2
    return Mn2 / sin(beta_r - theta_r)
end

"""
    solve_oblique(M, theta, gamma=1.4)

마하수 `M`, 쐐기각 `θ` 일때 발생한 경사충격파를 지난 후 물성치 계산

# Arguments
- `M::Float64`: 충격파 전 마하수
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `m2::Float64`: 수직충격파 후 마하수
- `rho2::Float64`: 수직충격파 전/후 밀도비
- `p2::Float64`: 수직충격파 전/후 압력비
- `p0ratio::Float64`: 수직충격파 전/후 전압력비
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function solve_oblique(M, theta, gamma=1.4)
    if theta < theta_max(M)
        beta_r = _beta_weak(M, theta, gamma)
    else
        println("Bow shock occured at M=$(round(M, digits=3)), theta=$(round(theta, digits=3))")
        beta_r = pi / 2
    end
    # Get beta in rad
    beta = rad2deg(beta_r)

    # Normal component of M1
    Mn1 = _Mn1(M, beta_r)

    # Normal shock relation
    Mn2, rho2, p2, p0ratio = solve_normal(Mn1, gamma)

    # Compute M2
    theta_r = deg2rad(theta)
    M2 = Mn2 / sin(beta_r - theta_r)

    return M2, rho2, p2, p0ratio, beta
end