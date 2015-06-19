function varargout = branchTagSvnDialog(varargin)
% BRANCHTAGSVNDIALOG MATLAB code for branchTagSvnDialog.fig
%      BRANCHTAGSVNDIALOG, by itself, creates a new BRANCHTAGSVNDIALOG or raises the existing
%      singleton*.
%
%      H = BRANCHTAGSVNDIALOG returns the handle to a new BRANCHTAGSVNDIALOG or the handle to
%      the existing singleton*.
%
%      BRANCHTAGSVNDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRANCHTAGSVNDIALOG.M with the given input arguments.
%
%      BRANCHTAGSVNDIALOG('Property','Value',...) creates a new BRANCHTAGSVNDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before branchTagSvnDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to branchTagSvnDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help branchTagSvnDialog

% Last Modified by GUIDE v2.5 13-Jun-2015 21:11:24
%               by Daniel Schneider(EK-704), 01.06.2015, Created Branch/Tag Dialog
%               by Daniel Schneider(EK-704), 08.06.2015, Bugfix because subfolder copy command not possible
%               by ...

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @branchTagSvnDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @branchTagSvnDialog_OutputFcn, ...
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


% --- Executes just before branchTagSvnDialog is made visible.
function branchTagSvnDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to branchTagSvnDialog (see VARARGIN)

% Get Command Line Parameter and Save to Components
% Info: {1} = Repository URL, {2} = Local Revision, {3} = Local Folder, {4}
% = passwordNeeded
set(handles.edit_repoUrl, 'String', varargin{1});
if ~isnumeric(varargin{2})
    % Convert..
    set(handles.edit_localRevision, 'String', num2str(varargin{2}));
else
    set(handles.edit_localRevision, 'String', varargin{2});
end
set(handles.edit_localFolder, 'String', varargin{3});

% Home Dir
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Load svn icon
iconsFolder = fullfile(handles.homeDir, 'rps', 'etc', 'icons_18');
btn_im = imread(fullfile(iconsFolder, 'svn.png'));
set(handles.btn_icon, 'CData', btn_im);

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(iconsFolder, 'BMW-neg_act_open_18.png'));
jframe.setFigureIcon(jIcon);

% Choose default command line output for branchTagSvnDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes branchTagSvnDialog wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = branchTagSvnDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(hObject);

% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Show Loading Animation
d = showLoadingAnimation('Creating Branch/Tag', 'Please wait...');
try
    % Get all component informations...
    handles.log = get(handles.edit_log, 'String');
    handles.repoUrl = get(handles.edit_repoUrl, 'String');
    handles.localRevision = str2num(get(handles.edit_localRevision, 'String'));
    handles.localFolder = get(handles.edit_localFolder, 'String');
    handles.tag = get(handles.radio_tag, 'Value');
    handles.branch = get(handles.radio_branch, 'Value');
    handles.name = get(handles.edit_name, 'String');

    % Get Revision out of Popupmenu
    str = getCurrentPopupString(handles.popupmenu_revision);
    if strcmp(str, '"Revision Number"')
        % Revision by number
        handles.revision = str2num(get(handles.edit_revision, 'String'));
    else
        % Predefined Revision
        handles.revision = str;
    end

    % Check if Input Paramaters are all availabe
    if isempty(handles.name) || isempty(handles.log) || isempty(handles.revision)
        % error missing parameters
        uiwait(errordlg('Please fill in all marked input parameters.', 'Missing Informations!'));
        error('Please fill in all marked input parameters.');
    end

    % Get local URL/Source
    sourceUrl = fullfile(handles.repoUrl{1}, handles.localFolder);

    % Run SVN Command...
    if handles.tag>handles.branch
        % Create Tag    
        % ###Bugfix: removed svn copy from subfolders, 08.06.2015, Daniel Schneider
        destinationUrl = fullfile(handles.repoUrl{1}, 'tags', handles.name);
        [info] = svnAbstraction('copy',handles.revision, handles.log, fullfile(sourceUrl), fullfile(destinationUrl));
        %[info] = createBranchTag(handles.revision, handles.log, fullfile(sourceUrl,'help'), fullfile(destinationUrl,'help'), username, password);
    else
        % Create Branch
        % ###Bugfix: removed svn copy from subfolders, 08.06.2015, Daniel Schneider
        destinationUrl = fullfile(handles.repoUrl{1}, 'branches', handles.name);
        [info] = svnAbstraction('copy',handles.revision, handles.log, fullfile(sourceUrl), fullfile(destinationUrl));
        %[info] = createBranchTag(handles.revision, handles.log, fullfile(sourceUrl,'help'), fullfile(destinationUrl,'help'), username, password);
    end
    if isequal(info,-1)
        error('Error creating Branch/Tag. Something went wrong (Conncetion, Login, ...).');
    end
    hideLoadingAnimation(d);
    close(gcf);
catch err
    hideLoadingAnimation(d);
    rethrow(err);
end

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on button press in btn_tag.
function btn_tag_Callback(hObject, eventdata, handles)
% hObject    handle to btn_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showdemo branchTagSvnDialog;


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_localFolder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_localFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_localFolder as text
%        str2double(get(hObject,'String')) returns contents of edit_localFolder as a double


% --- Executes during object creation, after setting all properties.
function edit_localFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_localFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_localRevision_Callback(hObject, eventdata, handles)
% hObject    handle to edit_localRevision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_localRevision as text
%        str2double(get(hObject,'String')) returns contents of edit_localRevision as a double


% --- Executes during object creation, after setting all properties.
function edit_localRevision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_localRevision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_repoUrl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_repoUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_repoUrl as text
%        str2double(get(hObject,'String')) returns contents of edit_repoUrl as a double


% --- Executes during object creation, after setting all properties.
function edit_repoUrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_repoUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_revision_Callback(hObject, eventdata, handles)
% hObject    handle to edit_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_revision as text
%        str2double(get(hObject,'String')) returns contents of edit_revision as a double


% --- Executes during object creation, after setting all properties.
function edit_revision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_revision.
function popupmenu_revision_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_revision contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_revision


% --- Executes during object creation, after setting all properties.
function popupmenu_revision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'f1')
    %open help
    showdemo branchTagSvnDialog;
end


function str = getCurrentPopupString(hh)
%# getCurrentPopupString returns the currently selected string in the popupmenu with handle hh

%# could test input here
if ~ishandle(hh) || strcmp(get(hh,'Type'),'popupmenu')
error('getCurrentPopupString needs a handle to a popupmenu as input')
end
%# get the string - do it the readable way
list = get(hh,'String');
val = get(hh,'Value');
if iscell(list)
   str = list{val};
else
   str = list(val,:);
end


function edit_log_Callback(hObject, eventdata, handles)
% hObject    handle to edit_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_log as text
%        str2double(get(hObject,'String')) returns contents of edit_log as a double


% --- Executes during object creation, after setting all properties.
function edit_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in btn_icon.
function btn_icon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
