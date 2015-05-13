function ret = runTM4C1294NPDTCmd (cmd, varargin )
switch (cmd)
    case 'download'
        narginchk(3, 3);
        ret = i_TM4C1294NPDT_download(varargin{1}, varargin{2});
    case 'opendemo'
        narginchk(2, 2);
        open_system(varargin{1});
        ret =[]; 
    case 'generateCoreLibrary'
        generateCoreLibrary;
    case 'getEthernetParameter'
        ret = getEthernetParameter;
    otherwise
        error('Invalid TM4C1294NPDT command!');
end
end

% This function is modified from Mikhail's package
function ret = i_TM4C1294NPDT_download(modelName, output_path)

disp(['### Downloading ', modelName, ' to TM4C1294NPDT LaunchPad [' getpref('TM4C1294NPDT','COMPort') ']...']);

TargetRoot = realtime.internal.getTM4C1294NPDTInfo('PackageDir');
lm4flash =  fullfile(TargetRoot,'utils','lm4flash','lmflash');

outfile = fullfile(output_path, [modelName, '.out']);
binfile = fullfile(output_path, [modelName, '.bin']);

if isunix
    ret = system(['"' lm4flash '" -q ek-tm4c1294xl -r "' binfile '" >/dev/null']);
else
    ret = system(['"' lm4flash '" -q ek-tm4c1294xl -r "' binfile '" >NUL']);
end

if ret == 0
    disp(['### Successfully downloaded ', modelName, ' to TM4C1294NPDT LaunchPad.']);
    ret =1;
else
    disp(['### Failed to download ', modelName, ' to TM4C1294NPDT LaunchPad.']);
    ret =0;
end

end

