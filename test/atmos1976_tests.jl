# Test cases for US Standard Atmosphere 1976
# Reference values from NASA-TM-X-74335

@testset "US Standard Atmosphere 1976 Tests" begin
    # Test temperature at different altitudes
    @test isapprox(CompAir.temperature(0.0), 288.15, rtol=1e-3)  # Sea level
    @test isapprox(CompAir.temperature(11000.0), 216.65, rtol=1e-3)  # Tropopause
    @test isapprox(CompAir.temperature(20000.0), 216.65, rtol=1e-3)  # Lower stratosphere
    
    # Test pressure at different altitudes
    @test isapprox(CompAir.pressure(0.0), 101325.0, rtol=1e-3)  # Sea level
    @test isapprox(CompAir.pressure(11000.0), 22632.0, rtol=1e-3)  # Tropopause
    @test isapprox(CompAir.pressure(20000.0), 5474.9, rtol=1e-3)  # Lower stratosphere
    
    # Test density at different altitudes
    @test isapprox(CompAir.density(0.0), 1.225, rtol=1e-3)  # Sea level
    @test isapprox(CompAir.density(11000.0), 0.3639, rtol=1e-3)  # Tropopause
    @test isapprox(CompAir.density(20000.0), 0.0880, rtol=1e-3)  # Lower stratosphere
    
    # Test speed of sound at different altitudes
    @test isapprox(CompAir.speed_of_sound(0.0), 340.3, rtol=1e-3)  # Sea level
    @test isapprox(CompAir.speed_of_sound(11000.0), 295.1, rtol=1e-3)  # Tropopause
    @test isapprox(CompAir.speed_of_sound(20000.0), 295.1, rtol=1e-3)  # Lower stratosphere
    
    # Test dynamic viscosity at different altitudes
    @test isapprox(CompAir.dynamic_viscosity(0.0), 1.789e-5, rtol=1e-3)  # Sea level
    @test isapprox(CompAir.dynamic_viscosity(11000.0), 1.421e-5, rtol=1e-3)  # Tropopause
    @test isapprox(CompAir.dynamic_viscosity(20000.0), 1.421e-5, rtol=1e-3)  # Lower stratosphere
end 