%% MSPE 298 Project 298 pt1
 
clear; clc; close all;

% Given data
x = [1.0; 2.0; 3.0];       %Rear stagger, in
y = [22.14; 21.70; 22.08]; %Lap time, s

% Candermode matric A = [1 x x.^2]
A = [ones(size(x)) x x.^2];

% Solve A*b = y
b = A \ y;
b0 = b(1);
b1 = b(2);
b2 = b(3);

% Dense x-grid for smooth curve
xplt = (0.0:0.01:5.0).';
yhat_plt = b0 + b1*xplt + b2*xplt.^2;

% Vertex (optimal RS)
xopt = -b1/(2*b2);
yopt = b0 + b1*xopt + b2*xopt^2;

% Display results
fprintf('Part 1 - Optimal rear stagger (x_opt): %.4f in\n', xopt);
fprintf('Part 1 - Minimum predicted lap time (y_min): %.4f s\n', yopt);

% Plot
figure('Color', 'w');
plot(xplt, yhat_plt, 'b-', 'LineWidth', 1.8); hold on;
plot(x, y, 'r*', 'MarkerSize', 8, 'LineWidth', 1.2);
plot(xopt, yopt, 'go', 'MarkerSize', 8, 'LineWidth', 1.6);
grid on; box on;
xlabel('Rear Stagger, RS (in)');
ylabel('Lap Time (s)');
title('Pavement Midget - Quadratic Regression (3 Sessions)');
legend('Quadratic fit', 'Data (3 Sessions)', 'Optimum (x_{x_opt}, y_{min})', 'Location', 'best');