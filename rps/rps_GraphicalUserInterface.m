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

% Last Modified by GUIDE v2.5 13-Jun-2015 22:16:51

% Modified:     13.06.2015, Daniel Schneider, "Modified OpeningFcn for new userconfig structure and svnAbstraction."
%               xx...

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

% Check if started in offline mode
if nargin == 4  % varargin{1} ... offline mode = true/false
    handles.offlineMode = varargin{1};
    handles.offlineMode = handles.offlineMode{1};
    disp('### Started RPS in offline mode.')
    
    % Disable SVN Menus, others will be disabled later
    set(handles.svn_connect,'Enable', 'off');
else
    % No offline mode
    handles.offlineMode = false;
    
    % Initialize Credentials Validated and Server Validated Preference
    setpref('RapidPrototypingSystem','SVNCredentialsValidated', false);
    setpref('RapidPrototypingSystem', 'SVNServerValidated', false);
end

% Create Menu Icons
set(hObject, 'Visible', 'on');
pause(0.25);
set(hObject, 'Visible', 'off');
addMenuIcons(hObject, handles);

% Save rps home path
pref_group = 'RapidPrototypingSystem';
handles.homeDir = getpref(pref_group, 'HomeDir');
iconsFolder = fullfile(handles.homeDir, 'rps', 'etc', 'icons_18');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','icons_18','bmw_icon.png'));
jframe.setFigureIcon(jIcon);

% Load svn icon
btn_im = imread(fullfile(iconsFolder, 'bmw_symbol_warning_18_r.png'));
set(handles.btn_icon, 'CData', btn_im, 'Visible', 'off');

% Actualize version information
if ispref(pref_group, 'version');
    version = getpref(pref_group, 'version');
else
    version = '!!Version!!';
end

% Splash Screen
s = SplashScreen( 'Rapid-Prototyping-System', 'splashScreen.png', ...
                        'ProgressBar', 'off', ...
                        'ProgressPosition', 5, ...
                        'ProgressRatio', 0.8 );
s.addText( 30, 40, 'Rapid-Prototyping-System', 'FontSize', 25,'FontName','BMW Group', 'Color', 'white' ,'FontWeight','bold');
s.addText( 30, 75, version, 'FontSize', 25,'FontName','BMW Group', 'Color', 'white' );
s.addText( 380, 360, 'Loading...', 'FontSize', 30,'FontName','BMW Group', 'Color', 'white','FontWeight','bold' );

% Check if login details should be deleted
if ispref('RPSuserconfig', 'credentialsSaved')
    if ~getpref('RPSuserconfig', 'credentialsSaved')
        % Delete auth.mat.aes if availabe
        if isequal(exist(fullfile(handles.homeDir,'auth.mat.aes'),'file'),2)
                % Delete
                delete(fullfile(handles.homeDir,'auth.mat.aes'));
        end
    end
end

% Check for First Startup
if ispref(pref_group, 'FirstStartup')
    if getpref(pref_group, 'FirstStartup') && isequal(exist(fullfile(handles.homeDir, 'rps', 'fcn','startup_rps.m'),'file'),2)
        % Remove old startup_rps.m in homeDir
        if isequal(exist(fullfile(handles.homeDir,'startup_rps.m'),'file'),2)
            % Delete old startup_rps.m
            delete(fullfile(handles.homeDir,'startup_rps.m'));
        end
        % Publish to Preferences
        setpref(pref_group, 'FirstStartup', false);
    end
end

% Check if userconfig is saved
if ~ispref('RPSuserconfig') && getpref(pref_group, 'PreferencesReminder') && ~handles.offlineMode
    % Question if first Startup, ask if preferences should be opened
    choice = questdlg('No Userconfig for the RPS has been found. Do you want to start the preferences dialog?',...
        'No RPS Userconfig Found!', 'Yes', 'No', 'Never ask again', 'Yes');
    drawnow; pause(0.05); %Bugfix: 14.06.2015, Daniel Schneider, "Common Prob: Wait after dlg because MATLAB freezes"
    switch choice
        case 'Yes'
            % Run Preferences Dialog
            options;
            drawnow; pause(0.05); %Bugfix: 14.06.2015, Daniel Schneider, "Common Prob: Wait after dlg because MATLAB freezes"
        case 'Never ask again'
            setpref(pref_group,'PreferencesReminder', false);
    end
