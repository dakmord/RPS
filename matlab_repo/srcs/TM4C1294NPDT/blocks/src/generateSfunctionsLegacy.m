% Go into script folder
scriptPath = mfilename('fullpath');
[path, name, ext] = fileparts(scriptPath);
cd(path);

% sfunc_digitalReadEnergia
digitalReadEnergia = legacy_code('initialize');
digitalReadEnergia.SFunctionName = 'sfunc_digitalReadEnergia';
digitalReadEnergia.HeaderFiles = {'gpioEnergia.h'};
digitalReadEnergia.SourceFiles = {'gpioEnergia.c'};
digitalReadEnergia.OutputFcnSpec = 'uint8 y1 = digitalReadEnergia(uint8 u1, uint8 u2)';
digitalReadEnergia.SampleTime = 'parameterized';
% sfunc_digitalWriteEnergia
digitalWriteEnergia = legacy_code('initialize');
digitalWriteEnergia.SFunctionName = 'sfunc_digitalWriteEnergia';
digitalWriteEnergia.HeaderFiles = {'gpioEnergia.h'};
digitalWriteEnergia.SourceFiles = {'gpioEnergia.c'};
digitalWriteEnergia.OutputFcnSpec = 'digitalWriteEnergia(uint8 u1, uint8 u2)';
digitalWriteEnergia.SampleTime = 'parameterized';
% sfunc_analogReadEnergia
analogReadEnergia = legacy_code('initialize');
analogReadEnergia.SFunctionName = 'sfunc_analogReadEnergia';
analogReadEnergia.HeaderFiles = {'gpioEnergia.h'};
analogReadEnergia.SourceFiles = {'gpioEnergia.c'};
analogReadEnergia.OutputFcnSpec = 'uint16 y1 = analogReadEnergia(uint8 u1)';
analogReadEnergia.SampleTime = 'parameterized';
% sfunc_analogWriteEnergia
analogWriteEnergia = legacy_code('initialize');
analogWriteEnergia.SFunctionName = 'sfunc_analogWriteEnergia';
analogWriteEnergia.HeaderFiles = {'gpioEnergia.h'};
analogWriteEnergia.SourceFiles = {'gpioEnergia.c'};
analogWriteEnergia.OutputFcnSpec = 'analogWriteEnergia(uint8 u1, uint8 u2)';
analogWriteEnergia.SampleTime = 'parameterized';
% sfunc_udpReadEnergia
udpReadEnergia = legacy_code('initialize');
udpReadEnergia.SFunctionName = 'sfunc_udpReadEnergia';
udpReadEnergia.HeaderFiles = {'ethernetEnergia.h'};
udpReadEnergia.SourceFiles = {'ethernetEnergia.c'};
udpReadEnergia.OutputFcnSpec = 'int32 y1 = udpReadEnergia(uint8 y2[p2], uint32 p1, uint16 p2)';
udpReadEnergia.SampleTime = 'parameterized';
% sfunc_udpWriteEnergia
udpWriteEnergia = legacy_code('initialize');
udpWriteEnergia.SFunctionName = 'sfunc_udpWriteEnergia';
udpWriteEnergia.HeaderFiles = {'ethernetEnergia.h'};
udpWriteEnergia.SourceFiles = {'ethernetEnergia.c'};
udpWriteEnergia.OutputFcnSpec = 'udpWriteEnergia(uint8 u1[], uint32 u2, uint32 p1, uint32 p2, uint8 p3, uint8 p4, uint8 p5 uint8 p6)';
udpWriteEnergia.SampleTime = 'parameterized';


% Add all definitions together
defs = [digitalReadEnergia(:)];
defs(end+1) = digitalWriteEnergia(:);
defs(end+1) = analogReadEnergia(:);
defs(end+1) = analogWriteEnergia(:);
defs(end+1) = udpReadEnergia(:);
defs(end+1) = udpWriteEnergia(:);
% Generate Blocks using legacy
legacy_code('sfcn_cmex_generate', defs);
legacy_code('compile', defs);
%legacy_code('slblock_generate', udpReadEnergia);
legacy_code('sfcn_tlc_generate', defs);


% Copy all generates files to blocks/mex/... folder
fPath = fullfile(path);
fNames = dir( fullfile(fPath,'sfunc_*'));
fNames = strcat({fNames.name});
% move every file
for i=1:length(fNames)
    tmpFile = fullfile(path, fNames{i});
    dest = fullfile('..', 'mex');
    movefile(tmpFile, dest, 'f');
end
