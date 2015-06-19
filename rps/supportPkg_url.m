function varargout = supportPkg_url(varargin)
% SUPPORTPKG_URL MATLAB code for supportPkg_url.fig
%      SUPPORTPKG_URL, by itself, creates a new SUPPORTPKG_URL or raises the existing
%      singleton*.
%
%      H = SUPPORTPKG_URL returns the handle to a new SUPPORTPKG_URL or the handle to
%      the existing singleton*.
%
%      SUPPORTPKG_URL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUPPORTPKG_URL.M with the given input arguments.
%
%      SUPPORTPKG_URL('Property','Value',...) creates a new SUPPORTPKG_URL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before supportPkg_url_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to supportPkg_url_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help supportPkg_url

% Last Modified by GUIDE v2.5 13-Jun-2015 20:47:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @supportPkg_url_OpeningFcn, ...
                   'gui_OutputFcn',  @supportPkg_url_OutputFcn, ...
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


% --- Executes just before supportPkg_url is made visible.
function supportPkg_url_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to supportPkg_url (see VARARGIN)

% Save rps home path
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Custom GUI Icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile(handles.homeDir,'rps','etc','icons_18','BMW-neg_nav_more_18.png'));
jframe.setFigureIcon(jIcon);

% Custom Icon Top left
iconsFolder = fullfile(handles.homeDir, 'rps', 'etc', 'icons_18');
btn_im = imread(fullfile(iconsFolder, 'package_icon.jpg'));
set(handles.btn_icon, 'CData', btn_im);

% Choose default command line output for supportPkg_url
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes supportPkg_url wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = supportPkg_url_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function url_edit_Callback(hObject, eventdata, handles)
% hObject    handle to url_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of url_edit as text
%        str2double(get(hObject,'String')) returns contents of url_edit as a double


% --- Executes during object creation, after setting all properties.
function url_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to url_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string = get(handles.url_edit, 'String');
close(gcf);
customUrl_targetinstaller(string);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directory = uigetdir(getpref('RapidPrototypingSystem', 'HomeDir'), 'Select Local SupportPackage Files Directory');
if directory~=0
    set(handles.url_edit, 'String', ['file:\\\' directory]);
end
% TODO: INIT hw_installer...


% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

function customUrl_targetinstaller(url)
% ex= hwconnectinstaller. Setup. get( ) ; 
hwconnectinstaller.show(  );
hSetup = hwconnectinstaller.Setup.get(  );
ex = hSetup.Explorer;
%ex = hwconnectinstaller.show();
ex.hide;

root=ex.getRoot;
%setup=get(root,'MCOSObjectReference');
setup = root.getMCOSObjectReference;

selected_mirror = url;


setup.Installer.XmlHttp=selected_mirror;
%setup.CurrentStep.next('');
setup.Steps.Children(1).Children(3)=[]; % license page
setup.Steps.Children(1).Children(2)=[]; % login page
setup.CurrentStep.next('');
ex.title=[ex.title ' Custom URL'];
setup.Steps.Children(1).StepData.Labels.Internet='From Custom URL...';
ex.show;
%ex.showTreeView(true);


% --- Executes on button press in btn_icon.
function btn_icon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