end
    
% Load Userconfig
[hObject, handles] = loadUserDataToHandles(hObject,handles);

% Check if SVN is connected
if ispref('RPSuserconfig') && ~isempty(getpref('RPSuserconfig','url')) && ~handles.offlineMode
    if ~getpref(pref_group,'SVNConnected') && getpref(pref_group, 'SVNConnectReminder')
        choiceStr = sprintf('You are not connected to a SVN-Server. Do you want to connect to %s? \nPlease mind that changes since installation will be reverted/deleted!',...
            getpref('RPSuserconfig', 'url'));
    	choice = questdlg(choiceStr,...
            'Not Connected with Server!', 'Yes', 'No', 'Never ask again', 'Yes');
        drawnow; pause(0.05); %Bugfix: 14.06.2015, Daniel Schneider, "Common Prob: Wait after dlg because MATLAB freezes"
        switch choice
            case 'Yes'
                % Start Loading Animation
                d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Connecting to Server', []);
                d.setValue(0.25);                        % default = 0
                d.setProgressStatusLabel('Please wait, checking out...');  % default = 'Please Wait'
                d.setSpinnerVisible(false);               % default = true
                d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
                d.setCancelButtonVisible(false);          % default = true
                d.setVisible(true);                      % default = false
                % Run SVNConnect Function
                if svnAbstraction('checkout',  fullfile(handles.url,'trunk','rps'), fullfile(handles.homeDir, 'rps'), 'infinity') ~= -1   % repository, destination, depth
                    % Run other commands
                    svnAbstraction('checkout',  fullfile(handles.url,'trunk','blocks'), fullfile(handles.homeDir, 'blocks'), 'infinity');
                    svnAbstraction('checkout',  fullfile(handles.url,'trunk','help'), fullfile(handles.homeDir, 'help'), 'infinity');
                    % Revert
                    d.setProgressStatusLabel('Please wait, reverting...');
                    svnAbstraction('revert',fullfile(handles.homeDir, 'rps'));
                    svnAbstraction('revert',fullfile(handles.homeDir, 'blocks'));
                    svnAbstraction('revert',fullfile(handles.homeDir, 'help'));
                    d.setProgressStatusLabel('Please wait, validating...');
                    % Check if connected
                    if isequal(exist(fullfile(handles.homeDir, 'rps','.svn'),'dir'),7) && ...
                            isequal(exist(fullfile(handles.homeDir, 'blocks','.svn'),'dir'),7) && ...
                            isequal(exist(fullfile(handles.homeDir, 'help','.svn'),'dir'),7)
                        % valid and everything connected
                        setpref(pref_group,'SVNConnected',true);
                        
                        % Maybe something changed, checkLocalWorkingCopy for Revision, ..
                        [ret] = svnAbstraction('wcInfo', fullfile(handles.homeDir,'rps'));
                        handles.revision = ret.revision;
                        handles.repoFolder = ret.folder;

                        % Store Revision & Folder into userconfig
                        setpref('RPSuserconfig', 'revision', handles.revision);
                        setpref('RPSuserconfig', 'folder', handles.repoFolder);
                    else
                        uiwait(errordlg('Something went wrong during connecting process. You are still in "not connected" state.', 'Something Wrong'));
                    end
                    
                    d.setProgressStatusLabel('Please wait, retrieving recent changes...');
                    d.setVisible(false);   
                else
                    d.setVisible(false);   
                    uiwait(errordlg('Something went wrong during connecting process. You are still in "not connected" state.', 'Something Wrong'));
                end
            case 'Never ask again'
                setpref(pref_group,'SVNConnectReminder', false);
        end
    end
end

% Disable SVN Menu Items if SVN is not connected!
if ~getpref(pref_group,'SVNConnected') || handles.offlineMode
    % Disable
    set(handles.svn_branch, 'Enable', 'off');
    set(handles.svn_switch, 'Enable', 'off');
    set(handles.svn_delete, 'Enable', 'off');
    set(handles.svn_refresh, 'Enable', 'off');
    set(handles.svn_update, 'Enable', 'off');
    set(handles.checkUpdates_btn, 'Enable', 'off');
