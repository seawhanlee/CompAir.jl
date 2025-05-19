# Test cases for oblique shock calculations
# Reference values from NACA Report 1135

@testset "Oblique Shock Tests" begin
    # Test shock angle calculation
    @test isapprox(CompAir.shock_angle(1.4, 2.0, 20.0), 53.4, rtol=1e-1)
    @test isapprox(CompAir.shock_angle(1.4, 3.0, 20.0), 37.8, rtol=1e-1)
    
    # Test deflection angle calculation
    @test isapprox(CompAir.deflection_angle(1.4, 2.0, 53.4), 20.0, rtol=1e-1)
    @test isapprox(CompAir.deflection_angle(1.4, 3.0, 37.8), 20.0, rtol=1e-1)
    
    # Test pressure ratio across shock
    @test isapprox(CompAir.oblique_shock_pressure_ratio(1.4, 2.0, 53.4), 2.842, rtol=1e-3)
    @test isapprox(CompAir.oblique_shock_pressure_ratio(1.4, 3.0, 37.8), 2.820, rtol=1e-3)
    
    # Test temperature ratio across shock
    @test isapprox(CompAir.oblique_shock_temperature_ratio(1.4, 2.0, 53.4), 1.473, rtol=1e-3)
    @test isapprox(CompAir.oblique_shock_temperature_ratio(1.4, 3.0, 37.8), 1.470, rtol=1e-3)
    
    # Test downstream Mach number
    @test isapprox(CompAir.oblique_shock_downstream_mach(1.4, 2.0, 53.4), 1.210, rtol=1e-3)
    @test isapprox(CompAir.oblique_shock_downstream_mach(1.4, 3.0, 37.8), 2.207, rtol=1e-3)
end 