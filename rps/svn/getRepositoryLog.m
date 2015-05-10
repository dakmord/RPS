function [log] = getRepositoryLog(repository,folder,maxLogEntries,username,password)
%Define important Paths which will be needed ...
homePath = getpref('RapidPrototypingSystem','HomeDir');
svnExe = fullfile(homePath,'rps','etc','svn','svn.exe');

%Check size of Files which will be transfered..
command='log';
custom=['-l ' num2str(maxLogEntries) ' --xml'];
repUrl = fullfile(repository, folder);
repUrl = strrep(repUrl,'\','/');

if strcmp(username, '')
    cmd=sprintf('%s %s %s %s', svnExe, command, repUrl, custom);
else
    cmd=sprintf('%s %s %s %s --username %s --password %s', svnExe, command, repUrl, custom,username,password);
end

[status, cmdout] = dos(cmd);
fid = fopen(fullfile(pwd, 'cmdout.xml'), 'wt');
fprintf(fid,'%s',cmdout);
fclose(fid);

if isequal(exist(fullfile(pwd,'cmdout.xml'),'file'),2)

    xmlOutput = xml2struct(fullfile(pwd,'cmdout.xml'));
    delete('cmdout.xml');

    % Create Log-Array
    log = {};
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