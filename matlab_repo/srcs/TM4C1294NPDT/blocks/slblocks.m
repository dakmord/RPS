function blkStruct = slblocks
% SLBLOCKS Defines the block library for TM4C1294NPDT

%   Copyright 2012 The MathWorks, Inc.

blkStruct.Name = sprintf('Run on TM4C1294NPDT Launchpad');
blkStruct.OpenFcn = '';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''TM4C1294NPDT'')';

Browser(1).Library = 'tm4c1294npdt';
Browser(1).Name    = sprintf('Run on TM4C1294NPDT Launchpad');
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;  

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @ecblksUpdateModel;
 
% LocalWords:  Uno arduinolib