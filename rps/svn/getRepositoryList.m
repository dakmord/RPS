function [folderList, info] = getRepositoryList(repoFolder,username,password)
%Define important Paths which will be needed ...
svnBin = getpref('RapidPrototypingSystem', 'SvnBinaries');
svnExe = fullfile(svnBin,'svn.exe');

%Check size of Files which will be transfered..
command='list';
custom='--xml';
repUrl = strrep(repoFolder,'\','/');

if strcmp(username, '')
    cmd=sprintf('%s %s %s %s', svnExe, command, repUrl, custom);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnExe, command, repUrl, custom,username,password);
end

[status, cmdout] = dos(cmd);

% Check for errors during svn command
[info, message] = handleErrorsSVN(status,cmdout);
if ~isempty(info)
   % Error
   uiwait(errordlg(['Error: ' info ', ' message],'SVN Error!'));
   info = -1;
   folderList={};
   return;
end

% Save output to file...
fid = fopen(fullfile(pwd, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(pwd,'cmdout.xml'),'file'),2)
    % Read XML-File
    xml = xml2struct(fullfile(pwd,'cmdout.xml'));
    delete('cmdout.xml');
    % store folderList
    folderList={};
    for  i=1:1:length(xml.lists.list.entry)
        if length(xml.lists.list.entry)==1
            if strcmp(xml.lists.list.entry.Attributes.kind,'dir')
                %folder
                folderList{end+1} = xml.lists.list.entry.name.Text;
            end
        else
            if strcmp(xml.lists.list.entry{i}.Attributes.kind,'dir')
                %folder
                folderList{end+1} = xml.lists.list.entry{i}.name.Text;
            end
        end
    end

else
    folderList={};
    disp('### Error: Something went wrong getting "log" informations. Could not find automatic generated cmdout.xml...');
end
info = 1;
end