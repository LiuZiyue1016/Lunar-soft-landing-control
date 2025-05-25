% 读取探测器图像
% detector_img = imread('detector.png'); % 不再需要读取图像

colors = lines(5);
% 创建新的图形窗口
figure;
hold on;

% 提取高度和时间数据
time = results(1).t;          % 时间数据
height = results(1).y(:,1) - RL; % 转换为相对于月面的高度
u = results(1).y(:,4);       % 径向速度
v = results(1).y(:,5);       % 横向速度

% 绘制轨道曲线
plot(time, height, 'Color', colors(1,:), 'LineWidth', 1.5);
grid on;

% 添加标签和标题
xlabel('时间 (s)');
ylabel('高度 (m)');

% 动画部分
axis manual; % 保持坐标轴不变

% 动画循环
detector_handle = []; % 用于存储探测器点句柄
text_handle = [];     % 用于存储文本句柄

% 创建 GIF 视频写入对象
gif_filename = 'detector_orbit';
gif_writer = VideoWriter([gif_filename, '.gif']);
gif_writer.FrameRate = 20; % 设置帧率
open(gif_writer);

% 动画循环
for i = 1:length(time)
    % 更新探测器位置
    x_pos = time(i);
    y_pos = height(i);
    current_u = u(i);
    current_v = v(i);

    % 如果上一帧存在探测器点，则删除它
    if ~isempty(detector_handle)
        delete(detector_handle);
    end

    % 显示红色实心圆点作为探测器
    detector_handle = plot(x_pos, y_pos, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

    % 如果上一帧存在文本，则删除它
    if ~isempty(text_handle)
        delete(text_handle);
    end

    % 显示速度信息
    speed_text = sprintf('u: %.2f m/s\nv: %.2f m/s', current_u, current_v);
    text_handle = text(x_pos, y_pos + 1000, speed_text, ...
        'Color', 'r', 'FontSize', 10, 'HorizontalAlignment', 'center');

    % 刷新显示
    drawnow;
    pause(0.05); % 控制动画速度

    if i == 35
        % 保存最后一帧为静态图像
        saveas(gcf, 'detector.jpg');
    end

    % 捕捉当前帧并写入 GIF
    frame = getframe(gcf);
    writeVideo(gif_writer, frame);
end

% 关闭视频写入对象并保存 GIF
close(gif_writer);

% 关闭图形窗口
close(gcf);