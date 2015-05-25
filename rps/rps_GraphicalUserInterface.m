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

% Last Modified by GUIDE v2.5 22-May-2015 11:04:12

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
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','icons_18','bmw_icon.png'));
jframe.setFigureIcon(jIcon);


% Splash Screen
s = SplashScreen( 'Rapid-Prototyping-System', 'splashScreen.png', ...
                        'ProgressBar', 'off', ...
                        'ProgressPosition', 5, ...
                        'ProgressRatio', 0.8 );
s.addText( 40, 50, 'Rapid-Prototyping-System', 'FontSize', 22, 'Color', 'white' ,'FontWeight','bold');
s.addText( 40, 120, 'v0.8', 'FontSize', 22, 'Color', 'white' );
s.addText( 200, 270, 'Loading...', 'FontSize', 30, 'Color', 'white','FontWeight','bold' );

[hObject, handles] = loadUserDataToHandles(hObject,handles);

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
    [log, files] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,username,password);
else
    % without
    [log, files] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,'','');
end

set(handles.log_table,'Data',log);
handles.log = log;
handles.logFiles = files;


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
set(handles.new_library, 'UserData', '3d_modelling.png');
set(handles.new_model, 'UserData', 'book.png');
set(handles.new_legacyCode, 'UserData', 'c_logo.png');
set(handles.file_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.sim_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.file_exit, 'UserData', 'BMW-neg_nav_close_18.png');
set(handles.file_open, 'UserData', 'BMW-neg_nav_imagegallery_18.png');
set(handles.file_openRpsLib, 'UserData', 'book.png');
set(handles.file_openModel, 'UserData', '3d_modelling.png');
set(handles.file_openLibs, 'UserData', 'book.png');

%SVN
set(handles.svn_menu, 'UserData', 'BMW-neg_act_replace_18.png');
set(handles.svn_refresh, 'UserData', 'BMW-neg_int_update_18.png');
set(handles.svn_update, 'UserData', 'BMW-neg_act_download_18.png');
set(handles.svn_branch, 'UserData', 'BMW-neg_act_open_18.png');
set(handles.svn_switch, 'UserData', 'BMW-neg_act_replace_18.png');
set(handles.svn_delete, 'UserData', 'BMW-neg_nav_close_18.png');

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

% Get Simulink pref
if strcmp(get(handles.preferences_default,'Checked'), 'on')
	handles.simulinkPereferences = true;
else
    handles.simulinkPereferences = false;
end

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
try
    enableDisableFig(gcf,'off');
    uiwait(options);
    [hObject, handles] = loadUserDataToHandles(hObject, handles);

    % Update handles structure
    guidata(hObject, handles);
catch err
    enableDisableFig(gcf,'on');
    figure(gcf);
    rethrow(err);
end
enableDisableFig(gcf,'on');
figure(gcf);

function [hObject, handles] = loadUserDataToHandles(hObject,handles)
% Check if it userconfig.xml is missing
if ~isequal(exist(fullfile(handles.homeDir, 'userconfig.xml'),'file'),2)
    % not existing, open preferences!
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

% existing, read userconfig and save in handles
[status ,updateInterval, autoUpdate,customUrl,credentialsNeeded, url, ...
repoFolder, revision, simPreferences] = getUserconfigValues(fullfile(handles.homeDir,'userconfig.xml'));

% create basic handles
handles.updateInterval = updateInterval;
handles.autoUpdate = autoUpdate;
handles.customUrl = customUrl;
handles.credentialsNeeded = credentialsNeeded;
handles.url = url;
handles.repoFolder = repoFolder;
handles.revision = revision;
handles.maxLogEntries = 20;
handles.simulinkPereferences = simPreferences;

% Actualize components
set(handles.revision_edit,'String',num2str(handles.revision));
set(handles.repo_edit,'String',handles.repoFolder);
set(handles.repository_edit,'String',handles.url);
if handles.simulinkPereferences
    set(handles.preferences_default,'Checked','on');
else
    set(handles.preferences_default,'Checked','off');
end


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

% Start Loading Animation
d = showLoadingAnimation('Save Simulink Preferences...', 'Please wait...');

