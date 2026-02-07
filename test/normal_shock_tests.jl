# Test cases for normal shock calculations

@testset "Normal Shock Tests" begin
    @testset "ns_mach2" begin
        # Test downstream Mach number
        @test isapprox(CompAir.ns_mach2(2.0), 0.577, rtol=1e-3)
        @test isapprox(CompAir.ns_mach2(3.0), 0.475, rtol=1e-3)
    end

    @testset "ns_rho2_over_rho1" begin
        # Test density ratio across shock
        @test isapprox(CompAir.ns_rho2_over_rho1(2.0), 2.667, rtol=1e-3)
        @test isapprox(CompAir.ns_rho2_over_rho1(3.0), 3.857, rtol=1e-3)
    end
    
    @testset "ns_p2_over_p1" begin
        # Test pressure ratio across shock
        @test isapprox(CompAir.ns_p2_over_p1(2.0), 4.500, rtol=1e-3)
        @test isapprox(CompAir.ns_p2_over_p1(3.0), 10.333, rtol=1e-3)
    end
    
    @testset "ns_t2_over_t1" begin
        # Test temperature ratio across shock
        @test isapprox(CompAir.ns_t2_over_t1(2.0), 1.687, rtol=1e-3)
        @test isapprox(CompAir.ns_t2_over_t1(3.0), 2.679, rtol=1e-3)
    end
    
    @testset "ns_p02_over_p01" begin
        # Test total pressure ratio across shock
        @test isapprox(CompAir.ns_p02_over_p01(2.0), 0.721, rtol=1e-3)
        @test isapprox(CompAir.ns_p02_over_p01(3.0), 0.3283, rtol=1e-3)
    end

    @testset "solve_normal" begin
        # Test solve_normal function
        sol = CompAir.solve_normal(2.0)
        @test isapprox(sol.M2, 0.577, rtol=1e-3)
        @test isapprox(sol.rho2_ratio, 2.667, rtol=1e-3)
        @test isapprox(sol.p2_ratio, 4.500, rtol=1e-3)
        @test isapprox(sol.p0_ratio, 0.7209, rtol=1e-3)
    end
end