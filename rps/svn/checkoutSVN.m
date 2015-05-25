function [] = checkoutSVN(repository, destination, depth, username, password)
%Define important Paths which will be needed ...
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

%Check size of Files which will be transfered..
command='checkout';
custom='-r HEAD';

repository = strrep(repository, '\', '/');

if isempty(username)
    cmd=sprintf('%s %s %s %s %s --depth %s', svnExe, command, custom, repository, destination, depth);
else
    cmd=sprintf('%s %s %s %s %s --depth %s --username %s --password %s', svnExe, ...
        command, custom, repository, destination, depth, username, password);
end
[status, cmdout] = dos(cmd, '-echo');
end