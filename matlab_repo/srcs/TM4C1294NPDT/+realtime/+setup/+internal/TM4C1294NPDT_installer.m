function ret = TM4C1294NPDT_installer ()
    ret = i_TM4C1294NPDT_setup;
end

function ret = i_TM4C1294NPDT_setup
    pref_group = 'TM4C1294NPDT';
    % Setup COM-Ports
    [COMPort, flag] = setup_com_port;
    ret = flag;
    setpref(pref_group,'COMPort',COMPort);
    % Get Package Install Dir
    hPkgInfo = realtime.internal.getTM4C1294NPDTInfo('PkgInfo');
    spPkg  = hPkgInfo.getSpPkgInfo('TM4C1294NPDT');
    spPkgInstallDir = spPkg.InstallDir;
    % Set Local Preferences
    EnergiaHome = fullfile(spPkgInstallDir, 'energia-0101E0014');
    setpref(pref_group,'EnergiaHome',EnergiaHome);
    setpref(pref_group,'toolsDir',fullfile(EnergiaHome, 'hardware', 'tools', 'lm4f', 'bin'));
    setpref(pref_group,'TivaWareDir',fullfile(EnergiaHome,'hardware','lm4f', 'cores', 'lm4f'));
    setpref(pref_group,'TM4C1294NPDT',fullfile(EnergiaHome,'hardware','lm4f', 'variants', 'launchpad_129'));
end

function [COMPort, flag] = setup_com_port()
    COMPort = '';
    [ports, names] = find_com_ports;

    [x,y] = size(names);
    for i=1:y
       startIndex = regexp(names(1,i),'Stellaris Virtual Serial Port');
       if cell2mat(startIndex) ~= 0
          COMPort = char(ports{i});
          flag = 1;
       end
    end
    if isempty(COMPort)
       disp('empty'); 
       disp(' ### Error: Could not resolve correct COMPort for "Stellaris Virtual Serial Port"');
       disp(' ### Using standard COMPort: "COM10"');
       disp(' ### -> Maybe COM-Driver is not installed. This can lead to flashing problems!')
       COMPort = 'COM10';
       flag = 0;
    end
end

function [ports, names] = find_com_ports()
%Find COM ports
if isunix
    %TODO
	%check /dev/serial
	unixCmd = 'ls -l /dev/serial/by-id/*';
	[unixCmdStatus,unixCmdOutput]=system(unixCmd);
	if (unixCmdStatus > 0)
		ports = {};
		names = {};
    else
		[names, ports] = regexp(unixCmdOutput,'(?<=/dev/serial/by-id/)\S.*?((?<=->.*/)tty\w+)','match','tokens');
	end
else
    wmiCmd = ['wmic /namespace:\\root\cimv2 '...
              'path Win32_SerialPort get DeviceID,Name'];
    [~,wmiCmdOutput]=system(wmiCmd);
    [names, ports] = regexp(wmiCmdOutput,'(?<=COM\d+\s*)\S.*?\((COM\d+)\)','match','tokens');
end
names = [names];
end
