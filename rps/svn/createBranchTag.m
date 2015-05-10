function [ ] = createBranchTag(revision, sourceUrl, destinationUrl, username, password, log)
% Home Path
homePath = getpref('RapidPrototypingSystem', 'HomeDir');
svnExe = fullfile(homePath, 'rps', 'etc','svn','svn.exe');

%Check size of Files which will be transfered..
command='copy';
log = '--message';

cmd=sprintf('%s %s %s --xml', svnExe, command, urlToRepoFolder);

[status, cmdout] = dos(cmd);


end

