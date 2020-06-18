%%
%   Author: Yash Bansod
%   Date: 13th February, 2020  
%   Problem 1 - Natural gas processing plant optimization
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;

%% Define the optimization problem

% Define the objective function
f = [-150 -175];

% Constraint matrix and vector (A*X <= B)
A = [7 11; 10 8; 1 0; 0 1];
B = [77; 80; 9; 6];

Aeq = [];
beq = [];
lb = zeros(2, 1);
ub = inf(2, 1);

%% Find the solution

% Compute the solution using linear programming
[X, fval] = linprog(f, A, B, Aeq, beq, lb, ub);

% print out the solution obtained using linear programming
fprintf('Solution using linear programming: X1 = %f, X2 = %f\n', X)
fprintf('Profit: %f\n\n', -fval)

% Compute the solution using integer programming
[X, fval] = intlinprog(f, [1 2], A, B, Aeq, beq, lb, ub);

% print out the solution obtained using integer programming
fprintf('Solution using integer programming: X1 = %d, X2 = %d\n', X)
fprintf('Profit: %d\n\n', -fval)