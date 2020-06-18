%%
%   Author: Yash Bansod
%   Date: 19th February, 2020  
%   Problem 1 - Networks & Shortest Path
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the graph

% Specify the node names
n_names = {'So', 'N1', 'N2', 'N3', 'N4', 'N5', 'Si'};

% Specify the edges and thier costs
e_start = [1 1 2 3 2 3 3 4 5 5 6 4 5 6];
e_stop  = [2 3 3 2 4 5 6 5 4 6 5 7 7 7];
e_cost  = [6 3 1 1 5 2 7 1 2 2 1 2 5 3] * 10;
% e_cost  = [60 30 10 10 50 20 70 10 20 20 10 20 50 30];

% Some dimension checks to make sure values were inputted correctly
assert(size(e_start, 2) == size(e_stop, 2));
assert(size(e_start, 2) == size(e_cost, 2));

% Create the graph
graph = digraph(e_start, e_stop, e_cost, n_names);

%% Plotting the graph to visualize it better

figure('Name', 'Problem graph')
p_g_plot = plot(graph, ...
    'EdgeLabel', graph.Edges.Weight, ...
    'LineWidth', 4 * graph.Edges.Weight / max(graph.Edges.Weight), ...
    'ArrowSize', 15);
title('Graph representing nodes and link cost')
xlabel('X Axis')
ylabel('Y Axis')

%% Calculate and plot the shortest path

[shortest_path, path_len] = shortestpath(graph, 'So', 'Si');
figure('Name', 'Shortest Path - Graph')
s_g_plot = plot(graph, ...
    'EdgeLabel', graph.Edges.Weight, ...
    'LineWidth', 4 * graph.Edges.Weight / max(graph.Edges.Weight), ...
    'ArrowSize', 15);
highlight(s_g_plot, shortest_path, 'MarkerSize', 6, ...
    'NodeColor', 'r', 'EdgeColor', 'g');
title(sprintf('Graph representing shortest path between %s and %s', ...
    'So', 'Si'))
xlabel('X Axis')
ylabel('Y Axis')


%% Print the computation results

disp(strcat(sprintf('Shortest path sequence: %s', shortest_path{1}), ...
    sprintf(' -> %s', shortest_path{2:end})))
fprintf('Shortest path cost: %d $/Tb\n', path_len)
