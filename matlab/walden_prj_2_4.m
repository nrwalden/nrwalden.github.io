%% walden_prj_2_4.m
% Project 2.4 - MATLAB Optimization
% Rear wing optimization at Road America
% Uses fmincon (Optimization Toolbox)

clear; clc; close all;

%% Decision variables and bounds
% x = wing fore-aft position (mm)
% z = wing height (mm)

x0 = [1850, 720]; % initial guess (x0, z0)
lb = [1600, 650]; % lower bounds
ub = [2100, 775]; % upper bounds

%% Objective and constraints for fmincon

% Objective function: lap time T(x,z) to MINIMIZE
obj_fun = @(xz) lap_time(xz(1), xz(2));

% Nonlinear inequality constraint: LC(x,z) <= 0.70
nonlcon = @(xz) wing_constraints(xz);

% Use SQP (good for small constrained problems) and show iterations
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

%% Call fmincon
[x_opt, T_opt, exitflag, output] = fmincon(obj_fun, x0, [], [], [], [], lb, ub, nonlcon, options);

x_star = x_opt(1);
z_star = x_opt(2);

%% Print results
fprintf('\n===== fmincon Optimization Results =====\n');
fprintf('Exit flag: %d\n', exitflag);
fprintf('Optimal wing fore-aft x* (mm): %.4f\n', x_star);
fprintf('Optimal wing height z*   (mm): %.4f\n', z_star);
fprintf('Optimal lap time T(x*,z*) (s): %.6f\n', T_opt);
fprintf('========================================\n');

%% Create contour plot over the design space
nx = 80; nz = 80;
x_vec = linspace(lb(1), ub(1), nx);
z_vec = linspace(lb(2), ub(2), nz);
[X, Z] = meshgrid(x_vec, z_vec);

T_grid  = lap_time(X, Z); % objective
LC_grid = load_cap(X, Z); % constraint LC(x,z)

figure;

% Lap-time contours
contour(X, Z, T_grid, 30, 'ShowText','on');
hold on;

% Constraint boundary LC(x,z) = 0.70
contour(X, Z, LC_grid - 0.70, [0 0], 'LineWidth', 2);

% Mark optimum
plot(x_star, z_star, 'r*', 'MarkerSize', 10, 'LineWidth', 2);

xlabel('Wing fore-aft x (mm)');
ylabel('Wing height z (mm)');
title('Lap time contours with LC(x,z) = 0.70 and fmincon optimum');
colorbar;
legend('Lap time contours','LC(x,z) = 0.70','Optimal point','Location','best');
grid on;
hold off;

%% ===== Local function definitions ====

function CL_val = CL_fun(x, z)
% Lift coefficient C_L(x,z)
% x, z can be scalars or arrays

CL_val = -( 0.02 + 0.05 .* exp( ...
    - ((x - 1850) ./ 160).^2 ...
    - ((z - 740) ./ 55 ).^2 ) );
end

function CD_val = CD_fun(x, z)
% Drag coefficient C_D(x,z)

CD_val = 0.90 ...
    - 0.15 .* exp( - ((x - 1850) ./ 180).^2 ) ...
    - 0.08 .* exp( - ((z - 710) ./ 60 ).^2 ) ...
    + 1.5e-7 .* (x - 2050).^2;
end

function T_val = lap_time(x, z)
% Lap time proxy T(x,z)
% T(x,z) = 60 - 18*F_S + 7*F_D + 0.6*F_I

CL = CL_fun(x, z);
CD = CD_fun(x, z);

% F_S: saturation benefit from downforce
u = -CL;
u_plus = max(u, 0); % [u]+ = max(u,0)
F_S = atan(8 .* u_plus);

% F_D: drag penalty
F_D = CD;

% F_I: interaction term
F_I = CD .* (-CL);

T_val = 60 - 18 .* F_S + 7 .* F_D + 0.6 .* F_I;
end

function LC_val = load_cap(x, z)
% Load cap LC(x,z) = C_D(x,z) + 0.35 * [-C_L(x,z)]+

CL = CL_fun(x, z);
CD = CD_fun(x, z);

u = -CL;
u_plus = max(u, 0);

LC_val = CD + 0.35 .* u_plus;
end

function [c, ceq] = wing_constraints(xz)
% Nonlinear constraint for fmincon:
% LC(x,z) <= 0.70  --> c(x,z) = LC(x,z) - 0.70 <= 0

x = xz(1);
z = xz(2);

LC = load_cap(x, z);

c   = LC - 0.70;   % inequality constraint(s)
ceq = [];          % no equality constraints
end

%% Extra visualization: dot plots with lines of best fit

% Choose a reference height and fore-aft position (e.g., the optimum)
z_ref = z_star;              % fix z, vary x
x_ref = x_star;              % fix x, vary z

% 1) T vs x at fixed z = z_ref
x_line = linspace(lb(1), ub(1), 30);
z_line_const = z_ref * ones(size(x_line));
T_x_line = lap_time(x_line, z_line_const);

% Fit a polynomial line of best fit (quadratic)
p_x = polyfit(x_line, T_x_line, 2);
T_x_fit = polyval(p_x, x_line);

figure;
plot(x_line, T_x_line, 'o', 'MarkerSize', 5);  % dots
hold on;
plot(x_line, T_x_fit, '-', 'LineWidth', 2);    % best-fit curve
xlabel('Wing fore-aft x (mm)');
ylabel('Lap time T(x,z_{ref}) (s)');
title(sprintf('Lap time vs x at z = %.1f mm', z_ref));
legend('Data (model samples)', 'Quadratic best fit', 'Location', 'best');
grid on;
hold off;

% 2) T vs z at fixed x = x_ref
z_line = linspace(lb(2), ub(2), 30);
x_line_const = x_ref * ones(size(z_line));
T_z_line = lap_time(x_line_const, z_line);

% Fit a polynomial line of best fit (quadratic)
p_z = polyfit(z_line, T_z_line, 2);
T_z_fit = polyval(p_z, z_line);

figure;
plot(z_line, T_z_line, 'o', 'MarkerSize', 5);  % dots
hold on;
plot(z_line, T_z_fit, '-', 'LineWidth', 2);    % best-fit curve
xlabel('Wing height z (mm)');
ylabel('Lap time T(x_{ref},z) (s)');
title(sprintf('Lap time vs z at x = %.1f mm', x_ref));
legend('Data (model samples)', 'Quadratic best fit', 'Location', 'best');
grid on;
hold off;