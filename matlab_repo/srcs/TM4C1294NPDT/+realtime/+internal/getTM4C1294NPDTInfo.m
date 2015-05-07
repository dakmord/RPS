function info = getTM4C1294NPDTInfo( name)
switch(name)
    case 'ctype_name'
        info = 'TM4C1294NPDT';
    case 'CTypeName'
        info = 'TM4C1294NPDT';
    case 'Package Name'
        info = 'TM4C1294NPDT';
    case 'COMPORT'
        info.COMPort    = getpref('TM4C1294NPDT','COMPort'); %'COM11';
        info.COMPortNumber = num2str(sscanf(info.COMPort,'COM%d')); %'11';
        info.UploadRate = '115200';
    case 'PackageDir'
        hPkgInfo = realtime.internal.getTM4C1294NPDTInfo('PkgInfo');
        spPkg  = hPkgInfo.getSpPkgInfo('TM4C1294NPDT');
        info = spPkg.RootDir;
    case 'TivaWareDir'
        info = getpref('TM4C1294NPDT','TivaWareDir'); 
    case 'TM4C1294NPDT'
        info = getpref('TM4C1294NPDT','TM4C1294NPDT');
    case 'EnergiaHome'
        info = getpref('TM4C1294NPDT','EnergiaHome');
    case 'toolsDir'
        compilerDir = getpref('TM4C1294NPDT','toolsDir');
        info = compilerDir;
    case 'RPS_Dir'
        info = getpref('RapidPrototypingSystem','HomeDir');
    case 'BlockSrcIncInfo'
        info = realtime.internal.rtwmakecfgTM4C1294NPDT();
    case 'PkgInfo'
        matlab_ver = ver('matlab');
        ver_str = matlab_ver.Version;
        switch (ver_str)
            case {'8.0', '8.1', '8.2', '8.3', '8.4'} %(2012b) - (2014b)
                info = hwconnectinstaller.PackageInfo;
            case '7.14' %(2012a)
                info = realtime.setup.PackageInfo; 
            otherwise
                error('Matlab version not supported. Supported version includes 2012a/b 2013a');
        end
    otherwise 
        info = [];
end
end