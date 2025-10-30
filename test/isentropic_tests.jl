# Test cases for isentropic flow calculations

@testset "total_to_static_temperature_ratio" begin
    # Test temperature ratio calculation
    @test isapprox(CompAir.total_to_static_temperature_ratio(0.5), 1.050, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_temperature_ratio(1.0), 1.200, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_temperature_ratio(2.0), 1.800, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_temperature_ratio(3.0), 2.800, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_temperature_ratio(4.0), 4.200, rtol=1e-3)
end

@testset "total_to_static_pressure_ratio" begin
    # Test pressure ratio calculation
    @test isapprox(CompAir.total_to_static_pressure_ratio(0.5), 1.186, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_pressure_ratio(1.0), 1.893, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_pressure_ratio(2.0), 7.824, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_pressure_ratio(3.0), 36.73, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_pressure_ratio(4.0), 151.8, rtol=1e-3)
end

@testset "total_to_static_density_ratio" begin
    # Test density ratio calculation
    @test isapprox(CompAir.total_to_static_density_ratio(0.5), 1.130, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_density_ratio(1.0), 1.577, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_density_ratio(2.0), 4.347, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_density_ratio(3.0), 13.12, rtol=1e-3)
    @test isapprox(CompAir.total_to_static_density_ratio(4.0), 36.15, rtol=1e-3)
end