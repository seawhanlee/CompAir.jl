# Test cases for nozzle flow calculations
# Reference values from NACA Report 1135

@testset "Nozzle Flow Tests" begin
    # Test critical area ratio
    @test isapprox(CompAir.area_ratio_at(1.0), 1.0, rtol=1e-3)
    
    # Test mass flow rate calculation
    @test isapprox(CompAir.mdot(1.0, 0.01, 101325.0, 288.15, 287.0), 0.241, rtol=1e-3)
    @test isapprox(CompAir.mdot(2.0, 0.01, 101325.0, 288.15, 287.0), 0.241, rtol=1e-3)
    
    # Test exit pressure calculation
    @test isapprox(CompAir.pe6(2.0), 12780.0, rtol=1e-3)
    @test isapprox(CompAir.pe6(3.0), 2750.0, rtol=1e-3)
    
    # Test exit temperature calculation
    @test isapprox(CompAir.t0_over_t(2.0) * 288.15, 160.0, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(3.0) * 288.15, 103.0, rtol=1e-3)
end 