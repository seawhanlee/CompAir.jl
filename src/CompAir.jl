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
include("deprecated.jl")

export t0_over_t, p0_over_p, rho0_over_rho
export ns_mach2, ns_rho2_over_rho1, ns_p2_over_p1, ns_t2_over_t1, ns_p02, ns_p02_over_p01, solve_normal
export theta_from_beta, beta_from_theta, theta_max, mn1, os_mach2, solve_oblique
export prandtl_meyer, pm_mach2, pm_p1_over_p2, pm_theta_from_pratio
export cone_theta_eff, cone_beta, cone_mach2, cone_mach_surface, solve_cone, solve_cone_properties
export mdot, a_over_astar, mach_from_area_ratio, subsonic_mach_from_area_ratio, subsonic_pressure_from_area_ratio, mach_after_exit_shock, pressure_after_exit_shock
export atmos, geo_to_geopot, geopot_to_geo, sutherland_viscosity
export intake_ramp

# Deprecated names (still exported for backward compatibility)
export total_to_static_temperature_ratio, total_to_static_pressure_ratio, total_to_static_density_ratio
export mach_after_normal_shock, density_ratio_normal_shock, pressure_ratio_normal_shock, temperature_ratio_normal_shock, total_pressure_after_normal_shock, total_pressure_ratio_normal_shock
export theta_beta, oblique_beta_weak, Mn1, oblique_mach2
export expand_mach2, expand_p2, theta_p
export theta_eff, cone_beta_weak, solve_shock
export area_ratio_at, mach_by_area_ratio, mach_after_shock_at_exit, pressure_after_shock_at_exit
export atmosphere_properties_at, geometric_to_geopotential_altitude, geopotential_to_geometric_altitude

end
