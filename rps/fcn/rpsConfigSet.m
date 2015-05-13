%---------------------------------------------------------------------------
%  MATLAB function for configuration set generated on 12-May-2015 13:13:28
%  MATLAB version: 8.2.0.701 (R2013b)
%---------------------------------------------------------------------------

function cs=rpsConfigSet(model)
cs= getActiveConfigSet(model);
cs = attachConfigSetCopy(model, cs, 1);
%cs = Simulink.ConfigSet;
 
% Original configuration set version: 1.13.1
if cs.versionCompare('1.13.1') < 0
    error('Simulink:MFileVersionViolation', 'The version of the target configuration set is older than the original configuration set.');
end
 
% Original environment character encoding: windows-1252
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'windows-1252')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',  get_param(0, 'CharacterEncoding'), 'windows-1252');
end
 
% Do not change the order of the following commands. There are dependencies between the parameters.
RealTime_SettingsController_Successful=true;
try
   componentCC = RealTime.SettingsController;
   cs.attachComponent(componentCC);
catch ME
   warning('Simulink:ConfigSet:AttachComponentError', ME.message);
   RealTime_SettingsController_Successful=false;
end

targetSwitchSuccessful = true;
try
   cs.set_param('SystemTargetFile', 'realtime.tlc');   % System target file
catch ME
   cs.set_param('SystemTargetFile', 'ert.tlc');
   disp(ME.message);
   disp('Setting ''System target file'' to ''ert.tlc''.');
   targetSwitchSuccessful = false;
end


% The following commands do not have dependencies.
cs.set_param('Description', '');  % Description
cs.set_param('Name', 'RapidPrototypingSystem_Configuration');  % Name

% Code Generation:Custom Code pane
cs.set_param('CustomHeaderCode', '');   % Header file 
cs.set_param('CustomInclude', sprintf('%s\n%s','C:\Users\q365198\Desktop\legacyTest\ ','C:\Users\q365198\Desktop\'));   % Include directories 
cs.set_param('CustomInitializer', '');   % Initialize function 
cs.set_param('CustomLibrary', '');   % Libraries 
cs.set_param('CustomSource', '');   % Source files 
cs.set_param('CustomSourceCode', '');   % Source file 
cs.set_param('CustomTerminator', '');   % Terminate function 
cs.set_param('RTWUseSimCustomCode', 'off');   % Use the same custom code settings as Simulation Target 

setActiveConfigSet(model, cs.get_param('Name'));
