function TM4C1294NPDTSetExtModeSettings( modelName, comPort )
% Beta Version for Setting ExtMode

% Check if extMode on
if isequal( get_param( modelName, 'ExtMode' ), 'off' ) ||  ...
    realtime.isModelRefBuild( modelName )
    disp('### External Mode Off');
    return 
end 

% Check Input Size
if nargin < 2
    comPort = [  ];
end 

% Dirty Mode and Target Extension Data
modelHandle = get_param( modelName, 'Handle' );
origDirty = rtwprivate( 'dirty_restore', modelHandle );
restoreDirtyFlag = onCleanup( @(  )rtwprivate( 'dirty_restore',  ...
modelHandle, origDirty ) );
tgtData = get_param( modelName, 'TargetExtensionData' );

% Check TargetExtensionData -> COM-Port
if isequal( tgtData.( 'Set_host_COM_port' ), 0 )
    comPort = getpref('TM4C1294NPDT', 'COMPort');
end 


setExtModeSettings( modelName, tgtData, comPort );
restoreDirtyFlag.delete;

end 


function setExtModeSettings( modelName, tgtData, comPort )


targetInfo = getTargetInfo( modelName );
set_param( modelName, 'ExtModeTransport', targetInfo.ExtModeTransport );


if isequal( tgtData.( 'Set_host_COM_port' ), 0 )
assert( ~isempty( comPort ), 'portInfo should not be empty' );
    if ispc
        arg = sprintf( '0 %s %s', strrep( comPort, 'COM', '' ),  ...
        tgtData.Serial0_baud_rate );
        disp(arg);
    end
else 
    if ispc
        arg = sprintf( '0 %s %s', tgtData.COM_port_number,  ...
        tgtData.Serial0_baud_rate );
    end
end 
set_param( modelName, 'ExtModeMexArgs', arg );
end 


function targetInfo = getTargetInfo( modelName )
platformName = get_param( modelName, 'TargetExtensionPlatform' );
targetInfo = realtime.TargetInfo(  ...
realtime.getDataFileName( 'targetInfo', platformName ), platformName );

end 