%% Rapid-Prototyping-System basic startup 
% This script will be executed every MATLAB startup and triggers first svn
% checkout during the first startup with RPS. This script will be installed
% using the *.exe installation file and triggers everything needed for
% installing/setup. RPS itself will be loaded from a given SVN-Server using
% a custom URL/Credentials.

%% Basic Startup Process
% 
% <<rpsStart.png>>
% 


try
    %% Initialize RPS
    % Setup basic Paths and Preferences needed.
    disp('### Initializing Rapid-Prototyping-System...');
    scriptPath = mfilename('fullpath');
    [path, name, ext] = fileparts(scriptPath);
    guiPath = [path '\gui'];
    % Create RPS Pref with home dir
    pref_group = 'RapidPrototypingSystem';
	setpref(pref_group,'HomeDir',path);
	
    
    %% Check if RPS initialize state
    if ~ispref('RapidPrototypingSystem', 'isInitialized');
		% Set SVN Path to prefs...
		setpref(pref_group,'SvnBinaries', fullfile(path, 'temp', 'svn', 'bin'));
	
        % First RPS startup... initialize
        % -> Checkout RPS Data from Repository
        addpath(fullfile(path, 'temp'));
        rps_initialization;
    else
		% Set SVN Path to prefs...
		setpref(pref_group,'SvnBinaries', fullfile(path, 'rps', 'etc', 'svn', 'bin'));
	
        % RPS Paths
        addpath(genpath(fullfile(path,'rps')));
        % Blocks Paths
        addpath(genpath(fullfile(path,'blocks')));
        % Help Paths
        addpath(fullfile(path,'help'));
        
        % Remove old temp path
        rmpath(fullfile(path, 'temp'));
        if isequal(exist(fullfile(path, 'temp'),'dir'),7)
            % Delete temp dir because no longer needed
            rmdir(fullfile(path, 'temp'),'s');
        end
    end
    
    %% Build Searchdatabase for help files
    
	%htmlFolder = fullfile(path,'help', 'html');
	%builddocsearchdb(htmlFolder);

    %% Finish
    % Change Dir to RPS...
    cd(path);

    disp('### DONE without Errors!');
catch
    %% Error
    disp('### ERROR: startup_rps.m failed!')
end