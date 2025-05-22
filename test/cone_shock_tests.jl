# Test cases for cone shock calculations
# Reference values from NACA Report 1135

@testset "theta_eff" begin
    @test isapprox(CompAir.theta_eff(2, 20), 8.5704, rtol=1e-3)
    @test isapprox(CompAir.theta_eff(3, 20), 12.3773, rtol=1e-3)
end

@testset "cone_beta_weak" begin
    # Test cone shock angle calculation
    @test isapprox(CompAir.cone_beta_weak(2.0, 20.0), 37.7955, rtol=1e-3)
    @test isapprox(CompAir.cone_beta_weak(3.0, 20.0), 29.6146, rtol=1e-3)
end

@testset "cone_mach2" begin
    @test isapprox(CompAir.cone_mach2(2.0, 10), 1.9470, rtol=1e-3)
    @test isapprox(CompAir.cone_mach2(3.0, 20), 2.38715, rtol=1e-3)
end

@testset "cone_mach_surface" begin
    # Test surface Mach number
    @test isapprox(CompAir.cone_mach_surface(2.0, 20.0)[1], 1.5677, rtol=1e-3)
    @test isapprox(CompAir.cone_mach_surface(3.0, 20.0)[1], 2.2899, rtol=1e-3)
end

@testset "solve_shock" begin

    M2_1, rho2_1, p2_1, p0ratio_1, beta_1 = CompAir.solve_shock(2, 10)
    @test isapprox(M2_1, 1.9469, rtol=1e-3)
    @test isapprox(rho2_1, 1.0605, rtol=1e-3)
    @test isapprox(p2_1, 1.0857, rtol=1e-3)
    @test isapprox(p0ratio_1, 0.9999, rtol=1e-3)
    @test isapprox(beta_1, 31.2018, rtol=1e-3)

    M2_2, rho2_2, p2_2, p0ratio_2, beta_2 = CompAir.solve_shock(3, 20)
    @test isapprox(M2_2, 2.3871, rtol=1e-3)
    @test isapprox(rho2_2, 1.8320, rtol=1e-3)
    @test isapprox(p2_2, 2.3973, rtol=1e-3)
    @test isapprox(p0ratio_2, 0.9352, rtol=1e-3)
    @test isapprox(beta_2, 29.6145, rtol=1e-3)
end

@testset "solve_cone_properties" begin
    # Test solve_cone_properties function for different scenarios
    # Expected values might need adjustment based on NACA Report 1135 or other reliable sources

    # Scenario 1: psi = nothing (simulates former solve_cone_theta)
    # Case 1.1: M=2.0, angle=20.0
    mc1_nothing, rhoc1_nothing, pc1_nothing, p0ratio1_nothing, beta1_nothing = CompAir.solve_cone_properties(2.0, 20.0)
    @test isapprox(mc1_nothing, 1.5677, rtol=1e-3)
    @test isapprox(rhoc1_nothing, 1.5839, rtol=1e-3)
    @test isapprox(pc1_nothing, 1.911, rtol=1e-3)
    @test isapprox(p0ratio1_nothing, 0.9900, rtol=1e-3)
    @test isapprox(beta1_nothing, 37.7955, rtol=1e-3)

    # Case 1.2: M=3.0, angle=20.0
    mc2_nothing, rhoc2_nothing, pc2_nothing, p0ratio2_nothing, beta2_nothing = CompAir.solve_cone_properties(3.0, 20.0)
    @test isapprox(mc2_nothing, 2.2899, rtol=1e-3)
    @test isapprox(rhoc2_nothing, 2.0421, rtol=1e-3)
    @test isapprox(pc2_nothing, 2.7909, rtol=1e-3)
    @test isapprox(p0ratio2_nothing, 0.9352, rtol=1e-3)
    @test isapprox(beta2_nothing, 29.6146, rtol=1e-3)

    # Scenario 2: psi provided (simulates former solve_cone_theta_phi)
    # Case 2.1: M=2.0, angle=20.0, psi=20.0 (should match Case 1.1 for common values)
    mc1_psi, rhoc1_psi, pc1_psi, p0ratio1_psi, beta1_psi, phi1_psi = CompAir.solve_cone_properties(2.0, 20.0, psi=20.0)
    @test isapprox(mc1_psi, 1.56774409414854, rtol=1e-3)
    @test isapprox(rhoc1_psi, 1.5839802754135424, rtol=1e-3)
    @test isapprox(pc1_psi, 1.9115263610431983, rtol=1e-3)
    @test isapprox(p0ratio1_psi, 0.9900872397064464, rtol=1e-3)
    @test isapprox(beta1_psi, 37.79553038467216, rtol=1e-3)
    @test isapprox(phi1_psi, 20.0, rtol=1e-3) # Flow direction at surface for psi = angle

    # Case 2.2: M=3.0, angle=20.0, psi=15.0
    mc2_psi, rhoc2_psi, pc2_psi, p0ratio2_psi, beta2_psi, phi2_psi = CompAir.solve_cone_properties(3.0, 20.0, psi=15.0)
    @test isapprox(mc2_psi, 2.358631156526412, rtol=1e-3)
    @test isapprox(rhoc2_psi, 1.891303415720342, rtol=1e-3)
    @test isapprox(pc2_psi, 2.5066642572688926, rtol=1e-3)
    @test isapprox(p0ratio2_psi, 0.9352415717129382, rtol=1e-3)
    @test isapprox(beta2_psi, 29.614552206867266, rtol=1e-3)
    @test isapprox(phi2_psi, 27.19117598207076, rtol=1e-3)
end



