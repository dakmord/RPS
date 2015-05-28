function blkStruct = slblocks
% SLBLOCKS Defines the block library for Arduino

%   Copyright 2012 The MathWorks, Inc.

blkStruct.Name = sprintf('Rapid-Prototyping-System');
blkStruct.OpenFcn = 'rpsrootlib';%'arduinorootlib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''RPS'')';

Browser(1).Library = 'rpsrootlib';
Browser(1).Name    = sprintf('Rapid-Prototyping-System');
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;  

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @ecblksUpdateModel;
 
% LocalWords:  Uno arduinolib
