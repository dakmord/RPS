function [info] = deleteSVN(deleteTarget, logMessage, username, password)
% Get Parent Dir _> ...\Rapid-Prototyping-System\
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

% Check if string
if ~ischar(logMessage)
    logMessage = num2str(logMessage);
end

% replace path seperators
deleteTarget = strrep(deleteTarget,'\', '/');

%Update current folder..
command='delete';
log = sprintf('--message "%s"', logMessage);

if isempty(username)
    cmd=sprintf('%s %s %s %s', svnExe, command, deleteTarget, log);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnExe, command, deleteTarget, log, username, password);
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