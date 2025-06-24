# Test case for intake

@testset "intake_ramp" begin
    M_infty1 = 2.5
    angles1 = [10, 16]
    sol1 = intake_ramp(M_infty1, angles1)
    @test isapprox(sol1.M[2], 2.085, rtol=1e-3)
    @test isapprox(sol1.rho2_ratio[1], 1.551, rtol=1e-3)
end