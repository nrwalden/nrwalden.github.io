%% PROJECT 2.3
% Course: MSPE 298
% Data: stpete_practice.csv
% Notes:
% - We DO NOT use avg_speed_kph in modeling to avoid circularity.
% - Model per spec: y = β0 + β1*x1 + β2*x2 + β3*x3 + β4*x2^2 + β5*x3^2,
%   where x1=track_temp_C, x2=fuel_kg, x3=tire_age_laps.
% - The PDF's design-matrix line listing x1^2 appears to be a typo; it
%   conflicts with the equation that uses x2^2 and x3^2. We implement x2^2,
%   x3^2.

clear; clc; close all;

%% 1) Load and prepare data
% a) Read as table
T = readtable('stpete_practice.csv');

% b) Remove columns: lap, tire_compound, stagger_mm
dropCols = intersect({'lap','tire_compound','stagger_mm'}, ...
    T.Properties.VariableNames);
T(:, dropCols) = [];

% Keep a copy of names for correlation/plot labels
varNames = T.Properties.VariableNames;

% c) Convert to numeric array for corrcoef / plotmatrix
A = table2array(T);   % rows = laps, cols = variables that remain

%% 2) Correlation Matrix
% a) Correlation matrix heatmap
R = corrcoef(A, 'Rows','pairwise');
figure('Color','w','Name','Correlation Matrix');
h = heatmap(varNames, varNames, R);
h.Title = 'Correlation Matrix (corrcoef)';
h.XLabel = 'Variables';
h.YLabel = 'Variables';

% b) Scatter matrix (plotmatrix)
figure('Color','w','Name','Scatter Plot Matrix');
plotmatrix(A);
title('Scatter Matrix of Variables');

%% 3) Regression Model
% Selected variables (per spec):
%   y: time_s (target)
%   x1: track_temp_C
%   x2: fuel_kg
%   x3: tire_age_laps
req = {'time_s','track_temp_C','fuel_kg','tire_age_laps'};
missing = setdiff(req, T.Properties.VariableNames);
if ~isempty(missing)
    error('Missing required columns in CSV: %s', strjoin(missing, ', '));
end

y  = T.time_s;
x1 = T.track_temp_C;
x2 = T.fuel_kg;
x3 = T.tire_age_laps;

% a) Verify pairwise correlations with target (same as in matrix)
Rmini = corrcoef([y x1 x2 x3]);  % base MATLAB
r_x1 = Rmini(1,2);
r_x2 = Rmini(1,3);
r_x3 = Rmini(1,4);

fprintf('Corr(y, track_temp_C) = %+0.4f\n', r_x1);
fprintf('Corr(y, fuel_kg)      = %+0.4f\n', r_x2);
fprintf('Corr(y, tire_age_laps)= %+0.4f\n', r_x3);

% b) Build regression with x2^2 and x3^2
% --- Base MATLAB regression (no toolbox) ---
% Design matrix: [1, x1, x2, x3, x2^2, x3^2]
X = [ones(size(y))  x1  x2  x3  x2.^2  x3.^2];

% Least-squares solution to X*beta = y
beta = X \ y;                        % 6x1 vector
b0 = beta(1); b1 = beta(2); b2 = beta(3);
b3 = beta(4); b4 = beta(5); b5 = beta(6);

% Fitted values and goodness-of-fit
yhat = X*beta;
SS_res = sum((y - yhat).^2);
SS_tot = sum((y - mean(y)).^2);
R2 = 1 - SS_res/SS_tot;

n = numel(y); p = size(X,2);         % n obs, p params (here p=6)
R2_adj = 1 - (1 - R2)*(n - 1)/(n - p);

fprintf('\n== Base MATLAB Regression ==\n');
fprintf('beta = [b0 b1 b2 b3 b4 b5] = [%.6g %.6g %.6g %.6g %.6g %.6g]\n', beta);
fprintf('R^2 = %.5f,  R^2_adj = %.5f\n', R2, R2_adj);

%% 4) Plots for prediction at mean
x2_bar = mean(x2, 'omitnan'); %#ok<*NASGU>

% Define grid for x1 (track temp) and x3 (tire age)
n1 = 60; n3 = 60;
x1_grid = linspace(min(x1), max(x1), n1);
x3_grid = linspace(min(x3), max(x3), n3);
[X1, X3] = meshgrid(x1_grid, x3_grid);

% Build table for prediction using x2 = mean
% Prediction on grid with x2 fixed at its mean
x2_bar = mean(x2,'omitnan');

yhat_grid = b0 ...
          + b1*X1(:) ...
          + b2*x2_bar ...
          + b3*X3(:) ...
          + b4*(x2_bar.^2) ...
          + b5*(X3(:).^2);

Yhat = reshape(yhat_grid, size(X1));

% a) Surface plot
figure('Color','w','Name','Surface: (track\_temp\_C, tire\_age\_laps) vs predicted time\_s');
surf(X1, X3, Yhat); shading interp; grid on; box on;
xlabel('track\_temp\_C (x1)');
ylabel('tire\_age\_laps (x3)');
zlabel('Predicted time\_s');
title(sprintf('Surface: x2=fuel\\_kg fixed at mean = %.3f', x2_bar));

% b) Contour + scatter of sampled (x1,x3)
figure('Color','w','Name','Contour: predicted time\_s with samples & optimum');
contour(X1, X3, Yhat, 20); hold on; grid on; box on;
xlabel('track\_temp\_C (x1)');
ylabel('tire\_age\_laps (x3)');
title(sprintf('Contour: x2=fuel\\_kg fixed at mean = %.3f', x2_bar));

% scatter of observed x1 vs x3 (no z)
plot(x1, x3, 'k.', 'MarkerSize', 12);

% c) Find minimum on the grid and mark it
[best_y, idx] = min(Yhat(:));
[i_row, j_col] = ind2sub(size(Yhat), idx);
x1_star = X1(i_row, j_col);
x3_star = X3(i_row, j_col);
plot(x1_star, x3_star, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
legend('Contours','Samples (x1,x3)','Min on grid','Location','best');

fprintf('\n===== Optimum on grid for x2=mean =====\n');
fprintf('track_temp_C* (x1*)   = %.4f\n', x1_star);
fprintf('tire_age_laps* (x3*)  = %.4f\n', x3_star);
fprintf('Predicted min time_s  = %.4f\n', best_y);
fprintf('======================================\n');

%% 5) End — Script prints model and shows four figures:
% - Correlation matrix (heatmap)
% - Scatter plot matrix
% - Surface plot (x1,x3 vs y | x2 fixed at mean)
% - Contour plot + samples + minimum marker