function path = fix_slash(path0)
path = path0;
if ispc
    path(path=='\')='/';
end
end

function generateCoreLibrary
    toolsDir = realtime.internal.getTM4C1294NPDTInfo('toolsDir');
    libFile = fullfile(pwd, 'libs', 'core.a');
    
    % Check if core.a is already existing and skip CoreLib generation...
    if ~isequal(exist(libFile, 'file'),2) % 7 = directory.
        mkdir(pwd,'libs');
        % Compile *.c/*.cpp files and generate *.o files...
        generateBasicLibObjectFiles;
        generateCustomLibObjectFiles;

        % Define Strings for CMD
        arPath = fullfile(toolsDir, 'arm-none-eabi-ar.exe');

        % Add all *.o files to core.a using archiever...
        fPath = fullfile(pwd, 'libs');
        fNames = dir( fullfile(fPath,'*.o') );
        fNames = strcat({fNames.name});
        %# process each *.o file
        for i=1:length(fNames)
            tmpFile = fullfile(fPath, fNames{i});
            cmd=sprintf('%s -rcs %s %s', arPath, libFile, tmpFile);
            [status, cmdout] = dos(cmd); 
        end

        % DONE
    end
end

function generateBasicLibObjectFiles
    toolsDir = realtime.internal.getTM4C1294NPDTInfo('toolsDir');
    TivaWareDir = realtime.internal.getTM4C1294NPDTInfo('TivaWareDir');
    
    % gcc and g++ compilers
    gccPath = fullfile(toolsDir, 'arm-none-eabi-gcc.exe');
    gppPath = fullfile(toolsDir, 'arm-none-eabi-g++.exe');
    % build a list of *.c files 
    fPath = fullfile(TivaWareDir);
    fNames = dir( fullfile(fPath,'*.c') );
    fNames = strcat({fNames.name});
    % compile each file
    flags = '-c -Os -w -ffunction-sections -fdata-sections -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant -DF_CPU=120000000L -MMD -DARDUINO=101 -DENERGIA=14';
    includes =['-I' TivaWareDir ' -I' fullfile(TivaWareDir, 'driverlib')];
    for i=1:length(fNames)
        tmpFile = fullfile(TivaWareDir, fNames{i});
        if ~isequal(fNames{i}, 'startup_gcc.c') % excluding startup_gcc.c because already in src dir
        [cmd]=sprintf('%s %s %s %s -o %s', gccPath,flags, includes, tmpFile, [fullfile(pwd,'libs', fNames{i}) '.o']);
        [status, cmdout] = dos(cmd);
        end
    end
    
    % build a list of *.cpp files
    fPath = fullfile(TivaWareDir);
    fNames = dir( fullfile(fPath,'*.cpp') );
    fNames = strcat({fNames.name});
    %# compile each file
    flags = '-c -Os -w -ffunction-sections -fdata-sections -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant -DF_CPU=120000000L -MMD -DARDUINO=101 -DENERGIA=14';
    includes =['-I' TivaWareDir ' -I' fullfile(TivaWareDir, 'driverlib')];
    for i=1:length(fNames)
        tmpFile = fullfile(TivaWareDir, fNames{i});
        if ~isequal(fNames{i}, 'main.cpp') % excluding main.cpp because simulink is generating a main
        [cmd]=sprintf('%s %s %s %s -o %s', gppPath,flags, includes, tmpFile, [fullfile(pwd,'libs', fNames{i}) '.o']);
        [status, cmdout] = dos(cmd);
        end
    end
end

function generateCustomLibObjectFiles
% get all needed paths/dirs
    toolsDir = realtime.internal.getTM4C1294NPDTInfo('toolsDir');
    energiaHomeDir = realtime.internal.getTM4C1294NPDTInfo('EnergiaHome');
    TivaWareDir = realtime.internal.getTM4C1294NPDTInfo('TivaWareDir');
    % custom lib dirs
    energiaVariantsDir = fullfile(energiaHomeDir,'hardware', 'lm4f', 'variants');
    energiaLibrariesDir = fullfile(energiaHomeDir,'hardware', 'lm4f', 'libraries');
    ethernetDir = fullfile(energiaLibrariesDir, 'Ethernet');
    ethernetUtilityDir = fullfile(energiaLibrariesDir, 'Ethernet', 'utility');
    spiDir = fullfile(energiaLibrariesDir, 'SPI');
    servoDir = fullfile(energiaLibrariesDir, 'Servo');
    stepperDir = fullfile(energiaLibrariesDir, 'Stepper');
    
    % add paths to cell
    pathCell = {};
    pathCell{end+1} = TivaWareDir;
    pathCell{end+1} = ethernetDir;
    pathCell{end+1} = ethernetUtilityDir;
    pathCell{end+1} = spiDir;
    pathCell{end+1} = servoDir;
    pathCell{end+1} = stepperDir;
    
    %compilers
    gccPath = fullfile(toolsDir, 'arm-none-eabi-gcc.exe');
    gppPath = fullfile(toolsDir, 'arm-none-eabi-g++.exe');
    flags = '-c -Os -w -fno-rtti -fno-exceptions -ffunction-sections -fdata-sections -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant -DF_CPU=120000000L -MMD -DARDUINO=101 -DENERGIA=14';
    % generate object files for *.c and *.cpp files contained in the dirs
    for p = 1:length(pathCell)
        fPath = fullfile(pathCell{p});
        fNames = dir( fullfile(fPath,'*.c') );
        fNames = strcat({fNames.name});
        % compile each *.c file
        includes =['-I' TivaWareDir ' -I' pathCell{p} ' -I' ethernetDir ' -I' fullfile(energiaVariantsDir, 'launchpad_129')];
        for i=1:length(fNames)
            tmpFile = fullfile(pathCell{p}, fNames{i});
            [cmd]=sprintf('%s %s %s %s -o %s', gccPath,flags, includes, tmpFile, [fullfile(pwd,'libs', fNames{i}) '.o']);
            [status, cmdout] = dos(cmd);
            % Check for Errors during compilation
            if status==1
                disp(cmdout);
            end
        end
        % compile each *.cpp file
        fNames = dir( fullfile(fPath,'*.cpp') );
        fNames = strcat({fNames.name});
        % compile each *.c file
        for i=1:length(fNames)
            tmpFile = fullfile(pathCell{p}, fNames{i});
            [cmd]=sprintf('%s %s %s %s -o %s', gppPath,flags, includes, tmpFile, [fullfile(pwd,'libs', fNames{i}) '.o']);
            [status, cmdout] = dos(cmd);
            % Check for Errors during compilation
            if status==1
                disp(cmdout);
            end
        end
    end
end

function par = getEthernetParameter
    par={};
    tgtData= get_param( bdroot, 'TargetExtensionData') ;
    % Get IP out of Model Parameter
    raw = tgtData.ip_address;
    parts = strsplit(raw, '.');
    if length(parts)==4
        % Correct IP size
        for i=1:length(parts)
           par{end+1} = parts{i}; 
        end
    else
        % Incorrect IP Size use standard....
        disp(' ### WARNING: Incorrect IP-Address given in Model Configuration!');
        disp('     Using default IP = 192.168.0.50');
        for i=1:4
           par{end+1} = FF; 
        end
    end
    % Get MAC out of Model Parameter
    raw = tgtData.mac_address;
    parts = strsplit(raw, ':');
    if length(parts)==6   
        % Correct MAC size
        for i=1:length(parts)
           par{end+1} = parts{i}; 
        end
    else
        %Wrong MAC-Adress use standard...
        disp(' ### WARNING: Incorrect MAC-Address given in Model Configuration!');
        disp('     Using default MAC = FF:FF:FF:FF:FF:FF');
        for i=1:6
           par{end+1} = FF; 
        end
    end
end