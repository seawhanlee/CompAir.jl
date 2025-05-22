module CompAir

# Write your package code here.

include("atmos1976.jl")
include("cone_shock.jl")
include("isentropic.jl")
include("normal_shock.jl")
include("nozzle.jl")
include("oblique_shock.jl")
include("prandtl_expand.jl")

export t0_over_t, p0_over_p, rho0_over_rho
export normal_mach2, rho2_over_rho1, p2_over_p1, t2_over_t1, normal_p02, p02_over_p01, solve_normal
export theta_beta, oblique_beta_weak, theta_max, Mn1, oblique_mach2, solve_oblique
export prandtl_meyer, expand_mach2, expand_p2, theta_p
export theta_eff, cone_beta_weak, cone_mach2, cone_mach_surface, solve_shock, solve_cone_properties
export mdot, area_ratio_at, mach_by_area_ratio, me6, pe6, me5, pe5
export atmos1976_at

end
