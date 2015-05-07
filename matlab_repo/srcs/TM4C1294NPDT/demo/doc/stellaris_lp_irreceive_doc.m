%% Build an IR (Infra-Red) Remote Receiver Using Stateflow
%
% This example demonstrate how to use the Stateflow to build an IR remote 
% receiver. The receiver is build entirely using Stateflow, commonly used
% MATLAB blocks and blocks in the Stellaris Hardware Support package.
%

%% Introduction
% 
% The Stellaris/TivaC board packs decent computational power for embedded
% application but does not offer enough input (only two simple push buttons) for many applications.
% Beside sparinig out many I/O pins and a lot of wiring effort, this
% problem can be solved using IR remote. Many home entertainment devices 
% come with a remote with decent quality and design. It is entirely
% possible that you have some old remote lying around after retirement of 
% VCRs, VCDs, tube TVs. If not, a universal remote only sales for a few
% bucks these days. Together with a cheap IR receiver chip (less than $1), the 
% IR remote effectively works as a fancy wireless controller for any
% project you made with Stellaris/TivaC.
%
% <<stellaris_lp_irreceive_doc_system.jpg>>

%% Demo
% 
% In order to use the demo, you need to first figure out two properties of 
% the remote you are using. First is the modulation frequency. This
% frequency decide the IR receiver chip you are buying. The most common
% choice is 38KHz, but you might want to confirm that. The IR receiver
% chip is usually a 3 pin device (VCC, GND, OUT) that
%  tranforms IR signal into electrical signal and then demodulate it to
% base band. IR diode only do the former part and cannot be directly used in 
% this demo. The second property is
% the protocol the remote uses. The protocol includes definition of the bit
% encoding as well as frame format. 
%
% This demo encompasses the following protocols:
% NEC, RC-5, SONY, RCA, which should cover a large portion of devices in
% the market. In case your remote is not support, you can either buy an
% universal remote or modify the demos according to the protocol of your
% own remote. 
%
% To figure out the protocol of a remote uses, you may search online or use
% an oscilloscope or logic analyzer. To do this, connect your IR receiver chip to power
% and probe the output pin and compare the wave form with those in 
% <http://www.sbprojects.com/knowledge/ir/index.php here>.
% Notice that some remote may output similar waveform but with different
% time specs. In this case, you may need to modify the decode Stateflow
% chart to achieve the goal.
% You may also found many valuable information about IR remote in the 
% reference above as well.
%
% In case there is no oscilloscope or logic analyzer available, the TivaC
% board can work as a logic analyzer itself with 
% <http://www.fischl.de/arm/sllogiclogger_logic_analyser_for_stellaris_launchpad/ this project>.
% Since by default the sample frequency is 10MHz, it is necessary to modify
% the source code (insert delay into |dosampling| function in
% sllogiclogger.c) to slow it down to 10-100KHz. Moreover, the cfg file
% need be modified accordingly to show the data in the right time scale (modify the "device.samplerates" setting)..
% 
% After the protocol is determined, open up corresponding model here.
% 
% * <matlab:realtime.internal.runStellarisLPCmd('opendemo','irreceive_NEC') Demo for remote using NEC Protocol>
% * <matlab:realtime.internal.runStellarisLPCmd('opendemo','irreceive_RC5') Demo for remote using RC-5 Protocol>
% * <matlab:realtime.internal.runStellarisLPCmd('opendemo','irreceive_SONY') Demo for remote using SONY Protocol>
% * <matlab:realtime.internal.runStellarisLPCmd('opendemo','irreceive_RCA')  Demo for remote using RCA Protocol>
%
% Connect the IR receiver chip to TivaC board. The output pin should go to 
% PF4 by default. You may choose to use TivaC board to power the receiver
% chip by connecting receiver GND and VCC to the pins on board. VBUS pin on the
% board will supply 5V and the +3.3V pin will supply 3.3V.
%
% The demo will output information about the key being
% pressed using Debug Print block, so it is necessary to open the
% communication server and a terminal program (e.g. putty). The terminal
% program should connect to localhost:12201.
%
% <matlab:realtime.internal.runStellarisLPCmd('runcommsvr') Open Communication Server>
%
% Finally, if everything is checked, double-click the "Double Click to Init Parameter" 
% in diagram to set time step parameter and download the program. After the
% compiling and downloading is finished, try to aim the remote to the
% receiver, press buttons on the remote.
% You will see the red LED on board flashes while you press button, and the
% terminal display messages correponding to the key being pressed.
%
% <<stellaris_lp_irreceive_doc_terminal.png>>

