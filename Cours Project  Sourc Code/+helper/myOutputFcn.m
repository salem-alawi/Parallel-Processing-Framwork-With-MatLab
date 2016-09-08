function stop = myOutputFcn(x, optimValues, state)

% Stores intermediate optimization results
% Use this as a custom output function

% Copyright 2006-2011 The MathWorks, Inc.

stop = false;

switch state
  case 'init'
    setappdata(0, 'optim_xSaved', []);
    
  case 'iter'
    setappdata(0, 'optim_xSaved', [getappdata(0, 'optim_xSaved'), x]);
        
end