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

% Delete old repo folders..
rmpath(fullfile(homeDir,'rps'));
rmpath(fullfile(homeDir,'blocks'));
rmpath(fullfile(homeDir,'help'));
rmdir(fullfile(homeDir,'rps'),'s');
rmdir(fullfile(homeDir,'blocks'),'s');
rmdir(fullfile(homeDir,'help'),'s');

% Define repo url's
rps = strrep(fullfile(repository,'trunk', 'rps'), '\', '/');
blocks = strrep(fullfile(repository,'trunk', 'blocks'), '\', '/');
help = strrep(fullfile(repository,'trunk', 'help'), '\', '/');

% Define destination's
destination = fullfile(getpref('RapidPrototypingSystem','HomeDir'));
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

% Restart RPS Graphical User Interface
% TODO: ?!?!?!

end


