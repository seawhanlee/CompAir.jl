# Atmospheric Model (US Standard Atmosphere 1976)

```@meta
CurrentModule = CompAir
```

This module provides functions for calculating atmospheric properties based on the US Standard Atmosphere 1976 model, which is widely used in aerospace engineering and meteorology.

## Overview

The US Standard Atmosphere 1976 is a mathematical model that describes the variation of atmospheric properties with altitude. It provides:

- **Density**: Air density variation with altitude
- **Pressure**: Atmospheric pressure profiles
- **Temperature**: Temperature lapse rates in different atmospheric layers
- **Speed of Sound**: Acoustic velocity based on temperature
- **Dynamic Viscosity**: Temperature-dependent viscosity using Sutherland's law
- **Geopotential Altitude**: Conversion between geometric and geopotential altitudes

## Theory

The atmosphere is divided into several layers with different temperature profiles:

**Troposphere (0-11 km)**: Linear temperature decrease
- ``T = T_0 - L \cdot h``
- ``L = 6.5`` K/km (lapse rate)

**Stratosphere (11-20 km)**: Isothermal layer
- ``T = T_{11} = 216.65`` K (constant)

**Stratosphere (20-32 km)**: Linear temperature increase
- ``T = T_{20} + L_2 \cdot (h - 20)``
- ``L_2 = 1.0`` K/km

**Hydrostatic equation**:
$$\frac{dp}{dh} = -\rho g$$

**Perfect gas law**:
$$p = \rho R T$$

**Geopotential altitude**:
$$h' = \frac{r_0 h}{r_0 + h}$$

**Sutherland viscosity law**:
$$\mu = \mu_0 \frac{T^{1.5}}{T + S}$$

Where:
- ``h`` = geometric altitude
- ``h'`` = geopotential altitude  
- ``r_0`` = Earth's radius (6356766 m)
- ``R`` = specific gas constant (287.0 J/kg·K for air)
- ``g_0`` = standard gravity (9.80665 m/s²)
- ``\mu_0`` = reference viscosity (1.716×10⁻⁵ Pa·s)
- ``S`` = Sutherland constant (110.4 K)

## Functions

```@docs
atmosphere_properties_at
geometric_to_geopotential_altitude
geopotential_to_geometric_altitude
sutherland_viscosity
```

## Function Details

### atmosphere_properties_at

```julia
atmosphere_properties_at(alt)
```

Calculate complete atmospheric properties at a given altitude using the US Standard Atmosphere 1976 model.

**Arguments:**
- `alt::Real`: Geometric altitude in kilometers

**Returns:**
- `density::Float64`: Air density in kg/m³
- `pressure::Float64`: Atmospheric pressure in Pa
- `temperature::Float64`: Temperature in K
- `asound::Float64`: Speed of sound in m/s
- `viscosity::Float64`: Dynamic viscosity in Pa·s

**Example:**
```julia
julia> density, pressure, temperature, asound, viscosity = atmosphere_properties_at(11.0)
(0.36391, 22632.1, 216.65, 295.07, 1.4216e-5)

julia> println("At 11 km: ρ=$(round(density, digits=3)) kg/m³, p=$(round(pressure/1000, digits=1)) kPa")
At 11 km: ρ=0.364 kg/m³, p=22.6 kPa
```

### geometric_to_geopotential_altitude

```julia
geometric_to_geopotential_altitude(alt, rearth=6369.0)
```

Convert geometric altitude to geopotential altitude.

**Arguments:**
- `alt::Real`: Geometric altitude in km
- `rearth::Real=6369.0`: Earth's radius in km

**Returns:**
- `Float64`: Geopotential altitude in km

**Formula:**
$$h' = \frac{r_0 h}{r_0 + h}$$

**Example:**
```julia
julia> geometric_to_geopotential_altitude(20.0)
19.93743718592965

julia> geometric_to_geopotential_altitude(50.0)
49.61139896373057
```

### geopotential_to_geometric_altitude

