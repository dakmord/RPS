function varargout = rps_GraphicalUserInterface(varargin)
%% Rapid-Prototyping-System User Interface
% Basic features:
%%
% 
% * Adding/Modifing Simulink Model (Default) Preferences (Include Folder for Custom C-Code S-Functions, ...)
% * Create <rps_GraphicalUserInterface.html#4 Custom S-Functions using C-Code> (GUI supported LegacyCodeTool)
% * Easy-to-use SVN-Interface (Log, Refresh, Update, Switch
% branches/tags/repo's, Branching/Tagging, Add, ...)
% * Install Simulink Support Packages (Mathworks & Thirdparty)
% * 
% 

%% Custom S-Functions using C-Code
% tbd...

%% SVN-Interface
% tbd...

%% Install Simulink Support Packages
% tbd...

% RPS_GRAPHICALUSERINTERFACE MATLAB code for rps_GraphicalUserInterface.fig
%      RPS_GRAPHICALUSERINTERFACE, by itself, creates a new RPS_GRAPHICALUSERINTERFACE or raises the existing
%      singleton*.
%
%      H = RPS_GRAPHICALUSERINTERFACE returns the handle to a new RPS_GRAPHICALUSERINTERFACE or the handle to
%      the existing singleton*.
%
%      RPS_GRAPHICALUSERINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RPS_GRAPHICALUSERINTERFACE.M with the given input arguments.
%
%      RPS_GRAPHICALUSERINTERFACE('Property','Value',...) creates a new RPS_GRAPHICALUSERINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rps_GraphicalUserInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rps_GraphicalUserInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rps_GraphicalUserInterface

% Last Modified by GUIDE v2.5 13-May-2015 10:56:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rps_GraphicalUserInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @rps_GraphicalUserInterface_OutputFcn, ...
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


% --- Executes just before rps_GraphicalUserInterface is made visible.
function rps_GraphicalUserInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rps_GraphicalUserInterface (see VARARGIN)

% Create Menu Icons
set(hObject, 'Visible', 'on');
pause(0.001);
set(hObject, 'Visible', 'off');
addMenuIcons(hObject, handles);

% Save rps home path
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','bmw_icons_18','bmw_icon.png'));
jframe.setFigureIcon(jIcon);


% Splash Screen
s = SplashScreen( 'Rapid-Prototyping-System', 'splashScreen.png', ...
                        'ProgressBar', 'off', ...
                        'ProgressPosition', 5, ...
                        'ProgressRatio', 0.8 );
s.addText( 40, 50, 'Rapid-Prototyping-System', 'FontSize', 22, 'Color', 'white' ,'FontWeight','bold');
s.addText( 40, 120, 'v0.8', 'FontSize', 22, 'Color', 'white' );
s.addText( 200, 270, 'Loading...', 'FontSize', 30, 'Color', 'white','FontWeight','bold' );

% Check if it userconfig.xml is missing
if isequal(exist(fullfile(handles.homeDir, 'userconfig.xml'),'file'),2)
    % existing, read userconfig and save in handles
    [status ,updateInterval, autoUpdate,customUrl,credentialsNeeded, url, ...
    repoFolder, revision] = getUserconfigValues(fullfile(handles.homeDir,'userconfig.xml'));

    % create basic handles
    handles.updateInterval = updateInterval;
    handles.autoUpdate = autoUpdate;
    handles.customUrl = customUrl;
    handles.credentialsNeeded = credentialsNeeded;
    handles.url = url;
    handles.repoFolder = repoFolder;
    handles.revision = revision;
    handles.maxLogEntries = 20;
else
    % not existing, end and open preferences!
    disp('### Missing userconfig.xml in your folder. Opening preferences...');
    uiwait(options);
    pause(0.5);
    if isequal(exist(fullfile(handles.homeDir, 'userconfig.xml'),'file'),2)
        % existing
    else
        % still missing
        error('Missing userconfig.xml in your Rapid-Prototyping-System directory! Re-run gui and fill in preferences window!');
    end
    
end

% Basic Initialization...
set(handles.repo_edit, 'String', handles.repoFolder);
set(handles.revision_edit, 'String', handles.revision);
set(handles.repository_edit, 'String', handles.url);

% Fill log with actual stuff
if handles.credentialsNeeded==1
    % login details
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        % Available
        [username,password] = decryptCredentials();
    else
        % Password Missing
        error('Missing SVN Login/Password!');
    end
    [log] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,username,password);
