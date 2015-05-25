function [validity] = credentialsValiditySVN(repository, username, password)
%Define important Paths which will be needed ...
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

%Check size of Files which will be transfered..
command='info';
custom='-r HEAD';

if isempty(username)
    cmd=sprintf('%s %s %s %s', svnExe, command, custom, repository);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnExe, ...
        command, custom, repository, username, password);
end
[status, cmdout] = dos(cmd);

filtered = regexp(cmdout, '[\f\n\r]', 'split');
[tx, ty] = size(filtered);
if ty>=10
    % credentials could be correct...
    validity = 1;
else
    validity = 0;
    % credentials are not save...
end

end