```julia
geopotential_to_geometric_altitude(alt, rearth=6369.0)
```

Convert geopotential altitude to geometric altitude.

**Arguments:**
- `alt::Real`: Geopotential altitude in km
- `rearth::Real=6369.0`: Earth's radius in km

**Returns:**
- `Float64`: Geometric altitude in km

**Formula:**
$$h = \frac{r_0 h'}{r_0 - h'}$$

**Example:**
```julia
julia> geopotential_to_geometric_altitude(19.937)
19.999685738514174

julia> geopotential_to_geometric_altitude(49.611)
49.999743718592965
```

### sutherland_viscosity

```julia
sutherland_viscosity(theta, t0=288.15, mu0=1.716e-5, suth=110.4)
```

Calculate dynamic viscosity using Sutherland's law for temperature dependence.

**Arguments:**
- `theta::Real`: Temperature ratio (T/T₀) or absolute temperature
- `t0::Real=288.15`: Reference temperature in K
- `mu0::Real=1.716e-5`: Reference viscosity in Pa·s
- `suth::Real=110.4`: Sutherland constant in K

**Returns:**
- `Float64`: Dynamic viscosity in Pa·s

**Formula:**
$$\mu = \mu_0 \frac{T^{1.5}}{T + S}$$

**Example:**
```julia
julia> sutherland_viscosity(1.0)  # At standard conditions
1.716e-5

julia> sutherland_viscosity(216.65/288.15)  # At 11 km
1.4216e-5
```

## Applications

### Flight Performance Analysis

Calculate flight conditions at cruise altitude:

```julia
# Commercial aircraft cruise conditions
cruise_alt = 11.0  # km (36,000 ft)
airspeed = 250     # m/s

# Get atmospheric properties
rho, p, T, a, mu = atmosphere_properties_at(cruise_alt)

# Calculate flight parameters
Mach = airspeed / a
dynamic_pressure = 0.5 * rho * airspeed^2
Reynolds_per_meter = rho * airspeed / mu

println("Flight Analysis at $(cruise_alt) km:")
println("True airspeed: $(airspeed) m/s")
println("Mach number: $(round(Mach, digits=3))")
println("Dynamic pressure: $(round(dynamic_pressure, digits=1)) Pa")
println("Reynolds number per meter: $(round(Reynolds_per_meter/1e6, digits=2)) million/m")
println("Air density: $(round(rho, digits=3)) kg/m³")
println("Temperature: $(round(T, digits=1)) K")
```

### Atmospheric Property Variation

Analyze how atmospheric properties change with altitude:

```julia
altitudes = [0.0, 5.0, 11.0, 20.0, 30.0, 50.0]  # km

println("Atmospheric Property Variation:")
println("Alt(km)\tρ(kg/m³)\tp(kPa)\tT(K)\ta(m/s)\tμ(μPa·s)")
println("------\t--------\t------\t-----\t------\t--------")

for alt in altitudes
    density, pressure, temperature, asound, viscosity = atmosphere_properties_at(alt)
    
    println("$(alt)\t$(round(density, digits=3))\t\t$(round(pressure/1000, digits=1))\t$(round(temperature, digits=1))\t$(round(asound, digits=1))\t$(round(viscosity*1e6, digits=1))")
end
```

### Rocket Launch Analysis

Analyze atmospheric conditions during rocket ascent:

```julia
println("Rocket Ascent Atmospheric Analysis:")
println("Alt(km)\tρ(kg/m³)\tDrag∝ρ\tq∝ρV²(rel)")
println("------\t--------\t------\t-----------")

# Assume constant velocity for simplification
V_rocket = 500  # m/s (approximate)

for alt in 0:5:30
    rho, p, T, a, mu = atmosphere_properties_at(alt)
    
    # Relative density and dynamic pressure
    rho0, _, _, _, _ = atmosphere_properties_at(0.0)
    rho_rel = rho / rho0
    q_rel = rho_rel  # Assuming constant velocity
    
    println("$(alt)\t$(round(rho, digits=4))\t\t$(round(rho_rel, digits=3))\t$(round(q_rel, digits=3))")
end
```

