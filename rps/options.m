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

% Last Modified by GUIDE v2.5 13-May-2015 10:55:27

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

% Save rps home path
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','icons_18','BMW-neg_com_settings_18.png'));
jframe.setFigureIcon(jIcon);

% Get old userconfig values ...
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

% fill in gui components
set(handles.customUrl_cb, 'Value', customUrl);
set(handles.credentials_cb, 'Value', credentialsNeeded);
set(handles.checkUpdates_cb, 'Value', autoUpdate);
if handles.autoUpdate==1
    set(handles.updateInterval_edit,'Enable','on')
else
    set(handles.updateInterval_edit,'Enable','off')
end
set(handles.updateInterval_edit, 'String', updateInterval);
if customUrl==true
    set(handles.customUrl_edit, 'Enable', 'on', 'String', url);
    set(handles.popupmenu_url, 'Enable', 'off');
else
    set(handles.customUrl_edit, 'Enable', 'off', 'String', 'https://svn-test.repo');
    set(handles.popupmenu_url, 'Enable', 'on');
end

% Check if Credentials already saved ...
if exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file')==2
    set(handles.text_credentials, 'String', 'Credentials available...', 'ForegroundColor', [0 0.5 0]);
else
    set(handles.text_credentials, 'String', 'No Credentials availabe...', 'ForegroundColor', 'red');
end

% Get current url's from xml-file..
xml = xml2struct(fullfile(handles.homeDir,'rps','cfg','repos.xml'));
[x, y] = size(xml.urls.url);
popup_list = {};

if y > 0
    for urls = 1:y
        if strcmp(xml.urls.url{1,urls}.Attributes.credentials, '1') || strcmp(xml.urls.url{1,urls}.Attributes.isPublic, '0')
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
    set(handles.popupmenu_url, 'String', popup_list, 'Value', 1);
end



% Choose default command line output for options
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes options wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
% Get previous userconfig data if available
d = showLoadingAnimation('Saving preferences...', 'Checking URLs...');
try
    % Get actualized data
    handles.updateInterval = str2num(get(handles.updateInterval_edit,'String'));
    handles.autoUpdate = get(handles.checkUpdates_cb,'Value');
    handles.customUrl = get(handles.customUrl_cb,'Value');
    handles.credentialsNeeded = get(handles.credentials_cb,'Value');
    handles.simulinkPereferences = false;


    % Check if Repo URL is valid
    if handles.customUrl==1
        % Custom URL
        handles.url = get(handles.customUrl_edit, 'String');
    else
        % Popupmenu URL
        handles.url = getCurrentPopupString(handles.popupmenu_url);
        % Check if Public/Private
        if ~isempty(strfind(handles.url, '(PUBLIC)')) && get(handles.credentials_cb,'Value')==0
            % Public
            handles.credentialsNeeded = false;
        else
            % Private
            handles.credentialsNeeded = true;
        end
        % Filter private/public out
        handles.url = strsplit(handles.url, ' (P');
        handles.url = handles.url{1};
    end

    d.setProgressStatusLabel('Verifying repo...');
    if ~isempty(strfind(handles.url,'trunk')) || ...
            ~isempty(strfind(handles.url,'tags')) || ...
            ~isempty(strfind(handles.url,'branches'))
        % Error wrong url given
        errordlg('Please delete subfolders in URL (e.g. trunk,tags,branches).','Wrong URL');
        return;
    end
    if checkSvnUrl(handles.url)==-1
        % Wrong URL, something wrong
        errordlg('Cannot connect to given SVN-Repository URL. Please check URL.','Wrong URL');
        return;
    end

    d.setProgressStatusLabel('Checking local working copy...');
    % Check for local working copy revision and repository folder (trunk, tags/.., branches/..
    homeDir = getpref('RapidPrototypingSystem','HomeDir');
    [revision, folder, repoHome]=checkLocalWorkingCopy(fullfile(homeDir, 'rps'));
    handles.revision = revision;
    handles.repoFolder = folder;

    d.setProgressStatusLabel('Validating credentials...');
    % Check if credentials are correct
    if handles.credentialsNeeded == true
        % needed, check if correct
        if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
            % Available
            [username,password] = decryptCredentials();
        else
            % Password Missing
            btn_saveCredentials_Callback(hObject, eventdata, handles);
            error('Missing SVN Login/Password! Save credentials and press "Save" button again.');
        end
        % Check Password
        if credentialsValiditySVN(handles.url, username, password)==1
            % Could be correct
        else
            % Wrong
            errordlg('SVN Login/Password seems to be wrong. Please re-enter your login details!','Wrong Login/Password!');
            error('SVN Login/Password seems to be wrong. Please re-enter your login details!');
        end
    else
        % No Password/Login needed
        password='';
        username='';
    end

    d.setProgressStatusLabel('Validating Repository...');
    % Check if url is the same repo as local working copy
    if isempty(strfind(handles.url,repoHome))
        % Another Repo URL, need to checkout/switch to new url/trunk...
        % First check if new repo/trunk contains dir (rps,blocks,help)
        if ~checkFolderExistence(fullfile(repoHome,'trunk', 'rps'))
            errordlg('Given Repository URL seems not configured/prepared for using it with the RPS.','Wrong Repo URL?');
            return;
        end
        if ~checkFolderExistence(fullfile(repoHome,'trunk', 'blocks'))
            errordlg('Given Repository URL seems not configured/prepared for using it with the RPS.','Wrong Repo URL?');
            return;
        end
        if ~checkFolderExistence(fullfile(repoHome,'trunk', 'help'))
            errordlg('Given Repository URL seems not configured/prepared for using it with the RPS.','Wrong Repo URL?');
            return;
        end

        choice = questdlg('You local repository differs from the given URL. Do you really want to switch to another repository?',...
            'Switching Repository?', 'Yes','No','No');
        switch choice
            case 'Yes'
                % TODO...
            case 'No'
                % NO
                return;
            otherwise
                % NO
                return;
        end
        %TODO: Switch/Relocate/Delete or Checkout (rps,blocks,help)
        %       Delete rps folder while still using options.fig??????
        %
        % Call Function 
        switchRepo = true;
    else
        % Same Repo, nothing to do right now.
        switchRepo = false;
    end

    d.setProgressStatusLabel('Creating userconfig...');
    
    % Generate XML
    createUserconfigXML(hObject, handles)

    hideLoadingAnimation(d);
    
    disp(' ### DONE saving preferences!');
    close(gcf);
    
    % Switch Repository if needed
    if switchRepo==true
        switchRepository(handles.url,username,password);
    end
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


% --- Executes on button press in btn_saveCredentials.
function btn_saveCredentials_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveCredentials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Password, UserName] = passwordEntryDialog('enterUserName', true,'ValidatePassword', true,'CheckPasswordLength',false,'WindowName','SVN Login/Password');
if Password >0
    encryptCredentials(UserName, Password);
end
if exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file')==2
    set(handles.text_credentials, 'String', 'Credentials available...', 'ForegroundColor', [0 0.5 0]);
else
    set(handles.text_credentials, 'String', 'No Credentials stored...', 'ForegroundColor', 'red');
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
    set(handles.btn_saveCredentials,'Enable', 'on');
    handles.credentialsNeeded = true;
else
    set(handles.btn_saveCredentials,'Enable', 'off');
    handles.credentialsNeeded = false;
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
