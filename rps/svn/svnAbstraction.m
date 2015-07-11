function [ret] = svnAbstraction(cmd, varargin)
% SVN abstraction function which calls subfunctions for included svn
% operations
% Modified:     11.06.2015, Daniel Schneider, "Created and added SVN Operations"
%               13.06.2015, Daniel Schneider, "Check before any SVN & removed wcInfo for any checks (local wc)"
%               13.06.2015, Daniel Schneider, "Added possibility to procees without connection. Modified Error Message for Cred. Validity"
%               13.06.2015, Daniel Schneider, "Added checkout, reverse, special update (--accept theirs-full)
%               14.06.2015, Daniel Schneider, "Optimized credentials validation"

% Load userconfig.xml and check credentialsNeeded
[status, info] = getUserconfigValues();

% Initialize Basic Variables
info.homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
info.svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
info.svnExe = fullfile(info.svnBin,'svn.exe');

% Global validation/checks before any SVN command is executed
narginchk(1,10);
% Exclude: wcInfo, switchRepo, ..
if ~strcmp(cmd,'wcInfo')
    info = checkProxySettings(info);
    [info, status] = checkCredentials(info);
    if (status==-1) || (validateSubversionServer(info)==-1)
        % Connection or Login Error
        ret =-1;
        return;
    end
end

% Switch Command and call SVN Functions
switch (cmd)
    case 'checkout'
        narginchk(4, 4)
        ret = checkoutSVN(info,  varargin{1}, varargin{2}, varargin{3}); % repository, destination, depth
    case 'info'
        narginchk(2,2);
        ret = svnInfo(info, varargin{1}); %subversionServerUrl
    case 'wcInfo'
        narginchk(2,2);
        ret = checkLocalWorkingCopy(info, varargin{1}); %workingCopyDir
    case 'list'
        narginchk(2,2);
        ret = svnList(info,varargin{1}); %urlToRepoFolder
    case 'switchRepo'
        narginchk(1,1);
        ret = switchRepository(info); % TempInfo for Switching
    case 'log'
        narginchk(1,1);
        [log, files] = getRepositoryLog(info);
        ret.log = log;
        ret.files = files;
    case 'copy'
        narginchk(5,5);
        ret = createBranchTag(info, varargin{1}, varargin{2}, varargin{3}, varargin{4}); %revision, log, sourceUrl, destiUrl
    case 'subfolderList'
        narginchk(2,2)
        [folderList, status] = getRepositoryList(info,varargin{1}); %repoFolder
        ret.folderList = folderList;
        ret.info = status;
    case 'switch'
        narginchk(4,4)
        ret = switchWorkingCopySVN(info, varargin{1}, varargin{2}, varargin{3}); %revision, fromPath, toPath
    case 'delete'
        narginchk(3,3)
        ret = deleteSVN(info,varargin{1}, varargin{2}); % deletePath, log
    case 'update'
        narginchk(3,3)
        ret = updateSVN(info,varargin{1}, varargin{2}); % workingCopy,revision
    case 'revert'
        narginchk(2,2);
        ret = reverseSVN(info,varargin{1}); %workingCopyUrl
    otherwise
        error('Invalid SVN command! -> svnAbstraction');
end
end

function [out, status] = checkCredentials(info)
    % Check if credentials are correct, needed and availabe
    if info.credentialsNeeded && ~getpref('RapidPrototypingSystem','SVNCredentialsValidated')
        if info.credentialsSaved
            % saved credentials, load and check
            if isequal(exist(fullfile(info.homeDir,'auth.mat.aes'),'file'),2)
                % Available
                [username,password] = decryptCredentials('credentials');
                info.username = username;
                info.password = password;
                % Check Password
                if ~credentialsValiditySVN(info, info.url, info.username, info.password)==1
                    % Wrong
                    uiwait(errordlg('Error occured: Please check your connection or login details.','Connection/Login Error!'));
                    out = info;
                    status = -1;
                    return;
                end
            else
                uiwait(errordlg('Missing Authentication file, please save your login again!','Missing Login'));
                out = info;
                status = -1;
                return;
            end
        else
            if isequal(exist(fullfile(info.homeDir,'auth.mat.aes'),'file'),2)
                % Available
                [username,password] = decryptCredentials('credentials');
            else
                % not saved, open password prompt and check
                [password, username] = passwordEntryDialog('enterUserName', true,'ValidatePassword', false,...
                    'PasswordLengthMax', 20,'PasswordLengthMin',0,'WindowName','Enter SVN Login Details');
                if isnumeric(password)
                    if password==-1
                        % Pressed Cancel Button
                        out = info;
                        status = -1;
                        return;
                    end
                end
                encryptCredentials(username, password, 'credentials');
            end
            info.password = password;
            info.username = username;
            if ~credentialsValiditySVN(info, info.url, username, password)==1
                uiwait(errordlg('Error occured: Please check your connection or login details.','Connection/Login Error!'));
                out = info;
                status = -1;
                
                % Delete Login file
                if isequal(exist(fullfile(info.homeDir,'auth.mat.aes'),'file'),2)
                    % Delete
                    delete(fullfile(info.homeDir,'auth.mat.aes'));
                end
                return;
            else
                if isempty(info.username) && isempty(info.password)
                    % No Login needed
                    setpref('RPSuserconfig', 'credentialsNeeded', false);
                    info.credentialsNeeded = false;
                end
            end
        end
    elseif ~getpref('RapidPrototypingSystem','SVNCredentialsValidated')
        % no credentials needed
        if ~isequal(credentialsValiditySVN(info, info.url, '', ''),1)
            
            % Save credentialsNeeded
            setpref('RPSuserconfig', 'credentialsNeeded', true);
            info.credentialsNeeded = true;
            % Wrong
            uiwait(errordlg('Error occured: Please check your connection or login details.','Connection/Login Error!'));
            out = info;
            status = -1;
            return;
        else
            info.username = '';
            info.password = '';
        end
    elseif getpref('RapidPrototypingSystem','SVNCredentialsValidated')
        if info.credentialsNeeded
            [username,password] = decryptCredentials('credentials');
            info.username = username;
            info.password = password;
        else
            info.username = '';
            info.password = '';
        end
    end
    % Output
    out = info;
    status = 1;
    setpref('RapidPrototypingSystem','SVNCredentialsValidated', true);
