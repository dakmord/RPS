function [status, configInfo] = getUserconfigValues()
% This file checks if userconfig.xml exists and reads all needed values

if ispref('RPSuserconfig')
    % Get Preferences
    userconfig = getpref('RPSuserconfig');
    
    configInfo.updateInterval = userconfig.updateInterval;
    configInfo.autoUpdate = userconfig.autoUpdate;

    configInfo.url = userconfig.url;
    configInfo.repoFolder = userconfig.folder;
    configInfo.revision = userconfig.revision;
    configInfo.customUrl = userconfig.customUrl;
    configInfo.credentialsSaved = userconfig.credentialsSaved;
    configInfo.simulinkPreference = userconfig.simulinkDefaultPreferences;
    configInfo.credentialsNeeded = userconfig.credentialsNeeded;
    
    % Proxy
    configInfo.proxyRequired = userconfig.proxyRequired;
    configInfo.proxyAddress = userconfig.proxyAddress;
    configInfo.proxyPort = userconfig.proxyPort;
    configInfo.proxyExceptions = userconfig.proxyExceptions;
    configInfo.maxLogEntries = userconfig.maxLogEntries;
    status = 1;
    return;
end

% Standard Config
configInfo.updateInterval = 10;
configInfo.autoUpdate = false;
configInfo.url = '';
configInfo.customUrl = false;
configInfo.repoFolder = '';
configInfo.revision = 0;
configInfo.simulinkPreference = false;
configInfo.credentialsNeeded = false;
configInfo.credentialsSaved = false;
configInfo.maxLogEntries = 20;

% Proxy
configInfo.proxyRequired = false;
configInfo.proxyAddress = '';
configInfo.proxyPort = 0;
configInfo.proxyExceptions = '';


status = -1;



