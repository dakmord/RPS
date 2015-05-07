% NOTE: DO NOT REMOVE THIS LINE XMAKEFILE_TOOL_CHAIN_CONFIGURATION
function toolChainConfiguration = TM4C1294NPDT()
%STELLARIS_LP Defines a tool chain configuration

toolsDir = realtime.internal.getTM4C1294NPDTInfo('toolsDir');
TargetRoot = realtime.internal.getTM4C1294NPDTInfo('PackageDir');

% General
toolChainConfiguration.Configuration = 'TM4C1294NPDT';
toolChainConfiguration.Version = '1.0';
toolChainConfiguration.Description = 'TivaC Launchpad';
toolChainConfiguration.Operational = true;
%toolChainConfiguration.InstallPath = 'C:\Program Files (x86)\Microsoft Visual Studio 8\';
toolChainConfiguration.Decorator = 'linkfoundation.xmakefile.decorator.eclipseDecorator';
% Make
toolChainConfiguration.MakePath = @(src) fullfile(toolsDir, 'gmake'); %'gmake'; %(tiCCSDir, 'utils', 'bin', 'gmake');
% toolChainConfiguration.MakePath = 'C:\Arduino22\hardware\tools\avr\utils\bin\make';
toolChainConfiguration.MakeFlags = '-f "[|||MW_XMK_GENERATED_FILE_NAME[R]|||]" [|||MW_XMK_ACTIVE_BUILD_ACTION_REF|||]';
toolChainConfiguration.MakeInclude = '';
% Compiler
toolChainConfiguration.CompilerPath = @(src) fullfile(toolsDir, 'arm-none-eabi-gcc');
toolChainConfiguration.CompilerFlags = '-c ';%-mv7M4 --code_state=16 --abi=eabi -me -O2 --gcc';
toolChainConfiguration.SourceExtensions = '.c,.cpp,.asm';
toolChainConfiguration.HeaderExtensions = '.h';
toolChainConfiguration.ObjectExtension = '.o';
% Linker
toolChainConfiguration.LinkerPath = @(src) fullfile(toolsDir,'arm-none-eabi-g++');
toolChainConfiguration.LinkerFlags = '-o [|||MW_XMK_GENERATED_TARGET_REF|||]';
toolChainConfiguration.LibraryExtensions = '.lib,.a';
toolChainConfiguration.TargetExtension = '.elf';
toolChainConfiguration.TargetNamePrefix = '';
toolChainConfiguration.TargetNamePostfix = '';
% Archiver
toolChainConfiguration.ArchiverPath = @(src) fullfile(toolsDir, 'arm-none-eabi-ar');
toolChainConfiguration.ArchiverFlags = '/OUT:[|||MW_XMK_GENERATED_TARGET_REF|||]';
toolChainConfiguration.ArchiveExtension = '.a';
toolChainConfiguration.ArchiveNamePrefix = 'lib';
toolChainConfiguration.ArchiveNamePostfix = '';
% Pre-build
toolChainConfiguration.PrebuildEnable = false;
toolChainConfiguration.PrebuildToolPath = '';
toolChainConfiguration.PrebuildFlags = '';
% Post-build
% hex     

if ispc
    % obj2bin tools 
    ofd = fullfile(toolsDir,'armofd');
    hex = fullfile(toolsDir,'armhex');
    mkhex = fullfile(TargetRoot,'utils','tiobj2bin','mkhex4bin');
    tiobj2bin = fullfile(toolsDir,'arm-none-eabi-objcopy');
    %system(['"' tiobj2bin '" "' outfile '" "' binfile  '" ]);
    
    toolChainConfiguration.PostbuildEnable = true;
    toolChainConfiguration.PostbuildToolPath = tiobj2bin; 
    % '$(TARGET) $(OUTPUT_PATH)$(MODEL_NAME).elf "'
    toolChainConfiguration.PostbuildFlags = [' -O binary ' '"$(TARGET)" ' '"$(OUTPUT_PATH)$(MODEL_NAME).bin"'];
else
    toolChainConfiguration.PostbuildEnable = false;
    toolChainConfiguration.PostbuildToolPath = ''; 
    toolChainConfiguration.PostbuildFlags = '';
end

% Execute
toolChainConfiguration.ExecuteDefault = false;
toolChainConfiguration.ExecuteToolPath = '';
toolChainConfiguration.ExecuteFlags = '';

% Directories
toolChainConfiguration.DerivedPath = '[|||MW_XMK_SOURCE_PATH_REF|||]';
toolChainConfiguration.OutputPath = '';
% Custom
toolChainConfiguration.Custom1 = '';
toolChainConfiguration.Custom2 = '';
toolChainConfiguration.Custom3 = '';
toolChainConfiguration.Custom4 = '';
toolChainConfiguration.Custom5 = '';
end
