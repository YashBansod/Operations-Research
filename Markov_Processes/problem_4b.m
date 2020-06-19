%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 4b - Simulating a Markov Chain using Monte Carlo
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the input parmeters
states = {'S1', 'S2', 'S3'};            % State Labels
num_states = size(states, 2);           % N = Number of states

% N x N Transition Matrix
transition_mat = [  0.6 0.2 0.2; 
                    0.3 0.4 0.3; 
                    0.5 0.3 0.2];
assert(size(transition_mat, 1) == num_states);
assert(size(transition_mat, 2) == num_states);

init_state = 'S2';

num_transitions = 5000;

% Number of steps taken in analytic approach to reach steady state
analytic_ss_steps = 10;     
ss_margin = 2;      % Steady state margin in percentage 

%% Monte Carlo Simulation to generate Markov Chain
% Map state names to indices
state_map_ind = containers.Map(states, 1:num_states);

% create a cell array for holding generated state sequence
state_seq = cell(1, num_transitions + 1);
state_seq{1} = init_state;

% Construct the state matrix where each row represents the state vector at
% time step = row_index - 1
state_mat = zeros(num_transitions + 1, num_states);
state_mat(1, state_map_ind(init_state)) = 1;

trans_mat_cumsum = cumsum(transition_mat, 2);   % Compute thresholds
assert(all(trans_mat_cumsum(:, end) == 1), "Sum of probabilities != 1")
rand_draw = rand(1, num_transitions);           % Random numbers sampled

% Next State is selected based on random draw and computed thresholds
for t_index = 1:num_transitions
    state_cumsum = trans_mat_cumsum(state_map_ind(state_seq{t_index}), :);
    for s_index = 1:num_states
        if rand_draw(t_index) <= state_cumsum(s_index)
            state_mat(t_index + 1, s_index) = 1;
            state_seq(t_index + 1) = states(s_index);
            break;
        end
    end
end

%% Some computations for analysis
% Compute the CRM
crm_state_mat = cumsum(state_mat, 1);
divisor = 1:num_transitions + 1;
crm_state_mat = crm_state_mat ./ divisor';

% Compute the analytic steady state
transition_mat_ss = transition_mat^analytic_ss_steps;
state_mat_ss = state_mat(1, :) * transition_mat_ss;

%% Plot the results
% Plot CRM
time_line = 0:num_transitions;
plot(time_line, crm_state_mat(:, 1));
hold on;

for state_vec_ind = 2:num_states
    plot(time_line, crm_state_mat(:, state_vec_ind));
end

% Draw Steady State Margins
for state_vec_ind = 1:num_states
    yline((1 + (ss_margin/100)) * state_mat_ss(state_vec_ind), '--');
    yline((1 - (ss_margin/100)) * state_mat_ss(state_vec_ind), '-.');
end

hold off;
legend(states);
title('State CRM Graph');
xlabel('Time Step');
ylabel('Cumulative Running Mean');
grid on;

%% Print the results
disp("Final mean system state:")
disp(array2table(crm_state_mat(end, :),'VariableNames' , states));