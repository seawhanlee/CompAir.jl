function intake_ramp(M_infty::Real, ramp_angle::Vector{<:Real}, gamma=1.4)
    n = length(ramp_angle)
    mach_number = zeros(n+1)
    rho, p, p0ratio, beta = zeros(n), zeros(n), zeros(n), zeros(n)

    mach_number[1] = M_infty

    for i in 1:n
        M = mach_number[i]
        theta = ramp_angle[i]
        sol = solve_oblique(M, theta, gamma)
        mach_number[i+1] = sol.M2
        rho[i] = sol.rho2_ratio
        p[i] = sol.p2_ratio
        p0ratio[i] = sol.p0_ratio
        beta[i] = sol.beta
    end
    
    return (M=mach_number, rho2_ratio=rho, p2_ratio=p, p0_ratio=p0ratio, beta=beta)

end