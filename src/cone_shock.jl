import Roots
import DiffEqBase
import OrdinaryDiffEq
import LinearAlgebra

"""
    _taylor_maccoll!(du, u, gamma, theta)

In-place Taylor-Maccoll ODE right-hand side in canonical DifferentialEquations.jl form `f!(du, u, p, t)`.

# Arguments
- `du::Vector{Float64}`: Derivative output vector (mutated in-place)
- `u::Vector{Float64}`: State vector `[v_r, v_theta]`
- `gamma`: Specific heat ratio (passed as ODE parameter `p`)
- `theta`: Polar angle in radians (ODE independent variable `t`)

# Returns
- `nothing`

# References
- [NASA Taylor-Maccoll](https://www1.grc.nasa.gov/beginners-guide-to-aeronautics/shockc/)
"""
function _taylor_maccoll!(du, u, gamma, theta)
    @inbounds begin
        v_r = u[1]
        v_theta = u[2]

        q = 1.0 - v_r * v_r - v_theta * v_theta
        a = 0.5 * (gamma - 1) * q

        sinθ = sin(theta)
        cosθ = cos(theta)
        cotθ = cosθ / sinθ

        denom = a - v_theta * v_theta

        du[1] = v_theta
        du[2] = (v_theta * v_theta * v_r - a * (2.0 * v_r + v_theta * cotθ)) / denom
    end
    return nothing
end

"""
    _integrate_tm(M, angle, theta, gamma=1.4)

Internal function to numerically integrate the Taylor-Maccoll equation using
the canonical DifferentialEquations.jl interface.

Uses the default composite algorithm for automatic stiffness detection with in-place
RHS and minimal saving for performance in root-finding loops.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Target angle for calculation (degrees)
- `theta::Float64`: Wedge angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `sol`: Solution object from DifferentialEquations.jl (only endpoint saved)
"""
function _integrate_tm(M, angle, theta, gamma=1.4)
    maximum_deflection_angle = theta_max(M, gamma)

    if theta <= maximum_deflection_angle
        shock_angle = beta_from_theta(M, theta, gamma)
        downstream_mach = os_mach2(M, theta, gamma)
    else
        shock_angle = 90
        downstream_mach = ns_mach2(M, gamma)
    end

    normalized_velocity = sqrt(((gamma - 1) / 2 * downstream_mach^2) / (1 + (gamma - 1) / 2 * downstream_mach^2))
    tangential_velocity = -normalized_velocity * sind(shock_angle - theta)
    radial_velocity = normalized_velocity * cosd(shock_angle - theta)

    tspan = (deg2rad(shock_angle), deg2rad(angle))
    u0 = [radial_velocity, tangential_velocity]

    prob = DiffEqBase.ODEProblem(_taylor_maccoll!, u0, tspan, gamma)
    sol = OrdinaryDiffEq.solve(
        prob;
        save_everystep=false,
        save_start=false,
        save_end=true,
        dense=false,
    )

    return sol
end

"""
    cone_theta_eff(M, angle, gamma=1.4)

Calculates the effective wedge angle for a conical shock.

# Arguments
- `M::Float64`: Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `theta_eff::Float64`: Effective wedge angle (degrees)
"""
function cone_theta_eff(M, angle, gamma=1.4)
    tangential_velocity_objective(wedge_angle) = _integrate_tm(M, angle, wedge_angle, gamma).u[end][2] # Use v_theta (tangential velocity component)
    return Roots.find_zero(tangential_velocity_objective, 1e-3)
end

"""
    cone_beta(M, angle, gamma=1.4)

Calculates the conical shock wave angle for a given Mach number `M` and cone half-angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `beta::Float64`: Conical shock wave angle (degrees)
"""
function cone_beta(M, angle, gamma=1.4)
    theta = cone_theta_eff(M, angle, gamma)
    return beta_from_theta(M, theta, gamma)
end

