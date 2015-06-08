function [username,password] = readEncryptedPassword(handles)
% Get homeDir
handles.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Read password/login from file
if handles.credentialsNeeded==1
    % login details
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        % Available
        [username,password] = decryptCredentials();
    else
        % Password Missing
        errordlg('Missing SVN Login/Password. Please save your login informations.', 'Missing SVN Login Information!');
        error('Missing SVN Login/Password!');
    end
else
   % Not needed
   username = '';
   password = '';
end
if credentialsValiditySVN(handles.url, username, password)==1
    % could be correct
else
    % wrong
    errordlg('Please check your saved svn login/password. Might be wrong!','Wrong password/login!?');
    
    % Delete old credentials if available
    if isequal(exist(fullfile(handles.homeDir,'credentials.xml.aes'),'file'),2)
        delete(fullfile(handles.homeDir,'credentials.xml.aes'));
    end
    
    % print Error and stop method execution
    error('Your SVN Login/Password seems to be wrong. Please save valid Login/Password informations.');
end