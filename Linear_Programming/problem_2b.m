%%
%   Author: Yash Bansod
%   Date: 13th February, 2020  
%   Problem 2b - Automobile Shop Optimization (Dual)
%
% GitHub: <https://github.com/YashBansod>

%% Clear the environment and the command line
clear;
clc;

%% Define the optimization problem

% Define the objective function
f = [24 60];

% Constraint matrix and vector (A*Y <= B)
A = [-0.5 -1; -2 -2; -1 -4];
B = [-6; -14; -13];

Aeq = [];
beq = [];
lb = zeros(2, 1);
ub = inf(2, 1);

%% Find the solution

% Compute the solution using linear programming
[Y, fval] = linprog(f, A, B, Aeq, beq, lb, ub);

% print out the solution obtained using linear programming
sprintf('Solution using linear programming: Y1 = %f, Y2 = %f', Y)
sprintf('Minimum acceptable price: %f', fval)
