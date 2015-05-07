
%% init
src_dir = fileparts(which(mfilename));
demo_dir =  fileparts(src_dir);

option.format = 'html';
option.stylesheet = fullfile(src_dir,'doc_simplehtml.xsl');
option.outputDir=fullfile(demo_dir,'html');
option.showCode=false;
option.evalCode=true;
option.catchError=true;
option.createThumbnail=false;


%% print2 demo
%
%publish(fullfile(src_dir,'stellaris_lp_print2_doc'), option);

%% irreceive demo
publish(fullfile(src_dir,'stellaris_lp_irreceive_doc'), option);


