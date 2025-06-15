function plot_and_save(results, case_ids, suffix, legend_labels, RL)
    % 输入参数:
    %   results: 结构体数组，包含每个case的仿真结果
    %   case_ids: 需要绘制的case索引数组
    %   suffix: 文件名后缀
    %   legend_labels: 图例标签的元胞数组
    %   RL: 参考高度（通常为天体半径）
    
    dir = ['figures/', suffix];

    % 检查输入有效性
    if isempty(case_ids) || isempty(results)
        error('输入数据为空！');
    end
    
    % 设置颜色方案
    colors = lines(3);
    
    %% 1. 高度变化曲线
    fig1 = figure('Name', '高度变化');
    ax1 = axes('Parent', fig1);
    hold(ax1, 'on');
    legend_handles = gobjects(1, length(case_ids)); % 预分配图形句柄
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        t = results(cid).t;
        altitude = results(cid).y(:,1) - RL;
        
        % 绘制高度曲线
        h_plot = plot(ax1, t, altitude, 'Color', colors(i,:), ...
                      'LineWidth', 2, 'DisplayName', legend_labels{cid});
        legend_handles(i) = h_plot;
        
        % 标记终点
        t_end = t(end);
        alt_end = altitude(end);
        scatter(ax1, t_end, alt_end, 80, 'MarkerFaceColor', colors(i,:), ...
                'MarkerEdgeColor', 'k', 'Marker', 'o');
        
        % 添加终点标签（智能位置）
        offset_x = max(t)*0.06;
        offset_y = sign(alt_end) * max(abs(altitude)) * 0.1 * cid;
        if cid == 1
            offset_y = sign(alt_end) * max(abs(altitude)) * 0.2;
        end
        
        text(ax1, t_end - offset_x, alt_end + offset_y, ...
             sprintf('t=%.1f s\n', t_end), ...
             'Color', colors(i,:), 'FontSize', 10, 'BackgroundColor', 'white');
    end
    
    xlabel(ax1, '时间 (s)');
    ylabel(ax1, '高度 (m)');
    grid(ax1, 'on');
    box(ax1, 'on');
    legend(ax1, legend_handles, 'Location', 'best');
    saveas(fig1, [dir, '/altitude_' suffix '.jpg']);
    
    %% 2. 横向速度v
    fig2 = figure('Name', '横向速度');
    ax2 = axes('Parent', fig2);
    hold(ax2, 'on');
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        plot(ax2, results(cid).t, results(cid).y(:,5), ...
             'Color', colors(i,:), 'LineWidth', 2);
    end
    
    xlabel(ax2, '时间 (s)');
    ylabel(ax2, '横向速度 v (m/s)');
    grid(ax2, 'on');
    box(ax2, 'on');
    legend(ax2, legend_labels(case_ids), 'Location', 'best');
    saveas(fig2, [dir, '/v_' suffix '.jpg']);
    
    %% 3. 径向速度u
    fig3 = figure('Name', '径向速度');
    ax3 = axes('Parent', fig3);
    hold(ax3, 'on');
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        plot(ax3, results(cid).t, results(cid).y(:,4), ...
             'Color', colors(i,:), 'LineWidth', 2);
    end
    
    xlabel(ax3, '时间 (s)');
    ylabel(ax3, '径向速度 u (m/s)');
    grid(ax3, 'on');
    box(ax3, 'on');
    legend(ax3, legend_labels(case_ids), 'Location', 'best');
    saveas(fig3, [dir, '/u_' suffix '.jpg']);
    
    %% 4. 角速度w
    fig4 = figure('Name', '角速度');
    ax4 = axes('Parent', fig4);
    hold(ax4, 'on');
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        plot(ax4, results(cid).t, results(cid).y(:,6), ...
             'Color', colors(i,:), 'LineWidth', 2);
    end
    
    xlabel(ax4, '时间 (s)');
    ylabel(ax4, '角速度 w (rad/s)');
    grid(ax4, 'on');
    box(ax4, 'on');
    legend(ax4, legend_labels(case_ids), 'Location', 'best'); % 添加缺失的图例
    saveas(fig4, [dir, '/w_' suffix '.jpg']);
    
    %% 5. 质量m
    fig5 = figure('Name', '质量变化');
    ax5 = axes('Parent', fig5);
    hold(ax5, 'on');
    legend_handles = gobjects(1, length(case_ids)); % 预分配图形句柄
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        t = results(cid).t;
        mass = results(cid).y(:,7);
        
        h_plot = plot(ax5, t, mass, 'Color', colors(i,:), 'LineWidth', 2, ...
            'DisplayName', legend_labels{cid});
        legend_handles(i) = h_plot;
        
        % 标记终点
        t_end = t(end);
        mass_end = mass(end);
        scatter(ax5, t_end, mass_end, 80, 'MarkerFaceColor', colors(i,:), ...
                'MarkerEdgeColor', 'k', 'Marker', 'd');
        
        % 添加终点标签
        offset_x = max(t)*0.18;
        offset_y = sign(mass_end) * max(abs(mass_end)) * 0.06 * cid;
        if cid == 1
            offset_y = sign(mass_end) * max(abs(mass_end)) * 0.25;
        end
        text(ax5, t_end - offset_x, mass_end + offset_y, ...
             sprintf('m=%.1f kg', mass_end), ...
             'Color', colors(i,:), 'FontSize', 10, 'BackgroundColor', 'white');
    end
    
    xlabel(ax5, '时间 (s)');
    ylabel(ax5, '质量 m (kg)');
    grid(ax5, 'on');
    box(ax5, 'on');
    legend(ax5, legend_handles, 'Location', 'best');
    saveas(fig5, [dir, '/m_' suffix '.jpg']);
    
    %% 6. 纬度（beta）变化曲线
    fig6 = figure('Name', '纬度变化');
    ax6 = axes('Parent', fig6);
    hold(ax6, 'on');
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        beta_deg = rad2deg(results(cid).y(:,2));
        plot(ax6, results(cid).t, beta_deg, ...
             'Color', colors(i,:), 'LineWidth', 2);
    end
    
    xlabel(ax6, '时间 (s)');
    ylabel(ax6, '纬度 \beta (deg)');
    grid(ax6, 'on');
    box(ax6, 'on');
    legend(ax6, legend_labels(case_ids), 'Location', 'best');
    saveas(fig6, [dir, '/beta_' suffix '.jpg']);
    
    %% 7. 经度（alpha）变化曲线
    fig7 = figure('Name', '经度变化');
    ax7 = axes('Parent', fig7);
    hold(ax7, 'on');
    
    for i = 1:length(case_ids)
        cid = case_ids(i);
        alpha_deg = rad2deg(results(cid).y(:,3));
        plot(ax7, results(cid).t, alpha_deg, ...
             'Color', colors(i,:), 'LineWidth', 2);
    end
    
    xlabel(ax7, '时间 (s)');
    ylabel(ax7, '经度 \alpha (deg)');
    grid(ax7, 'on');
    box(ax7, 'on');
    legend(ax7, legend_labels(case_ids), 'Location', 'best');
    saveas(fig7, [dir, '/alpha_' suffix '.jpg']);
    
    %% 关闭所有图形
    close([fig1, fig2, fig3, fig4, fig5, fig6, fig7]);
    disp(['成功保存' num2str(length(case_ids)) '个案例的' num2str(7) '组对比图']);
end