else
    % Enable
    set(handles.svn_connect,'Enable', 'off');
    set(handles.svn_branch, 'Enable', 'on');
    set(handles.svn_switch, 'Enable', 'on');
    set(handles.svn_delete, 'Enable', 'on');
    set(handles.svn_refresh, 'Enable', 'on');
    set(handles.svn_update, 'Enable', 'on');
end

% Fill log with actual stuff
if (getpref(pref_group, 'SVNConnected') && ~handles.offlineMode) &&...
        (ispref('RPSuserconfig') && ~isempty(getpref('RPSuserconfig','url')))
    [ret] = svnAbstraction('log');
else
    ret = {};
end

% Check if no error
if isfield(ret,'log')
    log = ret.log;
    files = ret.files;
    % Set log table
    set(handles.log_table,'Data',log);
    % Publish Handles
    handles.log = log;
    handles.logFiles = files;
else
    handles.log = {};
    handles.logFiles = {};
    set(handles.log_table,'Data',{});
end

% Create Timer Object
handles.AutoUpdateTimer = timer('TimerFcn', {@timerCallback, hObject, handles},... 
                 'StartDelay',5,...
                 'ExecutionMode', 'fixedSpacing',...
                 'Period', (handles.updateInterval*60),...
                 'Name', 'AutoUpdateTimer');

% Check wether autoUpdate is on/off
if handles.autoUpdate && getpref(pref_group, 'SVNConnected') && ~handles.offlineMode && (ret ~= -1)
    % activate Timer
    start(handles.AutoUpdateTimer);
end

% Choose default command line output for rps_GraphicalUserInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Check if local repo is outdated
checkForOutdated(hObject, handles);

% UIWAIT makes rps_GraphicalUserInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function timerCallback(obj, event, hObject, handles)
disp('### Refreshing log...')

% Show loading animation
d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Refreshing Log...', []);
d.setValue(0.25);                        % default = 0
d.setProgressStatusLabel('Please wait, refreshing recent changes...');  % default = 'Please Wait'
d.setSpinnerVisible(false);               % default = true
d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
d.setCancelButtonVisible(false);          % default = true
d.setVisible(true);                      % default = false

% Fill log with actual stuff
% Fill log with actual stuff
[ret] = svnAbstraction('log');
% Check if no error occured
if isfield(ret,'log')
    log = ret.log;
    files = ret.files;
else
    log = {};
    files = {};
end

set(handles.log_table,'Data',log);
handles.log = log;
handles.logFiles = files;

% Publish handles
guidata(hObject, handles);

% Check if local repo is outdated
checkForOutdated(hObject, handles);

d.setVisible(false);                      % default = false



function addMenuIcons(figure, handles)
% File
set(handles.file_menu, 'UserData', 'BMW-neg_med_document_18.png');
set(handles.file_new, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.new_library, 'UserData', 'BMW-neg_nav_overview_18.png');
set(handles.new_model, 'UserData', 'BMW-neg_med_stop_18.png');
set(handles.new_legacyCode, 'UserData', 'c_logo.png');
set(handles.file_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.sim_preferences, 'UserData', 'BMW-neg_com_settings_18.png');
set(handles.file_exit, 'UserData', 'BMW-neg_nav_close_18.png');
set(handles.file_open, 'UserData', 'BMW-neg_nav_imagegallery_18.png');
set(handles.file_openRpsLib, 'UserData', 'BMW-neg_nav_overview_18.png');
set(handles.file_openModel, 'UserData', 'BMW-neg_med_stop_18.png');
set(handles.file_openLibs, 'UserData', 'BMW-neg_nav_overview_18.png');
set(handles.preferences_model, 'UserData', 'BMW-neg_med_stop_18.png');


%SVN
set(handles.svn_menu, 'UserData', 'BMW-neg_act_replace_18.png');
set(handles.svn_refresh, 'UserData', 'BMW-neg_int_update_18.png');
set(handles.svn_update, 'UserData', 'BMW-neg_act_download_18.png');
set(handles.svn_branch, 'UserData', 'BMW-neg_act_open_18.png');
set(handles.svn_switch, 'UserData', 'BMW-neg_act_replace_18.png');
set(handles.svn_delete, 'UserData', 'BMW-neg_act_delete_18.png');
set(handles.svn_connect, 'UserData', 'BMW-neg_com_share_18.png');


