function [info] = switchWorkingCopySVN(revision, newUrl, localPath, username, password)
% Home Path
homePath = getpref('RapidPrototypingSystem', 'HomeDir');
svnExe = fullfile(homePath, 'rps', 'etc','svn','svn.exe');

% Initialize Commandline Call
command='switch';
revision = ['-r ' revision];
custom = '--force --accept postpone --ignore-ancestry';

% replace path seperators
newUrl = strrep(newUrl,'\', '/');

if isempty(username) && isempty(password)
    % No login/password
    cmd=sprintf('%s %s %s %s %s %s', svnExe, command, revision, ...
        newUrl, localPath, custom);
else
    % login/password needed
    cmd=sprintf('%s %s %s %s %s %s --username %s --password %s', svnExe, command, revision, ...
        newUrl, localPath, custom, username, password);
end
[status, cmdout] = dos(cmd);

% Check for errors during svn command
[info, message] = handleErrorsSVN(status,cmdout);
if ~isempty(info)
   % Error
   uiwait(errordlg(['Error: ' info ', ' message],'SVN Error!'));
   info=-1;
   return;
end

info = 1;
end
