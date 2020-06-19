%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 4a - Simulating a Markov Chain using Monte Carlo
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the input parmeters
num_time_steps = 10;                    % Number of time steps
state_vec_size = 3;
states = {'S1', 'S2', 'S3'};            % State Labels
assert(size(states, 2) == state_vec_size);

% Construct the state matrix where each row represents the state vector at
% time step = row_index - 1
state_mat = zeros(num_time_steps + 1, state_vec_size);
state_mat(1, :) = [0 1 0];              % Define the initial state vector

% Construct the state transition matrix
transition_mat = [  0.6 0.2 0.2; 
                    0.3 0.4 0.3; 
                    0.5 0.3 0.2];

%% Compute the state vector at each time step
for time_step = 2:num_time_steps+1
    state_mat(time_step, :) = state_mat(time_step - 1, :) * transition_mat;
end

% Sanity Check
transition_mat_ss = transition_mat^num_time_steps;
state_mat_ss = state_mat(1, :) * transition_mat_ss;
assert(all((state_mat_ss - state_mat(end, :)) < 1e-10));

%% Plot the results
time_line = 0:num_time_steps;
plot(time_line, state_mat(:, 1));
hold on;

for state_vec_ind = 2:state_vec_size
    plot(time_line, state_mat(:, state_vec_ind));
end
hold off;
legend(states);
title('System State Probability Graph');
xlabel('Time Step');
ylabel('Probability');
grid on;

%% Print the results
disp("Final system state:")
disp(array2table(state_mat(end, :),'VariableNames' , states));