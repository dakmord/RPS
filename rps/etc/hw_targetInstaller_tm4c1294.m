function hw_targetInstaller_tm4c1294()
%%

% Modified: 13.06.2015, Daniel Schneider, "Removed dynamic address for github.com and changed
%                                          to revision/tag 'SupportPackages' which contains
%                                          every SupportPackage in future."

% Show Loading Animation
d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Starting Support Package Installer', []);
d.setValue(0.25);                        % default = 0
d.setProgressStatusLabel('Please wait, loading...');  % default = 'Please Wait'
d.setSpinnerVisible(false);               % default = true
d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
d.setCancelButtonVisible(false);          % default = true
d.setVisible(true);                      % default = false

% ex= hwconnectinstaller. Setup. get( ) ; 
hwconnectinstaller.show(  );
hSetup = hwconnectinstaller.Setup.get(  );
ex = hSetup.Explorer;
%ex = hwconnectinstaller.show();
ex.hide;

root=ex.getRoot;
%setup=get(root,'MCOSObjectReference');
setup = root.getMCOSObjectReference;

selected_mirror = get_repo_url();


setup.Installer.XmlHttp=selected_mirror;

% Disable Loading Animation
d.setVisible(false);

%setup.CurrentStep.next('');
setup.Steps.Children(1).Children(3)=[]; % license page
setup.Steps.Children(1).Children(2)=[]; % login page
setup.CurrentStep.next('');
ex.title=[ex.title ' Custom Repository'];
setup.Steps.Children(1).StepData.Labels.Internet=['Custom Repository (' selected_mirror ')'];
ex.show;

%ex.showTreeView(true);
end

function url = get_repo_url()
% Get URL

url = 'https://github.com/dakmord/RPS/releases/download/';
url = fullfile(url, 'SupportPackages');
end