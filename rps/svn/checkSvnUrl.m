function [validity] = checkSvnUrl(repository)
%Define important Paths which will be needed ...
pref_group = 'RapidPrototypingSystem';
svnExe = fullfile(getpref(pref_group,'HomeDir'), 'rps','etc','svn','svn.exe');

%Check size of Files which will be transfered..
command='info';
custom='-r HEAD';


cmd=sprintf('%s %s %s %s', svnExe, command, custom, repository);

[status, cmdout] = dos(cmd, '-echo');

filtered = regexp(cmdout, '[\f\n\r]', 'split');
[tx, ty] = size(filtered);
if ty>=10
    % URL correct
    validity = 1;
else
    validity = 0;
    % URL incorrect
end

end