# Test cases for isentropic flow calculations

@testset "t0_over_t" begin
    # Test temperature ratio calculation
    @test isapprox(CompAir.t0_over_t(0.5), 1.050, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(1.0), 1.200, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(2.0), 1.800, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(3.0), 2.800, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(4.0), 4.200, rtol=1e-3)
end

@testset "p0_over_p" begin
    # Test pressure ratio calculation
    @test isapprox(CompAir.p0_over_p(0.5), 1.186, rtol=1e-3)
    @test isapprox(CompAir.p0_over_p(1.0), 1.893, rtol=1e-3)
    @test isapprox(CompAir.p0_over_p(2.0), 7.824, rtol=1e-3)
    @test isapprox(CompAir.p0_over_p(3.0), 36.73, rtol=1e-3)
    @test isapprox(CompAir.p0_over_p(4.0), 151.8, rtol=1e-3)
end

@testset "rho0_over_rho" begin
    # Test density ratio calculation
    @test isapprox(CompAir.rho0_over_rho(0.5), 1.130, rtol=1e-3)
    @test isapprox(CompAir.rho0_over_rho(1.0), 1.577, rtol=1e-3)
    @test isapprox(CompAir.rho0_over_rho(2.0), 4.347, rtol=1e-3)
    @test isapprox(CompAir.rho0_over_rho(3.0), 13.12, rtol=1e-3)
    @test isapprox(CompAir.rho0_over_rho(4.0), 36.15, rtol=1e-3)
end