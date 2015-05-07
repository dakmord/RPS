function info= buildInfoDataTM4C1294NPDT(~)
%buildInfoDataTM4C1294NPDT Defines build info data

% target_define = 'TARGET_IS_SNOWFLAKE_RA0'; % not needed anymore
makeinfo = realtime.internal.rtwmakecfgTM4C1294NPDT;

info.SourceFiles            = i_getSourceFiles(makeinfo);

info.SourceFilesToSkip      = {'main.cpp'};
info.IncludePaths           = union(i_getIncludePaths, makeinfo.includePath);
info.CompileFlags           = [ '-w ' ...
                                '-Os ' ...
                                '-ffunction-sections ' ...
                                '-fdata-sections ' ...
                                ...
                                '-mcpu=cortex-m4 '  ... arm7 cortex-m4
                                ...%'-march=armv7e-m '...'--align_structs=4 ' ... align struct to workaround a compiler bug
                                '-mthumb '  ... 32 bit thumb code
                                '-mfloat-abi=hard ' ... float support
                                '-mfpu=fpv4-sp-d16 '       ... ABI 
                                '-fsingle-precision-constant '              ... little endian
                                '-DF_CPU=120000000L '         ... optimalization lvl
                                '-MMD ' ...
                                '-DARDUINO=101 ' ... custom
                                '-DENERGIA=14 ' ... custom
                                ...'--profile:breakpt ' ...
                                ];   
info.Defines                = getTargetDefines ;
info.LinkFlags              = [ '-Os ' ...
                                '-nostartfiles ' ...
                                '-nostdlib ' ...
                                '-Wl,--gc-sections ' ...
                                '-T "' i_getLinkCmdFile '" ' ...
                                '-Wl,--entry=ResetISR ' ...
                                '-mthumb ' ...
                                '-mcpu=cortex-m4 '  ... arm7 cortex-m4
                                '-mfloat-abi=hard ' ... float support
                                '-mfpu=fpv4-sp-d16 ' ...
                                '-fsingle-precision-constant '  ...
                                '-Wl,--start-group ' ...
                                '"' i_getCoreLibPath '" ' ...
                                '"' i_getDriverLibPath '" ' ...
                                '-lm -lgcc -lc ' ...
                                '-lstdc++ '  ...  % CUSTOM CAUSE LINKER PROBS 
                                '-lrdimon ' ...
                                '-Wl,--end-group ' ...
                                ];
end

function link_cmd_file = i_getLinkCmdFile ()
pkgRootDir = realtime.internal.getTM4C1294NPDTInfo('PackageDir');
link_cmd_file = fullfile(pkgRootDir, 'registry', 'lm4fcpp_snowflake.ld');
end

% -------------------------------------------------------------------------
function files = i_getSourceFiles(makeinfo)

files = {};
% Basic rps directories
packageDir =  realtime.internal.getTM4C1294NPDTInfo('PackageDir');
EnergiaHomeDir = realtime.internal.getTM4C1294NPDTInfo('EnergiaHome');
EnergiaLibrariesDir = fullfile(EnergiaHomeDir, 'hardware', 'lm4f', 'libraries');

%add block sources
for i=1:length(makeinfo.sources)
    files{end+1}.Name = makeinfo.sources{i}; %#ok<*AGROW>
    files{end}.Path = i_getSourceFilePath(makeinfo.sourcePath, makeinfo.sources{i});
end

files{end+1}.Name = 'io_wrappers.cpp';
files{end}.Path = fullfile(packageDir, 'src');

files{end+1}.Name = 'energia_runtime.c';
files{end}.Path = fullfile(packageDir, 'src');
 
files{end+1}.Name = 'startup_gcc.c';
files{end}.Path = fullfile(packageDir, 'src');

files{end+1}.Name = 'rtiostream_serial.cpp';
files{end}.Path = fullfile(packageDir, 'src');