"""
    cone_mach2(M, angle, gamma=1.4)

Calculates the Mach number downstream of a conical shock wave for a given
upstream Mach number `M` and cone half-angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `M2::Float64`: Downstream Mach number
"""
function cone_mach2(M, angle, gamma=1.4)
    theta = cone_theta_eff(M, angle, gamma)
    return os_mach2(M, theta, gamma)
end

"""
    _cone_mach(M, angle, theta, gamma)

Internal function to calculate the Mach number and flow direction at the cone surface
for a given Mach number and angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Target angle for calculation (degrees)
- `theta::Float64`: Wedge angle (degrees)
- `gamma::Float64`: Specific heat ratio

# Returns
- `M2::Float64`: Mach number at the surface
- `phi::Float64`: Flow direction angle (degrees)
"""
function _cone_mach(M, angle, theta, gamma)
    velocity_vector = _integrate_tm(M, angle, theta, gamma).u[end]

    velocity_magnitude = LinearAlgebra.norm(velocity_vector)
    flow_direction = angle + rad2deg(atan(velocity_vector[2] / velocity_vector[1]))

    local_mach = sqrt(2 / (gamma - 1) * (velocity_magnitude^2 / (1 - velocity_magnitude^2)))
    return local_mach, flow_direction
end

"""
    cone_mach_surface(M, angle, gamma=1.4)

Calculates the Mach number at the cone surface for a given upstream Mach number `M`
and cone half-angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- `M2::Float64`: Mach number at the cone surface
"""
function cone_mach_surface(M, angle, gamma=1.4)
    theta = cone_theta_eff(M, angle, gamma)
    return _cone_mach(M, angle, theta, gamma)
end

"""
    solve_cone(M, angle, gamma=1.4)

Calculates the flow properties downstream of a conical shock wave for a given
upstream Mach number `M` and cone half-angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
A `NamedTuple` containing:
- `M2::Float64`: Downstream Mach number
- `rho2_ratio::Float64`: Density ratio across the shock (ρ₂/ρ₁)
- `p2_ratio::Float64`: Pressure ratio across the shock (p₂/p₁)
- `p0_ratio::Float64`: Total pressure ratio across the shock (p₀₂/p₀₁)
- `beta::Float64`: Conical shock wave angle (degrees)
"""
function solve_cone(M, angle, gamma=1.4)
    theta = cone_theta_eff(M, angle, gamma)
    return solve_oblique(M, theta, gamma)
end

"""
    solve_cone_properties(M, angle; psi::Union{Float64, Nothing}=nothing, gamma=1.4)

Calculates the flow properties at the cone surface or at a specific ray angle `psi`
for a given upstream Mach number `M` and cone half-angle.

# Arguments
- `M::Float64`: Upstream Mach number
- `angle::Float64`: Cone half-angle (degrees)
- `psi::Union{Float64, Nothing}=nothing`: Ray angle (degrees). If not provided or `nothing`, 
  properties at the cone surface (psi = angle) are calculated.
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
- If `psi` is `nothing` (cone surface properties):
    - `mc::Float64`: Mach number at cone surface
    - `rhoc::Float64`: Density ratio relative to freestream (ρ_c/ρ_∞)
    - `pc::Float64`: Pressure ratio relative to freestream (p_c/p_∞)
    - `p0ratio::Float64`: Total pressure ratio (p₀₂/p₀₁)
    - `beta::Float64`: Conical shock wave angle (degrees)
- If `psi` is provided (properties at ray angle `psi`):
    - `Mc::Float64`: Mach number at ray angle psi
    - `rhoc::Float64`: Density ratio relative to freestream (ρ/ρ_∞)
    - `pc::Float64`: Pressure ratio relative to freestream (p/p_∞)
    - `p0ratio::Float64`: Total pressure ratio (p₀₂/p₀₁)
    - `beta::Float64`: Conical shock wave angle (degrees)
    - `phi::Float64`: Flow direction at psi (degrees)
"""
function solve_cone_properties(M, angle; psi::Union{Float64, Nothing}=nothing, gamma=1.4)
    theta_eff_val = cone_theta_eff(M, angle, gamma)

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
