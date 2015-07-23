function varargout = options(varargin)
% OPTIONS MATLAB code for options.fig
%      OPTIONS, by itself, creates a new OPTIONS or raises the existing
%      singleton*.
%
%      H = OPTIONS returns the handle to a new OPTIONS or the handle to
%      the existing singleton*.
%
%      OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIONS.M with the given input arguments.
%
%      OPTIONS('Property','Value',...) creates a new OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help options

% Last Modified by GUIDE v2.5 11-Jun-2015 09:43:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @options_OpeningFcn, ...
                   'gui_OutputFcn',  @options_OutputFcn, ...
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


%% Rapid-Prototyping-System Preferences
% This Graphical User Interface is meant to let the user define it's basic
% configurations regarding the system. Following Preferences can be
% defined:
%%
% 
% * Choose SVN-Repository URL
% * Turn AutoUpdate on/off and decide interval in minutes
% * Save credentials needed for SVN-Repo
% 
%% Choosing SVN-Repository URL
% There are two ways how to define the URL of a suitable SVN-Repository.
% Remember that only Repositories that contain the correct folder structure
% can be used for the RPS. 
%%
% 
% # One way to choose from a predefined URL-List is using the given
% Popupmenu (seen in the top of the picture below).
% # Another possibility is to define your own URL by clicking the "Custom
% URL" checkcontrols.
% 
%%
% 
% <<svnRepo.png>>
% 
% *Important:* As you can see in the popupmenu, there are stated *PRIVATE*
% or *PUBLIC* at the end of the line. As a result some repositories will
% need login credentials and some won't. If you are going to define your
% own custom url, please make sure that you provide login credentials if
% needed.
%% Custom URL Definitions
% If your are going to choose a custom URL please type in the top path of
% your SVN-Repository and not the trunk/tags/.. folders. For example:
%%
% 
% * https:\\yourSVN-repository.url\repositoryName\ ... *(CORRECT)*
% * https:\\yourSVN-repository.url\repositoryName\trunk\ ... *(WRONG)*
% 
%% Saving SVN Login-Credentials
% By clicking the checkcontrol "Login/Password needed" the button "Save
% Credentials..." will get enabled. For saving your credentials please
% click the button and insert your credentials in the new window. If login
% credentials are present or have been saved, a green text will appear.
%%
% *Remeber:*
%%
% Don't worry about the security of your stored login and password. They
% have been stored in the file credentials.xml.aes by using 128-bit AES
% encryption. You cannot copy and use these login informations
% by another computer.
%%
% 
% <<svnCredentials.png>>
% 





% --- Executes just before options is made visible.
function options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to options (see VARARGIN)

% Create Java Password Edit Field
handles.java_Password = javax.swing.JPasswordField();
[handles.java_Password, handles.edit_password] = javacomponent(handles.java_Password, [99 138 103 22], handles.figure1);
handles.java_Password.setFocusable(true);

% Create Java Proxy Password Edit Field
handles.java_proxyPassword = javax.swing.JPasswordField();
[handles.java_proxyPassword, handles.edit_proxyPassword] = javacomponent(handles.java_proxyPassword, [337 108 116 22], handles.figure1);
handles.java_proxyPassword.setFocusable(true);

% Set Edit Password Handles
set(handles.edit_password, 'Parent', handles.figure1, 'Tag', 'edit_password', 'Units', 'Pixels','Position',[99 138 103 22]);
set(handles.edit_proxyPassword, 'Parent', handles.figure1, 'Tag', 'edit_proxyPassword', 'Units', 'Pixels','Position',[337 108 116 22]);
drawnow;    % This drawnow is required to allow the focus to work

% Save rps home path
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','icons_18','BMW-neg_com_settings_18.png'));
jframe.setFigureIcon(jIcon);

% Load Preferences icon
pref_icon = imread(fullfile(handles.homeDir,'rps','etc','icons_18', 'preferences-icon.png'));
set(handles.btn_icon, 'CData', pref_icon);

% Get old userconfig values ...
[status ,config] = getUserconfigValues();

% create basic handles
handles.updateInterval = config.updateInterval;
handles.autoUpdate = config.autoUpdate;
handles.customUrl = config.customUrl;
handles.credentialsSaved = config.credentialsSaved;
handles.credentialsNeeded = config.credentialsNeeded;
handles.url = config.url;
handles.repoFolder = config.repoFolder;
handles.revision = config.revision;
handles.switchRepository = false;
handles.proxyAddress = config.proxyAddress;
handles.proxyRequired = config.proxyRequired;
handles.proxyPort = config.proxyPort;
handles.proxyExceptions = config.proxyExceptions;
handles.maxLogEntries =  config.maxLogEntries;

