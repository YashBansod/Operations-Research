%%
%   Author: Yash Bansod
%   Date: 19th February, 2020  
%   Problem 3 - Critical Path Method
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the graph

% Specify the node names
n_names = {'N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9'};
num_nodes = size(n_names, 2);

% Specify the edges and thier costs
e_start = [1 1 2 3 3 3 4 5 6 7 8];
e_stop  = [2 3 4 4 5 6 7 7 8 9 9];
e_cost  = [6 4.33 3.33 9 10 15.83 8.83 2 3.33 15 8.83];

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
title('Graph representing nodes and mean activity duration')
xlabel('X Axis')
ylabel('Y Axis')

%% Calculate the longest path

% Create a matrix that stores the longest known path from the node marked
% by index to the end.
max_len = zeros(1, num_nodes);
% Create a matrix that indicates nodes that follow a node on critical path
follow_node = zeros(1, num_nodes);

% distance/cost matrix of going from (row) node i to (column) node j                                     
dist_mat = -inf(num_nodes);
for index = 1:size(e_start, 2)
    dist_mat(e_start(index), e_stop(index)) = e_cost(index);
end

% Simplified Bellman-Ford Algorithm
% Longest known path from node n-1 to n is the edge from n-1 to n
max_len(num_nodes - 1) = dist_mat(num_nodes - 1, num_nodes);

% Working back from node n-2 to compute longest path from node i to end
for i_ind = num_nodes-2:-1:1
    for j_ind = i_ind+1:num_nodes
        
        % If longest path length from node j to end + path length from node
        % i to j is greater than longest known path from node i to end then
        if max_len(j_ind) + dist_mat(i_ind, j_ind) > max_len(i_ind)
            
            % longest path length from node i to end equals the longest
            % path length from node j to end + path length from node i to j
            max_len(i_ind) = max_len(j_ind) + dist_mat(i_ind, j_ind);
            % node i is followed by node j in the longest known path
            follow_node(i_ind) = j_ind;
       end
    end
end

% Calculate the Critical Path
critical_path = zeros(1, num_nodes);
critical_path(1) = 1;   % Start node always lies on the critical path

for path_ctr = 2:1:num_nodes
    critical_path(path_ctr) = follow_node(critical_path(path_ctr -1));
    if critical_path(path_ctr) == 0
        critical_path(path_ctr) = num_nodes;
    end
end
critical_path = n_names(unique(critical_path));

%% Plotting the critical path

figure('Name', 'Critical Path - Graph')
l_g_plot = plot(graph, ...
    'EdgeLabel', graph.Edges.Weight, ...
    'LineWidth', 4 * graph.Edges.Weight / max(graph.Edges.Weight), ...
    'ArrowSize', 15);
title('Graph representing the Critical Path')
xlabel('X Axis')
ylabel('Y Axis')
highlight(l_g_plot, critical_path, 'MarkerSize', 6, ...
    'NodeColor', 'r', 'EdgeColor', 'g');

%% Print the computation results

disp(strcat(sprintf('Critical path: %s', critical_path{1}), ...
    sprintf(' -> %s', critical_path{2:end})))
fprintf('Longest path == Mean project duration: %.2f days\n\n', max_len(1))

%% Calculate the shortest path

[shortest_path, path_len] = shortestpath(graph, 'N1', 'N9');

%% Print the computation results

disp(strcat(sprintf('Shortest path sequence: %s', shortest_path{1}), ...
    sprintf(' -> %s', shortest_path{2:end})))
fprintf('Shortest path cost: %.2f days\n', path_len)
