# Test cases for Prandtl-Meyer expansion calculations
# Reference values from NACA Report 1135

@testset "prandtl_meyer" begin
    # Test Prandtl-Meyer angle calculation
    @test isapprox(CompAir.prandtl_meyer(2.0), 26.38, rtol=1e-2)
    @test isapprox(CompAir.prandtl_meyer(3.0), 49.76, rtol=1e-2)
end

@testset "pm_mach2" begin
    # Test Mach number from Prandtl-Meyer angle
    @test isapprox(CompAir.pm_mach2(1.0, 26.38), 2.0, rtol=1e-3)
    @test isapprox(CompAir.pm_mach2(1.0, 49.76), 3.0, rtol=1e-3)
end

@testset "pm_p1_over_p2" begin
    # Test pressure ratio across expansion
    @test isapprox(CompAir.pm_p1_over_p2(2.0, 3.0), 0.8416, rtol=1e-3)
    @test isapprox(CompAir.pm_p1_over_p2(1.5, 2.0), 0.9059, rtol=1e-3)
end

@testset "pm_theta_from_pratio" begin
    @test isapprox(CompAir.pm_theta_from_pratio(0.455, 2), 12.8406, rtol=1e-3)
    @test isapprox(CompAir.pm_theta_from_pratio(0.832, 3), 2.3240, rtol=1e-3)
end