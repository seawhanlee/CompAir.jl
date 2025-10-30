module CompAir

# Write your package code here.

include("atmos1976.jl")
include("cone_shock.jl")
include("isentropic.jl")
include("normal_shock.jl")
include("nozzle.jl")
include("oblique_shock.jl")
include("prandtl_expand.jl")
include("intake.jl")

export total_to_static_temperature_ratio, total_to_static_pressure_ratio, total_to_static_density_ratio
export mach_after_normal_shock, density_ratio_normal_shock, pressure_ratio_normal_shock, temperature_ratio_normal_shock, total_pressure_after_normal_shock, total_pressure_ratio_normal_shock, solve_normal
export theta_beta, oblique_beta_weak, theta_max, Mn1, oblique_mach2, solve_oblique
export prandtl_meyer, expand_mach2, expand_p2, theta_p
export theta_eff, cone_beta_weak, cone_mach2, cone_mach_surface, solve_shock, solve_cone_properties
export mdot, area_ratio_at, mach_by_area_ratio, subsonic_mach_from_area_ratio, subsonic_pressure_from_area_ratio, mach_after_shock_at_exit, pressure_after_shock_at_exit
export atmosphere_properties_at, geometric_to_geopotential_altitude, geopotential_to_geometric_altitude, sutherland_viscosity
export intake_ramp

end
