function makeInfo = rtwmakecfgTM4C1294NPDT()
%RTWMAKECFG adds include and source directories to the make files.
%   makeInfo=RTWMAKECFG returns a structured array containing build info.
%   Please refer to the rtwmakecfgTM4C1294NPDT API section in the Simulink Coder
%   documentation for details on the format of this structure.
%
%   Simulink version    : 8.2 (R2013b) 08-Aug-2013
%   MATLAB file generated on : 04-Apr-2015 18:00:47

% Verify the Simulink version
verify_simulink_version();

% Get the current directory
currDir = pwd;

% Get the MATLAB search paths and remove the toolbox sub-directories except simfeatures
pSep = pathsep;
matlabPaths = regexp([matlabpath pSep], ['.[^' pSep ']*' pSep], 'match');
if ~isempty(matlabPaths)
    filteredPathIndices = strncmp(fullfile(matlabroot,'toolbox'), matlabPaths, numel(fullfile(matlabroot,'toolbox')));
    lctPath = fileparts(which('sldemo_lct_builddemos'));
    if ~isempty(lctPath)
        filteredPathIndices(strncmp([lctPath pSep], matlabPaths, numel([lctPath pSep]))) = 0;
    end
    lctPath = fileparts(which('rtwdemo_lct_builddemos'));
    if ~isempty(lctPath)
        filteredPathIndices(strncmp([lctPath pSep], matlabPaths, numel([lctPath pSep]))) = 0;
    end
    matlabPaths(filteredPathIndices) = [];
    matlabPaths = strrep(matlabPaths, pSep, '');
end

% Declare cell arrays for storing the paths found
allIncPaths = {};
allSrcPaths = {};
allSrcs = {};


% Get the serialized paths information
info = get_serialized_info();

% Get all S-Function's name in the current model
sfunNames = {};
if ~isempty(bdroot)
    sfunBlks = find_system(bdroot,...
        'LookUnderMasks', 'all',...
        'FollowLinks', 'on',...
        'BlockType', 'S-Function'...
    );
    sfunNames = get_param(sfunBlks, 'FunctionName');
end

for ii = 1:length(info)
    % If the S-Function isn't part of the current build then skip its path info
    if isempty(strmatch(info(ii).SFunctionName, sfunNames, 'exact'))
        continue
    end

    % Path to the S-function source file
    if strcmp(info(ii).Language, 'C') && info(ii).singleCPPMexFile==0
        fext = '.c';
    else
        fext = '.cpp';
    end
    pathToSFun = fileparts(which([info(ii).SFunctionName,fext]));
    if isempty(pathToSFun) && strcmp(info(ii).Language, 'C') && info(ii).singleCPPMexFile
        pathToSFun = fileparts(which([info(ii).SFunctionName,'.c']));
    end
    if isempty(pathToSFun)
        pathToSFun = currDir;
    end

    % Default search paths for this S-function
    defaultPaths = [{pathToSFun} {currDir}];
    allPaths = [defaultPaths matlabPaths];
    
    % Verify if IncPaths are absolute or relative and then complete
    % relative paths with the full S-function dir or current dir or MATLAB path
    incPaths = info(ii).IncPaths;

    for jj = 1:length(incPaths)
        [fullPath, isFound] = resolve_path_info(correct_path_sep(incPaths{jj}), allPaths);
        if (isFound==0)
            DAStudio.error('Simulink:tools:LCTErrorCannotFindIncludePath',...
                incPaths{jj});
        else
            incPaths{jj} = fullPath;
        end
    end
    incPaths = [incPaths defaultPaths];
    
    % Verify if SrcPaths are Absolute or Relative and then complete
    % relative paths with the full S-function dir or current dir or MATLAB path
    srcPaths = info(ii).SrcPaths;
    for jj = 1:length(srcPaths)
        [fullPath, isFound] = resolve_path_info(correct_path_sep(srcPaths{jj}), allPaths);
        if (isFound==0)
            DAStudio.error('Simulink:tools:LCTErrorCannotFindSourcePath',...
                srcPaths{jj});
        else
            srcPaths{jj} = fullPath;
        end
    end
    srcPaths = [srcPaths defaultPaths];

    % Common search paths for Source files specified with path
    srcSearchPaths = [srcPaths matlabPaths];

    % Add path to source files if not specified and complete relative
    % paths with the full S-function dir or current dir or search
    % paths and then extract only the path part to add it to the srcPaths
    sourceFiles = info(ii).SourceFiles;
    pathFromSourceFiles = cell(1, length(sourceFiles));
    for jj = 1:length(sourceFiles)
        [fullName, isFound] = resolve_file_info(correct_path_sep(sourceFiles{jj}), srcSearchPaths);
        if isFound==0
            DAStudio.error('Simulink:tools:LCTErrorCannotFindSourceFile',...
                sourceFiles{jj});
        else
            % Extract the path part only
            [fpath, fname, fext] = fileparts(fullName);
            pathFromSourceFiles{jj} = fpath;
        end
    end
    srcPaths = [srcPaths pathFromSourceFiles];

    % Add the sources to the list of dependencies
    if info(ii).singleCPPMexFile
       allSrcs = RTW.unique([allSrcs sourceFiles]);
    end

    % Concatenate known include and source directories
    allIncPaths = RTW.uniquePath([allIncPaths incPaths]);
    allSrcPaths = RTW.uniquePath([allSrcPaths srcPaths]);
