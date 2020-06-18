%%
%   Author: Yash Bansod
%   Date: 13th February, 2020  
%   Problem 2a - Automobile Shop Optimization
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;

%% Define the optimization problem

% Define the objective function
f = [-6 -14 -13];

% Constraint matrix and vector (A*X <= B)
A = [0.5 2 1; 1 2 4];
B = [24; 60];

Aeq = [];
beq = [];
lb = zeros(3, 1);
ub = inf(3, 1);

%% Find the solution

% Compute the solution using linear programming
[X, fval] = linprog(f, A, B, Aeq, beq, lb, ub);

% print out the solution obtained using linear programming
sprintf('Solution using linear programming: X1 = %f, X2 = %f, X3 = %f', X)
sprintf('Profit: %f', -fval)

% Compute the solution using integer programming
[X, fval] = intlinprog(f, [1 2 3], A, B, Aeq, beq, lb, ub);

% print out the solution obtained using integer programming
sprintf('Solution using integer programming: X1 = %d, X2 = %d, X3 = %d', X)
sprintf('Profit: %d', -fval)