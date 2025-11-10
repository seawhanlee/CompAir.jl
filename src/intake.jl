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
    num_stages = length(ramp_angle)
    mach_number = zeros(num_stages+1)
    density_ratio, pressure_ratio, total_pressure_ratio, shock_angle = zeros(num_stages), zeros(num_stages), zeros(num_stages), zeros(num_stages)

    mach_number[1] = M_infty

    for stage_index in 1:num_stages
        upstream_mach = mach_number[stage_index]
        deflection_angle = ramp_angle[stage_index]
        shock_solution = solve_oblique(upstream_mach, deflection_angle, gamma)
        mach_number[stage_index+1] = shock_solution.M2
        density_ratio[stage_index] = shock_solution.rho2_ratio
        pressure_ratio[stage_index] = shock_solution.p2_ratio
        total_pressure_ratio[stage_index] = shock_solution.p0_ratio
        shock_angle[stage_index] = shock_solution.beta
    end
    
    return (M=mach_number, rho2_ratio=density_ratio, p2_ratio=pressure_ratio, p0_ratio=total_pressure_ratio, beta=shock_angle)

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

