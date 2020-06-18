%%
%   Author: Yash Bansod
%   Date: 27th February, 2020  
%   Problem 1 - Static Monte Carlo Project Cost Simulation
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the simulation parmeters
num_samples = 2000;
num_hist_bins = 51;

activity =  {'A' 'B' 'C' 'D' 'F' 'I' 'J' 'K' 'L' 'M' 'N'};
num_activities = size(activity, 2);

min_hours = [64 32 16 96 80 160 80 16 32 160 96];
max_hours = [128 128 112 192 240 400 192 48 96 320 176];
likely_hours = [96 64 48 144 160 240 144 32 48 240 144];

min_cost = [100 100 100 100 100 100 90 90 90 90 90];
max_cost = [150 150 150 150 150 150 110 110 110 110 110];
likely_cost = [120 120 120 120 120 120 100 100 100 100 100];

% Some dimension checks to make sure values were inputted correctly
assert(size(min_hours, 2) == num_activities);
assert(size(max_hours, 2) == num_activities);
assert(size(likely_hours, 2) == num_activities);

assert(size(min_cost, 2) == num_activities);
assert(size(max_cost, 2) == num_activities);
assert(size(likely_cost, 2) == num_activities);

%% Define the probability distributions to sample data from

% Create probability distribution samplers for labor hours and cost
prob_dist_hours = cell(size(likely_hours));
prob_dist_cost = cell(size(likely_cost));

for ind = 1:num_activities
    prob_dist_hours{ind} = makedist('triangular', ...
        'a', min_hours(ind), 'b', likely_hours(ind), 'c', max_hours(ind));
    prob_dist_cost{ind} = makedist('triangular', ...
        'a', min_cost(ind), 'b', likely_cost(ind), 'c', max_cost(ind));
end

%% Run the Monte-Carlo Simulation

% rand('seed', 5);                    % Seed to control randomization
tic;

rand_hours = zeros(num_activities, num_samples);
rand_cost = zeros(num_activities, num_samples);

for ind = 1:num_activities
    rand_hours(ind, :) = random(prob_dist_hours{ind}, 1, num_samples);
    rand_cost(ind, :) = random(prob_dist_cost{ind}, 1, num_samples);
end    

rand_task_cost = rand_hours .* rand_cost;

rand_proj_cost = sum(rand_task_cost, 1);
sample_range = 1:num_samples;
cum_run_mean_proj_cost = cumsum(rand_proj_cost) ./ sample_range;
mean_proj_cost = cum_run_mean_proj_cost(num_samples);

toc;

std_dev_proj_cost = std(rand_proj_cost);
std_err_proj_cost = std_dev_proj_cost / sqrt(num_samples);

% Calculate 10%ile and 90%ile of the collected dataset
percent_10 = prctile(rand_proj_cost, 10);
percent_90 = prctile(rand_proj_cost, 90);

% 10%ile & 90%ile assuming data is distributed as normal distribution.
norm_percent_10 = norminv(0.1, mean_proj_cost, std_dev_proj_cost);
norm_percent_90 = norminv(0.9, mean_proj_cost, std_dev_proj_cost);

%% Plot the results

figure(1)
histogram(rand_proj_cost, num_hist_bins);
hold on
xline(mean_proj_cost, '--r');
xline(percent_10, '-.g');
xline(norm_percent_10, '-.c');
xline(percent_90, '-.g');
xline(norm_percent_90, '-.c');
hold off
legend('Histogram', 'Final Mean', ...
    '10%->90% Actual Boundary', '10%->90% NormInv Boundary');
title('Histogram: Project Cost Distribution');
xlabel('Project Cost in $');
ylabel('Count');

figure(2)
plot(sample_range, cum_run_mean_proj_cost);
hold on
yline(mean_proj_cost, '--r');
hold off
legend('CRM', 'Final Mean');
title('Cumulative Running Mean (CRM) of Project Cost');
xlabel('Num Samples');
ylabel('CRM of Project Cost in $');

%% Print the computation results

fprintf('Project Cost - Mean: %.2f\n', mean_proj_cost);
fprintf('Project Cost - Standard Deviation: %.2f\n', std_dev_proj_cost)
fprintf('Project Cost - Standard Error: %.2f\n', std_err_proj_cost)
fprintf('Project Cost - 10%% -> 90%% Boundary: (%.2f, %.2f)\n',...
    percent_10, percent_90);
fprintf('Project Cost - 10%% -> 90%% Norm Inv Boundary: (%.2f, %.2f)\n',...
    norm_percent_10, norm_percent_90);
