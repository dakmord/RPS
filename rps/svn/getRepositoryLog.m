function [log, files] = getRepositoryLog(repository,folder,maxLogEntries,username,password)
%Define important Paths which will be needed ...
homePath = getpref('RapidPrototypingSystem','HomeDir');
svnExe = fullfile(homePath,'rps','etc','svn','svn.exe');

%Check size of Files which will be transfered..
command='log';
custom=['-l ' num2str(maxLogEntries) ' -v --xml'];
repUrl = fullfile(repository, folder);
repUrl = strrep(repUrl,'\','/');

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
   log={};
   log(1,:) = {'','',info,message};
   files={};
   return;
end

fid = fopen(fullfile(pwd, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(pwd,'cmdout.xml'),'file'),2)

    xmlOutput = xml2struct(fullfile(pwd,'cmdout.xml'));
    delete('cmdout.xml');

    % Create Log-Array
    log = {};
    files = {};
    for i=1:1:length(xmlOutput.log.logentry)
        author = xmlOutput.log.logentry{i}.author.Text;
        msg = xmlOutput.log.logentry{i}.msg.Text;
        revision = xmlOutput.log.logentry{i}.Attributes.revision;
        % Handle Date
        date = xmlOutput.log.logentry{i}.date.Text;
        dSplitted = strsplit(date,'T');
        date = dSplitted{1};
        time = strsplit(dSplitted{2},'.');
        time = time{1};
        newDate = [date ' ' time];
        commit.files={};
        commit.actions = {};
        % Get changed files/dirs
        for p = 1:1:length(xmlOutput.log.logentry{i}.paths.path)
            if length(xmlOutput.log.logentry{i}.paths.path)==1
                % just one
                commit.files{end+1} = xmlOutput.log.logentry{i}.paths.path.Text;
                commit.actions{end+1} = xmlOutput.log.logentry{i}.paths.path.Attributes.action;
            else
                commit.files{end+1} = xmlOutput.log.logentry{i}.paths.path{p}.Text;
                commit.actions{end+1} = xmlOutput.log.logentry{i}.paths.path{p}.Attributes.action;
            end
        end
        
        % Add Files from current commit..
        if ~isempty(commit)
            files{end+1} = commit;
        end
            
        % look for empty msg
        if isempty(msg)
            msg = '';
        end
        
        log(i,:) = {revision,author,newDate,msg};
    end

else
    disp('### Error: Something went wrong getting "log" informations. Could not find automatic generated cmdout.xml...');
end

end