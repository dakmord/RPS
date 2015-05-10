function [toolDirs] = getToolchainDirectories()
homePath = getParentDir(2, '\');

userSetupXML = xml2struct([homePath 'gui\cfg\usersetup.xml']);
toolchainXML = xml2struct([homePath 'gui\cfg\toolchains.xml']);
[x, y] = size(userSetupXML.toolchains.entry);
userEntries = {};
dirs = {};
if y > 1
    % more toolchain entries...
    for i=1:y
        tmp = cell2mat(userSetupXML.toolchains.entry(1,i));
        userEntries{end+1} = tmp.Text;
    end
else
    userEntries{end+1} = userSetupXML.toolchains.entry.Text;
end
%find out directories...
[x, y] = size(toolchainXML.toolchains.entry);
if y > 1
    % more toolchain entries...
    for i=1:y
        % look for userEntries and determine paths...
        tmp = cell2mat(toolchainXML.toolchains.entry(1,i));
        [ux, uy] = size(userEntries);
        for t=1:uy
            if strcmp(char(userEntries(t)), char(tmp.name.Text))
                % ADD Paths of this entry to "dirs"
                [dx, dy] = size(tmp.dir);
                if dy>1
                    for r=1:dy
                        tmpDir = cell2mat(tmp.dir(1,r));
                        dirs{end+1} = tmpDir.Text;
                    end
                else
                    dirs{end+1} = tmp.dir.Text;
                end
            end
        end
    end
else
    if ~isempty(userEntries)
        %get all dirs of this entry...
        [dx, dy] =size(toolchainXML.toolchains.entry.dir);
        for p=1:dy
            tmp=cell2mat(toolchainXML.toolchains.entry.dir(1,p));
            dirs{end+1} = tmp.Text;
        end
    end
end
toolDirs = dirs;