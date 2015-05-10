function [] = updateSVN(workingCopy, username, password)
% Get Parent Dir _> ...\Rapid-Prototyping-System\
homePath = getpref('RapidPrototypingSystem', 'HomeDir');
svnExe = fullfile(homePath, 'rps', 'etc','svn','svn.exe');

%Update current folder..
command='update';
flags='-r HEAD';
custom='';

if isempty(username)
    cmd=sprintf('%s %s %s %s %s', svnExe, command, flags, workingCopy, custom);
else
    cmd=sprintf('%s %s %s %s %s --username %s --password %s', svnExe, command, flags, workingCopy, custom, username, password);
end
[status, cmdout] = dos(cmd);

end