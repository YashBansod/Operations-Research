%%
%   Author: Yash Bansod
%   Date: 26th March, 2020  
%   Problem 2 - Estimating parameters of a Markov Chain
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
close all;
clc;

%% Define the input parmeters
state_sequence = [1 2 4 12 4 4 2 12];
% state_sequence = [2 3 2 2 2 1 3 1 3 1 2 2 3 1 3 3 2 2 2 1 2 2 3 3 2 2 3 ...
%     2 2 3 3 2 2 2 1 1 2 1 3 1 1 1 1 2 1 3 2 1 3 3];
% state_sequence = "a b a c d a b d a c d b a a b d";
% Preprocessing to convert sting input to string array

if all(class(state_sequence) == 'string')
    state_sequence = state_sequence.split(' ')';
end

seq_len = size(state_sequence, 2);

unique_states = unique(state_sequence);
num_states = size(unique_states, 2);
state_map_ind = containers.Map(unique_states, 1:num_states);

% Convert unique states array to cell array of strings
if all(class(state_sequence) == 'double')
    states = strsplit(int2str(unique_states));
else
    states = cellstr(unique_states);
end

%% Calculate the Transition Probability Matrix
transition_count_mat = zeros(num_states, num_states);

for seq_ind = 1:seq_len - 1
    from_state =  state_sequence(seq_ind);
    to_state = state_sequence(seq_ind + 1);
    
    from_index = state_map_ind(from_state);
    to_index = state_map_ind(to_state);
    
    transition_count_mat(from_index, to_index) = ...
        transition_count_mat(from_index, to_index) + 1;
end

assert(sum(transition_count_mat, 'all') == seq_len - 1);
    
transition_probability_mat = transition_count_mat ./ ...
    sum(transition_count_mat, 2);

transition_probability_table = array2table(transition_probability_mat, ...
    'rowNames', states, 'VariableNames' , states);

%% Print the Results
disp('Transition Probability Table:');
disp(transition_probability_table);
