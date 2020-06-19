%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 1c - Markov Birth-Death Process
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the input parmeters
num_time_steps = 1000;                    % Number of time steps
state_vec_size = 101;                     % N + 1; N = Maximum Population

% Construct the state matrix where each row represents the state vector at
% time step = row_index - 1
state_mat = zeros(num_time_steps + 1, state_vec_size);
state_mat(1, 91) = 1;                   % Define the initial state vector

time_step = 0;
exp_factor = exp(-2 * time_step);

% Define the birth rate
birth_rate_coeff = 0.9;
birth_rate = birth_rate_coeff * exp_factor;

% Define the death rate
death_rate_coeff = 0.9;
death_rate_1 = death_rate_coeff;
death_rate_2 = death_rate_coeff * exp_factor;
% death_rate = death_rate_1 - death_rate_2;

% Define the no state change rate
no_change_rate = 0.1;

%% Some pre-computations to calculate the state transition matrix
% Precomputations for calculating the state transition matrix
identity_mat = eye(state_vec_size, state_vec_size);

birth_rate_mat_0 = circshift(identity_mat, -1);
birth_rate_mat_0(end, 1) = 0;
% birth_rate = birth_rate_coeff * exp_factor;

death_rate_mat_0 = circshift(identity_mat, 1);
death_rate_mat_0(1, end) = 0;
death_rate_mat_1 = death_rate_mat_0 .* death_rate_1;
% death_rate_mat_2 = death_rate_mat_0 .* death_rate_2;
% death_rate_mat = death_rate_mat_1 - death_rate_mat_2;

no_change_mat = identity_mat .* no_change_rate;

transition_mat = zeros(state_vec_size, state_vec_size, num_time_steps);
% transition_mat(:, :, time_step) = no_change_mat + ...
%                                   death_rate_mat + birth_rate_mat;

%% Compute the state vector at each time step
for time_step = 1:num_time_steps
    exp_factor = exp(-2 * (time_step -1));
    
    birth_rate = birth_rate_coeff * exp_factor;
    death_rate_2 = death_rate_coeff * exp_factor;
    
    birth_rate_mat = birth_rate_mat_0 .* birth_rate;
    
    death_rate_mat_2 = death_rate_mat_0 .* death_rate_2;
    death_rate_mat = death_rate_mat_1 - death_rate_mat_2;
    
    % no_change_mat is modified to correct the edge conditions
    no_change_mat(1, 1) = 1 - birth_rate_mat(1, 2);
    no_change_mat(end, end) = 1 - death_rate_mat(end, end - 1);
    
    transition_mat(:, :, time_step) = no_change_mat + ...
        death_rate_mat + birth_rate_mat;
    
    state_mat(time_step + 1, :) = state_mat(time_step, :) * ...
        transition_mat(:, :, time_step);
end

expected_population_size = sum((0:state_vec_size-1) .* state_mat, 2);

%% Plot the results
time_line = 0:num_time_steps;
figure(1);
plot(time_line, expected_population_size, 'r');
legend('Expected Population');
title('System Population (Hostile Environment)');
xlabel('Time Step');
ylabel('Expected Population');
grid on;

%% Auxilliary Plots
ss_ind = 120;
plot_states = {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90'};

figure(2);
plot(time_line(1:ss_ind), ...
    state_mat(1:ss_ind, str2double(plot_states(1)) + 1));
hold on;

for index = 2:size(plot_states, 2)
    plot(time_line(1:ss_ind), state_mat(1:ss_ind, ...
        str2double(plot_states(index)) + 1));
end

hold off;
legend(plot_states);
title('System Population (Hostile Environment)');
xlabel('Time Step');
ylabel('Probability');
grid on;