### Wind Tunnel Corrections

Calculate air properties for wind tunnel testing:

```julia
# Wind tunnel facility analysis
test_conditions = [
    ("Sea Level", 0.0),
    ("Denver", 1.609),      # 5,280 ft
    ("High Altitude", 4.0)
]

println("Wind Tunnel Facility Conditions:")
println("Location\tAlt(km)\tρ(kg/m³)\tp(kPa)\tRe correction")
println("--------\t------\t--------\t------\t-------------")

# Reference: sea level
rho_ref, p_ref, T_ref, a_ref, mu_ref = atmosphere_properties_at(0.0)

for (location, alt) in test_conditions
    rho, p, T, a, mu = atmosphere_properties_at(alt)
    
    # Reynolds number correction factor
    Re_correction = (rho/rho_ref) * (mu_ref/mu)
    
    println("$location\t$(alt)\t$(round(rho, digits=3))\t\t$(round(p/1000, digits=1))\t$(round(Re_correction, digits=3))")
end
```

### Supersonic Aircraft Analysis

Analyze conditions for supersonic flight:

```julia
# Concorde-type aircraft analysis
cruise_alts = [16.0, 18.0, 20.0]  # km
cruise_mach = 2.0

println("Supersonic Cruise Analysis:")
println("Alt(km)\tT(K)\ta(m/s)\tV(m/s)\tρ(kg/m³)\tRe/m(×10⁶)")
println("------\t-----\t------\t------\t--------\t----------")

for alt in cruise_alts
    rho, p, T, a, mu = atmosphere_properties_at(alt)
    
    V_cruise = cruise_mach * a
    Re_per_m = rho * V_cruise / mu
    
    println("$(alt)\t$(round(T, digits=1))\t$(round(a, digits=1))\t$(round(V_cruise, digits=1))\t$(round(rho, digits=3))\t\t$(round(Re_per_m/1e6, digits=2))")
end
```

## Validation Examples

### Standard Atmosphere Verification

Compare with known atmospheric data:

```julia
# Validate against standard atmosphere tables
validation_points = [
    (0.0, 1.2250, 101325, 288.15),      # Sea level
    (11.0, 0.3639, 22632, 216.65),     # Tropopause
    (20.0, 0.0880, 5474.9, 216.65),    # Lower stratosphere
]

println("Model Validation:")
println("Alt(km)\tParameter\tCalculated\tStandard\tError(%)")
println("------\t---------\t----------\t--------\t-------")

for (alt, rho_std, p_std, T_std) in validation_points
    rho_calc, p_calc, T_calc, _, _ = atmosphere_properties_at(alt)
    
    rho_error = abs(rho_calc - rho_std) / rho_std * 100
    p_error = abs(p_calc - p_std) / p_std * 100
    T_error = abs(T_calc - T_std) / T_std * 100
    
    println("$(alt)\tDensity\t\t$(round(rho_calc, digits=4))\t\t$(rho_std)\t$(round(rho_error, digits=3))")
    println("$(alt)\tPressure\t$(round(p_calc, digits=1))\t$(p_std)\t$(round(p_error, digits=3))")
    println("$(alt)\tTemperature\t$(round(T_calc, digits=2))\t\t$(T_std)\t$(round(T_error, digits=3))")
    println()
end
```

### Altitude Conversion Verification

Verify geopotential altitude conversions:

```julia
println("Altitude Conversion Verification:")
println("Geometric(km)\tGeopotential(km)\tDifference(m)")
println("------------\t---------------\t-------------")

for h_geom in [0, 10, 20, 30, 50, 80]
    h_geop = geometric_to_geopotential_altitude(h_geom)
    h_back = geopotential_to_geometric_altitude(h_geop)
    difference = (h_geom - h_geop) * 1000  # Convert to meters
    error = abs(h_back - h_geom)
    
    println("$(h_geom)\t\t$(round(h_geop, digits=3))\t\t$(round(difference, digits=1))")
    println("Round-trip error: $(round(error*1000, digits=3)) m")
end
```

