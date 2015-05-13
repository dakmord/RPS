function varargout = legacyCodeHelper(varargin)
% LEGACYCODEHELPER MATLAB code for legacyCodeHelper.fig
%      LEGACYCODEHELPER, by itself, creates a new LEGACYCODEHELPER or raises the existing
%      singleton*.
%
%      H = LEGACYCODEHELPER returns the handle to a new LEGACYCODEHELPER or the handle to
%      the existing singleton*.
%
%      LEGACYCODEHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEGACYCODEHELPER.M with the given input arguments.
%
%      LEGACYCODEHELPER('Property','Value',...) creates a new LEGACYCODEHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before legacyCodeHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to legacyCodeHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help legacyCodeHelper

% Last Modified by GUIDE v2.5 11-May-2015 23:41:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @legacyCodeHelper_OpeningFcn, ...
                   'gui_OutputFcn',  @legacyCodeHelper_OutputFcn, ...
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

%% Custom Block Creation using Mathworks Legacy Code Tool
% tbd...


% --- Executes just before legacyCodeHelper is made visible.
function legacyCodeHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to legacyCodeHelper (see VARARGIN)

% Basic handles
handles.selectedFiles = {}; % structure:
                            % struct.files{}
                            % struct.path
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
handles.parameterizedSample = true;
handles.showBlockPreview = true;
handles.generateTlc = true;
handles.outputPath = fullfile(handles.homeDir,'tmp_legacy');
handles.outputFunction = '';
handles.startFunction = '';
handles.terminateFunction = '';
handles.name = '';
handles.cpp = false;
set(handles.edit_outputPath,'String', handles.outputPath);

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','bmw_icons_18','c_logo.png'));
jframe.setFigureIcon(jIcon);


% Choose default command line output for legacyCodeHelper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes legacyCodeHelper wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = legacyCodeHelper_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start loading screen..
enableDisableFig(gcf,'off');
try
    animationHandle = showLoadingAnimation('Generating Block Output...', 'Collecting data...');

    % Actualize Every Handle
    handles.parameterizedSample = get(handles.cb_parameterizedSample, 'Value');
    handles.showBlockPreview = get(handles.cb_blockPreview, 'Value');
    handles.generateTlc = get(handles.cb_tlcFile, 'Value');
    handles.outputPath = get(handles.edit_outputPath, 'String');
    handles.outputFunction = get(handles.edit_outputFunction, 'String');
    handles.name = get(handles.edit_sfuncName, 'String');
    handles.startFunction = get(handles.edit_startFcn, 'String');
    handles.terminateFunction = get(handles.edit_terminateFcn, 'String');
    handles.cpp = get(handles.cb_cpp, 'Value');

    % Check for minimal configuration
    if isempty(handles.name) || isempty(handles.outputPath) || ...
            isempty(handles.outputFunction) || isempty(handles.selectedFiles)
        errordlg('Please provide all * marked input parameter.','Missing Input Parameter');
        return;
    end

    % Initialize legacy code tool...
    animationHandle.setProgressStatusLabel('Please wait, initializing legacy...');
    spec = legacy_code('initialize');
    spec.SFunctionName = handles.name;

    % Define Header/Sources
    sources = {};
    srcPaths = {};
    headers = {};
    headerPaths = {};

    for i=1:1:length(handles.selectedFiles)
        for p=1:1:length(handles.selectedFiles{i}.files)
            tmpFile = handles.selectedFiles{i}.files{p};
            if ~isempty(strfind(tmpFile,'.c')) || ~isempty(strfind(tmpFile,'.C'))
                % Source
                sources{end+1} = fullfile(tmpFile);
                srcPaths{end+1} = handles.selectedFiles{i}.path;
            elseif ~isempty(strfind(tmpFile,'.h')) || ~isempty(strfind(tmpFile,'.H'))
                % Header
                headers{end+1} = fullfile(tmpFile);
                headerPaths{end+1} = handles.selectedFiles{i}.path;
            end
        end
    end
    spec.HeaderFiles = headers;
    spec.SourceFiles = sources;
    spec.IncPaths = headerPaths;
    spec.SrcPaths = srcPaths;

    % Define Functions
    spec.OutputFcnSpec = handles.outputFunction;
    spec.TerminateFcnSpec = handles.terminateFunction;
    spec.StartFcnSpec = handles.startFunction;

    % Define SampleTime
    if handles.parameterizedSample==true
        spec.SampleTime = 'parameterized';
    else
        spec.SampleTime = 'inherited';
    end

    % Define Language
    if handles.cpp == true
        spec.Options.language = 'C++';
    else
        spec.Options.language = 'C';
    end

    % Test Options
    %spec.Options.singleCPPMexFile = true;

    % Change to output Path
    currentPath = pwd;

    if isdir(handles.outputPath)
        % everything fine...
        cd(handles.outputPath);
    else
        % Create Dir
        mkdir(handles.outputPath);
        cd(handles.outputPath);
    end

    try
        % Compile
        animationHandle.setProgressStatusLabel('Please wait, compiling...');
        legacy_code('sfcn_cmex_generate', spec);
        legacy_code('compile', spec);
        legacy_code('rtwmakecfg_generate', spec);
        % Show Block preview in model?
        if handles.showBlockPreview==true
            legacy_code('slblock_generate', spec);
        end

        % Generate TLC-File?
        if handles.generateTlc==true
            legacy_code('sfcn_tlc_generate', spec);
        end

        % GO back to previous directory
        cd(currentPath);
    catch
        cd(currentPath);
        error('Error compiling s-function using legacyCodeTool...');
    end
    enableDisableFig(gcf,'on');