%SupportPackages
set(handles.supportPkg_menu, 'UserData', 'BMW-neg_act_download_18.png');
set(handles.supportPkg_install, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.supportPkg_custom, 'UserData', 'BMW-neg_act_logout_18.png');
set(handles.supportPkg_mathworks, 'UserData', 'Matlab_Logo.png');
set(handles.supportPkg_arduino, 'UserData', 'arduino_logo.png');
set(handles.supportPkg_tm4c1294npdt, 'UserData', 'ti_logo.png');
set(handles.supportPkg_url, 'UserData', 'BMW-neg_nav_more_18.png');
set(handles.supportPkg_template, 'UserData', 'BMW-neg_com_toolbox_18.png');


%Help
set(handles.help_menu, 'UserData', 'BMW-neg_com_help_18.png');
set(handles.help_about, 'UserData', 'BMW-neg_com_info_18.png');

% Set the icons 
Figure_Menu_Add_Icons(figure);


function checkForOutdated(hObject, handles)
% Maybe something changed, checkLocalWorkingCopy for Revision, ..
if ispref('RapidPrototypingSystem', 'SVNConnected')
    if getpref('RapidPrototypingSystem', 'SVNConnected')
        [ret] = svnAbstraction('wcInfo', fullfile(handles.homeDir,'rps'));
        handles.revision = ret.revision;
        handles.repoFolder = ret.folder;
        % Store Revision & Folder into userconfig
        setpref('RPSuserconfig', 'revision', handles.revision);
        setpref('RPSuserconfig', 'folder', handles.repoFolder);
        
        % Publish handles
        guidata(hObject, handles);
    end
end

if isfield(handles, 'log') && ~isempty(handles.log)
    if handles.revision<str2num(handles.log{1,1})
        set(handles.btn_icon, 'Visible', 'on');
        set(handles.revision_edit, 'String',num2str(handles.revision));
    else
        set(handles.btn_icon, 'Visible', 'off');
        set(handles.revision_edit, 'String',num2str(handles.revision));
    end
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

% Start Update Dialog with revision
[updateFigure, done] = updateDialog({handles.url});
if done
    %Updating gui... and configuration file
    [ret] = svnAbstraction('wcInfo',fullfile(handles.homeDir,'blocks'));

    handles.revision = ret.revision;
    handles.repoFolder = ret.folder;

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

    % Save changes to userconfig
    group = 'RPSuserconfig';
    setpref(group, 'revision',handles.revision);
    setpref(group, 'folder', handles.repoFolder);
    setpref(group, 'simulinkDefaultPreferences', handles.simulinkPereferences);

    % Refresh MATLAB paths
    addRpsPaths()

    % Rehash and Reload Simulink Browser
    rehash;
    libBrow = LibraryBrowser.StandaloneBrowser;
    libBrow.refreshLibraryBrowser;
end
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
    [optionsFig, switchRepository] = options;
    if switchRepository==true
        %close(gcf);
        % Restart GUI
        rps_GraphicalUserInterface;
        return;
    end
    [hObject, handles] = loadUserDataToHandles(hObject, handles);

    % Update handles structure
    guidata(hObject, handles);
    
    % Check wether autoUpdate is on/off
    if handles.autoUpdate ==true && getpref('RapidPrototypingSystem', 'SVNConnected')==true
        % activate Timer
        timer = timerfind('Name', 'AutoUpdateTimer');
        if ~isempty(timer)
            stop(timer);
            set(timer,'Period', (handles.updateInterval*60));
            start(timer);
        end
    else
        % deactivate Timer
        timer = timerfind('Name', 'AutoUpdateTimer');
        if ~isempty(timer)
            stop(timer);
        end
    end
catch err
    enableDisableFig(gcf,'on');
    figure(gcf);
    rethrow(err);
end
enableDisableFig(gcf,'on');
figure(gcf);

function [hObject, handles] = loadUserDataToHandles(hObject,handles)
% read userconfig and save in handles
[status, config] = getUserconfigValues();