% Set Max Log Entries
set(handles.edit_maxLogEntries, 'String', num2str(handles.maxLogEntries));

% Set Proxy GUI Components
set(handles.edit_proxyAddress, 'String', handles.proxyAddress);
set(handles.edit_proxyPort, 'String', num2str(handles.proxyPort));
set(handles.edit_proxyExceptions, 'String', handles.proxyExceptions);
set(handles.checkbox_proxyRequired, 'Value', handles.proxyRequired);
set(handles.edit_proxyUsername, 'String', '');

% Check if Proxy Required
if handles.proxyRequired
    % Enable fields
    set(handles.edit_proxyUsername, 'Enable', 'on');
    set(handles.edit_proxyAddress, 'Enable', 'on');
    set(handles.edit_proxyPort, 'Enable', 'on');
    set(handles.edit_proxyExceptions, 'Enable', 'on');
    handles.java_proxyPassword.Enable = 1;
else
    % Disable fields
    set(handles.edit_proxyUsername, 'Enable', 'off');
    set(handles.edit_proxyAddress, 'Enable', 'off');
    set(handles.edit_proxyPort, 'Enable', 'off');
    set(handles.edit_proxyExceptions, 'Enable', 'off');
    handles.java_proxyPassword.Enable = 0;
end

% fill in gui components
set(handles.customUrl_cb, 'Value', config.customUrl);
set(handles.credentials_cb, 'Value', config.credentialsSaved);
set(handles.checkUpdates_cb, 'Value', config.autoUpdate);
if handles.autoUpdate==1
    set(handles.updateInterval_edit,'Enable','on')
else
    set(handles.updateInterval_edit,'Enable','off')
end
set(handles.updateInterval_edit, 'String', config.updateInterval);
if config.customUrl==true
    set(handles.customUrl_edit, 'Enable', 'on', 'String', url);
    set(handles.popupmenu_url, 'Enable', 'off');
else
    set(handles.customUrl_edit, 'Enable', 'off', 'String', 'https://svn-test.repo');
    set(handles.popupmenu_url, 'Enable', 'on');
end
if config.credentialsSaved
    set(handles.edit_username, 'Enable','on');
    handles.java_Password.Enable = 1;
else
    set(handles.edit_username, 'Enable','off');
    handles.java_Password.Enable = 0;
end

% Get current url's from xml-file..
xml = xml2struct(fullfile(handles.homeDir,'rps','cfg','repos.xml'));
[x, y] = size(xml.urls.url);
popup_list = {};
userconfigItem = 1;

if y > 0
    for urls = 1:y
        % Check for url in userconfig and save poupmenu value
        if strcmp(xml.urls.url{1,urls}.Text, handles.url)
            % Get Value
            userconfigItem = urls;
        end
        if strcmp(xml.urls.url{1,urls}.Attributes.isPublic, '0')
            % Private
            popup_list{end+1} = [xml.urls.url{1,urls}.Text ' (PRIVATE)' ];
        else
           % Public
            popup_list{end+1} = [xml.urls.url{1,urls}.Text ' (PUBLIC)' ];
        end
        
    end
else
    disp('### Error: Problem starting options.fig because cfg/repos.xml is missing or contains failures! Define URL using Custom URL.');
end

% populate items to popupmenu
if length(popup_list)>0
    set(handles.popupmenu_url, 'String', popup_list, 'Value', userconfigItem);
end

% Get SVN&Proxy Login/Passwords
if isequal(exist(fullfile(handles.homeDir,'auth.mat.aes'),'file'),2)
    % load credentials
    [username,password] = decryptCredentials('credentials');
    set(handles.edit_username, 'String', username);
    handles.java_Password.Text = password;
end
if isequal(exist(fullfile(handles.homeDir,'proxy.mat.aes'),'file'),2)
    % load proxy login/pass
    [username,password] = decryptCredentials('proxy');
    set(handles.edit_proxyUsername, 'String', username);
    handles.java_proxyPassword.Text = password;
end

