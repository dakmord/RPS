function [info] = switchWorkingCopySVN(revision, fromPath, toPath, username, password)
% Home Path
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

% Initialize Commandline Call
command='switch';
revision = ['-r ' revision];
custom = '--force --accept postpone --ignore-ancestry';

% replace path seperators
fromPath = strrep(fromPath,'\', '/');
toPath = strrep(toPath,'\', '/');

if isempty(username) && isempty(password)
    % No login/password
    cmd=sprintf('%s %s %s %s %s %s', svnExe, command, revision, ...
        fromPath, toPath, custom);
else
    % login/password needed
    cmd=sprintf('%s %s %s %s %s %s --username %s --password %s', svnExe, command, revision, ...
        fromPath, toPath, custom, username, password);
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
