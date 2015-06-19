function [ret] = reverseSVN(info,workingCopy)
%Update current folder..
command='revert';
custom='--no-auth-cache';
flags ='-R';

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s %s --username %s --password %s %s', info.svnExe, command, flags, workingCopy, custom,...
        info.username, info.password,info.proxy);
else
    cmd=sprintf('%s %s %s %s %s %s', info.svnExe, command, flags, workingCopy, custom,info.proxy);
end
[status, cmdout] = dos(cmd,'-echo');

% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(['Error: ' err ', ' message],'SVN Error!'));
   ret = -1;
   return;
else
   ret = 1;
end

end