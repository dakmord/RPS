function createUserconfigXML(hObject, handles)

homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

docNode = com.mathworks.xml.XMLUtils.createDocument('userconfig');
docRootNode = docNode.getDocumentElement;
user_update = docNode.createElement('update'); 
updateInterval = docNode.createElement('updateInterval');
autoUpdate = docNode.createElement('autoUpdate');
repo = docNode.createElement('repo');
repoUrl = docNode.createElement('url');
repoFolder = docNode.createElement('folder');
repoRevision = docNode.createElement('revision'); 
repoCustomUrl = docNode.createElement('customUrl'); 
repoCredentialsNeeded = docNode.createElement('credentialsNeeded'); 

% Create update entries...
if str2num(get(handles.updateInterval_edit, 'String'))>0 && isnumeric(str2num(get(handles.updateInterval_edit, 'String')))
    updateInterval.appendChild(docNode.createTextNode((get(handles.updateInterval_edit, 'String'))));
else
    updateInterval.appendChild(docNode.createTextNode('10'));
end
autoUpdate.appendChild(docNode.createTextNode(num2str(handles.autoUpdate)));

% Create repo entries...
repoUrl.appendChild(docNode.createTextNode(handles.url));
repoCustomUrl.appendChild(docNode.createTextNode(num2str(handles.customUrl)));
repoCredentialsNeeded.appendChild(docNode.createTextNode(num2str(handles.credentialsNeeded)));
repoRevision.appendChild(docNode.createTextNode(handles.revision));
repoFolder.appendChild(docNode.createTextNode(handles.repoFolder));

user_update.appendChild(updateInterval);
user_update.appendChild(autoUpdate);
docRootNode.appendChild(user_update);
repo.appendChild(repoUrl);
repo.appendChild(repoFolder);
repo.appendChild(repoRevision);
repo.appendChild(repoCustomUrl);
repo.appendChild(repoCredentialsNeeded);
docRootNode.appendChild(repo);

% Generate userconfig.xml
xmlFileName = fullfile(homeDir, 'userconfig.xml');
xmlwrite(xmlFileName,docNode);