end

% Additional include directories
makeInfo.includePath = correct_path_name(allIncPaths);

% Additional source directories
makeInfo.sourcePath = correct_path_name(allSrcPaths);

% Additional sources 
makeInfo.sources = allSrcs;

%--------------------------------------------------------------------------
function verify_simulink_version()

% Retrieve Simulink version
slVer = ver('simulink');
factor = 1.0;
thisVer = 0.0;
for ii = 1:length(slVer.Version)
    if slVer.Version(ii)=='.'
        factor = factor/10.0;
    else
        thisVer = thisVer + sscanf(slVer.Version(ii), '%d')*factor;
    end
end

% Verify that the actual plateform supports the function used
if thisVer < 6.4
    DAStudio.error('Simulink:tools:LCTErrorBadSimulinkVersion', sprintf('%g',thisVer))
end


%--------------------------------------------------------------------------
function [fullPath, isFound] = resolve_path_info(fullPath, searchPaths)

% Initialize output value
isFound = 0;

if is_absolute_path(fullPath)==1
    % Verify that the dir exists
    if exist(fullPath, 'dir')
        isFound = 1;
    end
else
    % Walk through the search path
    for ii = 1:length(searchPaths)
        thisFullPath = fullfile(searchPaths{ii}, fullPath);
        % If this candidate path exists then exit
        if exist(thisFullPath, 'dir')
            isFound = 1;
            fullPath = thisFullPath;
            break
        end
    end
end


%--------------------------------------------------------------------------
function [fullName, isFound] = resolve_file_info(fullName, searchPaths)

% Initialize output value
isFound = 0;

% Extract file parts
[fPath, fName, fExt] = fileparts(fullName);

if is_absolute_path(fPath)==1
    % If the file has no extension then try to add it
    if isempty(fExt)
        fExt = find_file_extension(fullfile(fPath, fName));
        fullName = fullfile(fPath, [fullName,fExt]);
    end
    % Verify that the file exists
    if exist(fullName, 'file')
        isFound = 1;
    end
else
    % Walk through the search path
    for ii = 1:length(searchPaths)
        thisFullName = fullfile(searchPaths{ii}, fullName);
        % If the file has no extension then try to add it
        if isempty(fExt)
            fExt = find_file_extension(thisFullName);
            thisFullName = [thisFullName,fExt];
        end
        % If this candidate path exists then exit
        if exist(thisFullName, 'file')
            fullName = thisFullName;
            isFound = 1;
            break
        end
    end
