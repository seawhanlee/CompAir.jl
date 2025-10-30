"""
    _intake_ramp(M_infty::Float64, ramp_angle::Vector{Float64}, gamma::Float64=1.4)

Internal function to calculate the Mach number, density ratio, pressure ratio, total pressure ratio,
and shock angle at each stage of a multi-stage ramp intake for given ramp angles, freestream Mach number,
and specific heat ratio.

# Arguments
- `M_infty::Float64`: Freestream (inlet) Mach number
- `ramp_angle::Vector{Float64}`: Ramp angles for each stage (degrees)
- `gamma::Float64=1.4`: Specific heat ratio

# Returns
A `NamedTuple` containing:
- `M`: Vector of Mach numbers at each stage (length n+1)
- `rho2_ratio`: Vector of density ratios at each stage (length n)
- `p2_ratio`: Vector of pressure ratios at each stage (length n)
- `p0_ratio`: Vector of total pressure ratios at each stage (length n)
- `beta`: Vector of shock angles at each stage (length n)
"""
function _intake_ramp(M_infty::Float64, ramp_angle::Vector{Float64}, gamma::Float64=1.4)
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

"""
    intake_ramp(M_infty::Real, ramp_angle::Vector{<:Real}, gamma::Real=1.4)

Calculates the Mach number, density ratio, pressure ratio, total pressure ratio,
and shock angle at each stage of a multi-stage ramp intake for given ramp angles,
freestream Mach number, and specific heat ratio.

# Arguments
- `M_infty::Real`: Freestream (inlet) Mach number
- `ramp_angle::Vector{<:Real}`: Ramp angles for each stage (degrees)
- `gamma::Real=1.4`: Specific heat ratio

# Returns
A `NamedTuple` containing:
- `M`: Vector of Mach numbers at each stage (length n+1, where n is the number of ramps)
- `rho2_ratio`: Vector of density ratios at each stage (length n)
- `p2_ratio`: Vector of pressure ratios at each stage (length n)
- `p0_ratio`: Vector of total pressure ratios at each stage (length n)
- `beta`: Vector of shock angles at each stage (length n, degrees)
"""
function intake_ramp(M_infty::Real, ramp_angle::Vector{<:Real}, gamma::Real=1.4)
    return _intake_ramp(Float64(M_infty), Float64.(ramp_angle), Float64(gamma))
end