%% Under the hood
%
% In case you want to modify the demo to suit your unsupported remote or
% just curious about how this works. Here is a brief guide. We will use the
% <matlab:realtime.internal.runStellarisLPCmd('opendemo','irreceive_NEC') NEC protocol demo> as an example. 
%

realtime.internal.runStellarisLPCmd('opendemo','irreceive_NEC');
%%
% The "Ir Sensor" sub-system use GPIO read to get the status of the PF4
% pin, which is connected to the IR receiver output. Due to my IR receiver
% output is active low, bit operation is done to invert it, 
% _i.e._ if the output pin on IR
% receiver is low, the "Ir Sensor" sub-system outputs 1 and vice versa. 
% The output is also use to drive the LED status indicator to light the
% LED.
%
open_system('stellaris_lp_irreceive_NEC/Ir Sensor');
%%
% Output the "Ir Sensor" is feed into a state machine for decoding. The
% state machine is programmed using Stateflow. To understand the state
% machine diagram, it is recommended to follow the state transition with
% respect to a frame described in
% <http://www.sbprojects.com/knowledge/ir/nec.php this document>. When a
% full data frame is decoded from the line, the state goes to "OutStage", 
% which signals output "state" to 1 for one tick, by this time, the output
% "frame" should contains the frame data in a 32-bit integer. Temporal
% logic is used for concise representation.
%
open_system('stellaris_lp_irreceive_NEC/NEC BitDecoder')
%%
% Output from the the decoder goes through "LatchLogic" state diagram to
% find if a key is kept pressed. According to the protocol, repeated data
% frame is transmitted if the remote button is kept pressed. 
%
open_system('stellaris_lp_irreceive_NEC/LatchLogic')
%%
% Finally, the output from "LatchLogic" goes to the "Print Output" block
% and a status string is printed using "Debug Print" block. Since the
% status string is printed at a much lower frequency (10 Hz) than the
% decoder (10KHz), rate transition is needed. Bit operation is used to separate data
% fields from 32-bit integer frame.
%
open_system('stellaris_lp_irreceive_NEC/Print Output')
%

%% Application
% 
% To demonstrate how the IR receiver demo can be used in an application. A 
% demo is create to show a IR remote controlled R/C servo. The NEC protocol
% demo is appended with logic to drive a servo motor using PWM output.
%

realtime.internal.runStellarisLPCmd('opendemo','irreceive_servo');

%% Conclusion
% 
% This demo shows how to build an IR remote receiver with TivaC board and a 
% IR receiver chip. Stateflow is used to perform decoding of the base band
% IR remote signal. This demo can be integrated into other diagrams in
% order to act like an input device for a bigger project. Procedures of how
% to use the demo is described and the internal implementation  is
% also briefed.
%

%% References
% 
% # <http://www.sbprojects.com/knowledge/ir/ IR Remote Control Theory>
% # <http://www.vishay.com/docs/80071/dataform.pdf Data Formats for IR Remote Control>
% # <http://techdocs.altium.com/display/FPGA/Infrared+Communication+Concepts Infrared Communication Concepts>
% # <http://www.atmel.com/ja/jp/Images/doc1473.pdf AVR410: RC5 IR Remote Control Receiver>
% # <http://www.fischl.de/arm/sllogiclogger_logic_analyser_for_stellaris_launchpad/ SLLogicLogger - A simple logic analyser for TI Stellaris Launchpad>
% # <http://www.clearwater.com.au/code/rc5 An Efficient Algorithm for Decoding RC5 Remote Control Signals>
%

close_system('stellaris_irreceive_NEC', 0); 
displayEndOfDemoMessage(mfilename) 





