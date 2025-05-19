# Test cases for oblique shock calculations
# Reference values from NACA Report 1135

@testset "Oblique Shock Tests" begin
    # Test shock angle calculation
    @test isapprox(CompAir.oblique_beta_weak(2.0, 20.0), 53.4, rtol=1e-1)
    @test isapprox(CompAir.oblique_beta_weak(3.0, 20.0), 37.8, rtol=1e-1)
    
    # Test deflection angle calculation
    @test isapprox(CompAir.theta_beta(53.4, 2.0), 20.0, rtol=1e-1)
    @test isapprox(CompAir.theta_beta(37.8, 3.0), 20.0, rtol=1e-1)
    
    # Test pressure ratio across shock
    @test isapprox(CompAir.p2_over_p1(CompAir.Mn1(2.0, 53.4)), 2.842, rtol=1e-3)
    @test isapprox(CompAir.p2_over_p1(CompAir.Mn1(3.0, 37.8)), 2.820, rtol=1e-3)
    
    # Test temperature ratio across shock
    @test isapprox(CompAir.t2_over_t1(CompAir.Mn1(2.0, 53.4)), 1.473, rtol=1e-3)
    @test isapprox(CompAir.t2_over_t1(CompAir.Mn1(3.0, 37.8)), 1.470, rtol=1e-3)
    
    # Test downstream Mach number
    @test isapprox(CompAir.oblique_mach2(2.0, 20.0), 1.210, rtol=1e-3)
    @test isapprox(CompAir.oblique_mach2(3.0, 20.0), 2.207, rtol=1e-3)
end 