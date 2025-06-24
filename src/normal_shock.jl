"""
    normal_mach2(M::Float64, gamma::Float64=1.4)

수직 충격파 후 마하수

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `mach::Float64`: 충격파 후 마하수
"""
function normal_mach2(M::Float64, gamma::Float64=1.4)
    return sqrt((1 + 0.5 * (gamma - 1) * M^2) / (gamma * M^2 - 0.5 * (gamma - 1)))
end

"""
    rho2_over_rho1(M::Float64, gamma::Float64=1.4)

수직 충격파 전/후 밀도비

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `rho::Float64`: 충격파 전/후 밀도비

# Notes
수직 충격파 전/후 밀도비는 압축성 유체역학 이론을 통해 유도된다.
"""
function rho2_over_rho1(M::Float64, gamma::Float64=1.4)
    return (gamma + 1) * M^2 / (2 + (gamma - 1) * M^2)
end

"""
    p2_over_p1(M::Float64, gamma::Float64=1.4)

수직 충격파 전/후 압력비

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `p::Float64`: 충격파 전/후 압력비
"""
function p2_over_p1(M::Float64, gamma::Float64=1.4)
    return 1 + 2 * gamma / (gamma + 1) * (M^2 - 1)
end

"""
    t2_over_t1(M::Float64, gamma::Float64=1.4)

수직 충격파 전/후 온도비

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `t::Float64`: 충격파 전/후 온도비
"""
function t2_over_t1(M::Float64, gamma::Float64=1.4)
    return p2_over_p1(M, gamma) / rho2_over_rho1(M, gamma)
end

"""
    normal_p02(M::Float64, gamma::Float64=1.4)

수직 충격파 후 전압력

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `p0::Float64`: 충격파 후 전압력
"""
function normal_p02(M::Float64, gamma::Float64=1.4)
    p2 = p2_over_p1(M, gamma)
    M2 = normal_mach2(M, gamma)
    return p0_over_p(M2, gamma) * p2
end

"""
    p02_over_p01(M::Float64, gamma::Float64=1.4)

수직 충격파 후 전압력비

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `p02/p01::Float64`: 충격파 후 전압력비
"""
function p02_over_p01(M::Float64, gamma::Float64=1.4)
    p01 = p0_over_p(M, gamma)
    p02 = normal_p02(M, gamma)
    return p02 / p01
end

"""
    solve_normal(M::Float64, gamma::Float64=1.4)

수직 충격파 후 물성치 변화

# Arguments
- `M::Float64`: 충격파 전 마하수
- `gamma::Float64=1.4`: 비열비

# Returns
- `M2::Float64`: 수직충격파 후 마하수
- `rho2::Float64`: 수직충격파 전/후 밀도비
- `p2::Float64`: 수직충격파 전/후 압력비
- `p0ratio::Float64`: 수직충격파 전/후 전압력비
"""
function solve_normal(M::Float64, gamma::Float64=1.4)
    M2 = normal_mach2(M, gamma)
    rho2, p2 = rho2_over_rho1(M, gamma), p2_over_p1(M, gamma)
    p0ratio = p02_over_p01(M, gamma)
    return (M2=M2, rho2_ratio=rho2, p2_ratio=p2, p0_ratio=p0ratio)
end
