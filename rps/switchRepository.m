function [] = switchRepository(repoUrl,credentialsNeeded)
%SWITCHREPOSITORY Summary of this function goes here
%   Detailed explanation goes here

% Create tmp folder in rps home, add to path and copy all needed
% functions/scripts/files to it for updating...
mkdir(fullfile('..','tmp'));
addpath(fullfile('..','tmp'));

copyfile(fullfile('etc','svn'),fullfile('..','tmp','svn'));
copyfile(fullfile('svn','checkoutSVNSwitchRepository.m'),fullfile('..','tmp','checkoutSVNSwitchRepository.m'));

if isequal(credentialsNeeded,1)
    % Check if credentials are availabe
    if isequal(exist(fullfile('..','credentials.xml.aes'),'file'),2)
        % availabe
        [password,username]=decryptCredentials();
    else
        % open prompt
        [password, username] = passwordEntryDialog('enterUserName', true,'ValidatePassword', true);
    end
    % Check if credentials are valid
    
    if ~credentialsValiditySVN(repoUrl, username, password)
        % Not Valid
        error('SVN Login/Password is not valid for new Repository URL. Stopped switching working copy to new Repository!','Wrong SVN Login/Password');
    end
% if everything should be finde start function for deleting & checking out new files
rmpath(fullfile('svn'));
checkoutSVNSwitchRepository(repoUrl, username, password);

end

end

