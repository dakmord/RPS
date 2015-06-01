function [ret] = savePreferenceToXML(command, value)
%SAVEPREFERENCETOXML Summary of this function goes here
%   Detailed explanation goes here
switch command
    case 'simDefault'
        % Get Handles
        [status, handles] = getActualInformation();
        % Change actual value
        handles.simulinkPereferences = value;
        % Generate XML
        ret = saveToXmlFile(status, handles);
    case 'revision'
        % Get Handles
        [status, handles] = getActualInformation();
        % Change actual value
        handles.revision = value;
        % Generate XML
        ret = saveToXmlFile(status, handles);
    case 'repoFolder'
        % Get Handles
        [status, handles] = getActualInformation();
        % Change actual value
        handles.repoFolder = value;
        % Generate XML
        ret = saveToXmlFile(status, handles);
    otherwise
        return;
end
end


function [status, handles] = getActualInformation()
    xmlDir = fullfile(getpref('RapidPrototypingSystem', 'HomeDir'),'userconfig.xml');
    % Check if XML-Availabe..
    if ~isequal(exist(xmlDir,'file'),2)
        status = -1;
        disp('### Error, cannot apply Variable/Value to userconfig.xml because it is not existing!');
        handles = {};
        return;
    end
    
    [status ,updateInterval, autoUpdate,customUrl,...
         credentialsNeeded, url, repoFolder, revision, simulinkPreference] = getUserconfigValues(xmlDir);
    % create basic handles
    handles.updateInterval = updateInterval;
    handles.autoUpdate = autoUpdate;
    handles.customUrl = customUrl;
    handles.credentialsNeeded = credentialsNeeded;
    handles.url = url;
    handles.repoFolder = repoFolder;
    handles.revision = revision;
    handles.maxLogEntries = 20;
    handles.simulinkPereferences = simulinkPreference;
end


function flag = saveToXmlFile(status, handles)
    % Check for Errors
    if status==-1
        % Error
        flag = -1;
        return;
    end
    
    % Create Userconfig XML
    createUserconfigXML(gcf, handles);
    
    % Done
    flag = 1;
end