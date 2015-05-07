function sl_customization( cm)
% the first four is just to make it compatible with original realtime
% toolbox
test=0;
if(test==1)
    cm.ExtModeTransports.add('realtime.tlc', 'tcpip', 'ext_comm', 'Level1') ;
    cm.ExtModeTransports.add('realtime.tlc', 'serial_byteswap', 'ext_serial_win32_comm_no_acks_rtt_byteswap', 'Level1') ;
    cm.ExtModeTransports.add('realtime.tlc', 'serial', 'ext_serial_win32_comm_no_acks_rtt', 'Level1') ;
    cm.ExtModeTransports.add('realtime.tlc', 'serial_arduino', 'ext_serial_win32_comm', 'Level1') ;
% this added one send serial like package via 
    cm.ExtModeTransports.add('realtime.tlc', 'serial_TM4C1294XL', 'ext_serial_win32_comm', 'Level1') ; %mp
    cm.ExtModeTransports.add('realtime.tlc', 'serial_MP', 'ext_serial_win32_mp_comm', 'Level1') ; %mp
end
end
