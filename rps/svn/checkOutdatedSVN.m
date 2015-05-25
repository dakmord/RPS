function [outdatedFiles] = checkOutdatedSVN(url, username, password)
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

%Check size of Files which will be transfered..
command='status';
flags='-u -q';
custom='';


if isempty(username)
    cmd=sprintf('%s %s %s %s %s', svnExe, command, flags, url, custom);
else
    cmd=sprintf('%s %s %s %s %s --username %s --password %s', svnExe, command, flags, url, custom, username, password);
end
[status, cmdout] = dos(cmd);  
% Filter out the lines -> represents outdated, missing or new files ...


filtered = regexp(cmdout, '[\f\n\r]', 'split');

[tx ty] = size(filtered);
outdatedFiles = 0;
if ty>0
	ty = ty-1;
    for i=1:ty
       tmp = filtered{1,i};
       if strcmp(tmp(9), '*')
           % check for outdated on svn server and ignore local modified
           % files...
           outdatedFiles = outdatedFiles +1;
       end
    end
end
% Get Repo count informations
 %svn list -R file:///C:/svnServer/
 %count lines ... to get number of files (10-15s)
 %svn-bench null-list file:///c:/svnServer -depth infinty

end