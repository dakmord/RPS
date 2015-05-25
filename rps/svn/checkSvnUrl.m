function [isValid] = checkSvnUrl(repository)
%Define important Paths which will be needed ...
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

%Check size of Files which will be transfered..
command='info';
custom='-r HEAD';


cmd=sprintf('%s %s %s %s', svnExe, command, custom, repository);

[status, cmdout] = dos(cmd);

if ~isempty(strfind(cmdout, 'E160013')) || ~isempty(strfind(cmdout, 'E200009'))
    % Error
    isValid = -1;
else
    % Valid
    isValid = 1;
end

end