else
    % without
    [log] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,'','');
end
set(handles.log_table,'Data',log);
handles.log = log;


% Choose default command line output for rps_GraphicalUserInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Check if local repo is outdated
checkForOutdated(hObject, handles);

% UIWAIT makes rps_GraphicalUserInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function addMenuIcons(figure, handles)
% File
set(handles.file_menu, 'UserData', 'BMW-neg_med_document_18.png');
set(handles.file_new, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.new_legacyCode, 'UserData', 'c_logo.png');
set(handles.file_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.sim_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.file_exit, 'UserData', 'BMW-neg_nav_close_18.png');

%SVN
set(handles.svn_menu, 'UserData', 'BMW-neg_act_replace_18.png');
set(handles.svn_refresh, 'UserData', 'BMW-neg_int_update_18.png');
set(handles.svn_update, 'UserData', 'BMW-neg_act_download_18.png');

%SupportPackages
set(handles.supportPkg_menu, 'UserData', 'BMW-neg_act_download_18.png');
set(handles.supportPkg_install, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.supportPkg_custom, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.supportPkg_mathworks, 'UserData', 'Matlab_Logo.png');
set(handles.supportPkg_arduino, 'UserData', 'arduino_logo.png');
set(handles.supportPkg_tm4c1294npdt, 'UserData', 'ti_logo.png');
set(handles.supportPkg_url, 'UserData', 'BMW-neg_nav_more_18.png');

%Help
set(handles.help_menu, 'UserData', 'BMW-neg_com_help_18.png');
set(handles.help_about, 'UserData', 'BMW-neg_com_info_18.png');

% Set the icons 
Figure_Menu_Add_Icons(figure);


function checkForOutdated(hObject, handles)
if handles.revision<str2num(handles.log{1,1})
    set(handles.outdated_text,'Visible','on');
    set(handles.revision_edit, 'String',num2str(handles.revision));
else
    set(handles.outdated_text,'Visible','off');
    set(handles.revision_edit, 'String',num2str(handles.revision));
end


% --- Outputs from this function are returned to the command line.
function varargout = rps_GraphicalUserInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function svn_menu_Callback(hObject, eventdata, handles)
% hObject    handle to svn_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function svn_update_Callback(hObject, eventdata, handles)
% hObject    handle to svn_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
statusbar('Updating working copy...');
d = showLoadingAnimation('Updating working copy...', 'Please wait, updating /blocks/...');
[username,password] = readEncryptedPassword(hObject, handles);
updateSVN(fullfile(handles.homeDir,'blocks'), username, password);
d.setProgressStatusLabel('Please wait, updating /help/...');
updateSVN(fullfile(handles.homeDir,'help'), username, password);
d.setProgressStatusLabel('Please wait, updating /rps/...');
updateSVN(fullfile(handles.homeDir,'rps'), username, password);

%Updating gui... and configuration file
d.setProgressStatusLabel('Please wait, updating gui...');
[revision, folder, repoHomeUrl] = checkLocalWorkingCopy(fullfile(handles.homeDir,'rps'));
handles.revision = revision;
handles.repoFolder = folder;

% Update handles
guidata(hObject, handles);

% Update GUI
checkForOutdated(hObject, handles);

statusbar('');
hideLoadingAnimation(d);

% Store in userconfig.xml
createUserconfigXML(hObject, handles);

figure(gcf);


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_new_Callback(hObject, eventdata, handles)
% hObject    handle to file_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --------------------------------------------------------------------
function Untitled_17_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_url_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(gcf,'off');
uiwait(supportPkg_url);
enableDisableFig(gcf,'on');
figure(gcf);

