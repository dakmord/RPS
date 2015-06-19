function [ret] = deleteSVN(info,deleteTarget, logMessage)
% Check if string
if ~ischar(logMessage)
    logMessage = num2str(logMessage);
end

% replace path seperators
deleteTarget = strrep(deleteTarget,'\', '/');

%Update current folder..
command='delete';
log = sprintf('--message "%s"', logMessage);
authStore = '--no-auth-cache';

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s --username %s --password %s %s %s', info.svnExe, command, deleteTarget, log, info.username, info.password, authStore, info.proxy);
else
    cmd=sprintf('%s %s %s %s %s %s', info.svnExe, command, deleteTarget, log, authStore, info.proxy);
end
[status, cmdout] = dos(cmd);

% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(['Error: ' err ', ' message],'SVN Error!'));
   ret=-1;
   return;
end

ret = 1;

end