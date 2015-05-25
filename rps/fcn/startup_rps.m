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
    % Get HomeDir
    pref_group = 'RapidPrototypingSystem';
	path = getpref(pref_group,'HomeDir');
	
    
    %% Check if RPS initialize state
    if ispref('RapidPrototypingSystem', 'isInitialized');
		% Set SVN Path to prefs...
		setpref(pref_group,'SvnBinaries', fullfile(path, 'rps', 'etc', 'svn', 'bin'));
	
        % RPS Paths
        addpath(genpath(fullfile(path,'rps')));
        % Blocks Paths
        addpath(genpath(fullfile(path,'blocks')));
        % Help Paths
        addpath(fullfile(path,'help'));
        
        % Check if Shortcuts exist
        categories = GetShortcutCategories();
        shortcutExists = false;
        for i=1:1:length(categories)
           if strcmp(categories{i},'Rapid-Prototyping-System')
              shortcutExists = true; 
           end
        end
        
        if shortcutExists == false
            % Create ShortcutCategory
            rps = 'Rapid-Prototyping-System';
            AddShortcutCategories({rps});

            % Add GUI Shortcut
            rpsIconPath = fullfile(path, 'rps', 'etc', 'icons_18', 'bmw_icon.png');
            AddShortcut('GraphicalUserInterface','rps_GraphicalUserInterface()',...
                rpsIconPath, rps);

            % Add Options Shortcut
            optionsIconPath = fullfile(path, 'rps', 'etc', 'icons_18', 'BMW-neg_com_settings_18.png');
            AddShortcut('Preferences','options()',...
                optionsIconPath, rps);
        end
		
        if isequal(exist(fullfile(path, 'temp'),'dir'),7)
            % Delete temp dir because no longer needed
			rmpath(fullfile(path, 'temp'));
            rmdir(fullfile(path, 'temp'),'s');
        end
    else
		error('Rapid-Prototyping-System seems to be not initialized. -> isInitialized is missing in your MATLAB preferences! If you do not know what happened, please reinstall Rapid-Prototyping-System.');
	end
    
    %% Build Searchdatabase for help files
    
	%htmlFolder = fullfile(path,'help', 'html');
	%builddocsearchdb(htmlFolder);

    %% Finish
    % Change Dir to RPS...
    cd(path);

	% Save all Searchpaths
	savepath();
	
	% Clear WS
	clear;
	
    disp('### DONE without Errors!');
catch
    %% Error
    disp('### ERROR: startup_rps.m failed!');
end