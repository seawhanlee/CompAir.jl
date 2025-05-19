# Test cases for isentropic flow calculations

@testset "Isentropic Flow Tests" begin
    # Test temperature ratio calculation
    @test isapprox(CompAir.t0_over_t(2.0), 1.800, rtol=1e-3)
    @test isapprox(CompAir.t0_over_t(3.0), 2.800, rtol=1e-3)

    # Test pressure ratio calculation
    @test isapprox(CompAir.p0_over_p(2.0), 7.824, rtol=1e-3)
    @test isapprox(CompAir.p0_over_p(3.0), 36.73, rtol=1e-3)
    
    # Test density ratio calculation
    @test isapprox(CompAir.rho0_over_rho(2.0), 4.347, rtol=1e-3)
    @test isapprox(CompAir.rho0_over_rho(3.0), 13.12, rtol=1e-3)
end 