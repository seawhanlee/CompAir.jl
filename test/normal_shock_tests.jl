# Test cases for normal shock calculations
# Reference values from NACA Report 1135

@testset "Normal Shock Tests" begin
    # Test pressure ratio across shock
    @test isapprox(CompAir.shock_pressure_ratio(1.4, 2.0), 4.500, rtol=1e-3)
    @test isapprox(CompAir.shock_pressure_ratio(1.4, 3.0), 10.333, rtol=1e-3)
    
    # Test temperature ratio across shock
    @test isapprox(CompAir.shock_temperature_ratio(1.4, 2.0), 1.687, rtol=1e-3)
    @test isapprox(CompAir.shock_temperature_ratio(1.4, 3.0), 2.679, rtol=1e-3)
    
    # Test density ratio across shock
    @test isapprox(CompAir.shock_density_ratio(1.4, 2.0), 2.667, rtol=1e-3)
    @test isapprox(CompAir.shock_density_ratio(1.4, 3.0), 3.857, rtol=1e-3)
    
    # Test downstream Mach number
    @test isapprox(CompAir.shock_downstream_mach(1.4, 2.0), 0.577, rtol=1e-3)
    @test isapprox(CompAir.shock_downstream_mach(1.4, 3.0), 0.475, rtol=1e-3)
    
    # Test total pressure ratio across shock
    @test isapprox(CompAir.shock_total_pressure_ratio(1.4, 2.0), 0.721, rtol=1e-3)
    @test isapprox(CompAir.shock_total_pressure_ratio(1.4, 3.0), 0.328, rtol=1e-3)
end 