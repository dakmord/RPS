function hw_targetInstaller_tm4c1294(varargin)
%%
% ex= hwconnectinstaller. Setup. get( ) ; 
hwconnectinstaller.show(  );
hSetup = hwconnectinstaller.Setup.get(  );
ex = hSetup.Explorer;
%ex = hwconnectinstaller.show();
ex.hide;

root=ex.getRoot;
%setup=get(root,'MCOSObjectReference');
setup = root.getMCOSObjectReference;

if nargin == 0
    selected_mirror = get_repo_url('real');
else
    selected_mirror = get_repo_url('bmw');
end

setup.Installer.XmlHttp=selected_mirror;
%setup.CurrentStep.next('');
setup.Steps.Children(1).Children(3)=[]; % license page
setup.Steps.Children(1).Children(2)=[]; % login page
setup.CurrentStep.next('');
ex.title=[ex.title ' BMW Repository'];
setup.Steps.Children(1).StepData.Labels.Internet='From BMW Exchange Repository (Recommended)';
ex.show;
%ex.showTreeView(true);
end

function url = get_repo_url(name)
switch name
    case {'real', '1'}
        %url = 'https://bitbucket.org/sippey/aquaria/wiki/matlab_repo';
        url = 'https://github.com/dakmord/RPS/releases/download/0.8';
        %url = 'file:\\\C:\Users\q365198\Desktop\GithubRepo\trunk\matlab_repo'
        %url = 'https://bitbucket.org/sippey/aquaria/wiki/matlab_repo';
        %url = 'https://bytebucket.org/sippey/aquaria/wiki/matlab_repo/package_registry.xml?rev=707758b8e3d05e6cb0c385de76a58e59f8489de0'
    case {'bmw', '2'}
        url = 'file:\\\C:\Users\q365198\Documents\Rapid-Prototyping-System\toolchains\temp';
end

end