"""
수직 충격파 후 마하수

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
mach : float
    충격파 후 마하수
"""
function mach2(M, gamma=1.4)
    return sqrt((1 + 0.5 * (gamma-1)*M^2)/(gamma*M^2 - 0.5 * (gamma -1)))
end

"""
수직 충격파 전/후 밀도비

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
rho : float
    충격파 전/후 밀도비

Notes
-----
수직 충격파 전/후 밀도비는 압축성 유체역학 이론을 통해 유도된다.
"""
function rho2_over_rho1(M, gamma=1.4)
    return (gamma + 1)*M^2/(2+(gamma-1)*M^2)
end

"""
수직 충격파 전/후 압력비

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
p : float
    충격파 전/후 압력비
"""
function p2_over_p1(M, gamma=1.4)
    return 1+2*gamma/(gamma+1)*(M^2-1)
end

"""
수직 충격파 전/후 온도비

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
t : float
    충격파 전/후 온도비
"""
function t2_over_t1(M, gamma=1.4)
    return p2_over_p1(M, gamma)/rho2_over_rho1(M, gamma)
end

"""
수직 충격파 후 전압력

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
p0 : float
    충격파 후 전압력
"""
function p02(M, gamma=1.4)
    p2 = p2_over_p1(M)
    M2 = mach2(M)
    return p0_over_p(M2, gamma)*p2
end

"""
수직 충격파 후 전압력비

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
p0 : float
    충격파 후 전압력비
"""
function p02_over_p01(M, gamma=1.4)
    p01 = p0_over_p(M, gamma)
    p02 = p02(M, gamma)
    return p02/p01
end

"""
수직 충격파 후 물성치 변화

Parameters
----------
M : float
    충격파 전 마하수
gamma : float, optional
    비열비

Returns
--------
m2 : float
    수직충격파 후 마하수
rho2 : float
    수직충격파 전/후 밀도비
p2 : float
    수직충격파 전/후 압력비
p02 : float
    수직충격파 전/후 전압력비
"""
function solveNormalShock(M, gamma=1.4)
    M2 = mach2(M, gamma)
    rho2, p2 = rho2_over_rho1(M, gamma), p2_over_p1(M, gamma)
    p0ratio = p02_over_p01(M, gamma)
    return M2, rho2, p2, p0ratio
end