if status == -1
    % Pref Group
    group = 'RPSuserconfig';
    
    % Save to Userconfig
    setpref(group,'updateInterval',config.updateInterval);
    setpref(group,'autoUpdate',config.autoUpdate);
    setpref(group,'folder',config.repoFolder);
    setpref(group,'revision',config.revision);
    setpref(group,'customUrl',config.customUrl);
    setpref(group,'credentialsSaved',config.credentialsSaved);
    setpref(group,'credentialsNeeded',config.credentialsNeeded);
    setpref(group,'simulinkDefaultPreferences',config.simulinkPreference);
    setpref(group,'proxyRequired',config.proxyRequired);
    setpref(group,'proxyAddress',config.proxyAddress);
    setpref(group,'proxyPort',config.proxyPort);
    setpref(group,'proxyExceptions',config.proxyExceptions);
    setpref(group,'maxLogEntries', config.maxLogEntries);
    setpref(group,'url', config.url);
end

% create basic handles
handles.updateInterval = config.updateInterval;
handles.autoUpdate = config.autoUpdate;
handles.customUrl = config.customUrl;
handles.credentialsNeeded = config.credentialsNeeded;
handles.credentialsSaved = config.credentialsSaved;
handles.url = config.url;
handles.repoFolder = config.repoFolder;
handles.revision = config.revision;
handles.maxLogEntries = config.maxLogEntries;
handles.simulinkPereferences = config.simulinkPreference;
handles.proxyPort = config.proxyPort;
handles.proxyAddress = config.proxyAddress;
handles.proxyRequired = config.proxyRequired;
handles.proxyExceptions = config.proxyExceptions;

% Check if Connected
if getpref('RapidPrototypingSystem', 'SVNConnected')
    % Maybe something changed, checkLocalWorkingCopy for Revision, ..
    [ret] = svnAbstraction('wcInfo', fullfile(handles.homeDir,'rps'));
    handles.revision = ret.revision;
    handles.repoFolder = ret.folder;

    % Store Revision & Folder into userconfig
    setpref('RPSuserconfig', 'revision', handles.revision);
    setpref('RPSuserconfig', 'folder', handles.repoFolder);
end
    
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
    
    % Save to userconfig
    setpref('RPSuserconfig', 'simulinkDefaultPreferences',true);
    
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
    
    % Save to userconfig
    setpref('RPSuserconfig', 'simulinkDefaultPreferences',false);
    
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
try
    url = handles.url;
    branchTagSvnDialog({url},handles.revision,handles.repoFolder);
    enableDisableFig(gcf,'on');
    figure(gcf);
catch err
    enableDisableFig(gcf,'on');
    figure(gcf);
    rethrow(err);
end



% --------------------------------------------------------------------
function svn_switch_Callback(hObject, eventdata, handles)
% hObject    handle to svn_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(gcf,'off');
% Info: {1} = Repository URL, {2} = Local Revision, {3} = Local Folder, {4}
% = passwordNeeded
try
    [switchFig, isSwitched, newFolder] = switchSvnDialog(...
        {handles.url},...
        handles.revision,...
        handles.repoFolder);
    
    % Handle SwitchDialog Outputs (Switched? to which folder?)
    if isSwitched
        % Load Userconfig and add it to XML
        if ischar(newFolder)
            setpref('RPSuserconfig', 'folder',newFolder)
            set(handles.repo_edit, 'String', newFolder);
            
            % Publish to handles
            handles.repoFolder = newFolder;
            guidata(hObject, handles);
            
            % Refresh log
            checkUpdates_btn_Callback(hObject, eventdata, handles);
        end
    end
    
    enableDisableFig(gcf,'on');
    figure(gcf);
catch err
    % Error
    enableDisableFig(hObject,'on');
    figure(gcf);
    rethrow(err);
end


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
[ret] = svnAbstraction('log');
% Check if no error occured
if isfield(ret,'log')
    log = ret.log;
    files = ret.files;
else
    log = {};
    files = {};
end

% Create Handles and set log
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
if length(eventdata.Indices)>0 && ~isempty(handles.log) && ~isempty(handles.logFiles)
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

% Start Update Dialog with revision
deleteSvnDialog({handles.url}, handles.repoFolder);

figure(gcf);

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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% Check if delete login details
if ispref('RPSuserconfig', 'credentialsSaved')
    if ~getpref('RPSuserconfig', 'credentialsSaved')
        % Delete auth.mat.aes if availabe
        if isequal(exist(fullfile(handles.homeDir,'auth.mat.aes'),'file'),2)
            % Delete
            delete(fullfile(handles.homeDir,'auth.mat.aes'));
        end
    end
end

timer = timerfind('Name', 'AutoUpdateTimer');
if ~isempty(timer)
    stop(timer);
    delete(timer);
