function [] = switchRepository(repoUrl,username,password)
%SWITCHREPOSITORY Summary of this function goes here
%   Detailed explanation goes here

% Get RPS Path
homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
% Create tmp folder in rps home, add to path and copy all needed
% functions/scripts/files to it for updating...
mkdir(fullfile(homeDir,'tmp'));
addpath(fullfile(homeDir,'tmp'));

copyfile(fullfile(homeDir,'rps','etc','svn'),fullfile(homeDir,'tmp','svn'));
copyfile(fullfile(homeDir,'rps','svn','checkoutSVNSwitchRepository.m'),fullfile(homeDir,'tmp','checkoutSVNSwitchRepository.m'));


% delete old svn and run checkoutSVN... in tmp folder..
rmpath(fullfile(homeDir,'rps','svn'));

rehash;

checkoutSVNSwitchRepository(repoUrl, username, password);


end

