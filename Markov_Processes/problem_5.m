%%
%   Author: Yash Bansod
%   Date: 18th April, 2020  
%   Problem 5 - Markov Processes
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
close all;
clc;

%% Define the input parmeters
states = {'R', 'O', 'M'};               % List the uniques states here
num_states = size(states, 2);

% Define the state transition matrix
transition_mat = [  0.4     0.5     0.1; 
                    0       0.7     0.3; 
                    0.5     0       0.5];

assert(size(transition_mat, 1) == num_states);
assert(size(transition_mat, 2) == num_states);

init_state = 'R';                       % Mark the initial state

num_transitions = 2000;                  % Define the number of hours

% Provide the analytic steady state for comparison
state_mat_ss = [15/58 25/58 9/29];
ss_margin = 5;      % Steady state margin in percentage 

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

%% Plot the results
color_list = {'r', 'b', 'g', 'm', 'c', 'y', 'k'};
legend_arr = cell(num_states, 3);
% Plot CRM
time_line = 0:num_transitions;
state_vec_ind = 1;
plot(time_line, crm_state_mat(:, state_vec_ind), 'Color', ...
    color_list{state_vec_ind},'DisplayName', states{state_vec_ind});
hold on;
u_legend = strcat(states(state_vec_ind), ' Upper Margin');
l_legend = strcat(states(state_vec_ind), ' Lower Margin');
yline((1 + (ss_margin/100)) * state_mat_ss(state_vec_ind), '--', ...
    'Color', color_list{state_vec_ind}, 'DisplayName', u_legend{1});
yline((1 - (ss_margin/100)) * state_mat_ss(state_vec_ind), '-.', ...
    'Color', color_list{state_vec_ind}, 'DisplayName', l_legend{1});


for state_vec_ind = 2:num_states
    plot(time_line, crm_state_mat(:, state_vec_ind), 'Color', ...
        color_list{state_vec_ind}, 'DisplayName', states{state_vec_ind});
    u_legend = strcat(states(state_vec_ind), ' Upper Margin');
    l_legend = strcat(states(state_vec_ind), ' Lower Margin');
    yline((1 + (ss_margin/100)) * state_mat_ss(state_vec_ind), '--', ...
        'Color', color_list{state_vec_ind}, 'DisplayName', u_legend{1});
    yline((1 - (ss_margin/100)) * state_mat_ss(state_vec_ind), '-.', ...
        'Color', color_list{state_vec_ind}, 'DisplayName', l_legend{1});
end

hold off;
legend

title('State CRM Graph');
xlabel('Time Step');
ylabel('Cumulative Running Mean');
grid on;

%% Print the results
disp("Final mean system state:")
disp(array2table(crm_state_mat(end, :),'VariableNames' , states));