% Check if enable/disable
if strcmp(get(handles.preferences_default, 'Checked'),'off')
    % Set Checked
    set(handles.preferences_default, 'Checked', 'on');
    
    % Load Userconfig and add it to XML
    [ret] = savePreferenceToXML('simDefault', true);
    
    % Check for present cfg file and copy to _*
    if isequal(exist(fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'),'file'),2)
        % copy and rename
        movefile(fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'),fullfile(prefdir(),'_Simulink_ConfigSet_Prefs.mat'),'f');
    end

    % Get Basic ConfigSet and Add Paths
    configStruct = load(fullfile(handles.homeDir,'rps','cfg','basicSimulinkConfigSet.mat'),'basicSimulinkConfig');
    % Add current include paths
    ConfigSetSettings.Defaults = addIncludePathToConfigSet(configStruct.basicSimulinkConfig);
    save(fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'),'ConfigSetSettings');
    
else
    % uncheck
    set(handles.preferences_default, 'Checked', 'off');
    
    % Load Userconfig and add it to XML
    [ret] = savePreferenceToXML('simDefault', false);
    
    % Disable and revert
    if isequal(exist(fullfile(prefdir(),'_Simulink_ConfigSet_Prefs.mat'),'file'),2)
        % Basic File existing
        delete(fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'));
        movefile(fullfile(prefdir(),'_Simulink_ConfigSet_Prefs.mat'),fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'),'f');
    else
        % Nothing there.. just delete
        delete(fullfile(prefdir(),'Simulink_ConfigSet_Prefs.mat'));
    end
end

% Apply Default Simulink Configuration set
cs = getActiveConfigSet(0);
cs.savePreferences('Load');

% Remove Loading animation
hideLoadingAnimation(d);
figure(gcf);
    
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
enableDisableFig(gcf,'off');
% Info: {1} = Repository URL, {2} = Local Revision, {3} = Local Folder, {4}
% = passwordNeeded
url = handles.url;
assignin('base', 'str', url);
uiwait(branchTagSvnDialog(url,handles.revision,handles.repoFolder, handles.credentialsNeeded));
enableDisableFig(gcf,'on');
figure(gcf);

% --------------------------------------------------------------------
function svn_switch_Callback(hObject, eventdata, handles)
% hObject    handle to svn_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(gcf,'off');
% Info: {1} = Repository URL, {2} = Local Revision, {3} = Local Folder, {4}
% = passwordNeeded
try
    uiwait(switchSvnDialog(...
        handles.url,...
        handles.revision,...
        handles.repoFolder,...
        handles.credentialsNeeded));
catch
    % Error
    enableDisableFig(gcf,'on');
    figure(gcf);
    error('Error while loading Switch SVN-Dialog.');
end
enableDisableFig(gcf,'on');
figure(gcf);

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
    [log, files] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,username,password);
else
    % without
    [log, files] = getRepositoryLog(handles.url,handles.repoFolder,handles.maxLogEntries,'','');
end

set(handles.log_table,'Data',log);
handles.log = log;
handles.logFiles = files;

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

% Check if valid
if length(eventdata.Indices)>0
    % handle Data
    data = get(handles.log_table,'Data');
    commit = handles.logFiles;
    selected = commit{eventdata.Indices(1)};

    authorString =      ['#Author:   ' data{eventdata.Indices(1),2} ];
    revisionString =    ['#Revision: ' data{eventdata.Indices(1),1} ];
    dateString =        ['#Date:     ' data{eventdata.Indices(1),3} ];
    outputText = sprintf('\n\n%s\n%s\n%s\n#Log:\n%s',revisionString, authorString, dateString,data{eventdata.Indices(1),4});
    disp(outputText);
    for i=1:1:length(selected.files)
       % Output Files/Actions 
       outputText = sprintf(' -> %s   %s', selected.actions{i},selected.files{i});
       disp(outputText);
    end
end

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

% Loading Animation
d = showLoadingAnimation('Searching for Open Models...', 'Please wait...');

try

    openModels = find_system('SearchDepth', 0);
    modelList = {};
    for i=1:1:length(openModels)
       if strcmp(get_param(openModels{i},'Shown'),'on') 
           % Open Model
           modelList{end+1} = openModels{i};
       end
    end
    
    % Disable Loading Animation
    hideLoadingAnimation(d); 
    
    if ~isempty(modelList)
        [Selection,ok] = listdlg('PromptString', 'Select a Model:', 'SelectionMode', 'single', 'ListString', modelList);
        if ok==1 && ~isempty(Selection)
            % Load ConfigSet
            configStruct = load(fullfile(handles.homeDir,'rps','cfg','basicSimulinkConfigSet.mat'),'basicSimulinkConfig');
            % Add current include paths
            configStruct.basicSimulinkConfig=addIncludePathToConfigSet(configStruct.basicSimulinkConfig);
            
            % Look if RapidProt.. already present
            sets = getConfigSets(modelList{Selection});
            for cfg = 1:1:length(sets)
                % Check for RapidProt..
                if strcmp(sets{cfg},'RapidPrototypingSystem_Configuration')
                    % Found one, set to another config set and delete
                    if length(sets)>1
                        % another cfg present
                        for oldcfg = 1:1:length(cfg)
                            if ~isequal(cfg,oldcfg)
                               % Save name of other cfg
                               oldCfgName = sets{oldcfg};
                            end
                        end
                        % Set old cfg
                        setActiveConfigSet(modelList{Selection},oldCfgName);
                        % Detach RapidProt... CFG
                        detachConfigSet(modelList{Selection},'RapidPrototypingSystem_Configuration');
                    else
                        % Cannot do anything
                        errordlg('Cannot apply RapidPrototypingSystem_Configuration because it is the only one availabe!', 'Cannot Apply Config Set!');
                        error('Cannot apply RapidPrototypingSystem_Configuration because it is the only one availabe! Please create a basic Configuration first or delete the present manually.');
                    end
                end
            end
            
            % Publish Config to Model
            attachConfigSet(modelList{Selection},configStruct.basicSimulinkConfig);
            setActiveConfigSet(modelList{Selection},'RapidPrototypingSystem_Configuration');
        end
    else
       errordlg('No open models have been found!', 'No Models Found!');
    end
    
    figure(gcf);
catch err
    % save state...
    hideLoadingAnimation(d); 
    figure(gcf);
    % Show error..
    rethrow(err);
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


% --------------------------------------------------------------------
function svn_delete_Callback(hObject, eventdata, handles)
% hObject    handle to svn_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_open_Callback(hObject, eventdata, handles)
% hObject    handle to file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_openRpsLib_Callback(hObject, eventdata, handles)
% hObject    handle to file_openRpsLib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Search for RPS-Libraries
fPath = fullfile(handles.homeDir, 'blocks');
fNames = dir( fullfile(fPath,'*.slx') );
fNames = strcat({fNames.name});

% Generate List of possible libs
modelList = {};
for i=1:length(fNames)
    modelList{end+1} =  fullfile(fNames{i});
end

if ~isempty(modelList)
    [Selection,ok] = listdlg('PromptString', 'Select a Library:', 'SelectionMode', 'single', 'ListString', modelList);
    if ok==1 && ~isempty(Selection)
        % Open selected Model/Lib
        open_system(fullfile(fPath,modelList{Selection}));
    end
else
   errordlg('No open models have been found!', 'No Models Found!');
end

% --------------------------------------------------------------------
function file_openModel_Callback(hObject, eventdata, handles)
% hObject    handle to file_openModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile({'*.slx;*.mdl','Models (*.slx, *.mdl)'},...
    'Please Pick a Simulink Model File', 'MultiSelect', 'off');
if ~isequal(filename,0)
   % Selected and open
   open_system(fullfile(path,filename));
end


% --------------------------------------------------------------------
function file_openLibs_Callback(hObject, eventdata, handles)
% hObject    handle to file_openLibs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile({'*.slx;*.mdl','Models (*.slx, *.mdl)'},...
    'Please Pick a Simulink Library File', 'MultiSelect', 'off');
if ~isequal(filename,0)
   % Selected and open
   open_system(fullfile(path,filename));
end
