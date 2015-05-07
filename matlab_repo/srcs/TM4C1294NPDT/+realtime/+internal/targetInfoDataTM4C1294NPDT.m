function info= targetInfoDataTM4C1294NPDT(~)

%cominfo = realtime.internal.getTM4C1294NPDTInfo('COMPORT');


%disp(get_param( 'TM4C1294XL_test', 'EXTMode'));
%set_param( 'TM4C1294XL_test', 'EXTMode', 'on');

info. ProdHWDeviceType= 'ARM Compatible->ARM Cortex';

info. ExtModeTrigDuration= 2;
info. ExtModeConnectPause= 1;

info. ExtModeTransport= 3;
info. ExtModeMexArgsInit= ['0 '  'COM12 '  '115200'];

%info. ExtModeTransport= 3;
%info. ExtModeMexArgsInit= ['0 ' cominfo.COMPortNumber ' ' '256000'];%cominfo.UploadRate]; 

info. RTTParams= i_getRTTParams(info.ExtModeTransport);

end


function rttparams= i_getRTTParams(mode)
rttparams=  ...
    {
    'ExtModeTransport', mode, mode;
%    'SolverMode','MultiTasking','MultiTasking'
    'SolverMode','SingleTasking',{'SingleTasking', 'MultiTasking'}
    } ;

end