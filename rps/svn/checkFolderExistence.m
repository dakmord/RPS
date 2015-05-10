function [isExisting] = checkFolderExistence(urlToRepoFolder)
%Define important Paths which will be needed ...
svnExe = fullfile('..','etc','svn','svn.exe');

%Check size of Files which will be transfered..
command='ls';


cmd=sprintf('%s %s %s --xml', svnExe, command, urlToRepoFolder);

[status, cmdout] = dos(cmd);

if ~isempty(strfind(cmdout,'E200009')) || ~isempty(strfind(cmdout,'E180001'))
    % Error wrong url or dir not existing
    isExisting = false;
else
    % existing
    isExisting = true;
end
end