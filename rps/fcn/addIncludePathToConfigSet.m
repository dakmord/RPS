function cs=addIncludePathToConfigSet(cs)
 % Home Dir
 homeDir = getpref('RapidPrototypingSystem', 'HomeDir');

% Code Generation:Custom Code pane
cs.set_param('CustomHeaderCode', '');   % Header file 

% Generate pathlist depending on blocks\src...
folderList = genpath(fullfile(homeDir, 'blocks', 'src'));
splittedList = strsplit(folderList, ';');
for i=1:1:length(splittedList)
    if i==1
        customIncludeList = sprintf('%s\n',splittedList{i});
    else
        customIncludeList = sprintf('%s%s\n',customIncludeList,splittedList{i});
    end
end

cs.set_param('CustomInclude', customIncludeList);   % Include directories 
cs.set_param('CustomInitializer', '');   % Initialize function 
cs.set_param('CustomLibrary', '');   % Libraries 
cs.set_param('CustomSource', '');   % Source files 
cs.set_param('CustomSourceCode', '');   % Source file 
cs.set_param('CustomTerminator', '');   % Terminate function 
cs.set_param('RTWUseSimCustomCode', 'off');   % Use the same custom code settings as Simulation Target 

