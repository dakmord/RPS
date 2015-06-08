function varargout = switchSvnDialog(varargin)
% SWITCHSVNDIALOG MATLAB code for switchSvnDialog.fig
%      SWITCHSVNDIALOG, by itself, creates a new SWITCHSVNDIALOG or raises the existing
%      singleton*.
%
%      H = SWITCHSVNDIALOG returns the handle to a new SWITCHSVNDIALOG or the handle to
%      the existing singleton*.
%
%      SWITCHSVNDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SWITCHSVNDIALOG.M with the given input arguments.
%
%      SWITCHSVNDIALOG('Property','Value',...) creates a new SWITCHSVNDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before switchSvnDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to switchSvnDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help switchSvnDialog

% Last Modified by GUIDE v2.5 02-Jun-2015 01:21:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @switchSvnDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @switchSvnDialog_OutputFcn, ...
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


% --- Executes just before switchSvnDialog is made visible.
function switchSvnDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to switchSvnDialog (see VARARGIN)

% Home Dir
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Get Command Line Arguments and save to handles
% Info: {1} = Repository URL, {2} = Local Revision, {3} = Local Folder, {4}
% = passwordNeeded
handles.repoUrl = varargin{1};
handles.repoUrl = handles.repoUrl{1};
handles.localFolder = varargin{3};
if isnumeric(varargin{2})
    handles.localRevision = varargin{2};
else
    handles.localRevision = str2num(varargin{2});
end
if isnumeric(varargin{4})
    handles.passwordNeeded = varargin{4};
else
    handles.passwordNeeded = str2num(varargin{4});
end

% Check if Password/login is needed
if handles.passwordNeeded==1
    % login details
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        % Available
        [username,password] = decryptCredentials();
    else
        % Password Missing
        errordlg('Missing SVN Login/Password. Please save your login informations.', 'Missing SVN Login Information!');
        error('Missing SVN Login/Password!');
    end
else
   % Not needed
   username = '';
   password = '';
end

% Initialize Branch/Tag Popupmenu Items
[branches, info] = getRepositoryList(fullfile(handles.repoUrl,'branches'),username,password);
if isequal(info,-1)
    % Error
    error('Something went wrong during reading branches...! (Connection, Login, ...)');
end
[tags, info] = getRepositoryList(fullfile(handles.repoUrl,'tags'),username,password);
if isequal(info,-1)
    % Error
    error('Something went wrong during reading tags...! (Conncetion, Login, ...)');
end

% Set Strings for Popupmenus
if ~isempty(tags)
    set(handles.popup_tag, 'String', tags);
else
    
end
if ~isempty(branches)
    set(handles.popup_branch, 'String', branches);
end

% Set Edit fields...
set(handles.edit_repoUrl, 'String', handles.repoUrl);
set(handles.edit_localRevision, 'String', handles.localRevision);
set(handles.edit_localFolder, 'String', handles.localFolder);

% Handles initialization
handles.isSwitched = false;
handles.newFolder = '';
handles.isTag = true;
handles.isBranch = false;
handles.isTrunk = false;
handles.revision = 'HEAD';
if ~isempty(get(handles.popup_tag, 'String'))
    handles.tag = getCurrentPopupString(handles.popup_tag);
else
    handles.tag = '';
end
if ~isempty(get(handles.popup_branch, 'String'))
    handles.branch = getCurrentPopupString(handles.popup_branch);
else
    handles.branch = '';
end

% Choose default command line output for switchSvnDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes switchSvnDialog wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = switchSvnDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.isSwitched;      % WC has been Switched? -> true/false
varargout{3} = handles.newFolder;      % New WC Folder -> trunk/tag..

% Can be deleted
delete(hObject);

% --- Executes on button press in radio_tag.
function radio_tag_Callback(hObject, eventdata, handles)
% hObject    handle to radio_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_tag
set(handles.radio_tag, 'Value', 1);
set(handles.radio_branch, 'Value', 0);
set(handles.radio_trunk, 'Value', 0);

% Enable/Disable popup
set(handles.popup_tag, 'Enable', 'on');
set(handles.popup_branch, 'Enable', 'off');

% Publish Infos
handles.isTag = true;
handles.isBranch = false;
handles.isTrunk = false;
guidata(hObject, handles);

% --- Executes on button press in radio_branch.
function radio_branch_Callback(hObject, eventdata, handles)
% hObject    handle to radio_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_branch
set(handles.radio_tag, 'Value', 0);
set(handles.radio_branch, 'Value', 1);
set(handles.radio_trunk, 'Value', 0);

% Enable/Disable popup
set(handles.popup_tag, 'Enable', 'off');
set(handles.popup_branch, 'Enable', 'on');

