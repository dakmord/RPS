function [] = checkoutSVNSwitchRepository(repository, username, password)
% Used to deploy in rps/tmp folder during local switch of the working copy
% to another repository. E. g. from https://svn.repo to https://github.com

% Get HomeDir
homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Define important Paths which will be needed ...
svnExe = fullfile(homeDir, 'temp','svn', 'bin','svn.exe');

% Check size of Files which will be transfered..
command='checkout';
custom='-r HEAD';
depth='infinity';

% CD to homeDir
cd(homeDir);

% Remove RPS Paths (remove warnings while deleting folders..)
rmpath(fullfile(homeDir,'rps'));
rmpath(genpath(fullfile(homeDir,'rps', 'fcn')));
rmpath(genpath(fullfile(homeDir,'rps', 'html')));
rmpath(genpath(fullfile(homeDir,'rps', 'cfg')));
rmpath(fullfile(homeDir,'rps', 'etc'));
rmpath(fullfile(homeDir,'rps', 'etc', 'icons_18'));
rmpath(genpath(fullfile(homeDir,'rps', 'etc', 'shortcut_tools')));
% Blocks Paths
rmpath(fullfile(homeDir,'blocks'));
rmpath(genpath(fullfile(homeDir,'blocks', 'mex')));
rmpath(genpath(fullfile(homeDir,'blocks', 'sfcn')));
% Help Paths
rmpath(fullfile(homeDir,'help'));
rmpath(fullfile(homeDir,'help', 'html'));

% Delete old repo folders..
cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'blocks'));
system(cmd,'-echo');
cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'rps'));
system(cmd,'-echo');
cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'help'));
system(cmd,'-echo');

% Wait a sec...
pause(1);

% Define repo url's
rps = strrep(fullfile(repository,'trunk', 'rps'), '\', '/');
blocks = strrep(fullfile(repository,'trunk', 'blocks'), '\', '/');
help = strrep(fullfile(repository,'trunk', 'help'), '\', '/');

% Define destination's
dRps = strrep(fullfile(homeDir, 'rps'), '\', '/');
dBlocks = strrep(fullfile(homeDir, 'blocks'), '\', '/');
dHelp = strrep(fullfile(homeDir, 'help'), '\', '/');

if isequal(exist(dRps,'dir'),7) || isequal(exist(dBlocks,'dir'),7) || isequal(exist(dHelp,'dir'),7)
    % Try to remove again
    cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'blocks'));
    system(cmd,'-echo');
    cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'rps'));
    system(cmd,'-echo');
    cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'help'));
    system(cmd,'-echo'); 
    % Wait two sec.
    pause(2);
end

% Checkout rps,blocks and help from repo/trunk
if isempty(username)
    cmd=sprintf('%s %s %s %s %s --depth %s', svnExe, command, custom, rps, dRps, depth);
    [status, cmdout] = dos(cmd, '-echo');
    cmd=sprintf('%s %s %s %s %s --depth %s', svnExe, command, custom, blocks, dBlocks, depth);
    [status, cmdout] = dos(cmd, '-echo');
    cmd=sprintf('%s %s %s %s %s --depth %s', svnExe, command, custom, help, dHelp, depth);
    [status, cmdout] = dos(cmd, '-echo');
else
    cmd=sprintf('%s %s %s %s %s --depth %s --username %s --password %s', svnExe, ...
        command, custom, rps, dRps, depth, username, password);
    [status, cmdout] = dos(cmd, '-echo');
    cmd=sprintf('%s %s %s %s %s --depth %s --username %s --password %s', svnExe, ...
        command, custom, blocks, dBlocks, depth, username, password);
    [status, cmdout] = dos(cmd, '-echo');
    cmd=sprintf('%s %s %s %s %s --depth %s --username %s --password %s', svnExe, ...
        command, custom, help, dHelp, depth, username, password);
    [status, cmdout] = dos(cmd, '-echo');
end

% wait a sec...
pause(0.5);

% Restart RPS Graphical User Interface
rehash;

% Add Base Paths and initialize
startup_rps;
disp('### Finished switching Subversion Repository, you can start the GUI again.')
end


