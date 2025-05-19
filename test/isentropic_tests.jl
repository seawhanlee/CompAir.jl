# Test cases for isentropic flow calculations
# Reference values from NACA Report 1135

@testset "Isentropic Flow Tests" begin
    # Test Mach number calculation from area ratio
    @test isapprox(CompAir.mach_from_area_ratio(1.4, 2.0), 2.197, rtol=1e-3)
    @test isapprox(CompAir.mach_from_area_ratio(1.4, 4.0), 2.940, rtol=1e-3)
    
    # Test area ratio calculation from Mach number
    @test isapprox(CompAir.area_ratio(1.4, 2.0), 1.687, rtol=1e-3)
    @test isapprox(CompAir.area_ratio(1.4, 3.0), 4.235, rtol=1e-3)
    
    # Test pressure ratio calculation
    @test isapprox(CompAir.pressure_ratio(1.4, 2.0), 0.1278, rtol=1e-3)
    @test isapprox(CompAir.pressure_ratio(1.4, 3.0), 0.0272, rtol=1e-3)
    
    # Test temperature ratio calculation
    @test isapprox(CompAir.temperature_ratio(1.4, 2.0), 0.5556, rtol=1e-3)
    @test isapprox(CompAir.temperature_ratio(1.4, 3.0), 0.3571, rtol=1e-3)
    
    # Test density ratio calculation
    @test isapprox(CompAir.density_ratio(1.4, 2.0), 0.2300, rtol=1e-3)
    @test isapprox(CompAir.density_ratio(1.4, 3.0), 0.0762, rtol=1e-3)
end 