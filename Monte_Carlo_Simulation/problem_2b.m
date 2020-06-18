%%
%   Author: Yash Bansod
%   Date: 27th February, 2020  
%   Problem 2b - Time-Driven Dynamic MC Simulation of an AV
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the simulation parmeters
num_samples = 5000;
num_hist_bins = 21;

sim_time_len = 400;
time_step = 5;
num_t_steps = floor(sim_time_len/time_step);

mass_av = 2;
init_v_x = 16.6666;             % Initial velocity of AV in x-axis
init_v_y = 0;                   % Initial velocity of AV in y-axis

init_s_x = 0;                   % Initial position of AV in x-axis
init_s_y = 0;                   % Initial position of AV in y-axis

delta_p_y_mean = 0;             % Mean of Change in momentum
delta_p_std = 2.7777;           % Standard deviation of change in momentum

%% Define the probability distributions to sample data from

delta_v_y_mean = delta_p_y_mean/mass_av;
delta_v_y_std = delta_p_std/mass_av;

delta_v_y_dist = makedist('Normal', 'mu', ...
    delta_v_y_mean, 'sigma', delta_v_y_std);

%% Run the Monte-Carlo Simulation
% rand('seed', 5);                    % Seed to control randomization

% x-axis velocity trajectory of the AV
v_x = zeros(num_samples, num_t_steps + 1);
v_x(:, :) = init_v_x;

% x-axis position trajectory of the AV
delta_s_x = v_x(:, 1:end - 1) .* time_step;
s_x = zeros(num_samples, num_t_steps + 1);
s_x(:, 1) = init_s_x;
s_x(:, 2:end) = delta_s_x;
s_x = cumsum(s_x, 2); 

tic;

% y-axis velocity trajectory of the AV
delta_v_y = random(delta_v_y_dist, num_samples, num_t_steps);
v_y = zeros(num_samples, num_t_steps + 1);
v_y(:, 1) = init_v_y;
v_y(:, 2:end) = delta_v_y;
v_y = cumsum(v_y, 2);

% y-axis positioin trajectory of the AB
delta_s_y = v_y(:, 1:end - 1) .* time_step + 0.5 * delta_v_y .* time_step;
s_y = zeros(num_samples, num_t_steps + 1);
s_y(:, 1) = init_s_y;
s_y(:, 2:end) = delta_s_y;
s_y = cumsum(s_y, 2); 

end_y_cord = s_y(:, end);
mean_end_y_cord = mean(end_y_cord);
std_dev_end_y_cord = std(end_y_cord);
std_err_end_y_cord = std_dev_end_y_cord / sqrt(num_samples);

toc;

%% Plot the results

figure(1)
histogram(end_y_cord, num_hist_bins);
hold on
xline(mean_end_y_cord, '--r');
hold off
legend('Histogram', 'Mean');
title('Histogram: End Y Coordinate');
xlabel('Y Coordinate Position');
ylabel('Count');

%% Print the computation results

fprintf('Final Y-Coordinate - Mean: %.2f\n', mean_end_y_cord)
fprintf('Final Y-Coordinate - Standard Deviation: %.2f\n', ...
    std_dev_end_y_cord)
fprintf('Final Y-Coordinate - Standard Error: %.2f\n', std_err_end_y_cord)
