import Roots
import DifferentialEquations
import LinearAlgebra

"""
    _taylor_maccoll(y, p, t)

Taylor-Maccoll 방정식의 미분 방정식을 계산하는 내부 함수

# Arguments
- `y::Vector{Float64}`: [v_r, v_theta] 속도 벡터 
- `p::Float64`: 비열비
- `t::Float64`: 각도 (radian)

# Returns
- `dydt::Vector{Float64}`: 미분 방정식의 우변 벡터
"""
function _taylor_maccoll(theta, y, gamma=1.4)
    # Taylor-Maccoll function
    # Source: https://www.grc.nasa.gov/www/k-12/airplane/coneflow.html
    v_r, v_theta = y
    dydt = [
        v_theta;
        (v_theta^2 * v_r - (gamma - 1) / 2 * (1 - v_r^2 - v_theta^2) * (2 * v_r + v_theta / tan(theta)))/ ((gamma - 1) / 2 * (1 - v_r^2 - v_theta^2) - v_theta^2)
    ]

    return dydt
end

"""
    _integrate_tm(M, angle, theta, gamma=1.4)

Taylor-Maccoll 방정식을 수치적으로 적분하는 내부 함수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: 계산하려는 각도 (degree)
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `sol`: DifferentialEquations.jl의 해 객체
"""
function _integrate_tm(M, angle, theta, gamma=1.4)
    theta_max_val = theta_max(M, gamma)

    if theta <= theta_max_val
        beta = oblique_beta_weak(M, theta, gamma)
        M2 = oblique_mach2(M, theta, gamma)
    else
        beta = 90
        M2 = normal_mach2(M, gamma)
    end

    v = sqrt(((gamma - 1) / 2 * M2^2) / (1 + (gamma - 1) / 2 * M2^2))
    v_theta = -v * sind(beta - theta)
    v_r = v * cosd(beta - theta)

    # Integrate over [beta, angle]
    tspan = (deg2rad(beta), deg2rad(angle))

    # Integrate over [beta, angle]
    ode_function_wrapper = (u_state, param_gamma, time_angle) -> _taylor_maccoll(time_angle, u_state, param_gamma)
    
    # 초기값 u0 설정
    u0 = [v_r, v_theta]
    
    prob = DifferentialEquations.ODEProblem(ode_function_wrapper, u0, tspan, gamma)
    sol = DifferentialEquations.solve(prob)
    # Return solution
    return sol
end

"""
    theta_eff(M, angle, gamma=1.4)

Cone 형상 각도 계산

# Arguments
- `M::Float64`: 마하수
- `angle::Float64`: Cone 반각 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `theta_eff::Float64`: 형상 각도 (degree)
"""
function theta_eff(M, angle, gamma=1.4)
    f(x) = _integrate_tm(M, angle, x, gamma).u[end][2] # Use v_theta (tangential velocity component)
    return Roots.find_zero(f, 1e-3)
end

"""
    cone_beta_weak(M, angle, gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 Cone 충격파 각도 계산

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: Cone 반각 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function cone_beta_weak(M, angle, gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    return oblique_beta_weak(M, theta, gamma)
end

"""
    cone_mach2(M, angle, gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 발생한 경사충격파를 지난 후 마하수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: Cone 반각 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 경사 충격파후 마하수
"""
function cone_mach2(M, angle, gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    return oblique_mach2(M, theta, gamma)
end

"""
    _cone_mach(M, angle, theta, gamma)

주어진 마하수, 각도에서 콘 표면의 마하수와 유동 방향을 계산하는 내부 함수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: 계산하려는 각도 (degree)
- `theta::Float64`: 쇄기 각도 (degree)
- `gamma::Float64`: 비열비

# Returns
- `M2::Float64`: 표면에서의 마하수
- `phi::Float64`: 유동 방향 각도 (degree)
"""
function _cone_mach(M, angle, theta, gamma)
    vec = _integrate_tm(M, angle, theta, gamma).u[end]

    v = LinearAlgebra.norm(vec)
    phi = angle + rad2deg(atan(vec[2] / vec[1]))

    return sqrt(2 / (gamma - 1) * (v^2 / (1 - v^2))), phi
end

"""
    cone_mach(M, angle, gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 Cone 표면 마하수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: Cone 반각 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 경사 충격파후 마하수
"""
function cone_mach_surface(M, angle, gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    return _cone_mach(M, angle, theta, gamma)
end

"""
    solve_shock(M, angle, gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 발생한 경사충격파를 지난 후 물성치 계산

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 수직충격파 후 마하수
- `rho2::Float64`: 수직충격파 전/후 밀도비
- `p2::Float64`: 수직충격파 전/후 압력비
- `p0ratio::Float64`: 수직충격파 전/후 전압력비
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function solve_shock(M, angle, gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    return solve_oblique(M, theta, gamma)
end

"""
    solve_cone(M, angle; gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 발생한 Cone 표면에서 물성치

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: 쇄기 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `mcone::Float64`: 콘 표면 마하수
- `rho2::Float64`: 콘 표면 밀도비
- `p2::Float64`: 콘 표면 압력비
- `p0ratio::Float64`: 콘 표면 전압력비
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function solve_cone_theta(M, angle; gamma=1.4)
    mc, rhoc, pc, p0ratio, beta, _ = solve_cone_theta_phi(M, angle, angle, gamma=gamma)
    return mc, rhoc, pc, p0ratio, beta
end

"""
    solve(M, angle, psi; gamma=1.4)

마하수 `M`, Cone 반각 `θ` 일때 ray 각도 `ψ` 발생한 Cone 표면에서 물성치

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: 쇄기 각도 (degree)
- `psi::Float64`: Ray 각도 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `Mc::Float64`: 콘 표면 마하수
- `rhoc::Float64`: 콘 표면 밀도비
- `pc::Float64`: 콘 표면 압력비
- `p0ratio::Float64`: 콘 표면 전압력비
- `beta::Float64`: 경사 충격파 각도 (degree)
- `phi::Float64`: 유동 방향 (degree)
"""
function solve_cone_theta_phi(M, angle, psi; gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    
    # 충격파 전/후 물성치 계산
    M2, rho2, p2, p0ratio, beta = solve_oblique(M, theta, gamma)
    
    # Cone 마하수, 속도 방향
    Mc, phi = _cone_mach(M, psi, theta, gamma)
    
    # 밀도
    rhoc = rho2*rho0_over_rho(M2, gamma)/rho0_over_rho(Mc, gamma)
    
    # 압력
    pc = p2*p0_over_p(M2, gamma) / p0_over_p(Mc, gamma)
    
    return Mc, rhoc, pc, p0ratio, beta, phi
end