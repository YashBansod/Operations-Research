%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 3b - Simulating a Markov Chain using Monte Carlo
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
close all;
clc;

%% Define the input parmeters
states = {'a', 'b'};                % Add more states if you want here
% states = {'a', 'b', 'c'};           % Add more states if you want here
num_states = size(states, 2);       % N = Number of states

% N x N Transition Matrix
transition_mat = [0.3 0.7; 0.6 0.4];    
% transition_mat = [0.3 0.5 0.2; 0.4 0.4 0.2; 0.7 0.15 0.15]; 
assert(size(transition_mat, 1) == num_states);
assert(size(transition_mat, 2) == num_states);

init_state = 'a';

% num_transitions = 20;
% num_transitions = 200;
num_transitions = 2000;

%% Monte Carlo Simulation to generate Markov Chain
% Map state names to indices
state_map_ind = containers.Map(states, 1:num_states);

% create a cell array for holding generated state sequence
state_seq = cell(1, num_transitions + 1);
state_seq{1} = init_state;

trans_mat_cumsum = cumsum(transition_mat, 2);   % Compute thresholds
assert(all(trans_mat_cumsum(:, end) == 1), "Sum of probabilities != 1")
rand_draw = rand(1, num_transitions);           % Random numbers sampled

% Next State is selected based on random draw and computed thresholds
for t_index = 1:num_transitions
    state_cumsum = trans_mat_cumsum(state_map_ind(state_seq{t_index}), :);
    for s_index = 1:num_states
        if rand_draw(t_index) <= state_cumsum(s_index)
            state_seq(t_index + 1) = states(s_index);
            break;
        end
    end
end

%% Calculate the Transition Probability Matrix
transition_count_mat = zeros(num_states, num_states);

for seq_ind = 1:num_transitions
    from_state =  state_seq{seq_ind};
    to_state = state_seq{seq_ind + 1};
    
    from_index = state_map_ind(from_state);
    to_index = state_map_ind(to_state);
    
    transition_count_mat(from_index, to_index) = ...
        transition_count_mat(from_index, to_index) + 1;
end

assert(sum(transition_count_mat, 'all') == num_transitions);
    
transition_probability_mat = transition_count_mat ./ ...
    sum(transition_count_mat, 2);

transition_probability_table = array2table(transition_probability_mat, ...
    'rowNames', states, 'VariableNames' , states);

%% Print the Results
disp('Transition Probability Table:');
disp(transition_probability_table);
