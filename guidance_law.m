function [psi, phi, t_go] = guidance_law(y, F, mu)
    % 解包当前状态
    r = y(1);
    u = y(4);
    v = y(5);
    w = y(6);
    m = y(7);
    
    % 终端约束
    r_f = 1740e3;    % 终端高度 (离月面2km)
    u_f = 0;
    v_f = 0;
    w_f = 0;

    delta_v = v_f - v;
    delta_w = w_f - w;
    speed_error = sqrt(delta_v^2 + delta_w^2);
    
    % 初始猜测：假设a_H = F/m（即ψ=90度）
    a_F = F / m;
    a_H_initial = a_F;
    t_go_guess = speed_error / a_H_initial;
    
    max_iter = 10;       % 最大迭代次数
    tolerance = 1e-5;   % 收敛容差
    
    for iter = 1:max_iter
        % 计算径向加速度a（式17-14）
        numerator_a = 6*(r_f - r - u*t_go_guess) - 2*(u_f - u)*t_go_guess;
        a = numerator_a / (t_go_guess^2);
        
        % 计算ψ角（式17-15）
        term_gravity = mu / r^2;
        term_centrifugal = (v^2 + w^2) / r;
        numerator_psi = a + term_gravity - term_centrifugal;
        cos_psi = numerator_psi / a_F;
        cos_psi = max(min(cos_psi, 1), 0); % 限制在有效范围
        psi = acos(cos_psi);
        
        % 更新水平加速度和剩余时间
        a_H = a_F * sin(psi);
        t_go_new = speed_error / a_H;
        
        % 检查收敛
        if abs(t_go_new - t_go_guess) < tolerance
            % disp([iter, "收敛"])
            break;
        end
        t_go_guess = t_go_new;
    end
    t_go = t_go_guess;
    
    % 计算φ角（式17-15）
    phi = atan2(delta_w, delta_v);
end