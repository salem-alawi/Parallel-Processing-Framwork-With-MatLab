function celltowerGUI()
% CELLTOWERGUI

% Copyright 2006-2011 The MathWorks, Inc.

% Default Parameter Values
default.towers = [15 40];
default.side   = [10 15];
default.seed   = [5  5 ];
default.tol    = [0.001 0.1];

% Initial Parameters
param.towers = default.towers(1);
param.side   = default.side(1);
param.seed   = default.seed(1);
param.tol    = default.tol(1);

% Generate Figure
figH = findobj('type', 'figure', 'tag', 'phonetowerGUI');
if ishandle(figH)
   close(figH);
end
figH = figure(...
   'name'                            , 'Phone Tower Location', ...
   'numbertitle'                     , 'off', ...
   'tag'                             , 'phonetowerGUI', ...
   'color'                           , [.8 .8 .8], ...
   'menubar'                         , 'none', ...
   'defaultuicontrolunits'           , 'normalized', ...
   'defaultuicontrolbackgroundcolor' , [.8 .8 .8], ...
   'defaultuicontrolfontunits'       , 'points', ...
   'defaultuicontrolfontsize'        , 12);

menuH = uimenu(...
   'Parent'    , figH, ...
   'Label'     , 'MATLABPool');
uimenu(...
   'Parent'    , menuH, ...
   'Label'     , 'Start MATLABPool', ...
   'Callback'  , @startMLPool);
uimenu(...
   'Parent'    , menuH, ...
   'Label'     , 'Stop MATLABPool', ...
   'Callback'  , @stopMLPool);

axes(...
   'units'           , 'normalized', ...
   'position'        , [.05 .05 .7 .85], ...
   'box'             , 'on', ...
   'tag'             , 'mainaxes', ...
   'FontUnits'       , 'normalized');

uicontrol(...
   'style'           , 'text', ...
   'position'        , [.77 .85 .2, .05], ...
   'fontweight'      , 'bold', ...
   'string'          , 'Seed');
uicontrol(...
   'style'           , 'text', ...
   'position'        , [.77 .7 .2, .05], ...
   'fontweight'      , 'bold', ...
   'string'          , 'Side');
uicontrol(...
   'style'           , 'text', ...
   'position'        , [.77 .55 .2, .05], ...
   'fontweight'      , 'bold', ...
   'string'          , 'Towers');
uicontrol(...
   'style'           , 'text', ...
   'position'        , [.77 .4 .2, .05], ...
   'fontweight'      , 'bold', ...
   'string'          , 'Tolerance');
uicontrol(...
   'style'           , 'edit', ...
   'position'        , [.77 .78 .2, .07], ...
   'backgroundcolor' , 'white', ...
   'string'          , num2str(param.seed), ...
   'callback'        , @changeParamCallback, ...
   'tag'             , 'seed');
uicontrol(...
   'style'           , 'edit', ...
   'position'        , [.77 .63 .2, .07], ...
   'backgroundcolor' , 'white', ...
   'string'          , num2str(param.side), ...
   'callback'        , @changeParamCallback, ...
   'tag'             , 'side');
uicontrol(...
   'style'           , 'edit', ...
   'position'        , [.77 .48 .2, .07], ...
   'backgroundcolor' , 'white', ...
   'string'          , num2str(param.towers), ...
   'callback'        , @changeParamCallback, ...
   'tag'             , 'towers');
uicontrol(...
   'style'           , 'edit', ...
   'position'        , [.77 .33 .2, .07], ...
   'backgroundcolor' , 'white', ...
   'string'          , num2str(param.tol), ...
   'callback'        , @changeParamCallback, ...
   'tag'             , 'tol');

uicontrol(...
   'style'           , 'text', ...
   'position'        , [.77 .21 .2, .05], ...
   'fontweight'      , 'normal', ...
   'string'          , '', ...
   'tag'             , 'time');

uicontrol(...
   'style'           , 'pushbutton', ...
   'position'        , [.77 .13 .2, .07], ...
   'fontweight'      , 'bold', ...
   'callback'        , @runBtnCallback, ...
   'string'          , 'Run', ...
   'tag'             , 'run');
uicontrol(...
   'style'           , 'togglebutton', ...
   'position'        , [.77 .05 .2, .07], ...
   'fontweight'      , 'bold', ...
   'callback'        , @pauseBtnCallback, ...
   'string'          , 'Pause', ...
   'tag'             , 'pause', ...
   'enable'          , 'off');

htoggle = uibuttongroup('visible','off','Position',[.77 .92 .2, .07], ...
   'backgroundcolor', [.8 .8 .8]);
toggleobj(1) = uicontrol('Style','Radio','String','1','units','normalized',...
   'pos',[0.1 0.05 .4 .9],'parent',htoggle,'HandleVisibility','off');
toggleobj(2) = uicontrol('Style','Radio','String','2','units','normalized',...
   'pos',[0.5 0.05 .4 .9],'parent',htoggle,'HandleVisibility','off');
set(htoggle,'SelectionChangeFcn', @defaultValueCallback);
set(htoggle,'SelectedObject',toggleobj(1));  % No selection
set(htoggle,'Visible','on');

set(findobj(figH, 'Type', 'uicontrol'), 'FontUnits', 'Normalized');
set(toggleobj, 'FontUnits', 'Normalized');

handles = guihandles(figH);

stopOptim  = false;
pauseOptim = false;

% Initialize
[dimensions, lb, ub, x0] = ...
   helper.celltowersetup(param.towers, param.side, param.seed);

