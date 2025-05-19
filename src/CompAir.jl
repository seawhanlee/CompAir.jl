module CompAir

# Write your package code here.

include("atmos1976.jl")
include("cone_shock.jl")
include("isentropic.jl")
include("normal_shock.jl")
include("nozzle.jl")
include("oblique_shock.jl")
include("prandtl_expand.jl")

# Export main functions from each module
export atmos1976, cone_shock, isentropic, normal_shock, nozzle, oblique_shock, prandtl_expand

end
