# Test cases for Prandtl-Meyer expansion calculations
# Reference values from NACA Report 1135

@testset "Prandtl-Meyer Expansion Tests" begin
    # Test Prandtl-Meyer angle calculation
    @test isapprox(CompAir.prandtl_meyer(2.0), 26.38, rtol=1e-2)
    @test isapprox(CompAir.prandtl_meyer(3.0), 49.76, rtol=1e-2)
    
    # Test Mach number from Prandtl-Meyer angle
    @test isapprox(CompAir.expand_mach2(1.0, 26.38), 2.0, rtol=1e-3)
    @test isapprox(CompAir.expand_mach2(1.0, 49.76), 3.0, rtol=1e-3)
    
    # Test pressure ratio across expansion
    @test isapprox(CompAir.expand_p2(2.0, 3.0), 0.1278, rtol=1e-3)
    @test isapprox(CompAir.expand_p2(1.5, 2.0), 0.2724, rtol=1e-3)
    
    # Test temperature ratio across expansion
    @test isapprox(CompAir.t0_over_t(2.0) / CompAir.t0_over_t(3.0), 0.5556, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(1.5) / CompAir.t0_over_t(2.0), 0.6897, rtol=1e-3)
end 