end

function [validity] = credentialsValiditySVN(info, repository, username, password)
%Check size of Files which will be transfered..
command='info';
custom='-r HEAD';
authStore = '--no-auth-cache';

if isempty(username)
    cmd=sprintf('%s %s %s %s --username --password %s %s', info.svnExe, command, custom, repository, authStore,info.proxy);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s %s %s', info.svnExe, ...
        command, custom, repository, username, password, authStore, info.proxy);
end
[status, cmdout] = dos(cmd);

[info, message] = handleErrorsSVN(status,cmdout);
if ~isempty(info) %&& ~strcmp(info, 'E175011')
    validity = 0;
    uiwait(errordlg(message,info));
else
    validity = 1;
end

end

function out = checkProxySettings(info)
% Check if proxy required and create string for svn cmd.
if info.proxyRequired==1
    % Check if proxy.mat is available
    if isequal(exist(fullfile(info.homeDir,'proxy.mat.aes'),'file'),2)
        % Load proxy login/password
        [username,password] = decryptCredentials('proxy');
        info.proxyUsername = username;
        info.proxyPassword = password;
    else
        info.proxyUsername = '';
        info.proxyPassword = '';
    end
    
    % Generate proxy String
    proxyAddress = sprintf('--config-option servers:global:http-proxy-host="%s"',info.proxyAddress);
    proxyPort = sprintf('--config-option servers:global:http-proxy-port="%i"',info.proxyPort);
    proxyUsername = sprintf('--config-option servers:global:http-proxy-username="%s"',info.proxyUsername);
    proxyPassword = sprintf('--config-option servers:global:http-proxy-password="%s"',info.proxyPassword);
    proxyExceptions = sprintf('--config-option servers:global:http-proxy-exceptions="%s"',info.proxyExceptions);
    info.proxy = sprintf('%s %s %s %s %s', proxyAddress, proxyPort, proxyUsername, proxyPassword, proxyExceptions);
else
    info.proxy='';
end

% Outputs
out = info;

end

function out = validateSubversionServer(info)
% First check if new repo/trunk contains dir (rps,blocks,help)
if ispref('RapidPrototypingSystem', 'SVNServerValidated')
    if ~getpref('RapidPrototypingSystem', 'SVNServerValidated')
        if ~svnList(info,fullfile(info.url,'trunk', 'rps'))
            url = sprintf('Given Repository URL %s seems not configured/prepared for using it with the RPS (missing rps folder).',info.url);
            uiwait(errordlg(url,'Wrong Repo URL?'));
            out = -1;
            return;
        end
        if ~svnList(info,fullfile(info.url,'trunk', 'blocks'))
            url = sprintf('Given Repository URL %s seems not configured/prepared for using it with the RPS (missing blocks folder).',info.url);
            uiwait(errordlg(url,'Wrong Repo URL?'));
            out = -1;
            return;
        end
        if ~svnList(info,fullfile(info.url,'trunk', 'help'))
            url = sprintf('Given Repository URL %s seems not configured/prepared for using it with the RPS (missing help folder).',info.url);
            uiwait(errordlg(url,'Wrong Repo URL?'));
            out = -1;
            return;
        end
        setpref('RapidPrototypingSystem', 'SVNServerValidated', true);
    end
end
out = 1;
end