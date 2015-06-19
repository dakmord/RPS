function [] = addRpsPaths()
% Get RPS Home Path
path = getpref('RapidPrototypingSystem', 'HomeDir');

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
% addpath(genpath(fullfile(path,'blocks', 'src'))); % Not needed

% Help Paths
addpath(fullfile(path,'help'));
addpath(fullfile(path,'help', 'html'));
        
% Save Paths
savepath();

end

