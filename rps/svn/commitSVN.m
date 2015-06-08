function [info] = commitSVN(commitTarget, logMessage, username, password)
% Get Parent Dir _> ...\Rapid-Prototyping-System\
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

% Check if string
if ~ischar(logMessage)
    logMessage = num2str(logMessage);
end

%Update current folder..
command='commit';
log = sprintf('--message %s', logMessage);

% Commit
if isempty(username)
    cmd=sprintf('%s %s %s %s', svnExe, command, commitTarget, log);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnExe, command, commitTarget, username, password, log);
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