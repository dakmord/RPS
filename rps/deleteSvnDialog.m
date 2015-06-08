function varargout = deleteSvnDialog(varargin)
% DELETESVNDIALOG MATLAB code for deleteSvnDialog.fig
%      DELETESVNDIALOG, by itself, creates a new DELETESVNDIALOG or raises the existing
%      singleton*.
%
%      H = DELETESVNDIALOG returns the handle to a new DELETESVNDIALOG or the handle to
%      the existing singleton*.
%
%      DELETESVNDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETESVNDIALOG.M with the given input arguments.
%
%      DELETESVNDIALOG('Property','Value',...) creates a new DELETESVNDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before deleteSvnDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to deleteSvnDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help deleteSvnDialog

% Last Modified by GUIDE v2.5 03-Jun-2015 15:29:36
%               by Daniel Schneider(EK-704), 08.06.2015, Bugfix in delete branch/tag.
%               ...

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deleteSvnDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @deleteSvnDialog_OutputFcn, ...
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


% --- Executes just before deleteSvnDialog is made visible.
function deleteSvnDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to deleteSvnDialog (see VARARGIN)

% Handle GUI Input
handles.repoUrl = varargin{1};
handles.repoUrl = handles.repoUrl{1};
handles.url = handles.repoUrl;
handles.repoFolder = varargin{3};
if isnumeric(varargin{2})
    handles.credentialsNeeded = varargin{2};
else
    handles.credentialsNeeded = str2num(varargin{2});
end

% Get parent dir
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
iconsFolder = fullfile(handles.homeDir, 'rps', 'etc', 'icons_18');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(iconsFolder, 'svn.png'));
jframe.setFigureIcon(jIcon);

% Load svn icon
btn_im = imread(fullfile(iconsFolder, 'svn.png'));
set(handles.btn_icon, 'CData', btn_im);

% Check for SVN Username/Password
[username,password] = readEncryptedPassword(handles);

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
end
if ~isempty(branches)
    set(handles.popup_branch, 'String', branches);
end

% Init basic handles
handles.isTag = true;
handles.isBranch = false;
handles.tag = getCurrentPopupString(handles.popup_tag);
handles.branch = '';
handles.log = get(handles.edit_log, 'String');

% Choose default command line output for deleteSvnDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes deleteSvnDialog wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = deleteSvnDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Can be deleted
delete(hObject);


% --- Executes on button press in btn_icon.
function btn_icon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if Selected deletion is equal current working copy folder
if handles.isTag
    if strcmp(handles.tag, handles.repoFolder)
        error('You cannot delete your selected tag/branch please switch to another Branch/Tag/Trunk before deleting');
    end
elseif handles.isBranch
    if strcmp(handles.branch, handles.repoFolder)
       error('You cannot delete your selected tag/branch please switch to another Branch/Tag/Trunk before deleting');
    end
end

% Check if log is not empty
if isempty(get(handles.edit_log, 'String'))
    errordlg('Please fill in a Log-Message before deletion can be done.', 'Log-Message Required!');
    error('Please fill in a Log-Message before deletion can be done.');
end

% Check if input parameter valid
if handles.isTag
    if isempty(handles.tag)
        % Tag selected and empty
        error('You selected to delete a tag but it seems to be empty. Maybe there are not tags which can be deleted!');
    end
elseif handles.isBranch
    if isempty(handles.branch)
        % Branch selected and empty
        error('You selected to delete a branch but it seems to be empty. Maybe there are not branches which can be deleted!');
    end
else
    error('Something went wrong during selection of Branch/Tag. Nothing is selected?');
end

% Check for SVN Login/Password
[username,password] = readEncryptedPassword(handles);

% Delete selected Branch/Tag
if  handles.isTag
    deletePath = fullfile(handles.url,'tags', handles.tag);
elseif handles.isBranch
    deletePath = fullfile(handles.url,'branches', handles.branch);
end

% Delete
if isequal(deleteSVN(deletePath, handles.log, username, password),-1)
    % Error
    error('Something went wrong while deleting a tag/branch!');
end

% Close this dialog
close(gcf);


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


function edit_log_Callback(hObject, eventdata, handles)
% hObject    handle to edit_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_log as text
%        str2double(get(hObject,'String')) returns contents of edit_log as a double
handles.log = get(handles.edit_log, 'String');
guidata(hObject, handles);

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


% --- Executes on selection change in popup_tag.
function popup_tag_Callback(hObject, eventdata, handles)
% hObject    handle to popup_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_tag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_tag
handles.isTag = true;
handles.isBranch = false;
handles.branch = '';
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


% --- Executes on selection change in popup_branch.
function popup_branch_Callback(hObject, eventdata, handles)
% hObject    handle to popup_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_branch contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_branch
handles.isTag = false;
handles.isBranch = true;
handles.branch = getCurrentPopupString(handles.popup_branch);
handles.tag = '';
guidata(hObject, handles);

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


% --- Executes on button press in radio_branch.
function radio_branch_Callback(hObject, eventdata, handles)
% hObject    handle to radio_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_branch
set(handles.radio_tag, 'Value', 0);
set(handles.radio_branch, 'Value', 1);
set(handles.popup_tag, 'Enable', 'off');
set(handles.popup_branch, 'Enable', 'on');

% Publish handles
handles.isTag = false;
handles.isBranch = true;
handles.tag = '';
handles.branch = getCurrentPopupString(handles.popup_branch);
guidata(hObject, handles);

% --- Executes on button press in radio_tag.
function radio_tag_Callback(hObject, eventdata, handles)
% hObject    handle to radio_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_tag
set(handles.radio_tag, 'Value', 1);
set(handles.radio_branch, 'Value', 0);
set(handles.popup_tag, 'Enable', 'on');
set(handles.popup_branch, 'Enable', 'off');

% Publish handles
handles.isTag = true;
handles.isBranch = false;
handles.tag = getCurrentPopupString(handles.popup_tag);
handles.branch = '';
guidata(hObject, handles);


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