helper.plotFcn(x0, 0, '', dimensions);

%-------------------------------------------------
   function changeParamCallback(obj, edata)
      
      tmp = str2double(get(obj, 'string'));
      
      try
         switch get(obj, 'tag')
            case 'towers'
               validateattributes(tmp, {'double'}, {'scalar', 'integer', '>=', 3, '<=', 50}, '', '"Towers"');
            case 'side'
               validateattributes(tmp, {'double'}, {'scalar', 'integer', '>=', 5, '<=', 40}, '', '"Side"');
            case 'seed'
               validateattributes(tmp, {'double'}, {'scalar', '>=', 0}, '', '"Seed"');
            case 'tol'
               validateattributes(tmp, {'double'}, {'scalar', '>', 0}, '', '"Tolerance"');
         end
      catch ME
         uiwait(errordlg(ME.message, 'modal'));
         tmp = param.(get(obj, 'tag'));
      end
      
      param.(get(obj, 'tag')) = tmp;
      set(obj, 'string', num2str(tmp));
      
      [dimensions, lb, ub, x0] = ...
         helper.celltowersetup(param.towers, param.side, param.seed);
      helper.plotFcn(x0, 0, '', dimensions);
      
   end
%-------------------------------------------------

%-------------------------------------------------
   function startMLPool(obj, edata)
      if matlabpool('size') > 0
         msgbox('MATLAB Pool is already running', 'modal');
      else
         hW = waitbar(1, 'Starting MATLABPool');
         matlabpool open local 2
         delete(hW);
      end
   end
%-------------------------------------------------
%-------------------------------------------------
   function stopMLPool(obj, edata)
      if matlabpool('size') == 0
         msgbox('MATLAB Pool is not running', 'modal');
      else
         hW = waitbar(1, 'Closing MATLABPool');
         matlabpool close
         delete(hW);
      end
   end
%-------------------------------------------------

%-------------------------------------------------
   function defaultValueCallback(obj, edata)
      
      idx = str2double(get(edata.NewValue, 'String'));
      param.towers = default.towers(idx);
      param.side   = default.side(idx);
      param.seed   = default.seed(idx);
      param.tol    = default.tol(idx);
      set(handles.seed  , 'String', param.seed);
      set(handles.towers, 'String', param.towers);
      set(handles.side  , 'String', param.side);
      set(handles.tol   , 'String', param.tol);
      
      [dimensions, lb, ub, x0] = ...
         helper.celltowersetup(param.towers, param.side, param.seed);
      helper.plotFcn(x0, 0, '', dimensions);
      
   end
%-------------------------------------------------

%-------------------------------------------------
   function runBtnCallback(obj, edata)
      
      if strcmp(get(obj, 'string'), 'Run')
         set(obj           , 'string', 'Stop');
         set(handles.pause , 'enable', 'on');
         set(handles.seed  , 'enable', 'off');
         set(handles.towers, 'enable', 'off');
         set(handles.side  , 'enable', 'off');
         set(handles.tol   , 'enable', 'off');
         set(handles.time  , 'string', '');
         
         options = optimset;
         options = optimset(options, 'Display'    , 'none');
         options = optimset(options, 'TolFun'     , param.tol);
         options = optimset(options, 'OutputFcn'  , {@(x,it,f) helper.plotFcn(x,it,f,dimensions), @helper.myOutputFcn, @optimControlFcn});
         options = optimset(options, 'Algorithm'  , 'active-set');
         options = optimset(options, 'UseParallel', 'always');
         
         startTic = tic;
         [tmp, tmp, tmp, output] = ...
            fmincon(@(x) helper.objFcn(x, dimensions.R), x0, [], [], [], [], lb, ub, [], options); %#ok<ASGLU>
         tm = toc(startTic);
         
         set(handles.time, 'String', sprintf('%0.2f sec', tm));
         fprintf('Elapsed time: %0.2f sec\n', tm);
         
         helper.plotOptimSummary(output,dimensions);
         
         if ~ishandle(figH)
            return;
         end
         
         set(obj           , 'string', 'Run');
         set(handles.pause , 'enable', 'off', 'string', 'Pause', 'value', false);
         set(handles.seed  , 'enable', 'on');
         set(handles.towers, 'enable', 'on');
         set(handles.side  , 'enable', 'on');
         set(handles.tol   , 'enable', 'on');
         stopOptim  = false;
         pauseOptim = false;
         
      else
         
         set(obj           , 'string', 'Run');
         set(handles.pause , 'enable', 'off', 'string', 'Pause', 'value', false);
         set(handles.seed  , 'enable', 'on');
         set(handles.towers, 'enable', 'on');
         set(handles.side  , 'enable', 'on');
         set(handles.tol   , 'enable', 'on');
         stopOptim  = true;
         pauseOptim = false;
         
      end
      
   end
%-------------------------------------------------

%-------------------------------------------------
   function pauseBtnCallback(obj, edata)
      pauseOptim = ~pauseOptim;
      if pauseOptim
         set(obj, 'string', 'Resume');
      else
         set(obj, 'string', 'Pause');
      end
   end
%-------------------------------------------------

%-------------------------------------------------
   function stop = optimControlFcn(x,itervals,flag)
      % Control the flow of the optimization (pause, resume, stop)
      
      if ~ishandle(figH)
         stop = true;
         return;
      end
      
      switch flag
         case {'iter', ''}
            while pauseOptim && ishandle(figH)
               drawnow;
            end
      end
      
      stop = stopOptim;
      
   end
%-------------------------------------------------


end


%#ok<*INUSD>
%#ok<*INUSL>