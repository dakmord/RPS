function info= targetSettingsDataTM4C1294NPDT(~) 
% UI callback

 %{
 p1_1. Name= 'Analog input reference voltage:'; 
 p1_1. Type= 'combobox'; 
 p1_1. Enabled= 1; 
 p1_1. Visible= 1; 
 p1_1. Entries= { 'Default', 'Internal (1.5 V)', 'Internal (2.5 V)', 'External'} ; 
 p1_1. Value= 0; 
 p1_1. Tag= 'Analog_input_reference_voltage'; 
 p1_1. Data= { } ; 
 p1_1. RowSpan= [ 1, 1] ; 
 p1_1. ColSpan= [ 1, 2] ; 
 p1_1. Alignment= 0; 
 p1_1. DialogRefresh= 1; 
 p1_1. Storage= ''; 
 p1_1. DoNotStore= false; 
 %}
 p2_1. Name= 'Serial 0 baud rate:'; 
 p2_1. Type= 'combobox'; 
 p2_1. Enabled= 1; 
 p2_1. Visible= 1; 
 p2_1. Entries= { '300', '1200', '2400', '4800', '9600', '14400', '19200', '28800', '38400', '57600', '76800', '115200', '230400', '500000', '1000000'} ; 
 p2_1. Value= '9600'; 
 p2_1. Tag= 'Serial0_baud_rate'; 
 p2_1. Data= { } ; 
 p2_1. RowSpan= [ 2, 2] ; 
 p2_1. ColSpan= [ 1, 2] ; 
 p2_1. Alignment= 0; 
 p2_1. DialogRefresh= 0; 
 p2_1. Storage= 'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial0_baud_rate'', ''changed'');'; 
 p2_1. DoNotStore= false; 
 
 p3_1. Name= 'Enable overrun detection'; 
 p3_1. Type= 'checkbox'; 
 p3_1. Enabled= 1; 
 p3_1. Visible= 1; 
 p3_1. Entries= { } ; 
 p3_1. Value= 0; 
 p3_1. Tag= 'Enable_overrun_detection'; 
 p3_1. Data= { } ; 
 p3_1. RowSpan= [ 5, 5] ; 
 p3_1. ColSpan= [ 1, 2] ; 
 p3_1. Alignment= 0; 
 p3_1. DialogRefresh= 1; 
 p3_1. Storage= ''; 
 p3_1. DoNotStore= false; 
 
 p3_2. Name= 'Digital output to set on overrun:'; 
 p3_2. Type= 'edit'; 
 p3_2. Enabled= 1; 
 p3_2. Visible= 'hObj.TargetExtensionData.Enable_overrun_detection==1'; 
 p3_2. Entries= { } ; 
 p3_2. Value= '84'; 
 p3_2. Tag= 'Digital_output_to_set_on_overrun'; 
 p3_2. Data= { } ; 
 p3_2. RowSpan= [ 6, 6] ; 
 p3_2. ColSpan= [ 1, 2] ; 
 p3_2. Alignment= 0; 
 p3_2. DialogRefresh= 0; 
 p3_2. Storage= 'realtime.internal.integerScalarCallback(hObj, hDlg, ''Digital_output_to_set_on_overrun'', ''changed'');'; 
 p3_2. DoNotStore= false; 
 %{
 p2_2. Name= 'Serial 1 baud rate:'; 
 p2_2. Type= 'combobox'; 
 p2_2. Enabled= 1; 
 p2_2. Visible= 1; 
 p2_2. Entries= { '300', '1200', '2400', '4800', '9600', '14400', '19200', '28800', '38400', '57600', '76800', '115200', '230400', '500000', '1000000'} ; 
 p2_2. Value= '9600'; 
 p2_2. Tag= 'Serial1_baud_rate'; 
 p2_2. Data= { } ; 
 p2_2. RowSpan= [ 3, 3] ; 
 p2_2. ColSpan= [ 1, 2] ; 
 p2_2. Alignment= 0; 
 p2_2. DialogRefresh= 0; 
 p2_2. Storage= 'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial1_baud_rate'', ''changed'');'; 
 p2_2. DoNotStore= false; 
 
 p2_3. Name= 'Serial 2 baud rate:'; 
 p2_3. Type= 'combobox'; 
 p2_3. Enabled= 1; 
 p2_3. Visible= 1; 
 p2_3. Entries= { '300', '1200', '2400', '4800', '9600', '14400', '19200', '28800', '38400', '57600', '76800', '115200', '230400', '500000', '1000000'} ; 
 p2_3. Value= '9600'; 
 p2_3. Tag= 'Serial2_baud_rate'; 
 p2_3. Data= { } ; 
 p2_3. RowSpan= [ 4, 4] ; 
 p2_3. ColSpan= [ 1, 2] ; 
 p2_3. Alignment= 0; 
 p2_3. DialogRefresh= 0; 
 p2_3. Storage= 'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial2_baud_rate'', ''changed'');'; 
 p2_3. DoNotStore= false; 
 
 p2_4. Name= 'Serial 3 baud rate:'; 
 p2_4. Type= 'combobox'; 
 p2_4. Enabled= 1; 
 p2_4. Visible= 1; 
 p2_4. Entries= { '300', '1200', '2400', '4800', '9600', '14400', '19200', '28800', '38400', '57600', '76800', '115200', '230400', '500000', '1000000'} ; 
 p2_4. Value= '9600'; 
 p2_4. Tag= 'Serial3_baud_rate'; 
 p2_4. Data= { } ; 
 p2_4. RowSpan= [ 5, 5] ; 
 p2_4. ColSpan= [ 1, 2] ; 
 p2_4. Alignment= 0; 
 p2_4. DialogRefresh= 0; 
 p2_4. Storage= 'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial3_baud_rate'', ''changed'');'; 
 p2_4. DoNotStore= false; 
 
 
 info. ParametersGroup= { 'Arduino analog input channel properties', ...
                          'Arduino serial port properties'} ; 
 info. Parameters= { } ; 
 info. Parameters{ 1} { 1} = p1_1; 
 info. Parameters{ 2} { 1} = p2_1; 
 info. Parameters{ 2} { 2} = p2_2; 
 info. Parameters{ 2} { 3} = p2_3; 
 info. Parameters{ 2} { 4} = p2_4; 


 p1_1. Name= 'Setting A-1:'; 
 p1_1. Type= 'combobox'; 
 p1_1. Enabled= 1; 
 p1_1. Visible= 1; 
 p1_1. Entries= { 'A','B','C','D'} ; 
 p1_1. Value= 0; 
 p1_1. Tag= 'setting_a_1'; 
 p1_1. Data= { } ; 
 p1_1. RowSpan= [ 1, 1] ; 
 p1_1. ColSpan= [ 1, 2] ; 
 p1_1. Alignment= 0; 
 p1_1. DialogRefresh= 1; 
 p1_1. Storage= ''; 
 p1_1. DoNotStore= false; 
 %}
 p4_1. Name= 'Board IP-Adress:'; 
 p4_1. Type= 'edit'; 
 p4_1. Enabled= 1; 
 p4_1. Visible= 1; 
 p4_1. Entries= {} ; 
 p4_1. Value= '192.168.0.70'; 
 p4_1. Tag= 'ip_address'; 
 p4_1. Data= { } ; 
 p4_1. RowSpan= [ 2, 2] ; 
 p4_1. ColSpan= [ 1, 2] ; 
 p4_1. Alignment= 0; 
 p4_1. DialogRefresh= 0; 
 p4_1. Storage= '';%'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial0_baud_rate'', ''changed'');'; 
 p4_1. DoNotStore= false; 
 
 p4_2. Name= 'MAC-Adress:'; 
 p4_2. Type= 'edit'; 
 p4_2. Enabled= 1; 
 p4_2. Visible= 1; 
 p4_2. Entries= {} ; 
 p4_2. Value= '00:1A:B6:02:BB:1C'; 
 p4_2. Tag= 'mac_address'; 
 p4_2. Data= { } ; 
 p4_2. RowSpan= [ 3, 3] ; 
 p4_2. ColSpan= [ 1, 2] ; 
 p4_2. Alignment= 0; 
 p4_2. DialogRefresh= 0; 
 p4_2. Storage= '';%'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''Serial0_baud_rate'', ''changed'');'; 
 p4_2. DoNotStore= false;
 
 
 info. ParametersGroup= { ...'Analog Input Reference', ...
                          'Serial 0 Baudrate', ...
                          'Overrun Detection', ...
                          'Ethernet Setup'} ; 
 info. Parameters= { } ; 
 %info. Parameters{ 1} { 1} = p1_1; 
 info. Parameters{ 1} { 1} = p2_1; 
 info. Parameters{ 2} { 1} = p3_1; 
 info. Parameters{ 2} { 2} = p3_2; 
 info. Parameters{ 3} { 1} = p4_1;
 info. Parameters{ 3} { 2} = p4_2;
 end 
