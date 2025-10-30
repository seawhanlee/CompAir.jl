# Test cases for normal shock calculations

@testset "Normal Shock Tests" begin
    @testset "mach_after_normal_shock" begin
        # Test downstream Mach number
        @test isapprox(CompAir.mach_after_normal_shock(2.0), 0.577, rtol=1e-3)
        @test isapprox(CompAir.mach_after_normal_shock(3.0), 0.475, rtol=1e-3)
    end

    @testset "density_ratio_normal_shock" begin
        # Test density ratio across shock
        @test isapprox(CompAir.density_ratio_normal_shock(2.0), 2.667, rtol=1e-3)
        @test isapprox(CompAir.density_ratio_normal_shock(3.0), 3.857, rtol=1e-3)
    end
    
    @testset "pressure_ratio_normal_shock" begin
        # Test pressure ratio across shock
        @test isapprox(CompAir.pressure_ratio_normal_shock(2.0), 4.500, rtol=1e-3)
        @test isapprox(CompAir.pressure_ratio_normal_shock(3.0), 10.333, rtol=1e-3)
    end
    
    @testset "temperature_ratio_normal_shock" begin
        # Test temperature ratio across shock
        @test isapprox(CompAir.temperature_ratio_normal_shock(2.0), 1.687, rtol=1e-3)
        @test isapprox(CompAir.temperature_ratio_normal_shock(3.0), 2.679, rtol=1e-3)
    end
    
    @testset "total_pressure_ratio_normal_shock" begin
        # Test total pressure ratio across shock
        @test isapprox(CompAir.total_pressure_ratio_normal_shock(2.0), 0.721, rtol=1e-3)
        @test isapprox(CompAir.total_pressure_ratio_normal_shock(3.0), 0.3283, rtol=1e-3)
    end

    @testset "solve_normal" begin
        # Test solve_normal function
        sol = CompAir.solve_normal(2.0)
        @test isapprox(sol.M2, 0.577, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 2.667, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 4.500, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.7209, rtol=1e-3)
    end
end