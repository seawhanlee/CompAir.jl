# Test cases for Prandtl-Meyer expansion calculations
# Reference values from NACA Report 1135

@testset "Prandtl-Meyer Expansion Tests" begin
    # Test Prandtl-Meyer angle calculation
    @test isapprox(CompAir.prandtl_meyer_angle(1.4, 2.0), 26.38, rtol=1e-2)
    @test isapprox(CompAir.prandtl_meyer_angle(1.4, 3.0), 49.76, rtol=1e-2)
    
    # Test Mach number from Prandtl-Meyer angle
    @test isapprox(CompAir.mach_from_prandtl_meyer(1.4, 26.38), 2.0, rtol=1e-3)
    @test isapprox(CompAir.mach_from_prandtl_meyer(1.4, 49.76), 3.0, rtol=1e-3)
    
    # Test pressure ratio across expansion
    @test isapprox(CompAir.expansion_pressure_ratio(1.4, 2.0, 3.0), 0.1278, rtol=1e-3)
    @test isapprox(CompAir.expansion_pressure_ratio(1.4, 1.5, 2.0), 0.2724, rtol=1e-3)
    
    # Test temperature ratio across expansion
    @test isapprox(CompAir.expansion_temperature_ratio(1.4, 2.0, 3.0), 0.5556, rtol=1e-3)
    @test isapprox(CompAir.expansion_temperature_ratio(1.4, 1.5, 2.0), 0.6897, rtol=1e-3)
end 