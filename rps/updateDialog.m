function varargout = updateDialog(varargin)
% UPDATEDIALOG MATLAB code for updateDialog.fig
%      UPDATEDIALOG, by itself, creates a new UPDATEDIALOG or raises the existing
%      singleton*.
%
%      H = UPDATEDIALOG returns the handle to a new UPDATEDIALOG or the handle to
%      the existing singleton*.
%
%      UPDATEDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UPDATEDIALOG.M with the given input arguments.
%
%      UPDATEDIALOG('Property','Value',...) creates a new UPDATEDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before updateDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to updateDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help updateDialog

% Last Modified by GUIDE v2.5 03-Jun-2015 10:59:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @updateDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @updateDialog_OutputFcn, ...
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


% --- Executes just before updateDialog is made visible.
function updateDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to updateDialog (see VARARGIN)

% Get parent dir
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
iconsFolder = fullfile(handles.homeDir, 'rps', 'etc', 'icons_18');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(iconsFolder, 'svn.png'));
jframe.setFigureIcon(jIcon);

% Load cloud icon
btn_im = imread(fullfile(iconsFolder, 'svn.png'));
set(handles.btn_icon, 'CData', btn_im);

% Base Handles
handles.revision = 'HEAD';
handles.credentialsNeeded = varargin{1};
handles.credentialsNeeded = handles.credentialsNeeded{1};
handles.url = varargin{2};

% Choose default command line output for updateDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes updateDialog wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = updateDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(hObject);


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


% --- Executes on selection change in popup_revision.
function popup_revision_Callback(hObject, eventdata, handles)
% hObject    handle to popup_revision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_revision contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_revision
str = getCurrentPopupString(handles.popup_revision);
if strcmp(str, '"Revision Number"')
    % Enable edit
    set(handles.edit_revision, 'Enable', 'on');
    handles.revision = str;
else
    % Disable
    set(handles.edit_revision, 'Enable', 'off');
    handles.revision = str;
end

% Publish handles
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

% Show loading animation
d = showLoadingAnimation('Updating working copy...', 'Please wait, updating...');
try
    % Get popup string
    str = getCurrentPopupString(handles.popup_revision);

    % Check if data is valid
    if strcmp(str, '"Revision Number"')
        % Check if revision number is valid
        revision = str2num(get(handles.edit_revision, 'String'));
        if isnumeric(revision)
            % Correct
            handles.revision = revision;
        else
            % Entered sth. wrong
            errordlg('There might be a wrong input for your revision number.', 'Wrong Revision Number?');
            error('There might be a wrong input for your revision number.');
        end
    else
        % Set to predefined
        handles.revision = str;
    end

    % Check if Password/login is needed
    [username,password] = readEncryptedPassword(handles);

    % Get Working Copy Folder
    rps = fullfile(handles.homeDir, 'rps');
    blocks = fullfile(handles.homeDir, 'blocks');
    help = fullfile(handles.homeDir, 'help');
    
    % Run SVN Commands
    updateSVN(rps, username, password, 'HEAD');
    updateSVN(blocks, username, password, handles.revision);
    updateSVN(help, username, password, handles.revision);
    
    % Reset
    hideLoadingAnimation(d);
    
    % Close Fig
    close(gcf);
catch err
    % Reset
    hideLoadingAnimation(d);
	rethrow(err);
end



% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


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
