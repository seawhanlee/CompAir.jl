using Roots
using DifferentialEquations

function _taylor_maccoll(theta, y, gamma=1.4)
    # Taylor-Maccoll function
    # Source: https://www.grc.nasa.gov/www/k-12/airplane/coneflow.html
    v_r, v_theta = y
    dydt = [
        v_theta;
        (v_theta^2 * v_r - (gamma - 1) / 2 * (1 - v_r^2 - v_theta^2) * (2 * v_r + v_theta / tan(theta))) 
        / ((gamma - 1) / 2 * (1 - v_r^2 - v_theta^2) - v_theta^2)
    ]

    return dydt
end

function _intergrate_tm(M, angle, theta, gamma=1.4)
    theta_max_val = theta_max(M, gamma)

    if theta <= theta_max
        beta = beta_weak(M, theta, gamma)
        M2 = oblique_mach2(M, theta, gamma)
    else
        beta = 90
        M2 = normal_mach2(M, gamma)
    end

    v = sqrt(((gamma-1)/2*M2^2)/(1+(gamma-1)/2*M2^2))
    v_theta = -v*sin(deg2rad(beta-theta))
    v_r = v*cos(deg2rad(beta-theta))

    # Integrate over [beta, angle]
    tspan = (deg2rad(beta), deg2rad(angle))
    prob = ODEProblem(_taylor_maccoll, [v_r, v_theta], tspan, gamma)
    sol = solve(prob)

    # Return solution
    return sol
end