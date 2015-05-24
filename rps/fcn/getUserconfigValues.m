function [status ,updateInterval, autoUpdate,customUrl,credentialsNeeded, url, repoFolder, revision, simulinkPreference] = getUserconfigValues(xmlFile)
% This file checks if userconfig.xml exists and reads all needed values

if exist(xmlFile,'file')==2
    try
        xml = xml2struct(xmlFile);

        updateInterval = str2num(xml.userconfig.update.updateInterval.Text);
        autoUpdate = str2num(xml.userconfig.update.autoUpdate.Text);

        url = xml.userconfig.repo.url.Text;
        repoFolder = xml.userconfig.repo.folder.Text;
        revision = str2num(xml.userconfig.repo.revision.Text);
        customUrl = str2num(xml.userconfig.repo.customUrl.Text);
        credentialsNeeded = str2num(xml.userconfig.repo.credentialsNeeded.Text);
        simulinkPreference = str2num(xml.userconfig.simulink.defaultPreferences.Text);
    catch err
       disp('### Error, actual userconfig.xml contains failures or is not up-to-date.');
       updateInterval = 10;
       autoUpdate = false;
       url = '';
       customUrl = false;
       credentialsNeeded=false;
       repoFolder = 'trunk';
       revision = 0;
       status = -1;
       simulinkPreference = false;
       return;
    end
    status = 1;
else
    updateInterval = 10;
    autoUpdate = false;
    url = '';
    customUrl = false;
    credentialsNeeded=false;
    repoFolder = 'trunk';
    revision = 0;
    status = -1;
    simulinkPreference = false;
end


