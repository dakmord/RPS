function [] = checkoutSVNSwitchRepository(repository, username, password)
% Used to deploy in rps/tmp folder during local switch of the working copy
% to another repository. E. g. from https://svn.repo to https://github.com

% Get HomeDir
homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Define important Paths which will be needed ...
svnExe = fullfile(homeDir, 'tmp','svn', 'bin','svn.exe');

% Check size of Files which will be transfered..
command='checkout';
custom='-r HEAD';
depth='infinity';

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
system(cmd);
cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'rps'));
system(cmd);
cmd = sprintf('rd /S /Q %s',fullfile(homeDir,'help'));
system(cmd);

% Define repo url's
rps = strrep(fullfile(repository,'trunk', 'rps'), '\', '/');
blocks = strrep(fullfile(repository,'trunk', 'blocks'), '\', '/');
help = strrep(fullfile(repository,'trunk', 'help'), '\', '/');

% Define destination's
destination = fullfile(homeDir);
dRps = fullfile(destination, 'rps');
dBlocks = fullfile(destination, 'blocks');
dHelp = fullfile(destination, 'help');

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

% RPS Paths
addpath(fullfile(homeDir,'rps'));
addpath(genpath(fullfile(homeDir,'rps', 'fcn')));
addpath(genpath(fullfile(homeDir,'rps', 'html')));
addpath(genpath(fullfile(homeDir,'rps', 'svn')));
addpath(genpath(fullfile(homeDir,'rps', 'cfg')));
addpath(fullfile(homeDir,'rps', 'etc'));
addpath(fullfile(homeDir,'rps', 'etc', 'icons_18'));
addpath(genpath(fullfile(homeDir,'rps', 'etc', 'shortcut_tools')));
% Blocks Paths
addpath(fullfile(homeDir,'blocks'));
addpath(genpath(fullfile(homeDir,'blocks', 'mex')));
addpath(genpath(fullfile(homeDir,'blocks', 'sfcn')));
% Help Paths
addpath(fullfile(homeDir,'help'));
addpath(fullfile(homeDir,'help', 'html'));

% Save all Searchpaths
savepath();

% Restart RPS Graphical User Interface
rehash;
rps_GraphicalUserInterface();

end