### Viscosity Temperature Dependence

Analyze viscosity variation with temperature:

```julia
println("Viscosity Analysis:")
println("T(K)\tμ(μPa·s)\tμ/μ₀")
println("----\t--------\t----")

# Reference viscosity at 288.15 K
mu_ref = sutherland_viscosity(288.15)

temperatures = [200, 250, 288.15, 300, 400, 500]

for T in temperatures
    mu = sutherland_viscosity(T)
    mu_ratio = mu / mu_ref
    
    println("$(T)\t$(round(mu*1e6, digits=1))\t\t$(round(mu_ratio, digits=3))")
end
```

## Atmospheric Density Scale Height

Calculate density scale height in different layers:

```julia
# Scale height analysis
altitudes = [0.0, 5.0, 11.0, 15.0, 20.0]

println("Atmospheric Scale Height Analysis:")
println("Alt Range(km)\tρ₁(kg/m³)\tρ₂(kg/m³)\tH(km)")
println("------------\t---------\t---------\t-----")

for i in 1:length(altitudes)-1
    alt1 = altitudes[i]
    alt2 = altitudes[i+1]
    
    rho1, _, _, _, _ = atmosphere_properties_at(alt1)
    rho2, _, _, _, _ = atmosphere_properties_at(alt2)
    
    # Calculate scale height: H = Δh / ln(ρ₁/ρ₂)
    delta_h = alt2 - alt1
    scale_height = delta_h / log(rho1/rho2)
    
    println("$(alt1)-$(alt2)\t\t$(round(rho1, digits=3))\t\t$(round(rho2, digits=3))\t\t$(round(scale_height, digits=1))")
end
```

## Different Units and Conversions

Working with different unit systems:

```julia
# Convert to different units
alt_ft = 36000  # feet
alt_km = alt_ft * 0.0003048  # Convert to km

rho, p, T, a, mu = atmosphere_properties_at(alt_km)

# Convert to imperial units
rho_slugft3 = rho / 515.379  # kg/m³ to slug/ft³
p_lbft2 = p / 47.88  # Pa to lb/ft²
T_F = T * 9/5 - 459.67  # K to °F
a_fts = a * 3.28084  # m/s to ft/s

println("Atmospheric Properties at $(alt_ft) ft:")
println("Metric Units:")
println("  Density: $(round(rho, digits=4)) kg/m³")
println("  Pressure: $(round(p, digits=1)) Pa")
println("  Temperature: $(round(T, digits=1)) K")
println("  Speed of sound: $(round(a, digits=1)) m/s")

println("\nImperial Units:")
println("  Density: $(round(rho_slugft3, digits=6)) slug/ft³")
println("  Pressure: $(round(p_lbft2, digits=1)) lb/ft²")
println("  Temperature: $(round(T_F, digits=1)) °F")
println("  Speed of sound: $(round(a_fts, digits=1)) ft/s")
```

## Limitations and Considerations

1. **Altitude Range**: Valid up to approximately 86 km altitude
2. **Standard Conditions**: Represents average mid-latitude conditions
3. **Seasonal Variations**: Does not account for seasonal or geographical variations
4. **Weather Effects**: Does not include local weather phenomena
5. **Composition**: Assumes constant gas composition with altitude
6. **Real Atmosphere**: Actual conditions may vary significantly from the model

For precise applications requiring local atmospheric data, meteorological measurements should be used instead of or in addition to the standard atmosphere model.

## See Also

- [Isentropic Relations](isentropic.md): For flow property calculations
- [Normal Shock Waves](normal_shock.md): For shock wave analysis in atmospheric conditions
- [Nozzle Analysis](nozzle.md): For propulsion system analysis at altitude
