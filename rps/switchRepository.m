function [] = switchRepository(repoUrl,username,password)
%SWITCHREPOSITORY Summary of this function goes here
%   Detailed explanation goes here

% Get RPS Path
homeDir = getpref('RapidPrototypingSystem', 'HomeDir');
% Create temp folder in rps home, add to path and copy all needed
% functions/scripts/files to it for updating...
mkdir(fullfile(homeDir,'temp'));
addpath(fullfile(homeDir,'temp'));

copyfile(fullfile(homeDir,'rps','etc','svn'),fullfile(homeDir,'temp','svn'));
copyfile(fullfile(homeDir,'rps','svn','checkoutSVNSwitchRepository.m'),fullfile(homeDir,'temp','checkoutSVNSwitchRepository.m'));

% delete old svn and run checkoutSVN... in temp folder..
rmpath(fullfile(homeDir,'rps','svn'));

rehash;

% Show Loading Window...
d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Changing to new Repository...', []);
d.setValue(0.25);                        % default = 0
d.setProgressStatusLabel('Please wait, replacing data...');  % default = 'Please Wait'
d.setSpinnerVisible(false);               % default = true
d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
d.setCancelButtonVisible(false);          % default = true
d.setVisible(true);                      % default = false

% Start Delete, Checkout, ...
checkoutSVNSwitchRepository(repoUrl, username, password);

% Hide Loading window...
d.setVisible(false);

end

