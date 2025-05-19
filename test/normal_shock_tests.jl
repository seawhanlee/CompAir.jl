# Test cases for normal shock calculations

@testset "Normal Shock Tests" begin
    # Test downstream Mach number
    @test isapprox(CompAir.normal_mach2(2.0), 0.577, rtol=1e-3)
    @test isapprox(CompAir.normal_mach2(3.0), 0.475, rtol=1e-3)

    # Test density ratio across shock
    @test isapprox(CompAir.rho2_over_rho1(2.0), 2.667, rtol=1e-3)
    @test isapprox(CompAir.rho2_over_rho1(3.0), 3.857, rtol=1e-3)
    
    # Test pressure ratio across shock
    @test isapprox(CompAir.p2_over_p1(2.0), 4.500, rtol=1e-3)
    @test isapprox(CompAir.p2_over_p1(3.0), 10.333, rtol=1e-3)
    
    # Test temperature ratio across shock
    @test isapprox(CompAir.t2_over_t1(2.0), 1.687, rtol=1e-3)
    @test isapprox(CompAir.t2_over_t1(3.0), 2.679, rtol=1e-3)
    
    # Test total pressure ratio across shock
    @test isapprox(CompAir.p02_over_p01(2.0), 0.721, rtol=1e-3)
    @test isapprox(CompAir.p02_over_p01(3.0), 0.3283, rtol=1e-3)

    # Test solve_normal function
    M2, rho2, p2, p0ratio = CompAir.solve_normal(2.0)
    @test isapprox(M2, 0.577, rtol=1e-3)
    @test isapprox(rho2, 2.667, rtol=1e-3)
    @test isapprox(p2, 4.500, rtol=1e-3)
    @test isapprox(p0ratio, 0.7209, rtol=1e-3)
end 