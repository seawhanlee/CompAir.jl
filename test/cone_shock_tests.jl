# Test cases for cone shock calculations
# Reference values from NACA Report 1135

@testset "Cone Shock Tests" begin
    # Test cone shock angle calculation
    @test isapprox(CompAir.cone_beta_weak(2.0, 20.0), 48.5, rtol=1e-1)
    @test isapprox(CompAir.cone_beta_weak(3.0, 20.0), 35.2, rtol=1e-1)
    
    # Test surface pressure coefficient
    @test isapprox(CompAir.solve_cone(2.0, 20.0)[3], 0.342, rtol=1e-3)
    @test isapprox(CompAir.solve_cone(3.0, 20.0)[3], 0.285, rtol=1e-3)
    
    # Test surface Mach number
    @test isapprox(CompAir.cone_mach(2.0, 20.0)[1], 1.83, rtol=1e-2)
    @test isapprox(CompAir.cone_mach(3.0, 20.0)[1], 2.45, rtol=1e-2)
    
    # Test surface pressure ratio
    @test isapprox(CompAir.solve_cone(2.0, 20.0)[3], 2.15, rtol=1e-2)
    @test isapprox(CompAir.solve_cone(3.0, 20.0)[3], 2.85, rtol=1e-2)
end 