
% 事件检测函数
function [value, isterminal, direction] = event_terminal(~, y, r_f)
    value = y(1) - r_f;  % 检测高度是否到达r_f
    isterminal = 1;      % 终止仿真
    direction = -1;      % 当高度减小时触发
end