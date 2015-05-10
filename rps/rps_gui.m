function varargout = rps_gui(varargin)
% RPS_GUI MATLAB code for rps_gui.fig.
%      RPS_GUI, by itself, creates a new RPS_GUI or raises the existing
%      singleton*.
%
%      H = RPS_GUI returns the handle to a new RPS_GUI or the handle to
%      the existing singleton*.
%
%      RPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RPS_GUI.M with the given input arguments.
%
%      RPS_GUI('Property','Value',...) creates a new RPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rps_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rps_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rps_gui

% Last Modified by GUIDE v2.5 16-Mar-2015 23:55:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rps_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rps_gui_OutputFcn, ...
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


% --- Executes just before rps_gui is made visible.
function rps_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rps_gui (see VARARGIN)

% Choose default command line output for rps_gui
handles.output = hObject;

% Save current path of rps gui_Callback
handles.parentPath=getParentDir(2, '\');
handles.homePath = handles.parentPath;

% Check if userconfig exists and set checkboxes..
[status ,updateinterval, block, help, toolchain, gui, repo] = getUserconfigValues();
if status >0
    set(handles.cb_help, 'Value', help);
    set(handles.cb_toolchains, 'Value', toolchain);
    set(handles.cb_gui, 'Value', gui);
    set(handles.cb_blocks, 'Value', block);
else
    set(handles.btn_update, 'Enable', 'off');
    set(handles.btn_checkforupdates, 'Enable', 'off');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rps_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Refresh ICON Button
htmlStr = ['<html><b></b> <img src="file:\' handles.parentPath 'gui\pics\refresh_32.png"/></html>'];
set(handles.btn_checkforupdates, 'String',htmlStr);
% Update Icon Button
htmlStr = ['<html><b></b> <img src="file:\' handles.parentPath 'gui\pics\update_32.png"/></html>'];
set(handles.btn_update, 'String',htmlStr);

% --- Outputs from this function are returned to the command line.
function varargout = rps_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_options_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_new_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_options_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options;


% --------------------------------------------------------------------
function meun_help_Callback(hObject, eventdata, handles)
% hObject    handle to meun_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_gettingStarted_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_gettingStarted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_toolchainIntegration_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_toolchainIntegration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject)
i = imread('gui_background.png');
imagesc(i);
axis off;
% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_update.
function btn_update_Callback(hObject, eventdata, handles)
% hObject    handle to btn_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if credentials available..
[status ,updateinterval, block, help, toolchain, gui, repo] = getUserconfigValues();
credentialsCheck(handles.homePath, repo);

% Statusbar
sb = statusbar('');
sb.CornerGrip.setVisible(false);
statusbar(hObject,'Updating local system ...');

% Check for Updates before doing anything...
refreshFiles(handles)
guiFilesBeforeUpdate = str2num(get(handles.edit_gui, 'String'));
% Update outdated folders...
updateFolderSVN(handles)
% Check for updates after ..
refreshFiles(handles)
guiFilesAfterUpdate = str2num(get(handles.edit_gui, 'String'));

% Check if restart is needed..
if guiFilesAfterUpdate < guiFilesBeforeUpdate
   % updates ... 
   answer = questdlg('Your local GUI files have been updated! Rapid-Prototyping-System will be restarted!', ...
       'Restart RPS', 'Ok', 'Ok');
   if strcmp(answer, 'Ok')
      % Restart RPS and update local files...
      close all;
      pause(1);
      % Copy new Version of updateLocal before running...
      copyfile(fullfile(handles.homePath, 'rps', 'fcn', 'updateLocal.m'), fullfile(handles.homePath));
      rehash;
      pause(1);
      updateLocal('Yes');
   end
else
   % no need for restart..
   statusbar(hObject,'Done!');
end



function edit_blocks_Callback(hObject, eventdata, handles)
% hObject    handle to edit_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_blocks as text
%        str2double(get(hObject,'String')) returns contents of edit_blocks as a double


% --- Executes during object creation, after setting all properties.
function edit_blocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_toolchains_Callback(hObject, eventdata, handles)
% hObject    handle to edit_toolchains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_toolchains as text
%        str2double(get(hObject,'String')) returns contents of edit_toolchains as a double


% --- Executes during object creation, after setting all properties.
function edit_toolchains_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_toolchains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_help_Callback(hObject, eventdata, handles)
% hObject    handle to edit_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_help as text
%        str2double(get(hObject,'String')) returns contents of edit_help as a double


% --- Executes during object creation, after setting all properties.
function edit_help_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_gui_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gui as text
%        str2double(get(hObject,'String')) returns contents of edit_gui as a double


% --- Executes during object creation, after setting all properties.
function edit_gui_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_blocks.
function cb_blocks_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_blocks
% Check for old userconfig values...
[status ,updateinterval, ublock, uhelp, utoolchain, ugui, repo] = getUserconfigValues();
if status > 0
   
else
    
end

% --- Executes on button press in cb_toolchains.
function cb_toolchains_Callback(hObject, eventdata, handles)
% hObject    handle to cb_toolchains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_toolchains


% --- Executes on button press in cb_gui.
function cb_gui_Callback(hObject, eventdata, handles)
% hObject    handle to cb_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_gui


% --- Executes on button press in cb_help.
function cb_help_Callback(hObject, eventdata, handles)
% hObject    handle to cb_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_help


% --- Executes on button press in btn_checkforupdates.
function btn_checkforupdates_Callback(hObject, eventdata, handles)
% hObject    handle to btn_checkforupdates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if credentials are correct ...
[status ,updateinterval, block, help, toolchain, gui, repo] = getUserconfigValues();
credentialsCheck(handles.homePath, repo);

disp('GUI Updated.... v0.51 beta');
sb = statusbar('');
sb.CornerGrip.setVisible(false);
statusbar(hObject,'Searching for updates ...');

refreshFiles(handles);
statusbar(hObject,'Done!');

% --- Executes during object creation, after setting all properties.
function btn_checkforupdates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_checkforupdates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function refreshFiles(handles)
% To be CHANGED...
url = handles.parentPath;

% update file status
outdatedFiles = checkOutdatedSVN([url 'help'], '', '');
set(handles.edit_help, 'String', outdatedFiles);
outdatedFiles = checkOutdatedSVN([url 'rps'], '', '');
set(handles.edit_gui, 'String', outdatedFiles);
outdatedFiles = checkOutdatedSVN([url 'blocks'], '', '');
set(handles.edit_blocks, 'String', outdatedFiles);
outdatedFiles = checkOutdatedSVN([url 'toolchains\_appdata'], '', '');
% Get Toolchain dirs out of XML
toolDirs = getToolchainDirectories();
[tx, ty] = size(toolDirs);
for i=1:ty
    tmpURL = char(strcat(url,'/toolchains/',toolDirs(1,i)));
    [path, name, ext] = fileparts(tmpURL);
    if strcmp(ext, '')
        outdatedFiles = outdatedFiles + checkOutdatedSVN(tmpURL, '', '');
    end
end
set(handles.edit_toolchains, 'String', outdatedFiles);

% update color of each edit component..
if str2num(get(handles.edit_help, 'String'))>0
    set(handles.edit_help, 'ForegroundColor', 'red');
else
    set(handles.edit_help, 'ForegroundColor', [0 0.5 0]);
end
if str2num(get(handles.edit_blocks, 'String'))>0
    set(handles.edit_blocks, 'ForegroundColor', 'red');
else
    set(handles.edit_blocks, 'ForegroundColor', [0 0.5 0]);
end
if str2num(get(handles.edit_gui, 'String'))>0
    set(handles.edit_gui, 'ForegroundColor', 'red');
else
    set(handles.edit_gui, 'ForegroundColor', [0 0.5 0]);
end
if str2num(get(handles.edit_toolchains, 'String'))>0
    set(handles.edit_toolchains, 'ForegroundColor', 'red');
else
    set(handles.edit_toolchains, 'ForegroundColor', [0 0.5 0]);
end

% --- Executes during object creation, after setting all properties.
function btn_update_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function updateFolderSVN(handles)
% Check for update blocks ...
if str2num(get(handles.edit_blocks, 'String'))>0 && get(handles.cb_blocks, 'Value')==1.0
    updateSVN([handles.parentPath 'blocks'], '', '');
end
% Check for update help
if str2num(get(handles.edit_help, 'String'))>0 && get(handles.cb_help, 'Value')==1.0
    updateSVN([handles.parentPath 'help'], '', '');
end
% Check for update gui
if str2num(get(handles.edit_gui, 'String'))>0 && get(handles.cb_gui, 'Value')==1.0
    updateSVN([handles.parentPath 'rps'], '', '');
end
% Check for update toolchains
if str2num(get(handles.edit_toolchains, 'String'))>0 && get(handles.cb_toolchains, 'Value')==1.0
    updateSVN([handles.parentPath 'toolchains/_appdata'], '', '');
    toolDirs = getToolchainDirectories();
    [tx, ty] = size(toolDirs);
    for i=1:ty
        tmpURL = char(strcat(handles.parentPath,'toolchains/',toolDirs(1,i)));
        [path, name, ext] = fileparts(tmpURL);
        if strcmp(ext, '')
            updateSVN(tmpURL, '', '');
        else
            % some files e.g. *.zip
            updateSVN(tmpURL, '', '');
        end
    end
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Create Statusbar
% Create Statusbar
