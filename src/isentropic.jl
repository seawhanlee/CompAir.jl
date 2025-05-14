# Isentropic relation (Anderson Book 8.4x)

"""
마하수 M 일때 정체 온도비

Parameters
----------
M : float
    마하수
gamma : float, optional
    비열비

Returns
--------
t0 : 정체 온도비
"""
function t0_over_t(M, gamma=1.4)
    return 1 + 0.5 * (gamma - 1) * M^2
end

"""
마하수 `M` 일때 정체 압력비

Parameters
----------
M : float
    마하수
gamma : float, optional
    비열비

Returns
--------
p0 : 정체 압력비
"""
function p0_over_p(M, gamma=1.4)
    t = t0_over_t(M, gamma)
    return t^(gamma / (gamma - 1))
end

"""
마하수 `M` 일때 정체 밀도비

Parameters
----------
M : float
    마하수
gamma : float, optional
    비열비

Returns
--------
rho0 : 정체 밀도비
"""
function rho0_over_rho(M, gamma=1.4)
    t = t0_over_t(M, gamma)
    return t^(1 / (gamma - 1))
end