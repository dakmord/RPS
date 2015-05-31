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
rmpath(fullfile(path,'rps'));
rmpath(genpath(fullfile(path,'rps', 'fcn')));
rmpath(genpath(fullfile(path,'rps', 'html')));
rmpath(genpath(fullfile(path,'rps', 'cfg')));
rmpath(fullfile(path,'rps', 'etc'));
rmpath(fullfile(path,'rps', 'etc', 'icons_18'));
rmpath(genpath(fullfile(path,'rps', 'etc', 'shortcut_tools')));
% Blocks Paths
rmpath(fullfile(path,'blocks'));
rmpath(genpath(fullfile(path,'blocks', 'mex')));
rmpath(genpath(fullfile(path,'blocks', 'sfcn')));
% Help Paths
rmpath(fullfile(path,'help'));
rmpath(fullfile(path,'help', 'html'));

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
addpath(fullfile(path,'rps'));
addpath(genpath(fullfile(path,'rps', 'fcn')));
addpath(genpath(fullfile(path,'rps', 'html')));
addpath(genpath(fullfile(path,'rps', 'svn')));
addpath(genpath(fullfile(path,'rps', 'cfg')));
addpath(fullfile(path,'rps', 'etc'));
addpath(fullfile(path,'rps', 'etc', 'icons_18'));
addpath(genpath(fullfile(path,'rps', 'etc', 'shortcut_tools')));
% Blocks Paths
addpath(fullfile(path,'blocks'));
addpath(genpath(fullfile(path,'blocks', 'mex')));
addpath(genpath(fullfile(path,'blocks', 'sfcn')));
% Help Paths
addpath(fullfile(path,'help'));
addpath(fullfile(path,'help', 'html'));

% Save all Searchpaths
savepath();

% Restart RPS Graphical User Interface
rehash;
rps_GraphicalUserInterface();

end


