"""
    고도에 따른 표준 대기 (US Standard 1976) 물성치 계산

    Parameters
    ----------
    alt : float
        고도 (km))

    Returns
    -------
    density : float
        밀도 (kg/m^3)
    pressure : float
        압력 (Pa)
    temperature : float
        온도 (K)
    asound : float
        음속 (m/s^2)
    viscosity : float
        Dynamics 점도 (Pa s)
"""
function atmos1976_at(alt)
    t0, p0, rho0, a0 = 288.15, 101325.0, 1.225, 340.294

    # Compute ratio
    rhor, pr, tr = _air1976(alt)

    # Get density, pressure, temperature
    temperature = t0 * tr
    pressure = p0 * pr
    density = rho0 * rhor

    # Speed of sound
    asound = a0 * sqrt(tr)

    # Get viscosity
    viscosity = sutherland_mu(tr)

    return density, pressure, temperature, asound, viscosity
end

"""
Geometric 고도 (Z)를 Geopotential 고도 (H)로 변환

    Parameters
    ----------
    alt : float
        Geometric 고도 (km)
    Rearth : float, optional
        지구 반지름, 기본값은 6369.0km.

    Returns
    -------
    H : float
        Geopotential 고도 (km)

"""
function geopot_alt(alt, rearth=6369.0)
    return alt * rearth / (rearth + alt)
end

"""
    Geopotential 고도 (H)를 Geometric 고도 (Z)로 변환

    Parameters
    ----------
    alt : float
        Geopotential 고도 (km)
    Rearth : float, optional
        지구 반지름, 기본값은 6369.0km.

    Returns
    -------
    Z : float
        Geometric 고도 (km))
"""
function geometrric_alt(alt, rearth=6369.0)
    return alt * rearth / (rearth - alt)
end

function _air1976(alt, gmr=34.163195)
    # Seven Layer model up to 86km
    air_layers = [
        0.0 11.0 20.0 32.0 47.0 51.0 71.0 84.852;
        288.15 216.65 216.65 228.65 270.65 270.65 214.65 186.946;
        1.0 2.2336110E-1 5.4032950E-2 8.5666784E-3 1.0945601E-3 6.6063531E-4 3.9046834E-5 3.68501E-6;
        -6.5 0.0 1.0 2.8 0.0 -2.8 -2.0 0.0
    ]

    tbase0 = air_layers[2, 1]

    # Compute geopotential altitude
    h = geopot_alt(alt)

    # Find index
    if h > 0.0
        idx = searchsortedfirst(view(air_layers, 1, :), h)
    else
        idx = 1
    end

    # Get values
    hbase, tbase, pbase, tgrad = air_layers[:, idx]

    # Computet temperature and ratio
    dh = h - hbase
    tlocal = tbase + tgrad * dh
    theta = tlocal / tbase0

    # Compute pressure ratio
    if abs(tgrad) < 1e-6
        delta = pbase * exp(-gmr * dg / tbase)
    else
        delta = pbase * (tbase / tlocal)^(gmr / tgrad)
    end

    # Compute density ratio
    sigma = delta / theta

    return sigma, delta, theta
end

"""
    Sutherland law for viscosity

    온도에 따른 Dynamics 점도 계산

    Parameters
    ----------
    theta : float
        온도 비 (15C 대비 현재 온도)
    t0 : float, optional
        기준 온도, 기본값은 15C
    mu0 : float, optional
        기준 온도에서 점도, 기본값은 1.458e-6
    suth : float, optional
        Sutherland 관계식 계수, 기본값은 110.4

    Returns
    -------
    mu : float
        온도에 따른 Dynamic 점도
"""
function sutherland_mu(theta, t0=288.15, mu0=1.458e-6, suth=110.4)

    t = t0 * theta
    return mu0 * t * sqrt(t) / (t + suth)
end