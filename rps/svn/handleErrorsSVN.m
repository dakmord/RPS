function [info, message] = handleErrorsSVN(status,cmdout)
%HANDLEERRORSSVN Summary of this function goes here
%   looks for svn error codes inside the cmdoutput of the command line call
errorList = {};
errorList{end+1}.nr = 'E731001';
errorList{end}.text = 'Unable to connect to a repository at URL.';
errorList{end+1}.nr = 'E731004';
errorList{end}.text = 'Unable to connect to a repository at URL.';
errorList{end+1}.nr = 'E200009';
errorList{end}.text = 'Wrong URL or not existing.';
errorList{end+1}.nr = 'E180001';
errorList{end}.text = 'Wrong URL or not existing.';
errorList{end+1}.nr = 'E155007';
errorList{end}.text = 'Selected Folder is not a working copy.';
errorList{end+1}.nr = 'E205007';
errorList{end}.text = 'Could not use external editor to fetch log message. Missing log message!';
errorList{end+1}.nr = 'E020024';
errorList{end}.text = 'Fehler beim Ermitteln der Groﬂ-/Kleinschreibung... !';

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