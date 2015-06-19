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

% Modified:     17.06.2015, Daniel Schneider, "Bugfix for custom installation path. After Re-Install still MATLAB Preferences availabe for old version!
%                                              Check for new Version and re-initialize all preferences!"


try
    %% Initialize RPS
    % Setup basic Paths and Preferences needed.
    disp('### Initializing Rapid-Prototyping-System...');

    % Version
    version = 1.52;
    
    % Initialize PrefGroup
    pref_group = 'RapidPrototypingSystem';
    
    % Check if newer version
    if ispref(pref_group,'version')
        old_version = getpref(pref_group, 'version');
        old_version = strrep(old_version,'v','');
        old_version = str2num(old_version);
        
        % Check if older
        if version > old_version
            % new
            newVersion = true;
        else
            newVersion = false;
        end
    else
        % New Version
        newVersion = true;
    end
        
    % Reset HomeDir every Startup
    scriptPath = mfilename('fullpath');
    [path, name, ext] = fileparts(scriptPath);
    % Check if current script is in rps/fcn/...
    if  isequal(exist(fullfile(path,'decryptCredentials.p'),'file'),6)
        % Wrong Directory, find homeDir
        path = strrep(path,'\rps\fcn','');
    end

    % Create Pref home dir
    setpref(pref_group,'HomeDir',path);
    
    % Check Pref FirstStartup
    isFirstStartup = false;
    if ~ispref(pref_group, 'FirstStartup')
        setpref(pref_group,'FirstStartup',true);
        % Save FirstStartup info
        isFirstStartup = true;
    end
    % Check Pref Reminder
    if ~ispref(pref_group, 'PreferencesReminder')
        setpref(pref_group,'PreferencesReminder', true);
    end
    % Check Pref Conn Reminder
    if ~ispref(pref_group, 'SVNConnectReminder')
        setpref(pref_group,'SVNConnectReminder', true);
    end
        
    % Get HomeDir
	path = getpref(pref_group,'HomeDir');
    % Set SVN Bin pref
    setpref(pref_group,'SvnBinaries', fullfile(path, 'rps', 'etc', 'svn', 'bin'));
    % Set RapidPrototypingSystem version pref
    setpref(pref_group, 'version', ['v' num2str(version)]);

    % Check if login details should be deleted
    if ispref('RPSuserconfig', 'credentialsSaved')
        if ~getpref('RPSuserconfig', 'credentialsSaved')
            % Delete auth.mat.aes if availabe
            if isequal(exist(fullfile(path,'auth.mat.aes'),'file'),2)
                    % Delete
                    delete(fullfile(path,'auth.mat.aes'));
            end
        end
    end
    
    % Add RPS Paths to MATLAB Search Path
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
    % Save Paths & Make available
    savepath();
    rehash;
  
    % Refresh Simulink Browser
    libBrow = LibraryBrowser.StandaloneBrowser;
    libBrow.refreshLibraryBrowser;

    % Check if Shortcuts exist
    categories = GetShortcutCategories();
    shortcutExists = false;
    for i=1:1:length(categories)
       if strcmp(categories{i},'Rapid-Prototyping-System')
          shortcutExists = true; 
       end
    end

    if shortcutExists == false || isFirstStartup || newVersion
        % Icons path
        iconsPath = fullfile(path, 'rps', 'etc', 'icons_18');
        % Create ShortcutCategory
        rps = 'Rapid-Prototyping-System';
        supportPkg = 'Support Packages';
        AddShortcutCategories({rps});
        AddShortcutCategories({supportPkg});
        
        % Add shortcut SupportPkg custom install
        AddShortcut('Install Support Package','supportPkg_url();',...
            fullfile(iconsPath,'BMW-neg_nav_more_18.png'), supportPkg);
        
        % Add shortcut SupportPkg template supportPkg
        AddShortcut('Create Template SupportPkg','disp(''TBA'');',...
            fullfile(iconsPath,'BMW-neg_com_toolbox_18.png'), supportPkg);
        
        % Add shortcut SupportPkg xmakefile setup
        AddShortcut('XMakefile Configuration','xmakefilesetup();',...
            fullfile(iconsPath,'Matlab_Logo.png'), supportPkg);
        
        % Add shortcut SupportPkg Install Arduino Package
        AddShortcut('Install Arduino',...
            'open(fullfile(getpref(''RapidPrototypingSystem'',''HomeDir''),''rps'',''etc'',''arduino.mlpkginstall''));',...
            fullfile(iconsPath,'arduino_logo.png'), supportPkg);
        
        % Add shortcut SupportPkg Install custom TI package
        AddShortcut('Install TI TM4C1294XL',...
            'hw_targetInstaller_tm4c1294();',...
            fullfile(iconsPath,'ti_logo.png'), supportPkg);
        
        % Add GUI Shortcut
        AddShortcut('Rapid-Prototyping-System','rps_GraphicalUserInterface()',...
            fullfile(iconsPath,'bmw_icon.png'), rps);

        % Add GUI Shortcut (offline mode)
        AddShortcut('Rapid-Prototyping-System (offline)','rps_GraphicalUserInterface({true})',...
            fullfile(iconsPath,'bmw_icon.png'), rps);
        
        % Add Legacy Shortcut
        AddShortcut('Legacy Code Tool','legacyCodeHelper()',...
            fullfile(iconsPath,'c_logo.png'), rps);
        
        % Add Options Shortcut
        AddShortcut('Preferences','options()',...
            fullfile(iconsPath,'BMW-neg_com_settings_18.png'), rps);

        % Add Documentation shortcut
        AddShortcut('Documentation','doc;',...
            fullfile(iconsPath,'BMW-neg_com_help_18.png'), rps);
        
        % Add About shortcut
        AddShortcut('About','about;',...
            fullfile(iconsPath,'BMW-neg_com_info_18.png'), rps);
        
        % Add CD to RPS Shortcut
        cdDirIcon = fullfile(iconsPath, 'folder_icon.png');
        AddShortcut('RPS Folder','cd(getpref(''RapidPrototypingSystem'', ''HomeDir''));',...
            cdDirIcon, rps);

        % Add CD to Blocks Shortcut
        AddShortcut('Blocks Folder','cd(fullfile(getpref(''RapidPrototypingSystem'', ''HomeDir''),''blocks''));',...
            cdDirIcon, rps);

        % Add shortcut RPS in Explorer
        AddShortcut('Open RPS in Explorer','dos(sprintf(''explorer %s'',getpref(''RapidPrototypingSystem'',''HomeDir'')));',...
            cdDirIcon, rps);
    end
    
    % Check if SVN is connected to folders
    if isequal(exist(fullfile(path, 'rps', '.svn'),'dir'),7) && ...
            isequal(exist(fullfile(path, 'blocks', '.svn'),'dir'),7) && ...
            isequal(exist(fullfile(path, 'help', '.svn'),'dir'),7)
        setpref(pref_group,'SVNConnected', true);
    else
        setpref(pref_group,'SVNConnected', false);
    end

    % Question if first Startup, ask if preferences should be opened
    if (isFirstStartup || ~ispref('RPSuserconfig')) && getpref(pref_group, 'PreferencesReminder')
        choice = questdlg('No Userconfig for the RPS has been found. Do you want to start the preferences dialog?',...
            'No RPS Userconfig Found!', 'Yes', 'No', 'Never ask again', 'Yes');
        drawnow; pause(0.2); % Bugfix: 14.06.2015, Daniel Schneider, "Added wait becuase Common Bug after MATLAB dlgs"
        switch choice
            case 'Yes'
                % Run Preferences Dialog
                options;
				drawnow; pause(0.2); % Bugfix: 14.06.2015, Daniel Schneider, "Added wait becuase Common Bug after MATLAB dlgs"
            case 'Never ask again'
                setpref(pref_group,'PreferencesReminder', false);
            otherwise
                % do nothing
        end
    end

    %% Build Searchdatabase for help files
    
	%htmlFolder = fullfile(path,'help', 'html');
	%builddocsearchdb(htmlFolder);

    %% Finish
    % Change Dir to RPS...
    %cd(path);							### Edited: Daniel Schneider, 08.06.2015, not needed and should be defined by users
	
	% Clear WS
	clear;
	
    disp('### DONE without Errors!');
catch err
    %% Error
    disp('### ERROR: startup_rps.m failed!');
    rethrow(err);
end