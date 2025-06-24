function intake_ramp(M_infty::Real, ramp_angle::Vector{Real}, gamma=1.4)
    n = length(ramp_angle)
    mach_number = zeros(n+1)
    mach_number[1] = M_infty

    for i in 1:n
        M = mach_number[i]
        theta = ramp_angle[i]
        sol = solve_oblique(M, theta, gamma)
        mach_number[i+1] = sol.M2
    end
    
end