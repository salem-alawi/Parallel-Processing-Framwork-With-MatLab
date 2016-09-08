function  [dim,lb,ub,x0] = celltowersetup(N,up,seed) 
% CELLTOWERSETUP creates a randomly generated celltower problem.
%   [dim,lb,ub,x0] = CELLTOWERSETUP(N, SIDE, SEED)
%
%   Input:
%           N    : number of towers
%           SIDE : length of the side of area
%           SEED : random seed for initial cell location (integer)
%   Output:
%           dim.R    : radius of cell tower coverage
%           dim.xL   : 0       % for plotting
%           dim.xU   : SIDE    % for plotting
%           dim.yL   : 0       % for plotting
%           dim.yU   : SIDE    % for plotting
%           lb       : lower bound values for x, y (based on the radius)
%           ub       : upper bound values for x, y (based on the radius) 
%           x0       : initial center points (x, y pairs)
%
% Copyright 2003-2011 The MathWorks, Inc. 

low = 0;
st = RandStream('mcg16807', 'Seed', seed);
R = rand(st, N,1)+1; % allocate array

% Generate bound constraints
xL = low; xU = up;
yL = low; yU = up;
% 2*N variables in the order [x1,y1,x2,y2...,xn,yn]'
lb = zeros(2*N,1);
ub = lb;
lb(1:2:2*N) = xL + R;
lb(2:2:2*N) = yL + R;
ub(1:2:2*N) = xU - R;
ub(2:2:2*N) = yU - R;

% Random start point
x0 = up*rand(st, 2*N,1);

dim = struct('R', R, 'xL', xL, 'xU', xU, 'yL', yL, 'yU', yU);