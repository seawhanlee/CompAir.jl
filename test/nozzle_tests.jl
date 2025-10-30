# Test cases for nozzle flow calculations
# Reference values from NACA Report 1135

@testset "mdot" begin
    # Test mass flow rate calculation
    @test isapprox(CompAir.mdot(1.0), 0.6847, rtol=1e-3)
    @test isapprox(CompAir.mdot(2.0), 0.40576, rtol=1e-3)
    @test isapprox(CompAir.mdot(3.0), 0.16170, rtol=1e-3)
    @test isapprox(CompAir.mdot(4.0), 0.06388, rtol=1e-3)
end

@testset "area_ratio_at" begin
    # Test critical area ratio
    @test isapprox(CompAir.area_ratio_at(1.0), 1.0, rtol=1e-3)
    @test isapprox(CompAir.area_ratio_at(2.0), 1.6875, rtol=1e-3)
    @test isapprox(CompAir.area_ratio_at(3.0), 4.2345, rtol=1e-3)
    @test isapprox(CompAir.area_ratio_at(4.0), 10.7187, rtol=1e-3)
end

@testset "subsonic_mach_from_area_ratio" begin
    @test isapprox(CompAir.subsonic_mach_from_area_ratio(1), 1.0, rtol=1e-3)
    @test isapprox(CompAir.subsonic_mach_from_area_ratio(2), 0.3059, rtol=1e-3)
    @test isapprox(CompAir.subsonic_mach_from_area_ratio(3), 0.1974, rtol=1e-3)
    @test isapprox(CompAir.subsonic_mach_from_area_ratio(4), 0.1465, rtol=1e-3)
end

@testset "subsonic_pressure_from_area_ratio" begin
   @test isapprox(CompAir.subsonic_pressure_from_area_ratio(1), 0.5282817970269534, rtol=1e-3)
   @test isapprox(CompAir.subsonic_pressure_from_area_ratio(2), 0.9371625024322057, rtol=1e-3)
   @test isapprox(CompAir.subsonic_pressure_from_area_ratio(3), 0.9731817988106134, rtol=1e-3)
   @test isapprox(CompAir.subsonic_pressure_from_area_ratio(4), 0.9851106875021334, rtol=1e-3)
end