%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 3a - Simulating a Markov Chain using Monte Carlo
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
close all;
clc;

%% Define the input parmeters
states = {'a', 'b'};
num_states = size(states, 2);

% transition_mat = [0.5 0.5; 0.5 0.5];
% transition_mat = [0 1; 1 0];
transition_mat = [0.3 0.7; 0.6 0.4];
assert(size(transition_mat, 1) == num_states);
assert(size(transition_mat, 2) == num_states);

init_state = 'a';

% num_transitions = 10;
num_transitions = 200;

%% Monte Carlo Simulation to generate Markov Chain
% Map state names to indices
state_map_ind = containers.Map(states, 1:num_states);

% create a cell array for holding generated state sequence
state_seq = cell(1, num_transitions + 1);
state_seq{1} = init_state;

trans_mat_cumsum = cumsum(transition_mat, 2);   % Compute thresholds
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

string_state_seq = string(strjoin(state_seq));

%% Print out the results
disp("State Sequence: ")

per_line = 80;
pattern = sprintf('.{1,%d}', per_line);
print_str = regexp(string_state_seq, pattern, 'match');

fprintf('%s\n', print_str{:});

% disp(string_state_seq)
