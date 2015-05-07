function info = preferencesDataTM4C1294NPDT(~)
% Get ModelConfiguration Data
tgtData= get_param( bdroot, 'TargetExtensionData') ;

if isequal( tgtData.( 'Set_host_COM_port') , 0)
    % Automatically detect COM port. 
    if isequal(realtime.internal.runTM4C1294NPDTCmd('setup_com'),1)
       % Found correct COMPort
       info = realtime.internal.getTM4C1294NPDTInfo('COMPORT');
    else
        % ERROR cannot find COMPort, use standard manual COMPort...
        info.COMPort= [ 'COM', tgtData.COM_port_number];
        info.COMPortNumber = num2str(tgtData.COM_port_number); %'11';
        info.UploadRate = '115200';
    end
else
    %If MANUAL COM-PORT selected..
    info.COMPort= [ 'COM', tgtData.COM_port_number];
    info.COMPortNumber = num2str(tgtData.COM_port_number);
    info.UploadRate = '115200';
    setpref('TM4C1294NPDT','COMPort',info.COMPort);
end

info.InstallDir= ''; % dir of compiler ??? in arduino it is P:\Libs\Matlab\Targets\arduino-1.0

end
