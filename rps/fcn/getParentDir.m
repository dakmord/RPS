function [parentDir]=getParentDir(parentCDs, seperatorSymbol)

% Get Parent Dir _> ...\Rapid-Prototyping-System\
scriptPath = mfilename('fullpath');
[path, name, ext] = fileparts(scriptPath);
parts = strsplit(path, '\');
[x, y] = size(parts);
parentDir = {};

for i=1:(y-parentCDs)
    tmpDir = strcat(parts(1,i), seperatorSymbol);
    parentDir{end+1} = cell2mat(tmpDir);
end
parentDir = sprintf('%s',parentDir{1,:});

