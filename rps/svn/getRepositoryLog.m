function [log, files] = getRepositoryLog(info)
%Check size of Files which will be transfered..
command='log';
if info.maxLogEntries <= 1
    info.maxLogEntries = 2;
end
custom=['-l ' num2str(info.maxLogEntries) ' -v --xml'];
authStore = '--no-auth-cache';
repUrl = fullfile(info.url, info.repoFolder);
repUrl = strrep(repUrl,'\','/');

if isempty(info.username)
    cmd=sprintf('%s %s %s %s %s %s', info.svnExe, command, repUrl, custom,authStore,info.proxy);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s %s %s', info.svnExe, command, repUrl, custom,info.username,info.password,authStore,info.proxy);
end

[status, cmdout] = dos(cmd);
% Check for errors during svn command
[err, message] = handleErrorsSVN(status,cmdout);
if ~isempty(err)
   % Error
   uiwait(errordlg(['Error: ' err ', ' message],'SVN Error!'));
   log={};
   log(1,:) = {'','',err,message};
   files={};
   return;
end

% Get HomeDir for saving tmp file cmdout.xml
homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

fid = fopen(fullfile(homeDir, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(homeDir,'cmdout.xml'),'file'),2)

    xmlOutput = xml2struct(fullfile(homeDir,'cmdout.xml'));
    delete(fullfile(homeDir,'cmdout.xml'));

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