% Custom Libs for Ethernet
% files{end+1}.Name = 'Ethernet.cpp';
% files{end}.Path = fullfile(EnergiaLibrariesDir, 'Ethernet');
% 
% files{end+1}.Name = 'EthernetUdp.cpp';
% files{end}.Path = fullfile(EnergiaLibrariesDir, 'Ethernet');
% 
% files{end+1}.Name = 'EthernetClient.cpp';
% files{end}.Path = fullfile(EnergiaLibrariesDir, 'Ethernet');
% 
% files{end+1}.Name = 'EthernetServer.cpp';
% files{end}.Path = fullfile(EnergiaLibrariesDir, 'Ethernet');

% Ethernet utils..
% fPath = fullfile(EnergiaLibrariesDir, 'Ethernet', 'utility');
% fNames = dir( fullfile(fPath,'*.c') );
% fNames = strcat({fNames.name});
% %# process each file
% for i=1:length(fNames)
%     files{end+1}.Name = fNames{i};
%     files{end}.Path = fullfile(EnergiaLibrariesDir, 'Ethernet', 'utility');
% end


end

function p = i_getSourceFilePath(paths, file)
for i=1:length(paths)
    if exist(fullfile(paths{i},file),'file') == 2
        p=paths{i};
        return ;
    end
end
p=paths{1};
end

% -------------------------------------------------------------------------
function paths = i_getIncludePaths()
paths = {};
% Get standard rps paths
pkgRootDir = realtime.internal.getTM4C1294NPDTInfo('PackageDir');
TivaWareDir = realtime.internal.getTM4C1294NPDTInfo('TivaWareDir');
energiaHome = realtime.internal.getTM4C1294NPDTInfo('EnergiaHome');
energiaLibrariesDir = fullfile(energiaHome,'hardware', 'lm4f', 'libraries');
energiaVariantsDir = fullfile(energiaHome,'hardware', 'lm4f', 'variants');

% Add Paths for Compiler includes
paths{end+1} = fullfile(pkgRootDir, 'src');
% Custom energia libraries
paths{end+1} = fullfile(energiaLibrariesDir, 'Ethernet');
paths{end+1} = fullfile(energiaLibrariesDir, 'SPI');
paths{end+1} = fullfile(energiaLibrariesDir, 'Stepper');
paths{end+1} = fullfile(energiaLibrariesDir, 'Servo');
% Board speciefic ... tm4c1294xl
paths{end+1} = fullfile(energiaVariantsDir, 'launchpad_129');
% Basic Includes for energia and ti
paths{end+1} = fullfile(TivaWareDir);
% Basic RTT Block srcs
paths{end+1} = fullfile(pkgRootDir, 'blocks', 'src');

end


function path = i_getDriverLibPath()
tivaWare = realtime.internal.getTM4C1294NPDTInfo('TivaWareDir');
path = fullfile(tivaWare, 'driverlib','libdriverlib.a');
end

function path = i_getCoreLibPath()
if isequal(exist(fullfile('..', 'libs'), 'dir'),7)
   if isequal(exist(fullfile('..', 'libs', 'core.a'), 'file'),2)
        path = fullfile('..', 'libs', 'core.a');
        
   else
       disp('### Error in buildInfoDataTM4C1294NPDT.m: Error cannot find ../libs/core.a in current folder!');
   end
else
   disp('### Error in buildInfoDataTM4C1294NPDT.m: Error cannot find ../libs/core.a in current folder!');
end

end

function defines = getTargetDefines()
    defines = {};
    % Get IP and MAC from Model Parameters
    ethernetParameter = realtime.internal.runTM4C1294NPDTCmd('getEthernetParameter');
    for i=1:1:length(ethernetParameter)
        if i<=4
            tmp = sprintf('_RTT_Local_IP%i %s',i,ethernetParameter{i});
            defines{end+1}=tmp;
        else
            tmp = sprintf('_RTT_Local_MAC%i 0x%s',(i-4),ethernetParameter{i});
            defines{end+1}=tmp;
        end
    end   
end