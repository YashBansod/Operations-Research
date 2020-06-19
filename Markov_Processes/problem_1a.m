%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 1a - Markov Birth-Death Process
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the input parmeters
num_time_steps = 50;                    % Number of time steps
state_vec_size = 5;                     % N + 1; N = Maximum Population
states = {'0', '1', '2', '3', '4'};     % State Labels
assert(size(states, 2) == state_vec_size);

% Construct the birth rate vector. Vector is used to keep our code 
% adaptable to varying birth rates for different states
birth_rate = 0.5;
birth_rate_vec = zeros(1, state_vec_size);
birth_rate_vec(1:end - 1) = birth_rate;

% Construct the death rate vector. Vector is used to keep our code 
% adaptable to varying death rates for different states
death_rate = 0.3;
death_rate_vec = zeros(1, state_vec_size);
death_rate_vec(2:end) = death_rate;

% Construct the state matrix where each row represents the state vector at
% time step = row_index - 1
state_mat = zeros(num_time_steps + 1, state_vec_size);
state_mat(1, :) = 1/state_vec_size;     % Define the initial state vector

% Construct the state transition matrix
transition_mat = zeros(state_vec_size, state_vec_size);
for row_ind = 1:state_vec_size
    for col_ind = 1:state_vec_size
        if col_ind == row_ind - 1
            transition_mat(row_ind, col_ind) = death_rate_vec(row_ind);
        elseif col_ind == row_ind
            transition_mat(row_ind, col_ind) = 1 - ...
                (birth_rate_vec(row_ind) + death_rate_vec(row_ind));
        elseif col_ind == row_ind + 1
            transition_mat(row_ind, col_ind) = birth_rate_vec(row_ind);
        end
    end
end

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
title('System Population');
xlabel('Time Step');
ylabel('Probability');
grid on;