% Choose default command line output for options
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes options wait for user response (see UIRESUME)
uiwait(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.switchRepository;

% The figure can be deleted now
delete(hObject);


function updateInterval_edit_Callback(hObject, eventdata, handles)
% hObject    handle to updateInterval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of updateInterval_edit as text
%        str2double(get(hObject,'String')) returns contents of updateInterval_edit as a double


% --- Executes during object creation, after setting all properties.
function updateInterval_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updateInterval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save prefgroup
group = 'RPSuserconfig';

d = showLoadingAnimation('Saving preferences...', 'Checking URLs...');
try
    % Get actualized data
    handles.updateInterval = str2num(get(handles.updateInterval_edit,'String'));
    handles.autoUpdate = get(handles.checkUpdates_cb,'Value');
    handles.customUrl = get(handles.customUrl_cb,'Value');
    handles.credentialsSaved = get(handles.credentials_cb,'Value');
    handles.simulinkPereferences = false;
    handles.proxyAddress = get(handles.edit_proxyAddress, 'String');
    handles.proxyPort = str2num(get(handles.edit_proxyPort, 'String'));
    handles.proxyExceptions = get(handles.edit_proxyExceptions, 'String');
    handles.proxyRequired = get(handles.checkbox_proxyRequired, 'Value');
    handles.maxLogEntries = str2num(get(handles.edit_maxLogEntries, 'String'));
    
    % Check if isempty after str2num conversion and set to default value
    if isempty(handles.maxLogEntries)
        handles.maxLogEntries = 20;
    end
    if isempty(handles.proxyPort)
        handles.proxyPort = 8080;
    end
    if isempty(handles.updateInterval)
        handles.handles.updateInterval=20;
    end
    
    % Check if Repo URL is valid
    if handles.customUrl==1
        % Custom URL
        handles.url = get(handles.customUrl_edit, 'String');
    else
        % Popupmenu URL
        handles.url = getCurrentPopupString(handles.popupmenu_url);

        % Check if Private/Public
        if strfind(handles.url,'(PUBLIC)')
            % no creds needed
            handles.credentialsNeeded = false;
        elseif strfind(handles.url,'(PRIVATE)')
            % creds needed
            handles.credentialsNeeded = true;
        end
            
        % Filter private/public out
        handles.url = strsplit(handles.url, ' (P');
        handles.url = handles.url{1};
    end

    if ~isempty(strfind(handles.url,'trunk')) || ...
            ~isempty(strfind(handles.url,'tags')) || ...
            ~isempty(strfind(handles.url,'branches'))
        % Error wrong url given
        uiwait(errordlg('Please delete subfolders in URL (e.g. trunk,tags,branches).','Wrong URL'));
        return;
    end
    
    % Save Credentials
    if get(handles.credentials_cb, 'Value')==1
        encryptCredentials(get(handles.edit_username,'String'),handles.java_Password.Text, 'credentials');
    end
    
    % Save Proxy Login/pass
    if get(handles.checkbox_proxyRequired, 'Value')==1
        encryptCredentials(get(handles.edit_proxyUsername,'String'),handles.java_proxyPassword.Text, 'proxy');
    end

    % Check for local working copy revision and repository folder (trunk, tags/.., branches/..
    d.setProgressStatusLabel('Checking local working copy...');
    
    % Check if Connected
    if ispref('RapidPrototypingSystem', 'SVNConnected')
        if getpref('RapidPrototypingSystem', 'SVNConnected')
            ret = svnAbstraction('wcInfo', fullfile(handles.homeDir, 'rps'));
            handles.revision = ret.revision;
            handles.repoFolder = ret.folder;

            % Save to Preferences
            setpref(group,'folder',handles.repoFolder);
            setpref(group,'revision',handles.revision);
            
            % Check if url is the same repo as local working copy
            if isempty(strfind(handles.url,ret.repoHomeUrl))
                % Another Repo URL, need to checkout/switch to new url/trunk...
                choice = questdlg('You local repository differs from the given URL. Do you really want to switch to another repository?',...
                    'Switching Repository?', 'Yes','No','No');
                drawnow; pause(0.1);
                switch choice
                    case 'Yes'
                        % DO nothing
                        handles.switchRepository = true;
                    case 'No'
                        % NO
                        hideLoadingAnimation(d); 
                        return;
                end
            else
                % Same Repo, nothing to do right now.
                handles.switchRepository = false;
            end
        end
    end

    % Switch Repository Preconfigurations
    if handles.switchRepository
        % Save old values before switching
        old.proxyRequired = getpref(group,'proxyRequired');
        old.proxyAddress = getpref(group,'proxyAddress');
        old.proxyPort = getpref(group,'proxyPort');
        old.proxyExceptions = getpref(group,'proxyExceptions');
        old.url = getpref(group,'url');
        old.customUrl = getpref(group,'customUrl');
        old.credentialsSaved = getpref(group,'credentialsSaved');
        old.credentialsNeeded = getpref(group,'credentialsNeeded');
        % Preserve old auth file if available
        if isequal(exist(fullfile(handles.homeDir,'auth.mat.aes'),'file'),2)
           movefile(fullfile(handles.homeDir,'auth.mat.aes'),fullfile(handles.homeDir,'_auth.mat.aes'),'f');
        end
        % Preserve old proxy file if availabe
        if isequal(exist(fullfile(handles.homeDir,'proxy.mat.aes'),'file'),2)
           movefile(fullfile(handles.homeDir,'proxy.mat.aes'),fullfile(handles.homeDir,'_proxy.mat.aes'),'f');
        end
        old.SVNCredentialsValidated = getpref('RapidPrototypingSystem', 'SVNCredentialsValidated');
        old.SVNServerValidated = getpref('RapidPrototypingSystem', 'SVNServerValidated');
        setpref('RapidPrototypingSystem', 'SVNCredentialsValidated',false);
        setpref('RapidPrototypingSystem', 'SVNServerValidated',false);
    end
    
    % Save to Userconfig
    d.setProgressStatusLabel('Creating userconfig...');
    setpref(group,'url',handles.url);
    setpref(group,'updateInterval',handles.updateInterval);
    setpref(group,'autoUpdate',handles.autoUpdate);
    setpref(group,'folder',handles.repoFolder);
    setpref(group,'revision',handles.revision);
    setpref(group,'customUrl',handles.customUrl);
    setpref(group,'credentialsSaved',handles.credentialsSaved);
    setpref(group,'credentialsNeeded',handles.credentialsNeeded);
    setpref(group,'simulinkDefaultPreferences',handles.simulinkPereferences);
    setpref(group,'proxyRequired',handles.proxyRequired);
    setpref(group,'proxyAddress',handles.proxyAddress);
    setpref(group,'proxyPort',handles.proxyPort);
    setpref(group,'proxyExceptions',handles.proxyExceptions);
    setpref(group,'maxLogEntries', handles.maxLogEntries);
    
    if handles.switchRepository
        d.setProgressStatusLabel('Please wait, switching repository...');
        if svnAbstraction('switchRepo')==-1
            % Reverse changes
            d.setProgressStatusLabel('Switching failed, reverting changes...');
            % Revert prefs
            setpref(group,'url',old.url);
            setpref(group,'customUrl',old.customUrl);
            setpref(group,'credentialsSaved',old.credentialsSaved);
            setpref(group,'credentialsNeeded',old.credentialsNeeded);
            setpref(group,'proxyRequired',old.proxyRequired);
            setpref(group,'proxyAddress',old.proxyAddress);
            setpref(group,'proxyPort',old.proxyPort);
            setpref(group,'proxyExceptions',old.proxyExceptions);
            setpref('RapidPrototypingSystem', 'SVNCredentialsValidated',old.SVNCredentialsValidated);
            setpref('RapidPrototypingSystem', 'SVNServerValidated',old.SVNServerValidated);
            % Revert old auth & proxy file
            if isequal(exist(fullfile(handles.homeDir,'_auth.mat.aes'),'file'),2)
               movefile(fullfile(handles.homeDir,'_auth.mat.aes'),fullfile(handles.homeDir,'auth.mat.aes'),'f');
            end
            if isequal(exist(fullfile(handles.homeDir,'_proxy.mat.aes'),'file'),2)
               movefile(fullfile(handles.homeDir,'_proxy.mat.aes'),fullfile(handles.homeDir,'proxy.mat.aes'),'f');
            end
            % Do not save and stop switch process
            hideLoadingAnimation(d);
            return;
        end
    end
    
    % Remove temp proxy/auth files
    if isequal(exist(fullfile(handles.homeDir,'_auth.mat.aes'),'file'),2)
        delete(fullfile(handles.homeDir,'_auth.mat.aes'));
    end
    if isequal(exist(fullfile(handles.homeDir,'_proxy.mat.aes'),'file'),2)
        delete(fullfile(handles.homeDir,'_proxy.mat.aes'));
    end
    
    % Save Handles
    guidata(hObject, handles);
    
    hideLoadingAnimation(d);
    disp(' ### DONE saving preferences!');

    % Close Options Menu
    close(gcf);
    
catch err
   hideLoadingAnimation(d); 
   rethrow(err);
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

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes on selection change in popupmenu_url.
function popupmenu_url_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_url contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_url


% --- Executes during object creation, after setting all properties.
function popupmenu_url_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in customUrl_cb.
function customUrl_cb_Callback(hObject, eventdata, handles)
% hObject    handle to customUrl_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of customUrl_cb
if get(handles.customUrl_cb,'Value')==1
    set(handles.customUrl_edit,'Enable', 'on');
    set(handles.popupmenu_url,'Enable', 'off');
    handles.customUrl=true;
else
    set(handles.customUrl_edit,'Enable', 'off');
    set(handles.popupmenu_url,'Enable', 'on');
    handles.customUrl=false;
end


function customUrl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to customUrl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customUrl_edit as text
%        str2double(get(hObject,'String')) returns contents of customUrl_edit as a double


% --- Executes during object creation, after setting all properties.
function customUrl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customUrl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkUpdates_cb.
function checkUpdates_cb_Callback(hObject, eventdata, handles)
% hObject    handle to checkUpdates_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkUpdates_cb
if get(handles.checkUpdates_cb,'Value')==1
    set(handles.updateInterval_edit,'Enable', 'on');
    handles.updateInterval = str2num(get(handles.updateInterval_edit,'String'));
    handles.autoUpdate = true;
else
    set(handles.updateInterval_edit,'Enable', 'off');
    handles.updateInterval = 0;
    handles.updateInterval = false;
    handles.autoUpdate = false;
end

% --- Executes on button press in credentials_cb.
function credentials_cb_Callback(hObject, eventdata, handles)
% hObject    handle to credentials_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of credentials_cb
if get(handles.credentials_cb,'Value')==1
    set(handles.edit_username,'Enable', 'on');
    handles.java_Password.Enable = 1;
else
    set(handles.edit_username,'Enable', 'off');
    handles.java_Password.Enable = 0;
end


% --- Executes on button press in help_btn.
function help_btn_Callback(hObject, eventdata, handles)
% hObject    handle to help_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showdemo options


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
    showdemo options;
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


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_icon.
function btn_icon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_proxyRequired.
function checkbox_proxyRequired_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_proxyRequired (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_proxyRequired
if get(handles.checkbox_proxyRequired, 'Value')
    % Enable fields
    set(handles.edit_proxyUsername, 'Enable', 'on');
    set(handles.edit_proxyAddress, 'Enable', 'on');
    set(handles.edit_proxyPort, 'Enable', 'on');
    set(handles.edit_proxyExceptions, 'Enable', 'on');
    handles.java_proxyPassword.Enable = 1;
else
    % Disable fields
    set(handles.edit_proxyUsername, 'Enable', 'off');
    set(handles.edit_proxyAddress, 'Enable', 'off');
    set(handles.edit_proxyPort, 'Enable', 'off');
    set(handles.edit_proxyExceptions, 'Enable', 'off');
    handles.java_proxyPassword.Enable = 0;
end


function edit_username_Callback(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_username as text
%        str2double(get(hObject,'String')) returns contents of edit_username as a double


% --- Executes during object creation, after setting all properties.
function edit_username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_proxyAddress_Callback(hObject, eventdata, handles)
% hObject    handle to edit_proxyAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_proxyAddress as text
%        str2double(get(hObject,'String')) returns contents of edit_proxyAddress as a double


% --- Executes during object creation, after setting all properties.
function edit_proxyAddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_proxyAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_proxyUsername_Callback(hObject, eventdata, handles)
% hObject    handle to edit_proxyUsername (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_proxyUsername as text
%        str2double(get(hObject,'String')) returns contents of edit_proxyUsername as a double


% --- Executes during object creation, after setting all properties.
function edit_proxyUsername_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_proxyUsername (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_proxyPassword_Callback(hObject, eventdata, handles)
% hObject    handle to edit_proxyPassword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_proxyPassword as text
%        str2double(get(hObject,'String')) returns contents of edit_proxyPassword as a double


% --- Executes during object creation, after setting all properties.
function edit_proxyPassword_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_proxyPassword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_proxyExceptions_Callback(hObject, eventdata, handles)
% hObject    handle to edit_proxyExceptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_proxyExceptions as text
%        str2double(get(hObject,'String')) returns contents of edit_proxyExceptions as a double


% --- Executes during object creation, after setting all properties.
function edit_proxyExceptions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_proxyExceptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_proxyPort_Callback(hObject, eventdata, handles)
% hObject    handle to edit_proxyPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_proxyPort as text
%        str2double(get(hObject,'String')) returns contents of edit_proxyPort as a double


% --- Executes during object creation, after setting all properties.
function edit_proxyPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_proxyPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxLogEntries_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxLogEntries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxLogEntries as text
%        str2double(get(hObject,'String')) returns contents of edit_maxLogEntries as a double


% --- Executes during object creation, after setting all properties.
function edit_maxLogEntries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxLogEntries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
