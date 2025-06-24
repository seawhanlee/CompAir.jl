"""
    _intake_ramp(M_infty::Float64, ramp_angle::Vector{Float64}, gamma::Float64=1.4)

주어진 램프 각도(ramp_angle) 배열과 자유류 마하수(M_infty), 비열비(gamma)에 대해 다단 램프 흡입구의 각 단에서의 마하수, 밀도비, 압력비, 전체압비, 충격파 각도를 계산하는 내부 함수.

# Arguments
- `M_infty::Float64`: 자유류(입구) 마하수
- `ramp_angle::Vector{Float64}`: 각 램프의 각도 (degree)
- `gamma::Float64`: 비열비(기본값 1.4)

# Returns
- `NamedTuple`:
    - `M`: 각 단의 마하수 벡터 (길이 n+1)
    - `rho2_ratio`: 각 단의 밀도비 벡터 (길이 n)
    - `p2_ratio`: 각 단의 압력비 벡터 (길이 n)
    - `p0_ratio`: 각 단의 전체압비 벡터 (길이 n)
    - `beta`: 각 단의 충격파 각도 벡터 (길이 n)
"""
function _intake_ramp(M_infty::Float64, ramp_angle::Vector{Float64}, gamma::Float64=1.4)
    n = length(ramp_angle)
    mach_number = zeros(n+1)
    rho, p, p0ratio, beta = zeros(n), zeros(n), zeros(n), zeros(n)

    mach_number[1] = M_infty

    for i in 1:n
        M = mach_number[i]
        theta = ramp_angle[i]
        sol = solve_oblique(M, theta, gamma)
        mach_number[i+1] = sol.M2
        rho[i] = sol.rho2_ratio
        p[i] = sol.p2_ratio
        p0ratio[i] = sol.p0_ratio
        beta[i] = sol.beta
    end
    
    return (M=mach_number, rho2_ratio=rho, p2_ratio=p, p0_ratio=p0ratio, beta=beta)

end

"""
    intake_ramp(M_infty::Real, ramp_angle::Vector{<:Real}, gamma::Real=1.4)

주어진 램프 각도(ramp_angle) 배열과 자유류 마하수(M_infty), 비열비(gamma)에 대해 다단 램프 흡입구의 각 단에서의 마하수, 밀도비, 압력비, 전체압비, 충격파 각도를 계산한다.

# Arguments
- `M_infty::Real`: 자유류(입구) 마하수
- `ramp_angle::Vector{<:Real}`: 각 램프의 각도 (degree)
- `gamma::Float64`: 비열비(기본값 1.4)

# Returns
- `NamedTuple`:
    - `M`: 각 단의 마하수 벡터 (길이 n+1)
    - `rho2_ratio`: 각 단의 밀도비 벡터 (길이 n)
    - `p2_ratio`: 각 단의 압력비 벡터 (길이 n)
    - `p0_ratio`: 각 단의 전체압비 벡터 (길이 n)
    - `beta`: 각 단의 충격파 각도 벡터 (길이 n)
"""
function intake_ramp(M_infty::Real, ramp_angle::Vector{<:Real}, gamma::Real=1.4)
    return _intake_ramp(Float64(M_infty), Float64.(ramp_angle), Float64(gamma))
end

