function [ret] = switchWorkingCopySVN(info,revision, fromPath, toPath)
% Initialize Commandline Call
command='switch';
revision = ['-r ' revision];
custom = '--force --accept postpone --ignore-ancestry --no-auth-cache';

% replace path seperators
fromPath = strrep(fromPath,'\', '/');
toPath = strrep(toPath,'\', '/');

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s %s %s --username %s --password %s %s', info.svnExe, command, revision, ...
        fromPath, toPath, custom, info.username, info.password,info.proxy);
else
    cmd=sprintf('%s %s %s %s %s %s %s', info.svnExe, command, revision, ...
        fromPath, toPath, custom,info.proxy);
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
