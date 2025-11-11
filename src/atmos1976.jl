"""
    atmosphere_properties_at(alt)

Calculates properties of the US Standard Atmosphere 1976 at a given altitude.

# Arguments
- `alt::Float64`: Altitude (km)

# Returns
- `density::Float64`: Density (kg/m^3)
- `pressure::Float64`: Pressure (Pa)
- `temperature::Float64`: Temperature (K)
- `asound::Float64`: Speed of sound (m/s)
- `viscosity::Float64`: Dynamic viscosity (Pa s)
"""
function atmosphere_properties_at(alt)
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
    viscosity = sutherland_viscosity(tr)

    return density, pressure, temperature, asound, viscosity
end

"""
    geometric_to_geopotential_altitude(alt, rearth=6369.0)

Converts geometric altitude (Z) to geopotential altitude (H).

# Arguments
- `alt::Float64`: Geometric altitude (km)
- `rearth::Float64=6369.0`: Earth's radius (km)

# Returns
- `H::Float64`: Geopotential altitude (km)
"""
function geometric_to_geopotential_altitude(alt, rearth=6369.0)
    return alt * rearth / (rearth + alt)
end

"""
    geopotential_to_geometric_altitude(alt, rearth=6369.0)

Converts geopotential altitude (H) to geometric altitude (Z).

# Arguments
- `alt::Float64`: Geopotential altitude (km)
- `rearth::Float64=6369.0`: Earth's radius (km)

# Returns
- `Z::Float64`: Geometric altitude (km)
"""
function geopotential_to_geometric_altitude(alt, rearth=6369.0)
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

    sea_level_temperature = air_layers[2, 1]

    # Compute geopotential altitude
    geopotential_altitude = geometric_to_geopotential_altitude(alt)

    # Find index - determine which atmospheric layer the altitude belongs to
    if geopotential_altitude >= air_layers[1, end]
        # Altitude exceeds maximum, use last layer
        layer_index = size(air_layers, 2)
    else
        # Find the layer that contains this altitude
        layer_index = 1
        for i in 2:size(air_layers, 2)
            if geopotential_altitude < air_layers[1, i]
                break
            end
            layer_index = i
        end
    end

    # Get values for the atmospheric layer
    base_altitude, base_temperature, base_pressure, temperature_gradient = air_layers[:, layer_index]

    # Compute temperature and ratio
    altitude_difference = geopotential_altitude - base_altitude
    local_temperature = base_temperature + temperature_gradient * altitude_difference
    temperature_ratio = local_temperature / sea_level_temperature

    # Compute pressure ratio
    if abs(temperature_gradient) < 1e-6
        pressure_ratio = base_pressure * exp(-gmr * altitude_difference / base_temperature)
    else
        pressure_ratio = base_pressure * (base_temperature / local_temperature)^(gmr / temperature_gradient)
    end

    # Compute density ratio
    density_ratio = pressure_ratio / temperature_ratio

    return density_ratio, pressure_ratio, temperature_ratio
end

"""
    sutherland_viscosity(theta, t0=288.15, mu0=1.458e-6, suth=110.4)

Calculates dynamic viscosity using Sutherland's law.

# Arguments
- `theta::Float64`: Temperature ratio (T/T0)
- `t0::Float64=288.15`: Reference temperature (K)
- `mu0::Float64=1.458e-6`: Reference viscosity (Pa s)
- `suth::Float64=110.4`: Sutherland's constant

# Returns
- `mu::Float64`: Dynamic viscosity (Pa s)
"""
function sutherland_viscosity(theta, t0=288.15, mu0=1.716e-5, suth=110.4)
    t = t0 * theta
    return mu0 * t^1.5 / (t + suth)
end