end
delete(hObject);


% --------------------------------------------------------------------
function svn_connect_Callback(hObject, eventdata, handles)
% hObject    handle to svn_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check if SVN is connected
if ispref('RPSuserconfig') && ~isempty(getpref('RPSuserconfig','url'))
    if ~getpref('RapidPrototypingSystem','SVNConnected')
        choiceStr = sprintf('Do you want to connect to "%s"? \nPlease mind that changes since installation will be reverted/deleted!',...
            getpref('RPSuserconfig', 'url'));
    	choice = questdlg(choiceStr,...
            'Connect to Server!', 'Yes', 'No', 'Yes');
        switch choice
            case 'Yes'
                % Start Loading Animation
                d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Connecting to Server', []);
                d.setValue(0.25);                        % default = 0
                d.setProgressStatusLabel('Please wait, checking out...');  % default = 'Please Wait'
                d.setSpinnerVisible(false);               % default = true
                d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
                d.setCancelButtonVisible(false);          % default = true
                d.setVisible(true);                      % default = false
                % Run SVNConnect Function
                if svnAbstraction('checkout',  fullfile(handles.url,'trunk','rps'), fullfile(handles.homeDir, 'rps'), 'infinity') ~= -1   % repository, destination, depth
                    % Run other commands
                    svnAbstraction('checkout',  fullfile(handles.url,'trunk','blocks'), fullfile(handles.homeDir, 'blocks'), 'infinity');
                    svnAbstraction('checkout',  fullfile(handles.url,'trunk','help'), fullfile(handles.homeDir, 'help'), 'infinity');
                    % Revert
                    d.setProgressStatusLabel('Please wait, reverting...');
                    svnAbstraction('revert',fullfile(handles.homeDir, 'rps'));
                    svnAbstraction('revert',fullfile(handles.homeDir, 'blocks'));
                    svnAbstraction('revert',fullfile(handles.homeDir, 'help'));
                    
                    d.setProgressStatusLabel('Please wait, validating...');
                    % Check if connected
                    if isequal(exist(fullfile(handles.homeDir, 'rps','.svn'),'dir'),7) && ...
                            isequal(exist(fullfile(handles.homeDir, 'blocks','.svn'),'dir'),7) && ...
                            isequal(exist(fullfile(handles.homeDir, 'help','.svn'),'dir'),7)
                        % valid and everything connected
                        setpref('RapidPrototypingSystem','SVNConnected',true);
                        % Maybe something changed, checkLocalWorkingCopy for Revision, ..
                        [ret] = svnAbstraction('wcInfo', fullfile(handles.homeDir,'rps'));
                        handles.revision = ret.revision;
                        handles.repoFolder = ret.folder;

                        % Store Revision & Folder into userconfig
                        setpref('RPSuserconfig', 'revision', handles.revision);
                        setpref('RPSuserconfig', 'folder', handles.repoFolder);
                        
                        % Enable GUI Components
                        set(handles.svn_connect,'Enable', 'off');
                        set(handles.svn_branch, 'Enable', 'on');
                        set(handles.svn_switch, 'Enable', 'on');
                        set(handles.svn_delete, 'Enable', 'on');
                        set(handles.svn_refresh, 'Enable', 'on');
                        set(handles.svn_update, 'Enable', 'on');
                        d.setVisible(false);   
                        
                        % Refresh Log
                        checkUpdates_btn_Callback(hObject, eventdata, handles);
                    else
                        d.setVisible(false);   
                        uiwait(errordlg('Something went wrong during connecting process. You are still in "not connected" state.', 'Something Wrong'));
                    end
                else
                    d.setVisible(false);   
                    uiwait(errordlg('Something went wrong or connecting process aborted. You are still in "not connected" state.', 'Something Wrong/Aborted'));
                end
            otherwise
                % do nothing
                return;
        end
    else
        uiwait(errordlg('You are still connected. This menu item should not be available during connected state.', 'Something Wrong'));
    end
else
    uiwait(errordlg('Missing SVN URL/Preferences! Please fill in all neccessary preferences.','Missing Preferences'));
end

% --------------------------------------------------------------------
function supportPkg_template_Callback(hObject, eventdata, handles)
% hObject    handle to supportPkg_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_icon.
function btn_icon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
