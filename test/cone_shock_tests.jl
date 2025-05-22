# Test cases for cone shock calculations
# Reference values from NACA Report 1135

@testset "theta_eff" begin
    @test isapprox(CompAir.theta_eff(2, 20), 8.5704, rtol=1e-4)
    @test isapprox(CompAir.theta_eff(3, 20), 12.3773, rtol=1e-4)
end

@testset "cone_beta_weak" begin
    # Test cone shock angle calculation
    @test isapprox(CompAir.cone_beta_weak(2.0, 20.0), 37.7955, rtol=1e-4)
    @test isapprox(CompAir.cone_beta_weak(3.0, 20.0), 29.6146, rtol=1e-4)
end

@testset "cone_mach2" begin
    @test isapprox(CompAir.cone_mach2(2.0, 10), 1.9470, rtol=1e-4)
    @test isapprox(CompAir.cone_mach2(3.0, 20), 2.38715, rtol=1e-4)
end

@testset "cone_mach_surface" begin
    # Test surface Mach number
    @test isapprox(CompAir.cone_mach_surface(2.0, 20.0)[1], 1.5677, rtol=1e-4)
    @test isapprox(CompAir.cone_mach_surface(3.0, 20.0)[1], 2.2899, rtol=1e-4)
end

@testset "solve_shock" begin

    M2_1, rho2_1, p2_1, p0ratio_1, beta_1 = CompAir.solve_shock(2, 10)
    @test isapprox(M2_1, 1.9469, rtol=1e-4)
    @test isapprox(rho2_1, 1.0605, rtol=1e-4)
    @test isapprox(p2_1, 1.0857, rtol=1e-4)
    @test isapprox(p0ratio_1, 0.9999, rtol=1e-4)
    @test isapprox(beta_1, 31.2018, rtol=1e-4)

    M2_2, rho2_2, p2_2, p0ratio_2, beta_2 = CompAir.solve_shock(3, 20)
    @test isapprox(M2_2, 2.3871, rtol=1e-4)
    @test isapprox(rho2_2, 1.8320, rtol=1e-4)
    @test isapprox(p2_2, 2.3973, rtol=1e-4)
    @test isapprox(p0ratio_2, 0.9352, rtol=1e-4)
    @test isapprox(beta_2, 29.6145, rtol=1e-4)
end

@testset "solve_cone_theta" begin
    # Test solve_cone_theta function
    # Expected values might need adjustment based on NACA Report 1135 or other reliable sources
    mc1, rhoc1, pc1, p0ratio1, beta1 = CompAir.solve_cone_theta(2.0, 20.0)
    @test isapprox(mc1, 1.5677, rtol=1e-2) # Similar to cone_mach_surface
    @test isapprox(rhoc1, 1.0, rtol=1e-2) # Placeholder, adjust as needed
    @test isapprox(pc1, 1.0, rtol=1e-2)   # Placeholder, adjust as needed
    @test isapprox(p0ratio1, 1.0, rtol=1e-2) # Placeholder, adjust as needed
    @test isapprox(beta1, 37.7955, rtol=1e-4) # Similar to cone_beta_weak with effective theta

    mc2, rhoc2, pc2, p0ratio2, beta2 = CompAir.solve_cone_theta(3.0, 20.0)
    @test isapprox(mc2, 2.2899, rtol=1e-2) # Similar to cone_mach_surface
    @test isapprox(rhoc2, 1.0, rtol=1e-2) # Placeholder, adjust as needed
    @test isapprox(pc2, 1.0, rtol=1e-2)   # Placeholder, adjust as needed
    @test isapprox(p0ratio2, 1.0, rtol=1e-2) # Placeholder, adjust as needed
    @test isapprox(beta2, 29.6146, rtol=1e-4) # Similar to cone_beta_weak with effective theta
end

@testset "solve_cone_theta_phi" begin
    # Test solve_cone_theta_phi function
    # Expected values might need adjustment
    # Case 1: psi = angle
    Mc1, rhoc1_phi, pc1_phi, p0ratio1_phi, beta1_phi, phi1 = CompAir.solve_cone_theta_phi(2.0, 20.0, 20.0)
    @test isapprox(Mc1, 1.5677, rtol=1e-2)         # Should be same as mc1 from solve_cone_theta
    @test isapprox(rhoc1_phi, 1.0, rtol=1e-2)    # Placeholder
    @test isapprox(pc1_phi, 1.0, rtol=1e-2)      # Placeholder
    @test isapprox(p0ratio1_phi, 1.0, rtol=1e-2) # Placeholder
    @test isapprox(beta1_phi, 37.7955, rtol=1e-4) # Should be same as beta1 from solve_cone_theta
    @test isapprox(phi1, 20.0, rtol=1e-2)         # Flow direction at surface for psi = angle

    # Case 2: M=3.0, angle=20, psi=15 (example, needs verification)
    Mc2, rhoc2_phi, pc2_phi, p0ratio2_phi, beta2_phi, phi2 = CompAir.solve_cone_theta_phi(3.0, 20.0, 15.0)
    # These are placeholder values and need to be verified with correct aerodynamic calculations
    @test isapprox(Mc2, 2.5, rtol=1e-2)      # Placeholder, adjust as needed
    @test isapprox(rhoc2_phi, 1.0, rtol=1e-2) # Placeholder
    @test isapprox(pc2_phi, 1.0, rtol=1e-2)   # Placeholder
    @test isapprox(p0ratio2_phi, 1.0, rtol=1e-2) # Placeholder
    @test isapprox(beta2_phi, 29.6146, rtol=1e-4) # Beta should be based on effective theta for M=3, angle=20
    @test isapprox(phi2, 15.0, rtol=1e-2)     # Placeholder, flow direction at psi=15
end



