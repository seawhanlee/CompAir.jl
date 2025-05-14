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
    temperature = t0*tr
    pressure = p0*pr
    density = rho0*rhor
    
    # Speed of sound
    asound = a0*np.sqrt(tr)
    
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
    return alt*rearth/(rearth + alt)
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
    return alt*rearth/(rearth - alt)
end

function _air1976(alt, gmr=34.163195)
    # Seven Layer model up to 86km
    air_layers = [
        0.0  11.0  20.0  32.0  47.0  51.0  71.0  84.852;
        288.15  216.65  216.65  228.65  270.65  270.65  214.65  186.946;
        1.0  2.2336110E-1  5.4032950E-2  8.5666784E-3  1.0945601E-3  6.6063531E-4  3.9046834E-5  3.68501E-6;
        -6.5  0.0  1.0  2.8  0.0  -2.8  -2.0  0.0
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
    hbase, tbase, pbase, tgrad = air_layers[idx]
end