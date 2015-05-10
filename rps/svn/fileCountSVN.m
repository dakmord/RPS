function [fileSize] = fileCountSVN(url, username, password)
%Define important Paths which will be needed ...
homePath = getParentDir(2, '\');
svnPath = [homePath 'gui\etc\svn'];
svnExe = [svnPath '\svn.exe'];
svnBench = [svnPath '\svn-bench.exe'];

%Check size of Files which will be transfered..
command='null-list';
custom='--depth infinity';

if isempty(username)
    cmd=sprintf('%s %s %s %s', svnBench, command, url, custom);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnBench, command, url, custom, username, password);
end
[status, cmdout] = dos(cmd);

% filter out size of lines ...
filtered = regexp(cmdout, '[\f\n\r]', 'split');
[tx ty] = size(filtered);
if ty>3
    fileCount = regexp(filtered{1,2}, 'f', 'split'); %% >999 -> array!
    fileCount = str2num(fileCount{1,1});
    [x y] = size(fileCount);
    if y>= 2
        fileCount = fileCount(1,1)*1000 + fileCount(1,2);
    end
else
    fileCount = 0;
end

fileSize = fileCount;
% Get Repo count informations
 %svn list -R file:///C:/svnServer/
 %count lines ... to get number of files (10-15s)
 %svn-bench null-list file:///c:/svnServer -depth infinty

end