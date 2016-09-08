function varargout = Parallel_Processing(varargin)
% PARALLEL_PROCESSING MATLAB code for Parallel_Processing.fig
%      PARALLEL_PROCESSING, by itself, creates a new PARALLEL_PROCESSING or raises the existing
%      singleton*.
%
%      H = PARALLEL_PROCESSING returns the handle to a new PARALLEL_PROCESSING or the handle to
%      the existing singleton*.
%
%      PARALLEL_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARALLEL_PROCESSING.M with the given input arguments.
%
%      PARALLEL_PROCESSING('Property','Value',...) creates a new PARALLEL_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parallel_Processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Parallel_Processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parallel_Processing

% Last Modified by GUIDE v2.5 04-Sep-2016 11:46:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parallel_Processing_OpeningFcn, ...
                   'gui_OutputFcn',  @Parallel_Processing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Parallel_Processing is made visible.
function Parallel_Processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Parallel_Processing (see VARARGIN)

% Choose default command line output for Parallel_Processing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Parallel_Processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Parallel_Processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_Run.
function btn_Run_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
profile on   % Start the profile
contents_problem= get(handles.dl_problems,'value');%  get the index of the problem none = 1   ,  Cell Tower = 2 
contents_statuse= get(handles.dl_status,'value');  %  get the index of the Operation   none=1 , Seqence=2  , Parallel =3

switch contents_problem 
    case 2  % Choose the Cell Tower
towers = 40;  % number of towers
side = 15;    % dimension of piece of land (one side)
seed = 5;     % seed for random initial condition (not relavent to optimization
[dimensions,lb,ub,x0] = helper.celltowersetup(towers,side,seed);

if(contents_statuse==2)        %  single process

 tic %Start Timer 
 
[x,fval,exitflag,output] = helper.myOptim(x0,lb,ub,dimensions);
time= toc;
set(handles.txt_result,'string',time);
helper.plotOptimSummary(output,dimensions); % comparing between all step to finsh
set(handles.txt_core1,'string',time);

elseif(contents_statuse==3)   % parallel process
 no=get(handles.dl_no_core,'value');
  %%%% parpool   in matlab 2016 and up 
 matlabpool(no)
  
tic
[x,fval,exitflag,output] = helper.myOptim(x0,lb,ub,dimensions);
time= toc;
set(handles.txt_result,'string',time);
helper.plotOptimSummary(output,dimensions);  % comparing between all step to finsh
switch(no)
    
    case 1
    set(handles.txt_core1,'string',time);
       
    case 2
        set(handles.txt_core2,'string',time);
        
    case 3  
        set(handles.txt_core3,'string',time);
       
    case 4
        set(handles.txt_core4,'string',time);
       
    case 5
        set(handles.txt_core5,'string',time);
       
    case 6
        set(handles.txt_core6,'string',time);
       
    case 7
        set(handles.txt_core7,'string',time);
       
    case 8
        set(handles.txt_core8,'string',time);
    otherwise
           
end
   %%%%%%  parpool close force     2016  and up
matlabpool close force
 profile off
else
    set(handles.txt_result,'string','please chose single or parallel');
    
end
    case 3
        
        
        % here new problem   to Enter
    otherwise
       set(handles.txt_result,'string','please chose the problem first');
        
end

 
% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a2='0.0';
set(handles.txt_result,'string',a2);

% --- Executes on selection change in dl_problems.
function dl_problems_Callback(hObject, eventdata, handles)
% hObject    handle to dl_problems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.dl_problems,'value')==2)
set(handles.btn_brows_problem,'String','Cell Tower');
else
    set(handles.btn_brows_problem,'String','');
end


% Hints: contents = cellstr(get(hObject,'String')) returns dl_problems contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dl_problems


% --- Executes during object creation, after setting all properties.
function dl_problems_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dl_problems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dl_status.
function dl_status_Callback(hObject, eventdata, handles)
% hObject    handle to dl_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns dl_status contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dl_status
if(get(handles.dl_status,'value')==2)
  set(handles.dl_no_core,'Enable','off') 
else
 set(handles.dl_no_core,'Enable','on') 
end
% --- Executes during object creation, after setting all properties.
function dl_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dl_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dl_no_core.
function dl_no_core_Callback(hObject, eventdata, handles)
% hObject    handle to dl_no_core (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dl_no_core contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dl_no_core


% --- Executes during object creation, after setting all properties.
function dl_no_core_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dl_no_core (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_result.
function btn_result_Callback(hObject, eventdata, handles)
% hObject    handle to btn_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c1=str2num(get(handles.txt_core1,'string'));
c2=str2num(get(handles.txt_core2,'string'));
c3=str2num(get(handles.txt_core3,'string'));
c4=str2num(get(handles.txt_core4,'string'));
c5=str2num(get(handles.txt_core5,'string'));
c6=str2num(get(handles.txt_core6,'string'));
c7=str2num(get(handles.txt_core7,'string'));
c8=str2num(get(handles.txt_core8,'string'));

oo=[c1 c2 c3 c4 c5 c6 c7 c8];
% x=openfig('second2.fig')
figure;
bar(oo); 
xlabel('Number Of Core ');
ylabel('Excution Time');


% --- Executes on button press in btn_profile.
function btn_profile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
profile viewer


% --- Executes on button press in btn_brows_problem.
function btn_brows_problem_Callback(hObject, eventdata, handles)
% hObject    handle to btn_brows_problem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.dl_problems,'value')==2)
winopen('cell tower description.txt');
else
 
end


% --- Executes on button press in btn_dev.
function btn_dev_Callback(hObject, eventdata, handles)
% hObject    handle to btn_dev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = msgbox({'University Of Aden ' '' 'Salem Alawi Mohammed '   'Anes Fuad Alawi'  'Amr Abdullah Mohammed'});