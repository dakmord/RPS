function [info, message] = handleErrorsSVN(status,cmdout)
%HANDLEERRORSSVN Summary of this function goes here
%   looks for svn error codes inside the cmdoutput of the command line call
errorList = {};
errorList{end+1}.nr = 'E731004';
errorList{end}.text = 'Unable to connect to a repository at URL.';
errorList{end+1}.nr = 'E200009';
errorList{end}.text = 'Wrong URL or not existing.';
errorList{end+1}.nr = 'E180001';
errorList{end}.text = 'Wrong URL or not existing.';

% Check for Errors
for i=1:1:length(errorList)
    if ~isempty(strfind(cmdout,errorList{i}.nr))
        info = errorList{i}.nr;
        message = errorList{i}.text;
        return;
    end
end

info='';
message = '';

end