% Publish Infos
handles.isTag = false;
handles.isBranch = true;
handles.isTrunk = false;
guidata(hObject, handles);


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_localRevision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_localRevision as text
%        str2double(get(hObject,'String')) returns contents of edit_localRevision as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
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


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Show Loading Animation
d = showLoadingAnimation('Creating Branch/Tag', 'Please wait...');
try
    % Check if Input Paramaters are all availabe
    if isempty(handles.revision)
        % error missing parameters
        uiwait(errordlg('Please fill in all marked input parameters.', 'Missing Informations!'));
        error('Please fill in all marked input parameters.');
    end
    
    % Check for Tag
    if handles.isTag && isempty(handles.tag)
        % error missing parameters
        uiwait(errordlg('Please fill in all marked input parameters.', 'Missing Informations!'));
        error('Please fill in all marked input parameters.');
    end
        
    % Check for Branch
    if handles.isBranch && isempty(handles.branch)
        % error missing parameters
        uiwait(errordlg('Please fill in all marked input parameters.', 'Missing Informations!'));
        error('Please fill in all marked input parameters.');
    end
    
    % Check for correct revision number/string
    if ischar(handles.revision)
        if strcmp(handles.revision, '"Revision Number"')
            % no number 
            set(handles.edit_revision, 'Enable', 'off');
            set(handles.popup_revision, 'Value', 1);
            handles.revision = 'HEAD';
        end
    elseif isnumeric(handles.revision)
            handles.revision = num2str(handles.revision);
    end
    
    % Check for SVN-Password
    if handles.passwordNeeded == true
        % Look for credentials
        if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
            % Available
            [username,password] = decryptCredentials();
        else
            % Password Missing
            uiwait(errordlg('Missing SVN Login/Password. Please save your login details.', 'Missing Login Information!'));
            error('Missing SVN Login/Password!');
        end
    else
        % not needed
        username = '';
        password = '';
    end
    
    % Get local URL/Source
    fromPath = fullfile(handles.homeDir);

    % Run SVN Command...
    if handles.isTag
        % Switch to Tag
        toPath = fullfile(handles.repoUrl, 'tags', handles.tag);
        handles.newFolder = fullfile('tags',handles.tag);
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'blocks'), fullfile(fromPath, 'blocks'), username, password);
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'help'), fullfile(fromPath, 'help'), username, password);
    elseif handles.isBranch
        % Switch to Branch
        toPath = fullfile(handles.repoUrl, 'branches', handles.branch);
        handles.newFolder = fullfile('branches',handles.branch);
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'blocks'), fullfile(fromPath, 'blocks'), username, password);
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'help'), fullfile(fromPath, 'help'), username, password);
    elseif handles.isTrunk
        % Switch to Trunk
        toPath = fullfile(handles.repoUrl, 'trunk');
        handles.newFolder = 'trunk';
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'blocks'), fullfile(fromPath, 'blocks'), username, password);
        [info] = switchWorkingCopySVN(handles.revision, fullfile(toPath, 'help'), fullfile(fromPath, 'help'), username, password);
    end
    if isequal(info,-1)
        error('Error creating Branch/Tag. Something went wrong (Conncetion, Login, ...).');
    end
    
    % Should be Switched..
    handles.isSwitched = true;
    
    % Publish handles
    guidata(hObject, handles);
    
    hideLoadingAnimation(d);
    close(gcf);
catch err
    hideLoadingAnimation(d);
    close(gcf)
    rethrow(err);
end

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on button press in btn_help.
function btn_help_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showdemo switchSvnDialog;

% --- Executes on selection change in popup_tag.
function popup_tag_Callback(hObject, eventdata, handles)
% hObject    handle to popup_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_tag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_tag
handles.tag = getCurrentPopupString(handles.popup_tag);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on selection change in popup_revision.
function popup_revision_Callback(hObject, eventdata, handles)
% hObject    handle to popup_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_revision contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_revision
revisionString = getCurrentPopupString(handles.popup_revision);

% Check if edit should be enabled
if strcmp(revisionString, '"Revision Number"')
    % enable edit
    set(handles.edit_revision, 'Enable', 'on');
else
    set(handles.edit_revision, 'Enable', 'off');
end
handles.revision = revisionString;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_revision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
    showdemo switchSvnDialog;
end


% --- Executes during object creation, after setting all properties.
function popup_branch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on selection change in popup_branch.
function popup_branch_Callback(hObject, eventdata, handles)
% hObject    handle to popup_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_branch contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_branch
handles.branch = getCurrentPopupString(handles.popup_branch);
guidata(hObject, handles);


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



function edit_revision_Callback(hObject, eventdata, handles)
% hObject    handle to edit_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_revision as text
%        str2double(get(hObject,'String')) returns contents of edit_revision as a double
% Manual Revision is enabled if here...
try
    handles.revision = str2num(get(handles.edit_revision, 'String'));
    if ~isnumeric(handles.revision)
        error('Wrong input format, please just use numbers as revision!');
    end
catch err
    handles.revision = 'HEAD';
    rethrow(err);
end


% --- Executes on button press in radio_trunk.
function radio_trunk_Callback(hObject, eventdata, handles)
% hObject    handle to radio_trunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_trunk
set(handles.radio_tag, 'Value', 0);
set(handles.radio_branch, 'Value', 0);
set(handles.radio_trunk, 'Value', 1);

% Enable/Disable popup
set(handles.popup_tag, 'Enable', 'off');
set(handles.popup_branch, 'Enable', 'off');

% Publish Infos
handles.isTag = false;
handles.isBranch = false;
handles.isTrunk = true;
guidata(hObject, handles);
