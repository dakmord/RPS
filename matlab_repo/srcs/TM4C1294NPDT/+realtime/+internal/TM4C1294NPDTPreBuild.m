function TM4C1294NPDTPreBuild( hObj, automationHandle, projectBuildInfo, mdlName) %#ok<INUSL>

disp(['### Building binary file of ', mdlName, ' for TM4C1294NPDT LaunchPad...']);

% Generate Custom core.a library for energia and custom libs (e.g. ethernet)

if isequal( get_param( mdlName, 'ExtMode') , 'off')
    return
else
    disp('EXTERNAL MODE1');
    if isequal( get_param( mdlName, 'ExtModeTransport' ), 4 )
        disp('EXTERNAL MODE2S');
        projectBuildInfo.mBuildInfo.addDefines( 'EXT_MODE=1') ;
        projectBuildInfo.mBuildInfo.addDefines( 'EXIT_FAILURE=1') ;
        projectBuildInfo.mBuildInfo.addDefines( 'EXTMODE_DISABLEPRINTF') ;
        projectBuildInfo.mBuildInfo.addDefines( 'EXTMODE_DISABLETESTING' );
        projectBuildInfo.mBuildInfo.addDefines( 'EXTMODE_DISABLE_ARGS_PROCESSING=1' );

        extModeSources{ 3} = 'ext_work.c';
        extModeSources{ 2} = 'updown.c';
        extModeSources{ 1} = 'ext_svr.c';
        extModePaths( 1: length( extModeSources) ) = { fullfile( matlabroot, 'rtw', 'c', 'src', 'ext_mode', 'common') } ;
        projectBuildInfo.mBuildInfo.addSourceFiles( extModeSources, extModePaths) ;
        extModeSources{ 3} = 'ext_serial_pkt.c';
        extModeSources{ 2} = 'rtiostream_serial_interface.c';
        extModeSources{ 1} = 'ext_svr_serial_transport.c';
        extModePaths( 1: length( extModeSources) ) = { fullfile( matlabroot, 'rtw', 'c', 'src', 'ext_mode', 'serial') } ;
        projectBuildInfo.mBuildInfo.addSourceFiles( extModeSources, extModePaths) ;

        str= fullfile( realtime.internal.getTM4C1294NPDTInfo('PackageDir'), 'src') ;
        projectBuildInfo.mBuildInfo.addSourceFiles( 'rtiostream_serial.cpp', str) ;
        projectBuildInfo.mBuildInfo.addIncludePaths( fullfile( matlabroot, 'rtw', 'c', 'src', 'ext_mode', 'serial') ) ;

        automationHandle.emitProject( projectBuildInfo) ;
    end

end

%{
dirtyState= get_param( mdlName, 'dirty') ;

tgtData= get_param( mdlName, 'TargetExtensionData') ;
if isAutoExtModeOverSerialEnabled( mdlName)
    portInfo= realtime.internal.getTM4C1294NPDTInfo('COMPORT');
    if ~ isempty( portInfo)
        arg= sprintf( '0 %s %s', strrep( portInfo.COMPort, 'COM', '') ,  ...
            portInfo.UploadRate) ;
        set_param( mdlName, 'ExtModeMexArgs', arg) ;
    end
else
    arg= sprintf( '0 %s %s', tgtData.COM_port_number,  ...
        tgtData.COM_port_baud_rate) ;
end

set_param( mdlName, 'ExtModeMexArgs', arg) ;


% recover dirty bit
set_param( mdlName, 'dirty', dirtyState) ;
%}
end

%{
function ret= isAutoExtModeOverSerialEnabled( modelName)
ret= ( get_param( modelName, 'ExtModeTransport') == 1) ||  ...
    ( get_param( modelName, 'ExtModeTransport') == 2) ||  ...
    ( get_param( modelName, 'ExtModeTransport') == 3) ;
if ret
    val= get_param( modelName, 'TargetExtensionData') ;
    ret= isequal( val.Set_host_COM_port, 0) ;
end
end
%}