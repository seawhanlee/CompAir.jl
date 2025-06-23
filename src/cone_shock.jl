import Roots
import DiffEqBase
import OrdinaryDiffEq
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

    prob = DiffEqBase.ODEProblem(ode_function_wrapper, u0, tspan, gamma)
    sol = OrdinaryDiffEq.solve(prob)
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

마하수 `M`, Cone 반각 `angle` 일때 발생한 경사충격파를 지난 후 물성치 계산

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: Cone 반각 (degree)
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 경사충격파 후 마하수
- `rho2::Float64`: 경사충격파 전/후 밀도비
- `p2::Float64`: 경사충격파 전/후 압력비
- `p0ratio::Float64`: 경사충격파 전/후 전압력비
- `beta::Float64`: 경사 충격파 각도 (degree)
"""
function solve_shock(M, angle, gamma=1.4)
    theta = theta_eff(M, angle, gamma)
    return solve_oblique(M, theta, gamma)
end

"""
    solve_cone_properties(M, angle; psi::Union{Float64, Nothing}=nothing, gamma=1.4)

마하수 `M`, Cone 반각 `angle`일 때 콘 표면 또는 특정 ray 각도 `psi`에서의 물성치를 계산합니다.

# Arguments
- `M::Float64`: 충격파 전 마하수
- `angle::Float64`: Cone 반각 (degree)
- `psi::Union{Float64, Nothing}=nothing`: Ray 각도 (degree). 제공되지 않거나 `nothing`이면 `angle`과 동일하게 간주되어 콘 표면에서의 물성치를 계산합니다.
- `gamma::Float64=1.4`: 비열비

# Returns
- If `psi` is `nothing` (콘 표면 물성치):
    - `mc::Float64`: 콘 표면 마하수
    - `rhoc::Float64`: 콘 표면 밀도비 (자유흐름 밀도 대비)
    - `pc::Float64`: 콘 표면 압력비 (자유흐름 압력 대비)
    - `p0ratio::Float64`: 전압력비 (충격파 통과 후 / 전)
    - `beta::Float64`: 경사 충격파 각도 (degree)
- If `psi` is provided (특정 ray 각도 `psi`에서의 물성치):
    - `Mc::Float64`: `psi`에서의 마하수
    - `rhoc::Float64`: `psi`에서의 밀도비 (자유흐름 밀도 대비)
    - `pc::Float64`: `psi`에서의 압력비 (자유흐름 압력 대비)
    - `p0ratio::Float64`: 전압력비 (충격파 통과 후 / 전)
    - `beta::Float64`: 경사 충격파 각도 (degree)
    - `phi::Float64`: `psi`에서의 유동 방향 (degree)
"""
function solve_cone_properties(M, angle; psi::Union{Float64, Nothing}=nothing, gamma=1.4)
    theta_eff_val = theta_eff(M, angle, gamma)

    # 충격파 직후 물성치 계산 (M은 자유흐름 마하수)
    # M_after_shock는 충격파 직후 마하수
    # rho_ratio_across_shock는 rho_after_shock / rho_freestream
    # p_ratio_across_shock는 p_after_shock / p_freestream
    # p0_ratio_across_shock는 p0_after_shock / p0_freestream
    # beta_shock_angle은 충격파 각도
    M_after_shock, rho_ratio_across_shock, p_ratio_across_shock, p0_ratio_across_shock, beta_shock_angle = solve_oblique(M, theta_eff_val, gamma)

    # _cone_mach 계산을 위한 psi 값 결정
    # psi가 제공되지 않으면 콘 표면(angle)에서의 값을 계산
    psi_calc = (psi === nothing) ? angle : psi

    # Cone 표면 또는 특정 psi에서의 마하수(Mc_at_psi) 및 유동방향(phi_at_psi) 계산
    # _cone_mach 함수는 자유흐름 마하수 M, 계산하려는 각도 psi_calc, 유효 쐐기각 theta_eff_val을 사용합니다.
    Mc_at_psi, phi_at_psi = _cone_mach(M, psi_calc, theta_eff_val, gamma)

    # 밀도비 계산 (psi_calc 지점의 밀도 / 자유흐름 밀도)
    # rho_psi / rho_freestream = (rho_psi / rho_after_shock) * (rho_after_shock / rho_freestream)
    # 여기서 rho_psi / rho_after_shock = rho0_over_rho(M_after_shock) / rho0_over_rho(Mc_at_psi) (등엔트로피 과정)
    rhoc_ratio_freestream = rho_ratio_across_shock * rho0_over_rho(M_after_shock, gamma) / rho0_over_rho(Mc_at_psi, gamma)

    # 압력비 계산 (psi_calc 지점의 압력 / 자유흐름 압력)
    # p_psi / p_freestream = (p_psi / p_after_shock) * (p_after_shock / p_freestream)
    # 여기서 p_psi / p_after_shock = p0_over_p(M_after_shock) / p0_over_p(Mc_at_psi) (등엔트로피 과정)
    pc_ratio_freestream = p_ratio_across_shock * p0_over_p(M_after_shock, gamma) / p0_over_p(Mc_at_psi, gamma)

    if psi === nothing
        # 기존 solve_cone_theta와 동일한 반환 (phi 제외)
        return Mc_at_psi, rhoc_ratio_freestream, pc_ratio_freestream, p0_ratio_across_shock, beta_shock_angle
    else
        # 기존 solve_cone_theta_phi와 동일한 반환
        return Mc_at_psi, rhoc_ratio_freestream, pc_ratio_freestream, p0_ratio_across_shock, beta_shock_angle, phi_at_psi
    end
end
