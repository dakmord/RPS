function [isExisting] = svnList(info, urlToRepoFolder)
%Check size of Files which will be transfered..
command='ls';
authStore = '--no-auth-cache';

urlToRepoFolder = strrep(urlToRepoFolder, '\', '/');

if info.credentialsNeeded
    cmd=sprintf('%s %s %s --xml --username %s --password %s %s %s', info.svnExe, command, urlToRepoFolder,info.username,info.password,authStore,info.proxy);
else
    cmd=sprintf('%s %s %s --xml %s %s', info.svnExe, command, urlToRepoFolder,authStore,info.proxy);
end

[status, cmdout] = dos(cmd);

% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(['Error: ' err ', ' message],'SVN Error!'));
   isExisting = false;
   return;
else
    isExisting = true;
end

end