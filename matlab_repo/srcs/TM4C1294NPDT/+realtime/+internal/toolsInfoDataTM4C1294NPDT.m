function info= toolsInfoDataTM4C1294NPDT( ~ )

% Check if Preferences are not set and setup RTT..
if isequal(ispref('TM4C1294NPDT'),0)
    realtime.setup.internal.TM4C1294NPDT_installer;
end
    
hPkgInfo = hwconnectinstaller.PackageInfo;
spPkg = hPkgInfo.getSpPkgInfo( 'TM4C1294NPDT' );

% Basic Setup
info.IncludePathDelimiter= '-I';
info.PreprocSymbolDelimiter= '-D';
info.RTIOStreamFileName = 'rtiostream_serial.cpp';
info.RTIOStreamFilePath = fullfile( spPkg.RootDir, 'src' );
info.SetExtModeSettings = '@realtime.internal.TM4C1294NPDTSetExtModeSettings';
info.PreBuildUtility= '@realtime.internal.TM4C1294NPDTPreBuild';
info.BuildUtility= '';
info.PreDownloadUtility= '@realtime.internal.TM4C1294NPDTPreDownload';
info.PreDownloadUtilityFlags= '';
info.PreDownloadFileExtension= '';
info.DownloadUtility= ''; %path to download utility
info.DownloadUtilityFlags= ''; %???
info.DownloadFileExtension= '.out';
info.PostDownloadUtility= '';
info.PostDownloadUtilityFlags= '';
info.PostDownloadFileExtension= '';
info.RunUtility= '';
info.RunUtilityFlags= '';
info.RunFileExtension= '';
info.PostRunUtility= '';
info.RunOnEntry= 'realtime.internal.TM4C1294NPDT_build_init';
info.ErrorHandling= '';
info.XMakefileTemplate = 'gmake';
info.XMakefileConfiguration = 'TM4C1294NPDT';
info.XMakefileTemplateLocation = fullfile(  ...
    realtime.internal.getTM4C1294NPDTInfo('PackageDir'), 'registry' );
end