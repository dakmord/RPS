function [folderList, ret] = getRepositoryList(info, repoFolder)
%Check size of Files which will be transfered..
command='list';
custom='--xml --no-auth-cache';
repUrl = strrep(repoFolder,'\','/');

if info.credentialsNeeded
    cmd=sprintf('%s %s %s %s --username %s --password %s %s', info.svnExe, command, repUrl, custom,info.username,info.password, info.proxy);
else
    cmd=sprintf('%s %s %s %s %s', info.svnExe, command, repUrl, custom, info.proxy);
end

[status, cmdout] = dos(cmd);

% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(['Error: ' err ', ' message],'SVN Error!'));
   ret = -1;
   folderList={};
   return;
end

% Save output to file...
fid = fopen(fullfile(info.homeDir, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(info.homeDir,'cmdout.xml'),'file'),2)
    % Read XML-File
    xml = xml2struct(fullfile(info.homeDir,'cmdout.xml'));
    delete(fullfile(info.homeDir,'cmdout.xml'));
    assignin('base', 'test', xml);
    % store folderList
    folderList={};
    if isfield(xml.lists.list, 'entry');
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
       folderList = {}; 
    end

else
    folderList={};
    disp('### Error: Something went wrong getting "log" informations. Could not find automatic generated cmdout.xml...');
end
ret = 1;
end