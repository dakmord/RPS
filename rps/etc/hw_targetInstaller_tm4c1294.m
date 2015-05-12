function hw_targetInstaller_tm4c1294()
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

selected_mirror = get_repo_url();


setup.Installer.XmlHttp=selected_mirror;
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
% Basic Github URL
tagsRepo = 'https://github.com/dakmord/RPS/tags';

% Find all revisions/tags
folderList = getRepositoryList(tagsRepo,'','');
if length(folderList)>1
    % look
    version = {};
    for p=1:1:length(folderList)
        % Filter crap out of it
        tmp = strrep(folderList{p},'v','');
        tmp = strrep(tmp,'V','');
        tmp = strrep(tmp, 'beta','');
        tmp = strrep(tmp, 'alpha','');
        tmp = strrep(tmp, 'version','');
        tmp = strrep(tmp, 'Version','');
        tmp = strrep(tmp, ' ','');
        versions{end+1} = str2num(tmp);
    end
    % find latest release
    biggestNumber = 0;
    for z = 1:1:length(versions);
        if versions{z}>biggestNumber
            biggestNumber = versions{z};
        end
    end
    % Find folder
    for dirs=1:1:length(folderList)
        if ~isempty(strfind(folderList{dirs}),num2str(biggestNumber))
            releaseFolder = folderList{dirs};
            break;
        end
    end
else
    % doenst matter just one entry
    releaseFolder = folderList{1};
end

url = 'https://github.com/dakmord/RPS/releases/download/';
url = fullfile(url, releaseFolder);
end