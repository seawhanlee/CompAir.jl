# Test cases for cone shock calculations
# Reference values from NACA Report 1135

@testset "cone_theta_eff" begin
    @test isapprox(CompAir.cone_theta_eff(2, 20), 8.5704, rtol=1e-3)
    @test isapprox(CompAir.cone_theta_eff(3, 20), 12.3773, rtol=1e-3)
end

@testset "cone_beta" begin
    # Test cone shock angle calculation
    @test isapprox(CompAir.cone_beta(2.0, 20.0), 37.7955, rtol=1e-3)
    @test isapprox(CompAir.cone_beta(3.0, 20.0), 29.6146, rtol=1e-3)
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

@testset "solve_cone" begin

    sol1 = CompAir.solve_cone(2, 10)
    @test isapprox(sol1.M2, 1.9469, rtol=1e-3)
    @test isapprox(sol1.rho2_ratio, 1.0605, rtol=1e-3)
    @test isapprox(sol1.p2_ratio, 1.0857, rtol=1e-3)
    @test isapprox(sol1.p0_ratio, 0.9999, rtol=1e-3)
    @test isapprox(sol1.beta, 31.2018, rtol=1e-3)

    sol2 = CompAir.solve_cone(3, 20)
    @test isapprox(sol2.M2, 2.3871, rtol=1e-3)
    @test isapprox(sol2.rho2_ratio, 1.8320, rtol=1e-3)
    @test isapprox(sol2.p2_ratio, 2.3973, rtol=1e-3)
    @test isapprox(sol2.p0_ratio, 0.9352, rtol=1e-3)
    @test isapprox(sol2.beta, 29.6145, rtol=1e-3)
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

# Edge case tests for refactored _taylor_maccoll! / _integrate_tm

@testset "cone_shock edge cases" begin

    @testset "small cone half-angle (5°)" begin
        @test isapprox(CompAir.cone_theta_eff(3.0, 5.0), 0.319, rtol=1e-3)
        @test isapprox(CompAir.cone_beta(3.0, 5.0), 19.688, rtol=1e-3)

        sol = CompAir.solve_cone(3.0, 5.0)
        @test isapprox(sol.M2, 2.984, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 1.018, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 1.025, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 1.000, rtol=1e-3)
        @test isapprox(sol.beta, 19.688, rtol=1e-3)
    end

    @testset "high Mach M=4, angle=20°" begin
        sol = CompAir.solve_cone(4.0, 20.0)
        @test isapprox(sol.M2, 2.970, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 2.333, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 3.546, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.820, rtol=1e-3)
        @test isapprox(sol.beta, 26.485, rtol=1e-3)
    end

    @testset "high Mach M=5, angle=15°" begin
        sol = CompAir.solve_cone(5.0, 15.0)
        @test isapprox(sol.M2, 3.930, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 2.218, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 3.254, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.851, rtol=1e-3)
        @test isapprox(sol.beta, 20.028, rtol=1e-3)
    end

    @testset "bow shock (M=2, angle=40° exceeds θ_max)" begin
        sol = CompAir.solve_cone(2.0, 40.0)
        @test isapprox(sol.M2, 0.627, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 2.667, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 4.5, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.721, rtol=1e-3)
        @test isapprox(sol.beta, 90.0, rtol=1e-3)
    end

    @testset "non-air gamma γ=5/3 (monatomic gas)" begin
        sol = CompAir.solve_cone(2.5, 10.0, 5 / 3)
        @test isapprox(sol.M2, 2.365, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 1.116, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 1.201, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.9995, rtol=1e-2)
        @test isapprox(sol.beta, 25.528, rtol=1e-3)
    end

    @testset "non-air gamma γ=1.3 (high-temp diatomic)" begin
        sol = CompAir.solve_cone(3.0, 15.0, 1.3)
        @test isapprox(sol.M2, 2.676, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 1.492, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 1.691, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.984, rtol=1e-3)
        @test isapprox(sol.beta, 25.032, rtol=1e-3)
    end

    @testset "cone_mach_surface edge cases" begin
        ms1 = CompAir.cone_mach_surface(2.5, 15.0)
        @test isapprox(ms1[1], 2.118, rtol=1e-3)
        @test isapprox(ms1[2], 15.0, rtol=1e-3)

        ms2 = CompAir.cone_mach_surface(3.0, 5.0)
        @test isapprox(ms2[1], 2.891, rtol=1e-3)
        @test isapprox(ms2[2], 5.0, rtol=1e-3)
    end

    @testset "solve_cone_properties with intermediate psi" begin
        mc, rhoc, pc, p0r, beta, phi = CompAir.solve_cone_properties(3.0, 15.0, psi=10.0)
        @test isapprox(mc, 2.622, rtol=1e-3)
        @test isapprox(rhoc, 1.483, rtol=1e-3)
        @test isapprox(pc, 1.749, rtol=1e-3)
        @test isapprox(p0r, 0.983, rtol=1e-3)
        @test isapprox(beta, 25.259, rtol=1e-3)
        @test isapprox(phi, 23.611, rtol=1e-3)
    end

end
