%% MSPE 298 Porject 2.2 pt2

clear; clc; close all;

% Given Data
x = [1.00; 2.00; 3.00; 1.50; 2.50; 3.50; 2.25];        %in
y = [22.14; 21.70; 22.08; 21.96; 21.79; 22.27; 21.68]; %s

% Vandermonde matrix
A = [ones(size(x)) x x.^2];

% Solve Via Moore-Penrose
b = pinv(A) * y;
b0 = b(1);
b1 = b(2);
b2 = b(3);

% Goodness of fit
yhat = A * b;
SS_res = sum((y - yhat).^2);
SS_tot = sum((y - mean(y)).^2);
R2 = 1 - SS_res/SS_tot;

n = numel(1);    % 7 points
p = 3;           % parameters: b0, b1, b2
R2_adj = 1 - (1 - R2) * (n - 1) / (n - p);

% Dense x-grid for smooth curve and optimum
xplt = (0.0:0.01:5.0).';
yhat_plt = b0 + b1*xplt + b2*xplt.^2;

% Vertex 
xopt = -b1/(2*b2);
yopt = b0 + b1*xopt + b2*xopt^2;

% Display results
fprintf('Part 2 — R^2:       %.5f\n', R2);
fprintf('Part 2 — R^2_adj:   %.5f\n', R2_adj);
fprintf('Part 2 — x_opt:     %.4f in\n', xopt);
fprintf('Part 2 — y_min:     %.4f s\n', yopt);

% Plot
figure('Color','w');
plot(xplt, yhat_plt, 'b-', 'LineWidth', 1.8); hold on;

% NOTE: The spec likely intends plotting *all* given data in red:
plot(x, y, 'r*', 'MarkerSize', 8, 'LineWidth', 1.2);

plot(xopt, yopt, 'go', 'MarkerSize', 8, 'LineWidth', 1.6);
grid on; box on;
xlabel('Rear Stagger, RS (in)');
ylabel('Lap Time (s)');
legend('Quadratic fit','Data (7 sessions)','Optimum (x_{opt}, y_{min})','Location','best');
title('Pavement Midget — Quadratic Regression (7 Sessions)');