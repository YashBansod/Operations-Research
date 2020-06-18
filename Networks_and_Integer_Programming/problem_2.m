%%
%   Author: Yash Bansod
%   Date: 19th February, 2020  
%   Problem 2 - Transshipment/Production Problem
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;
close all;

%% Define the graph

% Specify the node names
n_names = {'LA', 'SE', 'CH', 'DA', 'PH', 'BA'};

% Specify the edges and thier costs
e_start = [ 1 1 1 1 1; 
            2 2 2 2 2; 
            3 3 3 3 3;
            4 4 4 4 4;
            5 5 5 5 5;
            6 6 6 6 6]';
e_start = e_start(:)';

e_stop  = [ 2 3 4 5 6;
            1 3 4 5 6;
            1 2 4 5 6;
            1 2 3 5 6;
            1 2 3 4 6;
            1 2 3 4 5]';
e_stop = e_stop(:)';
        
e_cost  = [ 90 150 100 200 250;
            90 100 120 180 240;
            150 100 50 120 140;
            100 120 50 100 150;
            200 180 120 100 30;
            250 240 140 150 30]';
e_cost = e_cost(:)';

% Some dimension checks to make sure values were inputted correctly
assert(size(e_start, 2) == size(e_stop, 2));
assert(size(e_start, 2) == size(e_cost, 2));

% Create the graph
graph = digraph(e_start, e_stop, e_cost, n_names);

%% Plotting the graph to visualize it better

figure('Name', 'Shortest Path - Graph')
g_plot = plot(graph, ...
    'EdgeLabel', graph.Edges.Weight, ...
    'LineWidth', 4 * graph.Edges.Weight / max(graph.Edges.Weight), ...
    'ArrowSize', 15);
title('Graph representing cities and the paths between them')
xlabel('X Axis')
ylabel('Y Axis')

%% Calculate the least cost paths from production plants to markets

[shortest_path_ch_la, cost_ch_la] = shortestpath(graph, 'CH', 'LA');
[shortest_path_ch_ba, cost_ch_ba] = shortestpath(graph, 'CH', 'BA');
[shortest_path_da_la, cost_da_la] = shortestpath(graph, 'DA', 'LA');
[shortest_path_da_ba, cost_da_ba] = shortestpath(graph, 'DA', 'BA');

%% Define the optimization problem

f = [cost_ch_la cost_ch_ba cost_da_la cost_da_ba];

A = [1 1 0 0; 0 0 1 1];
B = [100; 200];

Aeq = [1 0 1 0; 0 1 0 1];
Beq = [120; 160];

lb = zeros(4, 1);
ub = inf(4, 1);

%% Find the solution

% Compute the solution using linear programming
[X, fval] = intlinprog(f, [1 2 3 4], A, B, Aeq, Beq, lb, ub);

%% Print the computation results

% print out the least cost paths obtained using graph search
disp('Let C_A_B represent least cost path from city A to city B.')
fprintf([ 'Least cost of paths: \nC_CH_LA = %.2f' ...
    '\nC_CH_BA = %.2f \nC_DA_LA = %.2f \nC_DA_BA = %.2f\n\n'], f)

% print out the solution obtained using integer programming
disp('Let X_A_B represent number of drones shipped from city A to city B.')
fprintf([ 'Solution using integer programming: \nX_CH_LA = %d' ...
    '\nX_CH_BA = %d \nX_DA_LA = %d \nX_DA_BA = %d\n\n'], X)
fprintf('Cost of Shipment: %.2f dollars/week\n', fval)