end


%--------------------------------------------------------------------------
function fext = find_file_extension(fullName)

% Initialize output value
fext = [];

% Use 'dir' because this command has the same behavior both
% on PC and Unix
theDir = dir([fullName,'.*']);
if ~isempty(theDir)
    for ii = 1:length(theDir)
        if theDir(ii).isdir
            continue
        end
        [fpath, fname, fext] = fileparts(theDir(ii).name);
        if ~isempty(fext)
            break % stop on first occurrence
        end
    end
end


%--------------------------------------------------------------------------
function bool = is_absolute_path(thisPath)

if isempty(thisPath)
    bool = 0;
    return
end

if(thisPath(1)=='.')
    % Relative path
    bool = 0;
else
    if(ispc && length(thisPath)>=2)
        % Absolute path on PC start with drive letter or \(for UNC paths)
        bool = (thisPath(2)==':') | (thisPath(1)=='\');
    else
        % Absolute paths on unix start with '/'
        bool = thisPath(1)=='/';
    end
end


%--------------------------------------------------------------------------
function thePath = correct_path_sep(thePath)

if isunix
    wrongFilesepChar = '\';
    filesepChar = '/';
else
    wrongFilesepChar = '/';
    filesepChar = '\';
end

seps = find(thePath==wrongFilesepChar);
if(~isempty(seps))
    thePath(seps) = filesepChar;
end


%--------------------------------------------------------------------------
function thePaths = correct_path_name(thePaths)

for ii = 1:length(thePaths)
    thePaths{ii} = rtw_alt_pathname(thePaths{ii});
end
thePaths = RTW.uniquePath(thePaths);


%--------------------------------------------------------------------------
function info = get_serialized_info()

% Allocate the output structure array
info(1:3) = struct(...
    'SFunctionName', '',...
    'IncPaths', {{}},...
    'SrcPaths', {{}},...
    'LibPaths', {{}},...
    'SourceFiles', {{}},...
    'HostLibFiles', {{}},...
    'TargetLibFiles', {{}},...
    'singleCPPMexFile', false,...
    'Language', ''...
    );

% Dependency info for S-function 'sfunc_digitalWriteEnergia'
info(1).SFunctionName = 'sfcn_digitalWriteEnergia';
info(1).IncPaths = {'src'};
info(1).SrcPaths = {'src'};
info(1).SourceFiles = {'gpioEnergia.c'};
info(1).singleCPPMexFile = 1;
info(1).SFunctionName = 'sfcn_digitalWriteEnergia';
info(1).IncPaths = {'src'};
info(1).SrcPaths = {'src'};
info(1).SourceFiles = {'gpioEnergia.c'};
info(1).singleCPPMexFile = 1;
info(1).Language = 'C';
% Dependency info for S-function 'sfunc_digitalReadEnergia'
info(2).SFunctionName = 'sfcn_digitalReadEnergia';
info(2).IncPaths = {'src'};
info(2).SrcPaths = {'src'};
info(2).SourceFiles = {'gpioEnergia.c'};
info(2).singleCPPMexFile = 1;
info(2).SFunctionName = 'sfcn_digitalReadEnergia';
info(2).IncPaths = {'src'};
info(2).SrcPaths = {'src'};
info(2).SourceFiles = {'gpioEnergia.c'};
info(2).singleCPPMexFile = 1;
info(2).Language = 'C';
% Dependency info for S-function 'sfunc_udpWriteEnergia'
info(3).SFunctionName = 'sfunc_udpWriteEnergia';
info(3).IncPaths = {'src'};
info(3).SrcPaths = {'src'};
info(3).SourceFiles = {'ethernetEnergia.c'};
info(3).singleCPPMexFile = 1;
info(3).SFunctionName = 'sfunc_udpWriteEnergia';
info(3).IncPaths = {'src'};
info(3).SrcPaths = {'src'};
info(3).SourceFiles = {'ethernetEnergia.c'};
info(3).singleCPPMexFile = 1;
info(3).Language = 'C';
% Dependency info for S-function 'sfunc_udpReadEnergia'
info(4).SFunctionName = 'sfunc_udpReadEnergia';
info(4).IncPaths = {'src'};
info(4).SrcPaths = {'src'};
info(4).SourceFiles = {'ethernetEnergia.c'};
info(4).singleCPPMexFile = 1;
info(4).SFunctionName = 'sfunc_udpReadEnergia';
info(4).IncPaths = {'src'};
info(4).SrcPaths = {'src'};
info(4).SourceFiles = {'ethernetEnergia.c'};
info(4).singleCPPMexFile = 1;
info(4).Language = 'C';
% Dependency info for S-function 'sfunc_analogReadEnergia'
info(5).SFunctionName = 'sfunc_analogReadEnergia';
info(5).IncPaths = {'src'};
info(5).SrcPaths = {'src'};
info(5).SourceFiles = {'gpioEnergia.c'};
info(5).singleCPPMexFile = 1;
info(5).SFunctionName = 'sfunc_analogReadEnergia';
info(5).IncPaths = {'src'};
info(5).SrcPaths = {'src'};
info(5).SourceFiles = {'gpioEnergia.c'};
info(5).singleCPPMexFile = 1;
info(5).Language = 'C';
% Dependency info for S-function 'sfunc_analogWriteEnergia'
info(6).SFunctionName = 'sfcn_analogWriteEnergia';
info(6).IncPaths = {'src'};
info(6).SrcPaths = {'src'};
info(6).SourceFiles = {'gpioEnergia.c'};
info(6).singleCPPMexFile = 1;
info(6).SFunctionName = 'sfcn_analogWriteEnergia';
info(6).IncPaths = {'src'};
info(6).SrcPaths = {'src'};
info(6).SourceFiles = {'gpioEnergia.c'};
info(6).singleCPPMexFile = 1;
info(6).Language = 'C';
% Dependency info for S-function 'sfcn_analogWriteEnergia'
info(7).SFunctionName = 'sfcn_serialReceiveEnergia';
info(7).IncPaths = {'src'};
info(7).SrcPaths = {'src'};
info(7).SourceFiles = {'serialEnergia.c'};
info(7).singleCPPMexFile = 1;
info(7).SFunctionName = 'sfcn_serialReceiveEnergia';
info(7).IncPaths = {'src'};
info(7).SrcPaths = {'src'};
info(7).SourceFiles = {'serialEnergia.c'};
info(7).singleCPPMexFile = 1;
info(7).Language = 'C';
% Dependency info for S-function 'sfcn_analogWriteEnergia'
info(8).SFunctionName = 'sfcn_serialWriteEnergia';
info(8).IncPaths = {'src'};
info(8).SrcPaths = {'src'};
info(8).SourceFiles = {'serialEnergia.c'};
info(8).singleCPPMexFile = 1;
info(8).SFunctionName = 'sfcn_serialWriteEnergia';
info(8).IncPaths = {'src'};
info(8).SrcPaths = {'src'};
info(8).SourceFiles = {'serialEnergia.c'};
info(8).singleCPPMexFile = 1;
info(8).Language = 'C';
% Dependency info for S-function 'sfcn_analogWriteEnergia'
info(9).SFunctionName = 'sfcn_linSendEnergia';
info(9).IncPaths = {'src'};
info(9).SrcPaths = {'src'};
info(9).SourceFiles = {'serialEnergia.c'};
info(9).singleCPPMexFile = 1;
info(9).SFunctionName = 'sfcn_linSendEnergia';
info(9).IncPaths = {'src'};
info(9).SrcPaths = {'src'};
info(9).SourceFiles = {'serialEnergia.c'};
info(9).singleCPPMexFile = 1;
info(9).Language = 'C';

if (exist('rtwmakecfgTM4C1294NPDT_user','file') == 2), info = [info rtwmakecfgTM4C1294NPDT_user()]; end