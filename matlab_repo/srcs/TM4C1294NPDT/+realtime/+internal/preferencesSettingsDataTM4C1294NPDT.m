function info= preferencesSettingsDataTM4C1294NPDT(~) 
 
 info. ParametersGroup= { ...'Build Setting',...
                          'Host-board connection'};%,... 
                          %'Signal monitoring and parameter tuning' } ; 
                          %'Overrun detection' ...
 p1_1. Name= 'Set host COM port:'; 
 p1_1. Type= 'combobox'; 
 p1_1. Enabled= 1; 
 p1_1. Visible= 1; 
 p1_1. Entries= { 'Automatically', 'Manually'} ; 
 p1_1. Value= 0; 
 p1_1. Tag= 'Set_host_COM_port'; 
 p1_1. Data= { } ; 
 p1_1. RowSpan= [ 1, 1] ; 
 p1_1. ColSpan= [ 1, 2] ; 
 p1_1. Alignment= 0; 
 p1_1. DialogRefresh= 1; 
 p1_1. Storage= ''; 
 p1_1. DoNotStore= false; 

 p1_2. Name= 'COM port number:'; 
 p1_2. Type= 'edit'; 
 p1_2. Enabled= 1; 
 p1_2. Visible= 'hObj.TargetExtensionData.Set_host_COM_port==1'; 
 p1_2. Entries= { } ; 
 p1_2. Value= '1'; 
 p1_2. Tag= 'COM_port_number'; 
 p1_2. Data= { } ; 
 p1_2. RowSpan= [ 2, 2] ; 
 p1_2. ColSpan= [ 1, 2] ; 
 p1_2. Alignment= 0; 
 p1_2. DialogRefresh= 0; 
 p1_2. Storage= 'realtime.internal.integerScalarCallback(hObj, hDlg, ''COM_port_number'', ''changed'');'; 
 p1_2. DoNotStore= false; 
 %{
 p1_3. Name= 'COM port baud rate:'; 
 p1_3. Type= 'combobox'; 
 p1_3. Enabled= 1; 
 p1_3. Visible= 0; 
 p1_3. Entries= { '300', '1200', '2400', '4800', '9600', '14400', '19200', '28800', '38400', '57600', '76800', '115200', '128000'} ; 
 p1_3. Value= '115200'; 
 p1_3. Tag= 'COM_port_baud_rate'; 
 p1_3. Data= { } ; 
 p1_3. RowSpan= [ 3, 3] ; 
 p1_3. ColSpan= [ 1, 2] ; 
 p1_3. Alignment= 0; 
 p1_3. DialogRefresh= 0; 
 p1_3. Storage= 'realtime.internal.arduinoCOMPortBaudRateCallback(hObj, hDlg, ''COM_port_baud_rate'', ''changed'');'; 
 p1_3. DoNotStore= false; 
 %}
%  p2_1. Name= 'Enable External mode'; 
%  p2_1. Type= 'checkbox'; 
%  p2_1. Enabled= 1; 
%  p2_1. Visible= 1; 
%  p2_1. Entries= { } ; 
%  p2_1. Value= '';%realtime.extModeCallback(hObj, hDlg, ''Enable_external_mode'', ''init'');'; 
%  p2_1. Tag= 'Enable_external_mode'; 
%  p2_1. Data= { } ; 
%  p2_1. RowSpan= [ 4, 4] ; 
%  p2_1. ColSpan= [ 1, 2] ; 
%  p2_1. Alignment= 0; 
%  p2_1. DialogRefresh= 1; 
%  p2_1. Storage= '';%realtime.extModeCallback(hObj, hDlg, ''Enable_external_mode'', ''changed'');'; 
%  p2_1. DoNotStore= true; 
%{
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
 p3_2. Value= '13'; 
 p3_2. Tag= 'Digital_output_to_set_on_overrun'; 
 p3_2. Data= { } ; 
 p3_2. RowSpan= [ 6, 6] ; 
 p3_2. ColSpan= [ 1, 2] ; 
 p3_2. Alignment= 0; 
 p3_2. DialogRefresh= 0; 
 p3_2. Storage= 'realtime.internal.integerScalarCallback(hObj, hDlg, ''Digital_output_to_set_on_overrun'', ''changed'');'; 
 p3_2. DoNotStore= false; 
 %}
 info. Parameters= { } ; 
 %info. Parameters{ 2} { 1} = p2_1; 
 info. Parameters{ 1} { 1} = p1_1; 
 info. Parameters{ 1} { 2} = p1_2; 
 %info. Parameters{ 1} { 3} = p1_3; 
 %info. Parameters{ 2} { 1} = p2_1; 
 %info. Parameters{ 3} { 1} = p3_1; 
 %info. Parameters{ 3} { 2} = p3_2; 
 
 end 
 
