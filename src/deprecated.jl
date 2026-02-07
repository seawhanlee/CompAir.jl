# Deprecated function names — backward compatibility aliases
# These will emit a deprecation warning when called.

# Isentropic relations
@deprecate total_to_static_temperature_ratio(M, gamma=1.4) t0_over_t(M, gamma)
@deprecate total_to_static_pressure_ratio(M, gamma=1.4) p0_over_p(M, gamma)
@deprecate total_to_static_density_ratio(M, gamma=1.4) rho0_over_rho(M, gamma)

# Normal shock
@deprecate mach_after_normal_shock(M, gamma=1.4) ns_mach2(M, gamma)
@deprecate density_ratio_normal_shock(M, gamma=1.4) ns_rho2_over_rho1(M, gamma)
@deprecate pressure_ratio_normal_shock(M, gamma=1.4) ns_p2_over_p1(M, gamma)
@deprecate temperature_ratio_normal_shock(M, gamma=1.4) ns_t2_over_t1(M, gamma)
@deprecate total_pressure_after_normal_shock(M, gamma=1.4) ns_p02(M, gamma)
@deprecate total_pressure_ratio_normal_shock(M, gamma=1.4) ns_p02_over_p01(M, gamma)

# Oblique shock
@deprecate theta_beta(beta, M, gamma=1.4) theta_from_beta(beta, M, gamma)
@deprecate oblique_beta_weak(M, theta, gamma=1.4) beta_from_theta(M, theta, gamma)
@deprecate Mn1(M, theta, gamma=1.4) mn1(M, theta, gamma)
@deprecate oblique_mach2(M, theta, gamma=1.4) os_mach2(M, theta, gamma)

# Prandtl-Meyer expansion
@deprecate expand_mach2(M1, theta, gamma=1.4) pm_mach2(M1, theta, gamma)
@deprecate expand_p2(M1, theta, gamma=1.4) pm_p1_over_p2(M1, theta, gamma)
@deprecate theta_p(pratio, M1, gamma=1.4) pm_theta_from_pratio(pratio, M1, gamma)

# Cone shock
@deprecate theta_eff(M, angle, gamma=1.4) cone_theta_eff(M, angle, gamma)
@deprecate cone_beta_weak(M, angle, gamma=1.4) cone_beta(M, angle, gamma)
@deprecate solve_shock(M, angle, gamma=1.4) solve_cone(M, angle, gamma)

# Nozzle
@deprecate area_ratio_at(M, gamma=1.4) a_over_astar(M, gamma)
@deprecate mach_by_area_ratio(area, gamma=1.4, x0=0.1) mach_from_area_ratio(area, gamma, x0)
@deprecate mach_after_shock_at_exit(area, gamma=1.4) mach_after_exit_shock(area, gamma)
@deprecate pressure_after_shock_at_exit(area, gamma=1.4, p0=1) pressure_after_exit_shock(area, gamma, p0)

# Atmosphere
@deprecate atmosphere_properties_at(alt) atmos(alt)
@deprecate geometric_to_geopotential_altitude(alt, rearth=6369.0) geo_to_geopot(alt, rearth)
@deprecate geopotential_to_geometric_altitude(alt, rearth=6369.0) geopot_to_geo(alt, rearth)
