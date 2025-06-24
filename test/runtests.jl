using CompAir
using Test

@testset "CompAir.jl" begin
    @testset "Isentropic Flow" begin
        include("isentropic_tests.jl")
    end

    @testset "Normal Shock" begin
        include("normal_shock_tests.jl")
    end

    @testset "Oblique Shock" begin
        include("oblique_shock_tests.jl")
    end

    @testset "Prandtl-Meyer Expansion" begin
        include("prandtl_expand_tests.jl")
    end

    @testset "Cone Shock" begin
        include("cone_shock_tests.jl")
    end

    @testset "Nozzle Flow" begin
        include("nozzle_tests.jl")
    end

    @testset "US Standard Atmosphere 1976" begin
        include("atmos1976_tests.jl")
    end

    @testset "Intake" begin
        include("intake_test.jl")
    end
end
