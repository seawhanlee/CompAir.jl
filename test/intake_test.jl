# Test case for intake

@testset "intake_ramp" begin
    # Two-ramp intake example
    sol1 = intake_ramp(2.5, [10.0, 16.0])
    @test length(sol1.M) == 3
    @test length(sol1.rho2_ratio) == 2
    @test isapprox(sol1.M[2], 2.0859, rtol=1e-3)
    @test isapprox(sol1.M[3], 1.4827, rtol=1e-3)
    @test isapprox(sol1.rho2_ratio[1], 1.5493, rtol=1e-3)
    @test isapprox(sol1.rho2_ratio[2], 1.8072, rtol=1e-3)
    @test isapprox(sol1.p2_ratio[1], 1.8639, rtol=1e-3)
    @test isapprox(sol1.p2_ratio[2], 2.3476, rtol=1e-3)
    @test isapprox(sol1.p0_ratio[1], 0.9759, rtol=1e-3)
    @test isapprox(sol1.p0_ratio[2], 0.9396, rtol=1e-3)
    @test isapprox(sol1.beta[1], 31.851, rtol=1e-3)
    @test isapprox(sol1.beta[2], 44.730, rtol=1e-3)

    # Single-ramp intake example
    sol2 = intake_ramp(2.0, [15.0])
    @test length(sol2.M) == 2
    @test isapprox(sol2.M[2], 1.4457, rtol=1e-3)
    @test isapprox(sol2.rho2_ratio[1], 1.7289, rtol=1e-3)
    @test isapprox(sol2.p2_ratio[1], 2.1947, rtol=1e-3)
    @test isapprox(sol2.p0_ratio[1], 0.9524, rtol=1e-3)
    @test isapprox(sol2.beta[1], 45.344, rtol=1e-3)

    # Three-ramp intake example
    sol3 = intake_ramp(3.0, [5.0, 5.0, 5.0])
    @test length(sol3.M) == 4
    @test isapprox(sol3.M[2], 2.7497, rtol=1e-3)
    @test isapprox(sol3.M[3], 2.5216, rtol=1e-3)
    @test isapprox(sol3.M[4], 2.3116, rtol=1e-3)
    @test isapprox(sol3.rho2_ratio[1], 1.3045, rtol=1e-3)
    @test isapprox(sol3.rho2_ratio[2], 1.2805, rtol=1e-3)
    @test isapprox(sol3.rho2_ratio[3], 1.2594, rtol=1e-3)
    @test isapprox(sol3.p2_ratio[1], 1.4540, rtol=1e-3)
    @test isapprox(sol3.p2_ratio[2], 1.4160, rtol=1e-3)
    @test isapprox(sol3.p2_ratio[3], 1.3830, rtol=1e-3)
    @test isapprox(sol3.p0_ratio[1], 0.9947, rtol=1e-3)
    @test isapprox(sol3.p0_ratio[2], 0.9957, rtol=1e-3)
    @test isapprox(sol3.p0_ratio[3], 0.9965, rtol=1e-3)
    @test isapprox(sol3.beta[1], 23.133, rtol=1e-3)
    @test isapprox(sol3.beta[2], 25.061, rtol=1e-3)
    @test isapprox(sol3.beta[3], 27.197, rtol=1e-3)
end