% --------------------------------------------------------------------
function file_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to file_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uiwait(options);
enableDisableFig(gcf,'off');
uiwait(options);
loadUserDataToHandles(hObject, handles);
enableDisableFig(gcf,'on');
figure(gcf);

function loadUserDataToHandles(hObject,handles)
% Check if it userconfig.xml is missing
if isequal(exist(fullfile(handles.homeDir, 'userconfig.xml'),'file'),2)
    % existing, read userconfig and save in handles
    [status ,updateInterval, autoUpdate,customUrl,credentialsNeeded, url, ...
    repoFolder, revision] = getUserconfigValues(fullfile(handles.homeDir,'userconfig.xml'));

    % create basic handles
    handles.updateInterval = updateInterval;
    handles.autoUpdate = autoUpdate;
    handles.customUrl = customUrl;
    handles.credentialsNeeded = credentialsNeeded;
    handles.url = url;
    handles.repoFolder = repoFolder;
    handles.revision = revision;
    handles.maxLogEntries = 20;
    % Actualize components
    set(handles.revision_edit,'String',num2str(handles.revision));
    set(handles.repo_edit,'String',handles.repoFolder);
    set(handles.repository_edit,'String',handles.url);
else
    % not existing, end and open preferences!
    disp('### Missing userconfig.xml in your folder. Opening preferences...');
    uiwait(options);
    pause(0.5);
    if isequal(exist(fullfile(handles.homeDir, 'userconfig.xml'),'file'),2)
        % existing
    else
        % still missing
        error('Missing userconfig.xml in your Rapid-Prototyping-System directory! Re-run gui and fill in preferences window!');
    end
    
end
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_19_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_about_Callback(hObject, eventdata, handles)
% hObject    handle to help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(gcf,'off');
uiwait(about);
enableDisableFig(gcf,'on');
figure(gcf)

% --------------------------------------------------------------------
function svn_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to svn_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkUpdates_btn_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function preferences_default_Callback(hObject, eventdata, handles)
% hObject    handle to preferences_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_rttModel_Callback(hObject, eventdata, handles)
% hObject    handle to file_rttModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function new_legacyCode_Callback(hObject, eventdata, handles)
% hObject    handle to new_legacyCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(gcf,'off');
uiwait(legacyCodeHelper);
enableDisableFig(gcf,'on');
figure(gcf);


% --------------------------------------------------------------------
function svn_branch_Callback(hObject, eventdata, handles)
% hObject    handle to svn_branch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function svn_switch_Callback(hObject, eventdata, handles)
% hObject    handle to svn_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_install_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_install (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_mathworks_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_mathworks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
targetinstaller;

% --------------------------------------------------------------------
function supportPkg_arduino_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_arduino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open(fullfile('etc','arduino.mlpkginstall'));

% --------------------------------------------------------------------
function Untitled_31_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_custom_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function supportPkg_tm4c1294npdt_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_tm4c1294npdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hw_targetInstaller_tm4c1294();

% --- Executes on button press in checkUpdates_btn.
function checkUpdates_btn_Callback(hObject, eventdata, handles)
% hObject    handle to checkUpdates_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

animationHandle = showLoadingAnimation('Refreshing...', 'Please wait while refreshing recent changes...');

sb = statusbar('Refreshing Recent Changes...');
sb.CornerGrip.setVisible(false);
%set(sb.CornerGrip, 'visible','off');

% Fill log with actual stuff
if handles.credentialsNeeded==1
    % login details
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        % Available
        [username,password] = decryptCredentials();
    else
        % Password Missing
        error('Missing SVN Login/Password!');
    end
    [log] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,username,password);
else
    % without
    [log] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,'','');
end
set(handles.log_table,'Data',log);
handles.log = log;

% Publish handles
guidata(hObject, handles);

% Check if local repo is outdated
checkForOutdated(hObject, handles);

% stop Animation/Statusbar
statusbar('');
hideLoadingAnimation(animationHandle);
figure(gcf);




