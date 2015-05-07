function ret = TM4C1294NPDT_build_init(varargin)

% Generate core.a lib in current folder
disp('### Creating Custom Library for TM4C1294NPDT LaunchPad...');
realtime.internal.runTM4C1294NPDTCmd('generateCoreLibrary');
disp(' ### Done creating ..\libs\core.a');

%rtw.targetNeedsCodeGen( 'set', true) ;
h = varargin{1};
set_param( h.ModelName, 'ObfuscateCode', '0' ); % force it not to ObfuscateCode
%set_param( h.ModelName, 'ObfuscateCode', '3' ); % force it to ObfuscateCode
%set_param( h.ModelName, 'PackageGeneratedCodeAndArtifacts','off'); % save the code for analysis

hPkgInfo = realtime.internal.getTM4C1294NPDTInfo('PkgInfo');
spPkg= hPkgInfo.getSpPkgInfo( 'TM4C1294NPDT') ;
set_mkt_toolchain(spPkg.RootDir);

ret = true;
end

function set_mkt_toolchain(pkg_root_dir)
%%
xmake_path = fileparts(which('xmakefilesetup'));
if isempty(xmake_path) || ~exist(fullfile( xmake_path, 'registry', 'templates' , 'defgmake.mkt'), 'file')
    % use package defgmake
    linkfoundation.xmakefile.XMakefilePreferences.setUserConfigurationLocation( fullfile( pkg_root_dir, 'registry') ) ;
    linkfoundation.xmakefile.XMakefilePreferences.setActiveTemplate( 'gmake') ;
else
    %use stellaris_lp_gmake
    linkfoundation.xmakefile.XMakefilePreferences.setActiveTemplate( 'TM4C1294NPDT_gmake') ;
end


linkfoundation.xmakefile.XMakefilePreferences.setUserConfigurationLocation( fullfile( pkg_root_dir, 'registry') ) ;
linkfoundation.xmakefile.XMakefilePreferences.setActiveConfiguration( 'TM4C1294NPDT') ;  % name without space

linkfoundation.xmakefile.XMakefileConfiguration.getConfigurations( true) ;
linkfoundation.xmakefile.XMakefileTemplate.reload( ) ;

end
