%%
%   Author: Yash Bansod
%   Date: 11th March, 2020  
%   Problem 4 - Transshipment Problem
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the graph

% Specify the node names
n_names = {'P1', 'P2', 'WH1', 'WH2', 'RO1', 'RO2', 'RO3'};
num_nodes = size(n_names, 2);

% Specify the edges and thier costs
e_start = [1 1 2 2 3 3 3 4 4 4];
e_stop  = [3 4 3 4 5 6 7 5 6 7];
e_cost  = [425 560 510 600 470 505 490 390 410 440];

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
title('Graph representing nodes and shipping costs')
xlabel('X Axis')
ylabel('Y Axis')

%% Define the optimization problem

f = e_cost;

A = [   1 1 0 0 0 0 0 0 0 0; 
        0 0 1 1 0 0 0 0 0 0];
    
B = [200; 300];

Aeq = [ 0 0 0 0 1 0 0 1 0 0; 
        0 0 0 0 0 1 0 0 1 0; 
        0 0 0 0 0 0 1 0 0 1;
        1 0 1 0 -1 -1 -1 0 0 0; 
        0 1 0 1 0 0 0 -1 -1 -1];
    
Beq = [100; 150; 100; 0; 0];

lb = zeros(10, 1);
ub = [125; 150; 175; 200; 100; 150; 100; 125; 150; 75];

%% Find the solution

% Compute the solution using linear programming
[X, fval] = intlinprog(f, 1:10, A, B, Aeq, Beq, lb, ub);

%% Print the computation results

% print out the solution obtained using integer programming
fprintf('Cost of Shipment: %d dollars\n\n', fval)
disp("Units Shipped [From->To:Number]");
% Optimal Plan
for index = 1:size(e_start, 2)
    print_str = strcat(n_names{e_start(index)}, '->', ...
        n_names{e_stop(index)}, ': ', int2str(X(index)));
    fprintf('[%s]\n', print_str);
end

