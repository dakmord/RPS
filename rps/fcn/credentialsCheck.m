function credentialsCheck(homePath, repository)
% INFO CRED....

iterator = 0;
while iterator~=1
    % ask for username/password first
    if ~(exist(fullfile(homePath, 'gui', 'cfg', 'credentials.xml.aes'),'file')==2)
        [Password, UserName] = passwordEntryDialog('enterUserName', true,'ValidatePassword', true, 'WindowName', 'SVN-Login Information');
        if ~isempty(Password) && ~isempty(UserName)
            encryptCredentials(UserName, Password);
        else
            % no user/pass inserted ...

        end
    else
        [UserName, Password] = decryptCredentials();
    end
    % Check for validity of password
    [validity] = credentialsValiditySVN(repository, UserName, Password);
    if validity == 0
        % user/pass wrong!?
        errordlg('Please re-enter your Username and Password.', 'Username/Password wrong!?');
        iterator = 0;
        delete(fullfile(homePath, 'gui', 'cfg', 'credentials.xml.aes'));
    else
        % user/pass should be correct...
        iterator = 1;
    end
end

end