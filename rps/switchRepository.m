function [] = switchRepository(repoUrl,username,password)
%SWITCHREPOSITORY Summary of this function goes here
%   Detailed explanation goes here

% Create tmp folder in rps home, add to path and copy all needed
% functions/scripts/files to it for updating...
mkdir(fullfile('..','tmp'));
addpath(fullfile('..','tmp'));

copyfile(fullfile('etc','svn'),fullfile('..','tmp','svn'));
copyfile(fullfile('svn','checkoutSVNSwitchRepository.m'),fullfile('..','tmp','checkoutSVNSwitchRepository.m'));


% if everything should be finde start function for deleting & checking out new files
rmpath('svn');
checkoutSVNSwitchRepository(repoUrl, username, password);


end

