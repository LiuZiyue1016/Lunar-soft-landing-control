function dydt = dynamics(t, y, mu, C, F)
    % 状态变量: y = [r, beta, alpha, u, v, w, m]
    
    r = y(1); u = y(4); v = y(5); w = y(6); m = y(7); beta = y(2);
    
    % 调用制导律计算控制角
    [psi, phi, ~] = guidance_law(y, F, mu);

    global psi_history
    psi_history = [psi_history; psi];

    % 数值保护：当beta接近0时，用泰勒展开近似
    beta_safe = beta;
    epsilon = 1e-8;  % 阈值
    if abs(beta) < epsilon
        beta_safe = epsilon * sign(beta);  % 避免严格为零
    end

    % 对tan(beta)进行保护
    if abs(beta) < epsilon
        tan_beta = beta_safe;  % 泰勒展开近似：tan(beta) ≈ beta (当beta→0)
    else
        tan_beta = tan(beta);
    end
    
    % 动力学方程（式17-2）
    drdt = u;
    dbetadt = v / r;
    dalphadt = w / (r * sin(beta_safe));
    dudt = F/m * cos(psi) - mu/r^2 + (v^2 + w^2)/r;

    dvdt = F/m * sin(psi)*cos(phi) - u*v/r + (w^2)/(r*tan_beta);
    dwdt = F/m * sin(psi)*sin(phi) - u*w/r - v*w/(r*tan_beta);

    dmdt = -F / C;
    
    dydt = [drdt; dbetadt; dalphadt; dudt; dvdt; dwdt; dmdt];
end