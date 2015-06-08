function [info] = createBranchTag(revision, message, sourceUrl, destinationUrl, username, password)
% Home Path
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

% Initialize Commandline call
command='copy';
revision = ['-r ' revision];
custom = '--force-log --parents';
message = ['--message "' message '"'];

% replace path seperators
sourceUrl = strrep(sourceUrl,'\', '/');
destinationUrl = strrep(destinationUrl,'\', '/');

if isempty(username) && isempty(password)
    % No login/password
    cmd=sprintf('%s %s %s %s %s %s %s', svnExe, command, revision, ...
        sourceUrl, destinationUrl, custom, message);
else
    % login/password needed
    cmd=sprintf('%s %s %s %s %s %s %s --username %s --password %s', svnExe, command, revision, ...
        sourceUrl, destinationUrl, custom, message, username, password);
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

