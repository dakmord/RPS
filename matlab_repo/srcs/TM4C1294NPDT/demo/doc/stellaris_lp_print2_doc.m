%% Using Advanced Debug Print Block 
%
% This example demonstrate the usage of the Advanced Debug Print block.
%

%% Introduction
%
% Advanced Debug Print block in the Stellaris/Tiva Launchpad Support
% Package enables runtime data output as system status report or for
% debugging purpose. The limitation of the original Debug Print block (now
% obsoleted) is that it only supports maximum of 4 int32 inputs. The
% Advanced Debug Print block supports arbitrary number of integer of
% various size and both single and double precision float-point numbers.
% The input port also accept scalar, vector or matrix of any data type. 
% These newly added features helps to make nicer printed messages.
%

realtime.internal.runStellarisLPCmd('opendemo','print2');

%% Demo
%
% A demo is made to shows how to use the Advanced Debug Print block to print
% data collected from onboard A/D converter. Click <matlab:realtime.internal.runStellarisLPCmd('opendemo','print2')  here>
% to open the simulink diagram. 
%
% Four A/D channels are used in this demo. Channel 1 and 2 are setup so
% that they output raw A/D converter readings, while outputs of channel 3 and 4
% are scaled properly according to chip user manual to have unit of volt.
% Data types of channel 1 and 2 output are both _uint32_. Channel 3 and 4 output
% data in float-point number and will adapt to the request data type from
% downstream blocks. 
%
% The Advanced Debug Print block is configured so that it has three input
% ports, requesting data type of _uint32_, _single_ and _double_,
% respectively. Data from channel 1 and 2 are muxed to form a 2x1 vector
% and fed into the first input port of Advanced Debug Print block. A/D
% converter channel 3 and 4 outputs are connected directly to input port 2
% and 3 of the Advanced Debug Print block. The format string set the format
% of the output text and is explained section by section.
% 
% * "AD1 Raw=%4u" corresponds to first element of data from input port
% 1, which is the data from AD channel 1. It is printed as unsigned 32bit
% integer with 4 reserved spaces.
%
% * "AD2 Raw=%04u" corresponds to second element of data from input port
% 1, which is the data from AD channel 2. It is printed as unsigned 32bit
% integer with 4 reserved spaces, but the unused space is filled with 0.
%
% * "AD3=%-7.3hf_V" corresponds to data from input port 2, which is the
% data from AD channel 3. It is printed as single precision float number
% (hf) with 7 reserved spaces and 3 digits after decimal point. The '-'
% denotes this field will be left adjusted.
%
% * "AD4=%09.5f V" corresponds to data from input
% port 4, which is the data from AD channel 4. It is printed as double
% precision float number (hf) with 9 reserved spaces and 5 digits. 
%
% * "\r\n" This force the message to change line every time it is printed.
% Unlike the old Debug Print block, the Advanced Debug Print block no
% longer automatically append carriage return and line feed symbols to the
% format string. If a new line is desired for each message, please add
% escaped end-of-line symbols (\r\n) manually in the format string.
% Moreover, other escape sequence of characters defined by MATLAB 
% <matlab:eval('help sprintf') sprintf> 
% function is also supported. 
%
% The sample time of this block is set to -1, which inherited the base 
% sample time 0.1 sec, or 100ms.
% 
% An additional Running Indicator block is included to display random
% colors at the LED on the launchpad during execution to indicate running
% status and add a bit of fun factor to this demo.
%

%% Experiment 
% 
% To experiment with this demo, first, with Stellaris Launchpad connected
% to PC, start the communication server by click
% <matlab:realtime.internal.runStellarisLPCmd('runcommsvr') here> or run the
% following command.
%
%   realtime.internal.runStellarisLPCmd('runcommsvr')
% 
% A command line window should appear with the following message show up.
% If you cannot see this message, please check connection of launchpad and
% communication server settings following the Host-Target Communication
% Tutorial slides. 
%
% *|Open serial COM7 at 1000000 bps|*
%
% *|Open port 0 in TCP mode (AutoReset=1)|*
%
% *|Open port 1 in TCP mode (AutoReset=0)|*
%
% *|Intialization Finished|*
% 
% Then, build the model. Once it is successfully built, two flashes of on
% the Stellaris Launchpad indicates the binary is downloaded and the
% Stelleris Launchpad is reset. A message  *|"Physical Com port synced!"|*
% will show up in the communication server command line window.
%
% Now, connect your preferred termial, such as putty or realterm, to
% localhost:12201 to view print out from the Stellaris Launchpad. Here is a
% screen shot of what is observed, which shows data is printed out in
% expected format. Note that nothing is connected to the physical AD
% converter pins during test, and the data shown are due to noise.
% 
% <<stellaris_lp_print2_putty.PNG>>
% 
% 

%% Conclusion
% 
% This demos shows how to use the Advanced Debug Print block to print data
% to a console. Parameters of this block are explained and the result are
% shown in screenshot to show this block works as expected.
%

%% See Also
% <matlab:realtime.internal.runStellarisLPCmd('opendemo','adc') Using Advanced Debug Print Block>

close_system('stellaris_lp_print2', 0); 
displayEndOfDemoMessage(mfilename) 

