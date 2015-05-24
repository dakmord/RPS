function createUserconfigXML(hObject, handles)

homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

docNode = com.mathworks.xml.XMLUtils.createDocument('userconfig');
docRootNode = docNode.getDocumentElement;
% Update tree
user_update = docNode.createElement('update'); 
updateInterval = docNode.createElement('updateInterval');
autoUpdate = docNode.createElement('autoUpdate');

% Repository tree
repo = docNode.createElement('repo');
repoUrl = docNode.createElement('url');
repoFolder = docNode.createElement('folder');
repoRevision = docNode.createElement('revision'); 
repoCustomUrl = docNode.createElement('customUrl'); 
repoCredentialsNeeded = docNode.createElement('credentialsNeeded'); 

% Simulink tree
simulink = docNode.createElement('simulink');
simulinkPreference = docNode.createElement('defaultPreferences'); 

% Create update entries...
updateInterval.appendChild(docNode.createTextNode(num2str(handles.updateInterval)));
autoUpdate.appendChild(docNode.createTextNode(num2str(handles.autoUpdate)));

% Create repo entries...
repoUrl.appendChild(docNode.createTextNode(handles.url));
repoCustomUrl.appendChild(docNode.createTextNode(num2str(handles.customUrl)));
repoCredentialsNeeded.appendChild(docNode.createTextNode(num2str(handles.credentialsNeeded)));
repoRevision.appendChild(docNode.createTextNode(num2str(handles.revision)));
repoFolder.appendChild(docNode.createTextNode(handles.repoFolder));

% Create Simulink entries...
simulinkPreference.appendChild(docNode.createTextNode(num2str(handles.simulinkPereferences)));

% Append childs..
% Update
user_update.appendChild(updateInterval);
user_update.appendChild(autoUpdate);
docRootNode.appendChild(user_update);
% Repository
repo.appendChild(repoUrl);
repo.appendChild(repoFolder);
repo.appendChild(repoRevision);
repo.appendChild(repoCustomUrl);
repo.appendChild(repoCredentialsNeeded);
docRootNode.appendChild(repo);
% Simulink
simulink.appendChild(simulinkPreference);
docRootNode.appendChild(simulink);

% Delete old one if present
if isequal(exist(fullfile(homeDir, 'userconfig.xml'),'file'),2)
    delete(fullfile(homeDir, 'userconfig.xml'));
end

% Generate userconfig.xml
xmlFileName = fullfile(homeDir, 'userconfig.xml');
xmlwrite(xmlFileName,docNode);