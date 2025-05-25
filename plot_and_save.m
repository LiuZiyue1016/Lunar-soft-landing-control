% 定义绘图函数
function plot_and_save(results, case_ids, suffix, legend_labels, RL)
    
    colors = lines(length(legend_labels));
    legend_lines = []; % 创建一个数组用于存储折线句柄
    % 高度变化曲线
    figure;
    hold on;
    for case_id = case_ids
        h_line = plot(results(case_id).t, results(case_id).y(:,1) - RL, ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
        legend_lines = [legend_lines, h_line]; % 存储折线句柄
        % 获取最后一个点的坐标
        x_end = results(case_id).t(end);
        y_end = results(case_id).y(end,1) - RL;
        scatter(x_end, y_end, 36, colors(case_id,:), 'filled', 'MarkerEdgeColor', colors(case_id,:));
        % 添加文本
        text(x_end-10, y_end + 2000 * case_id, sprintf('%.2f', x_end), 'Color', colors(case_id,:));
    end
    xlabel('时间 (s)');
    ylabel('高度 (m)');
    legend(legend_lines, legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['altitude_' suffix '.jpg']);
    close(gcf);

    % 横向速度v
    figure;
    hold on;
    for case_id = case_ids
        plot(results(case_id).t, results(case_id).y(:,5), ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
    end
    xlabel('时间 (s)'); ylabel('横向速度 v (m/s)');
    legend(legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['v_' suffix '.jpg']);
    close(gcf);

    % 径向速度u
    figure;
    hold on;
    for case_id = case_ids
        plot(results(case_id).t, results(case_id).y(:,4), ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
    end
    xlabel('时间 (s)'); ylabel('径向速度 u (m/s)');
    legend(legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['u_' suffix '.jpg']);
    close(gcf);

    % 角速度w
    figure;
    hold on;
    for case_id = case_ids
        plot(results(case_id).t, results(case_id).y(:,6), ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
        
    end
    xlabel('时间 (s)'); ylabel('角速度 w');
    grid on;
    saveas(gcf, ['w_' suffix '.jpg']);
    close(gcf);

    % 质量m
    figure;
    legend_lines = [];
    hold on;
    for case_id = case_ids
        h_line = plot(results(case_id).t, results(case_id).y(:,7), ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
        legend_lines = [legend_lines, h_line];
        % 获取最后一个点的坐标
        x_end = results(case_id).t(end);
        y_end = results(case_id).y(end, 7);
        scatter(x_end, y_end, 36, colors(case_id,:), 'filled', 'MarkerEdgeColor', colors(case_id,:));
        % 添加文本
        text(x_end-8, y_end + 28 * case_id, sprintf('%.2f', y_end), 'Color', colors(case_id,:));
    
    end
    xlabel('时间 (s)'); ylabel('质量 m(kg)');
    legend(legend_lines, legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['m_' suffix '.jpg']);
    close(gcf);

    % 纬度（beta）变化曲线
    figure;
    hold on;
    for case_id = case_ids
        beta_deg = rad2deg(results(case_id).y(:,2));
        plot(results(case_id).t, beta_deg, ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
    end
    xlabel('时间 (s)');
    ylabel('纬度 \beta (deg)');
    legend(legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['beta_' suffix '.jpg']);
    close(gcf);

    % 经度（alpha）变化曲线
    figure;
    hold on;
    for case_id = case_ids
        alpha_deg = rad2deg(results(case_id).y(:,3));
        plot(results(case_id).t, alpha_deg, ...
            'Color', colors(case_id,:), 'LineWidth', 1.5);
    end
    xlabel('时间 (s)');
    ylabel('经度 \alpha (deg)');
    legend(legend_labels(case_ids), 'Location', 'best');
    grid on;
    saveas(gcf, ['alpha_' suffix '.jpg']);
    close(gcf);
end