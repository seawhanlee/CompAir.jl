# Test cases for oblique shock calculations
# Reference values from NACA Report 1135

@testset "Oblique Shock Tests" begin
    # Test deflection angle calculation for M=1.0
    @test isapprox(CompAir.theta_beta(30.0, 1.0), -33.670, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(40.0, 1.0), -21.375, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(50.0, 1.0), -12.129, rtol=1e-3)

    # Test deflection angle calculation for M=2.0
    @test isapprox(CompAir.theta_beta(30.0, 2.0), -0.000, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(40.0, 2.0), 10.623, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(50.0, 2.0), 18.130, rtol=1e-3)

    # Test deflection angle calculation for M=3.0
    @test isapprox(CompAir.theta_beta(30.0, 3.0), 12.774, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(40.0, 3.0), 21.846, rtol=1e-3)
    @test isapprox(CompAir.theta_beta(50.0, 3.0), 28.860, rtol=1e-3)

    # Test error conditions
    @test_throws DomainError CompAir.theta_beta(0.0, 1.0)  # beta = 0 is invalid
    @test_throws DomainError CompAir.theta_beta(90.0, 1.0)  # beta = 90 is invalid
    @test_throws DomainError CompAir.theta_beta(30.0, 0.0)  # M = 0 is invalid
    @test_throws DomainError CompAir.theta_beta(30.0, -1.0)  # M < 0 is invalid

    # Test shock angle calculation
    @test isapprox(CompAir.oblique_beta_weak(2.0, 20.0), 53.4, rtol=1e-1)
    @test isapprox(CompAir.oblique_beta_weak(3.0, 20.0), 37.8, rtol=1e-1)
    @test isapprox(CompAir.oblique_beta_weak(4.0, 20.0), 32.46, rtol=1e-1)
    @test isapprox(CompAir.oblique_beta_weak(5.0, 20.0), 29.80, rtol=1e-1)

    # Test max deflection angle
    @test isapprox(CompAir.theta_max(2.0), 22.97, rtol=1e-1)
    @test isapprox(CompAir.theta_max(3.0), 37.8, rtol=1e-1)
    
    # Test downstream Mach number
    @test isapprox(CompAir.oblique_mach2(2.0, 20.0), 1.210, rtol=1e-3)
    @test isapprox(CompAir.oblique_mach2(3.0, 20.0), 2.207, rtol=1e-3)
end 