function [ret] = switchRepository(info)
%SWITCHREPOSITORY Summary of this function goes here
%   Detailed explanation goes here

% Check if TSVNCache.exe is running (TortoiseSVN background worker)
cmd = sprintf('tasklist');
[status, output] = system(cmd);
if ischar(output) && ~isempty(output)
    % search for TSVNCache.exe
    splitted = strsplit(output, ' ');
    findstr = strfind(splitted, 'TSVNCache.exe');
    for i=1:1:length(findstr)
        if ~isempty(findstr{i})
            % Found it..., get PID or just close by name
            disp('### Found running TSVNCache.exe!');
            disp(' ### Stopping it...');
            cmd = sprintf('taskkill /F /IM TSVNCache.exe /T');
            [status, output] = system(cmd);
            disp(output);
        end
    end
end

% Remove old .svn folders
rmdir(fullfile(info.homeDir,'rps','.svn'),'s');
rmdir(fullfile(info.homeDir,'blocks','.svn'),'s');
rmdir(fullfile(info.homeDir,'help','.svn'),'s');

if ~isequal(exist(fullfile(info.homeDir, 'rps','.svn'),'dir'),7) && ...
        ~isequal(exist(fullfile(info.homeDir, 'blocks','.svn'),'dir'),7) && ...
        ~isequal(exist(fullfile(info.homeDir, 'help','.svn'),'dir'),7)
    % Checkout
    svnAbstraction('checkout',fullfile(info.url,'trunk','rps'),fullfile(info.homeDir, 'rps'), 'infinity')   % repository, destination, depth
    svnAbstraction('checkout',fullfile(info.url,'trunk','blocks'),fullfile(info.homeDir, 'blocks'), 'infinity');
    svnAbstraction('checkout',fullfile(info.url,'trunk','help'),fullfile(info.homeDir, 'help'), 'infinity');
    % Revert
    svnAbstraction('revert',fullfile(info.homeDir, 'rps'));
    svnAbstraction('revert',fullfile(info.homeDir, 'blocks'));
    svnAbstraction('revert',fullfile(info.homeDir, 'help'));
else
    uiwait(errordlg('Could not delete every hidden .svn folder in blocks, help and rps. Please delete it manually and try to Connect to Server.', 'Switching Error'));
    setpref(pref_group,'SVNConnected',false);
    ret = 1;
    return;
end

% Validate
if isequal(exist(fullfile(info.homeDir, 'rps','.svn'),'dir'),7) && ...
        isequal(exist(fullfile(info.homeDir, 'blocks','.svn'),'dir'),7) && ...
        isequal(exist(fullfile(info.homeDir, 'help','.svn'),'dir'),7)
    % valid and everything connected
    setpref('RapidPrototypingSystem','SVNConnected',true);
else
    uiwait(errordlg('Something went wrong during switching process.', 'Switching Error'));
end
ret = 1;
end

