function [ret] = createBranchTag(info, revision, message, sourceUrl, destinationUrl, username, password)
% Initialize Commandline call
command='copy';
revision = ['-r ' revision];
custom = '--force-log --parents --no-auth-cache';
message = ['--message "' message '"'];

% replace path seperators
sourceUrl = strrep(sourceUrl,'\', '/');
destinationUrl = strrep(destinationUrl,'\', '/');

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s %s %s %s --username %s --password %s %s', info.svnExe, command, revision, ...
        sourceUrl, destinationUrl, custom, message, info.username, info.password, info.proxy);
else
    cmd=sprintf('%s %s %s %s %s %s %s %s', info.svnExe, command, revision, ...
        sourceUrl, destinationUrl, custom, message, info.proxy);
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

