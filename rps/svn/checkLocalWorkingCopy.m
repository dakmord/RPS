function [ret] = checkLocalWorkingCopy(info, workingCopyDir)
%Check size of Files which will be transfered..
command='info';

cmd=sprintf('%s %s %s --xml %s', info.svnExe, command, workingCopyDir);

[status, cmdout] = dos(cmd);

fid = fopen(fullfile(info.homeDir, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(info.homeDir,'cmdout.xml'),'file'),2)
    try
        xmlOutput = xml2struct(fullfile(info.homeDir,'cmdout.xml'));
        ret.revision = str2num(xmlOutput.info.entry.Attributes.revision);
        delete(fullfile(info.homeDir,'cmdout.xml'));
    catch
       error('System kann den angegebenen Pfad nicht finden svn.exe info <workingCopy>') ;
    end
    % Find out current repo-folder (if we are in trunk,branches or tags..)
    tmp = strrep(workingCopyDir,'\','/');
    if strcmp(tmp(length(tmp)),'/')
        tmp = strsplit(tmp,'/');
        givenFolder = tmp{end-1};
    else
        tmp = strsplit(tmp,'/');
        givenFolder = tmp{end};
    end
    
    completeRepoUrl = xmlOutput.info.entry.url.Text;
    if ~isempty(strfind(completeRepoUrl,'trunk'))
        % in trunk
        ret.folder = 'trunk';
    elseif ~isempty(strfind(completeRepoUrl,'branches'))
        % in branches
        % find out subfolder
        indexes = strfind(completeRepoUrl,givenFolder);
        branchIndex = strfind(completeRepoUrl,'branches');
        if length(branchIndex)~=1
            % more found... use last one
            branchIndex = branchIndex(length(branchIndex));
        end
        if length(indexes)==1
            ret.folder = completeRepoUrl(branchIndex:(indexes-2));
        else
           % more found so use last one
           ret.folder = completeRepoUrl(branchIndex:(indexes(length(indexes))-2));
        end
    elseif ~isempty(strfind(completeRepoUrl,'tags'))
        % i tags
        % find out subfolder
        indexes = strfind(completeRepoUrl,givenFolder);
        branchIndex = strfind(completeRepoUrl,'tags');
        if length(branchIndex)~=1
            % more found... use last one
            branchIndex = branchIndex(length(branchIndex));
        end
        if length(indexes)==1
            ret.folder = completeRepoUrl(branchIndex:(indexes-2));
        else
           % more found so use last one
           ret.folder = completeRepoUrl(branchIndex:(indexes(length(indexes))-2));
        end
    end
    ret.repoHomeUrl = strrep(completeRepoUrl,givenFolder, '');
    ret.repoHomeUrl = strrep(ret.repoHomeUrl, ret.folder, '');
    strrep(ret.repoHomeUrl,'\', '/');
    for i=1:1:2
        if strcmp(ret.repoHomeUrl(end),'/')
            ret.repoHomeUrl=ret.repoHomeUrl(1:(length(ret.repoHomeUrl)-1));
        end
    end
else
    ret.revision = 0;
    ret.folder = '';
    disp('### Error: Something went wrong checking out local Working Copy Infos. Could not find automatic generated cmdout.xml');
end

end