% 月球软着陆主制动段仿真
clear; close all;

% 仿真参数
F_nom = 1500;    % 标称推力 (N)
Isp_nom = 300;   % 标称比冲 (s)
gE = 9.8;
mu = 4.88775e12; % 月球引力常数
RL = 1738e3;     % 月球半径 (m)

% 终端约束
r_f = 1740e3;    % 终端高度 (离月面2km)
u_f = 0;
v_f = 0;
w_f = 0;

% 初始条件
r0 = 1753e3;     % 初始高度 (m)
beta0 = deg2rad(1e-6);
alpha0 = deg2rad(5);
u0 = 0;          % 初始径向速度
v0 = 1692;       % 初始横向速度
w0 = 0;
m0 = 600;        % 初始质量 (kg)

% 仿真时间设置
tspan = [0 10000]; % 初始时间范围

% 定义参数组合（添加质量变化案例）
param_cases = struct(...
    'F_ratio',    [1, 1.1, 0.9, 1, 1,   1,   1,   1,     1], ...   % 推力变化比例
    'Isp_ratio',  [1, 1,   1,   1.1, 0.9, 1,   1,   1,     1], ...  % 比冲变化比例
    'v_angle',    [0, 0,   0,   0,   0,   5,   0,   0,     0], ...  % 速度偏转角度（deg）
    'w_angle',    [0, 0,   0,   0,   0,   0,   5,   0,     0], ...  % 速度偏转角度（deg）
    'm_ratio',    [1, 1,   1,   1,   1,   1,   1,   1.1,   0.9] ... % 质量变化比例
);

% 事件函数：检测高度是否达到终端
options = odeset('Events', @(t,y) event_terminal(t, y, r_f));

% 预存储结果
results = struct();

% 修改主循环
for case_id = 1:length(param_cases.F_ratio)
    % 参数设置
    F = F_nom * param_cases.F_ratio(case_id);
    Isp = Isp_nom * param_cases.Isp_ratio(case_id);
    C_perturbed = Isp * gE;
    
    % 计算速度方向分量
    theta_v = deg2rad(param_cases.v_angle(case_id));
    theta_w = deg2rad(param_cases.w_angle(case_id));
    
    % 原始速度分量
    v0_base = 1692;  % 初始横向速度
    u0_new = v0_base * sin(theta_w);
    v0_new = v0_base * cos(theta_v) * cos(theta_w);
    w0_new = v0_base * sin(theta_v) * cos(theta_w);

    % 更新初始条件（添加质量变化）
    m0_perturbed = m0 * param_cases.m_ratio(case_id);
    y0 = [r0, beta0, alpha0, u0_new, v0_new, w0_new, m0_perturbed];

    % 运行仿真
    [t, y] = ode45(@(t, y) dynamics(t, y, mu, C_perturbed, F), tspan, y0, options);
    
    % 记录结果
    results(case_id).t = t;
    results(case_id).y = y;
    results(case_id).F = F;
    results(case_id).Isp = Isp;
    results(case_id).m0 = m0_perturbed;
    
    % 计算终端误差
    final_alpha = rad2deg(y(end,3));
    final_beta = rad2deg(y(end,2));
    results(case_id).alpha_error = final_alpha - rad2deg(alpha0);
    results(case_id).beta_error = final_beta - rad2deg(beta0);
    results(case_id).fuel_consumed = m0_perturbed - y(end,7);
end

%% 结果可视化与分析
% 终端位置误差表格
fprintf('\n终端位置误差分析:\n');
fprintf('Case\tF(%%)\tIsp(%%)\tX Angle(deg)\tY Angle(deg)\tMass(%%)\tAlpha Error(deg)\tBeta Error(deg)\tFuel Used(kg)\n');
for case_id = 1:length(results)
    fprintf('%d\t%+.1f\t%+.1f\t%d\t\t%d\t\t%+.1f\t%+.4f\t\t%+.4f\t\t%.2f\n', ...
        case_id, ...
        (param_cases.F_ratio(case_id)-1)*100, ...
        (param_cases.Isp_ratio(case_id)-1)*100, ...
        param_cases.v_angle(case_id), ...
        param_cases.w_angle(case_id), ...
        (param_cases.m_ratio(case_id)-1)*100, ...
        results(case_id).alpha_error, ...
        results(case_id).beta_error, ...
        results(case_id).fuel_consumed);
end

% 定义案例ID
case_ids_F = [1, 2, 3]; % F变化
case_ids_Isp = [1, 4, 5]; % Isp变化
case_ids_V = [1, 6, 7]; % 速度方向变化
case_ids_M = [1, 8, 9]; % 质量变化

% 定义图例标签
legend_labels = {'base', 'F+10%', 'F-10%', 'Isp+10%', 'Isp-10%', 'X+5deg', 'Y+5deg', 'M+10%', 'M-10%'};

% 生成各组图片
plot_and_save(results, case_ids_F, 'F', legend_labels, RL);
plot_and_save(results, case_ids_Isp, 'Isp', legend_labels, RL);
plot_and_save(results, case_ids_V, 'VelDir', legend_labels, RL);
plot_and_save(results, case_ids_M, 'Mass', legend_labels, RL); 
