function [status] = svnInfo(info,repository)

%Check size of Files which will be transfered..
command='info';
custom='-r HEAD';
authStore = '--no-auth-cache';

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s --username %s --password %s %s %s', info.svnExe, command, custom, repository, info.username,info.password,authStore,info.proxy);
else
    cmd=sprintf('%s %s %s %s %s %s', info.svnExe, command, custom, repository,authStore,info.proxy);
end

[status, cmdout] = dos(cmd);

% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(message,err));
   status = -1;
   return;
end
status=1;
end