"""
    atmos1976_at(alt)

고도에 따른 표준 대기 (US Standard 1976) 물성치 계산

# Arguments
- `alt::Float64`: 고도 (km)

# Returns
- `density::Float64`: 밀도 (kg/m^3)
- `pressure::Float64`: 압력 (Pa)
- `temperature::Float64`: 온도 (K)
- `asound::Float64`: 음속 (m/s)
- `viscosity::Float64`: Dynamics 점도 (Pa s)
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
    geopot_alt(alt, rearth=6369.0)

Geometric 고도 (Z)를 Geopotential 고도 (H)로 변환

# Arguments
- `alt::Float64`: Geometric 고도 (km)
- `rearth::Float64=6369.0`: 지구 반지름(km)

# Returns
- `H::Float64`: Geopotential 고도 (km)
"""
function geopot_alt(alt, rearth=6369.0)
    return alt * rearth / (rearth + alt)
end

"""
    geometric_alt(alt, rearth=6369.0)

Geopotential 고도 (H)를 Geometric 고도 (Z)로 변환

# Arguments
- `alt::Float64`: Geopotential 고도 (km)
- `rearth::Float64=6369.0`: 지구 반지름(km)

# Returns
- `Z::Float64`: Geometric 고도 (km)
"""
function geometric_alt(alt, rearth=6369.0)
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

    # Find index - determine which atmospheric layer the altitude belongs to
    if h >= air_layers[1, end]
        # Altitude exceeds maximum, use last layer
        idx = size(air_layers, 2)
    else
        # Find the layer that contains this altitude
        idx = 1
        for i in 2:size(air_layers, 2)
            if h < air_layers[1, i]
                break
            end
            idx = i
        end
    end

    # Get values
    hbase, tbase, pbase, tgrad = air_layers[:, idx]

    # Compute temperature and ratio
    dh = h - hbase
    tlocal = tbase + tgrad * dh
    theta = tlocal / tbase0

    # Compute pressure ratio
    if abs(tgrad) < 1e-6
        delta = pbase * exp(-gmr * dh / tbase)
    else
        delta = pbase * (tbase / tlocal)^(gmr / tgrad)
    end

    # Compute density ratio
    sigma = delta / theta

    return sigma, delta, theta
end

"""
    sutherland_mu(theta, t0=288.15, mu0=1.458e-6, suth=110.4)

Sutherland law for viscosity - 온도에 따른 Dynamics 점도 계산

# Arguments
- `theta::Float64`: 온도 비 (15C 대비 현재 온도)
- `t0::Float64=288.15`: 기준 온도(K)
- `mu0::Float64=1.458e-6`: 기준 온도에서 점도
- `suth::Float64=110.4`: Sutherland 관계식 계수

# Returns
- `mu::Float64`: 온도에 따른 Dynamic 점도(Pa s)
"""
function sutherland_mu(theta, t0=288.15, mu0=1.716e-5, suth=110.4)
    t = t0 * theta
    return mu0 * t^1.5 / (t + suth)
end
