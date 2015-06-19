function [status] = checkoutSVN(info, repository, destination, depth)
% depth: 'infinity', 'empty', 'files', 'immediates'

%Check size of Files which will be transfered..
command='checkout';
custom='-r HEAD --no-auth-cache --non-interactive';

repository = strrep(repository, '\', '/');

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s %s --depth %s --username %s --password %s %s', info.svnExe, ...
        command, custom, repository, destination, depth, info.username, info.password, info.proxy);
    
else
    cmd=sprintf('%s %s %s %s %s --depth %s %s', info.svnExe, command, custom, repository, destination, depth, info.proxy);
end
[status, cmdout] = dos(cmd, '-echo');

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