catch
    enableDisableFig(gcf,'on');
end
hideLoadingAnimation(animationHandle);


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on button press in btn_add.
function btn_add_Callback(hObject, eventdata, handles)
% hObject    handle to btn_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[files, path] = uigetfile({'*.c;*.h', 'C/Header-Files (*.c/*.h)';...
    '*.*','All Files (*.*)'},...
    'Pick C-Source and/or Header Files...',...
    'MultiSelect', 'on');
if ~isequal(files,0)
    tmp.files = {};
    if ischar(files)
            tmp.files{end+1} = files;
            tmp.path = path;
    else
        for i=1:1:length(files)
            tmp.files{end+1} = files{i};
            tmp.path = path;
        end
    end
    handles.selectedFiles{end+1} = tmp; 
    guidata(hObject, handles);
    % Refresh Listbox
    actualizeListbox(hObject, handles);
end


function actualizeListbox(hObject, handles)
% Reset
set(handles.files_listbox, 'String', '');
% Get all files..
tmpString = {};
for i=1:1:length(handles.selectedFiles)
    for p=1:1:length(handles.selectedFiles{i}.files)
        tmpString{end+1} = handles.selectedFiles{i}.files{p};
    end
end
set(handles.files_listbox, 'String', tmpString);


function deleteFile(hObject, handles, fileName)
for i=1:1:length(handles.selectedFiles)
    for p=1:1:length(handles.selectedFiles{i}.files)
        if strcmp(handles.selectedFiles{i}.files{p},fileName)
            handles.selectedFiles{i}.files(p)=[];
        end
    end
end
guidata(hObject, handles);

% --- Executes on button press in btn_help.
function btn_help_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showdemo legacyCodeHelper;

% --- Executes on button press in cb_tlcFile.
function cb_tlcFile_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tlcFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_tlcFile
handles.generateTlc = get(hObject, 'Value');
guidata(hObject, handles);

% --- Executes on button press in cb_blockPreview.
function cb_blockPreview_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blockPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_blockPreview
handles.showBlockPreview = get(handles.cb_blockPreview, 'Value');
guidata(hObject, handles);

% --- Executes on selection change in files_listbox.
function files_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns files_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from files_listbox


% --- Executes during object creation, after setting all properties.
function files_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_delete.
function btn_delete_Callback(hObject, eventdata, handles)
% hObject    handle to btn_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = get(handles.files_listbox,'Value');
prev_str = get(handles.files_listbox, 'String');
if ~isempty(selected)
    fileName = prev_str{selected};
    % Actualize Handles
    deleteFile(hObject, handles, fileName);
end
len = length(prev_str);
if len > 0
    if selected(1) == 1
        indices = [(selected(end)+1):length(prev_str)];
    else
        indices = [1:(selected(1)-1) (selected(end)+1):length(prev_str)];
    end
    prev_str = prev_str(indices);
    set(handles.files_listbox, 'String', prev_str, 'Value', min(selected, length(prev_str)));
end



function edit_sfuncName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sfuncName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sfuncName as text
%        str2double(get(hObject,'String')) returns contents of edit_sfuncName as a double


% --- Executes during object creation, after setting all properties.
function edit_sfuncName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sfuncName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outputFunction_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputFunction as text
%        str2double(get(hObject,'String')) returns contents of edit_outputFunction as a double


% --- Executes during object creation, after setting all properties.
function edit_outputFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputFunction_btn.
function outputFunction_btn_Callback(hObject, eventdata, handles)
% hObject    handle to outputFunction_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_parameterizedSample.
function cb_parameterizedSample_Callback(hObject, eventdata, handles)
% hObject    handle to cb_parameterizedSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_parameterizedSample
handles.parameterizedSample = get(hObject, 'Value');
guidata(hObject, handles);


function edit_outputPath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputPath as text
%        str2double(get(hObject,'String')) returns contents of edit_outputPath as a double
handles.outputPath = get(handles.edit_outputPath,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_outputPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_outputPathSelector.
function btn_outputPathSelector_Callback(hObject, eventdata, handles)
% hObject    handle to btn_outputPathSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir = uigetdir(handles.homeDir,'Select Output Path for Block Generation...');
if dir~=0
    set(handles.edit_outputPath,'String',dir);
    handles.outputPath = dir;
    guidata(hObject, handles);
end



function edit_startFcn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startFcn as text
%        str2double(get(hObject,'String')) returns contents of edit_startFcn as a double


% --- Executes during object creation, after setting all properties.
function edit_startFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_terminateFcn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_terminateFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_terminateFcn as text
%        str2double(get(hObject,'String')) returns contents of edit_terminateFcn as a double


% --- Executes during object creation, after setting all properties.
function edit_terminateFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_terminateFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_cpp.
function cb_cpp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_cpp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_cpp


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'f1')
    %open help
    showdemo legacyCodeHelper;
end
