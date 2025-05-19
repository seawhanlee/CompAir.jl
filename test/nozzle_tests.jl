# Test cases for nozzle flow calculations
# Reference values from NACA Report 1135

@testset "Nozzle Flow Tests" begin
    # Test critical area ratio
    @test isapprox(CompAir.critical_area_ratio(1.4), 1.0, rtol=1e-3)
    
    # Test mass flow rate calculation
    @test isapprox(CompAir.mass_flow_rate(1.4, 101325.0, 288.15, 0.01, 1.0), 0.241, rtol=1e-3)
    @test isapprox(CompAir.mass_flow_rate(1.4, 101325.0, 288.15, 0.01, 2.0), 0.241, rtol=1e-3)
    
    # Test thrust calculation
    @test isapprox(CompAir.nozzle_thrust(1.4, 101325.0, 288.15, 0.01, 2.0, 101325.0), 241.0, rtol=1e-3)
    @test isapprox(CompAir.nozzle_thrust(1.4, 101325.0, 288.15, 0.01, 3.0, 101325.0), 241.0, rtol=1e-3)
    
    # Test exit pressure calculation
    @test isapprox(CompAir.exit_pressure(1.4, 101325.0, 2.0), 12780.0, rtol=1e-3)
    @test isapprox(CompAir.exit_pressure(1.4, 101325.0, 3.0), 2750.0, rtol=1e-3)
    
    # Test exit temperature calculation
    @test isapprox(CompAir.exit_temperature(1.4, 288.15, 2.0), 160.0, rtol=1e-3)
    @test isapprox(CompAir.exit_temperature(1.4, 288.15, 3.0), 103.0, rtol=1e-3)
end 