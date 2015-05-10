function updateLocal(reopenGUI)
% Get current Path of this script
scriptPath = mfilename('fullpath');
[path, name, ext] = fileparts(scriptPath);

% Copy files from rps to gui folder (guis...)
copyfile(fullfile(path, 'rps', '*.m'), fullfile(path, 'gui'));
status = copyfile(fullfile(path, 'rps', '*.p'), fullfile(path, 'gui'));
copyfile(fullfile(path, 'rps', '*.fig'), fullfile(path, 'gui'));

% Copy folders from rps to gui
    % - functions       (\fcn)
    % - tools...support (\etc)
    % - configurations  (\cfg\*.xml)
    % - pictures        (\pics\*.png)
    % - svn functions   (\svn\*.m)
copyfile(fullfile(path, 'rps', 'pics', '*.png'), fullfile(path, 'gui', 'pics'));
copyfile(fullfile(path, 'rps', 'cfg', '*.xml'), fullfile(path, 'gui', 'cfg'));
copyfile(fullfile(path, 'rps', 'svn', '*.m'), fullfile(path, 'gui', 'svn'));
copyfile(fullfile(path, 'rps', 'etc'), fullfile(path, 'gui', 'etc'));
copyfile(fullfile(path, 'rps', 'fcn'), fullfile(path, 'gui', 'fcn'));

% Copy startup_rps.m file..
copyfile(fullfile(path, 'rps', 'fcn', 'startup_rps.m'), fullfile(path));
% Clean ..\gui\fcn\.. directory...
delete(fullfile(path, 'gui', 'fcn', 'startup_rps.m'));
delete(fullfile(path, 'gui', 'fcn', 'updateLocal.m'));

if strcmp(reopenGUI, 'Yes')
   rehash;
   run([path '\startup_rps.m']);
   rps_gui; 
end