function [username,password] = readEncryptedPassword(hObject, handles)
% Read password/login from file
if handles.credentialsNeeded==1
    % login details
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        % Available
        [username,password] = decryptCredentials();
    else
        % Password Missing
        error('Missing SVN Login/Password!');
    end
else
   % Not needed
   username = '';
   password = '';
end
if credentialsValiditySVN(handles.url, username, password)==1
    % could be correct
else
    % wrong
    errordlg('Please check your saved svn login/password. Might be wrong!','Wrong password/login!?');
end


function repo_edit_Callback(hObject, eventdata, handles)
% hObject    handle to repo_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repo_edit as text
%        str2double(get(hObject,'String')) returns contents of repo_edit as a double


% --- Executes during object creation, after setting all properties.
function repo_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repo_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function revision_edit_Callback(hObject, eventdata, handles)
% hObject    handle to revision_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of revision_edit as text
%        str2double(get(hObject,'String')) returns contents of revision_edit as a double


% --- Executes during object creation, after setting all properties.
function revision_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to revision_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in log_table.
function log_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to log_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.log_table,'Data');

authorString =      ['#Author:   ' data{eventdata.Indices(1),2} ];
revisionString =    ['#Revision: ' data{eventdata.Indices(1),1} ];
dateString =        ['#Date:     ' data{eventdata.Indices(1),3} ];
outputText = sprintf('\n\n%s\n%s\n%s\n#Log:\n%s',revisionString, authorString, dateString,data{eventdata.Indices(1),4});
disp(outputText);



% --- Executes when entered data in editable cell(s) in log_table.
function log_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to log_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function log_table_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to log_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on log_table and none of its controls.
function log_table_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to log_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function repository_edit_Callback(hObject, eventdata, handles)
% hObject    handle to repository_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repository_edit as text
%        str2double(get(hObject,'String')) returns contents of repository_edit as a double


% --- Executes during object creation, after setting all properties.
function repository_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repository_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function sim_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to sim_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function preferences_model_Callback(hObject, eventdata, handles)
% hObject    handle to preferences_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openModels = find_system('SearchDepth', 0);
modelList = {};
for i=1:1:length(openModels)
   if strcmp(get_param(openModels{i},'Shown'),'on') 
       % Open Model
       modelList{end+1} = openModels{i};
   end
end
if ~isempty(modelList)
    [Selection,ok] = listdlg('PromptString', 'Select a Model:', 'SelectionMode', 'single', 'ListString', modelList);
    if ok==1 && ~isempty(Selection)
        % Load ConfigSet
        configStruct = load(fullfile(handles.homeDir,'rps','cfg','basicSimulinkConfigSet.mat'),'basicSimulinkConfig');
        % Add current include paths
        configStruct.basicSimulinkConfig=addIncludePathToConfigSet(configStruct.basicSimulinkConfig);
        
        % Publish Config to Model
        attachConfigSet(modelList{Selection},configStruct.basicSimulinkConfig);
        setActiveConfigSet(modelList{Selection},'RapidPrototypingSystem_Configuration');
    end
else
   errordlg('No open models have been found!', 'No Models Found!');
end

% --------------------------------------------------------------------
function new_model_Callback(hObject, eventdata, handles)
% hObject    handle to new_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = new_system('default_model','Model');
open_system(model);

% Load ConfigSet
configStruct = load(fullfile(handles.homeDir,'rps','cfg','basicSimulinkConfigSet.mat'),'basicSimulinkConfig');

% Add current include paths
configStruct.basicSimulinkConfig=addIncludePathToConfigSet(configStruct.basicSimulinkConfig);

% Publish Config to Model
attachConfigSet(model,configStruct.basicSimulinkConfig);
setActiveConfigSet(model,'RapidPrototypingSystem_Configuration');


% --------------------------------------------------------------------
function new_library_Callback(hObject, eventdata, handles)
% hObject    handle to new_library (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = new_system('default_model','Library');
open_system(model);


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
    showdemo rps_GraphicalUserInterface;
end
