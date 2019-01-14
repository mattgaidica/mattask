% [ ] github auto-update task list?
% [ ] carry over text above Tasks listing

% config
w = whos;
tasksFilename = 'README.md';
useWorkingDir = false;
fileExtensions = {'.m'};
expression = '\[(x| )\].*';
skipString = 'skiptasks';
nlChar = ['  ',newline]; % newline
openTaskFile = true;

disp([newline,'<<< mattask >>>']);
disp('Select a folder to find tasks...');

% set working directory
if useWorkingDir
    workingDir = pwd;
else
    workingDir = uigetdir;
end

% list all files recursively
listing = struct;
for iExt = 1:numel(fileExtensions)
    listing = dir([workingDir,filesep,'**',filesep,'*',fileExtensions{iExt}]);
end
% remove self
listing = listing(~cellfun(@(S) strcmp([mfilename,'.m'],S), {listing.name}));

% extract tasks
tasks = {};
taskCount = 0;
for iFile = 1:numel(listing)
    fid = fopen(fullfile(listing(iFile).folder,listing(iFile).name));
    lnCount = 0;
    while ~feof(fid)
        lnCount = lnCount + 1;
        tline = fgetl(fid);
        % exit file if skipString encountered
        matchStr = regexp(tline,skipString,'match');
        if ~isempty(matchStr)
            break;
        end
        % build task list
        matchStr = regexp(tline,expression,'match');
        if ~isempty(matchStr)
            taskCount = taskCount + 1;
            tasks(taskCount).task = matchStr{1};
            tasks(taskCount).file = iFile;
            tasks(taskCount).line = lnCount;
        end
    end
end
disp(['Found ',num2str(taskCount),' tasks in ',num2str(numel(listing)),' files...']);

% generate .md task file
disp(['Writing task file...']);
taskFile = fullfile(workingDir,tasksFilename);
fid = fopen(taskFile,'w');
fprintf(fid,'# Tasks %s',nlChar);
fprintf(fid,'*Last Updated %s*%s',datestr(now,'mmm.dd, yyyy at HH:MM'),[nlChar nlChar]);
curFilename = '';
if numel(tasks) == 0
    fprintf(fid,'No tasks.%s',nlChar);
else
    for iTask = 1:numel(tasks)
        if isempty(curFilename) || ~strcmp(curFilename,listing(tasks(iTask).file).name)
            curFilename = listing(tasks(iTask).file).name;
            curFolder = listing(tasks(iTask).file).folder;
            fprintf(fid,'%s',nlChar);
            fprintf(fid,'%s%s**%s**%s',strrep(curFolder,workingDir,''),filesep,curFilename,nlChar);
        end
        fprintf(fid,'%s `(ln%s)`%s',['- ',tasks(iTask).task],num2str(tasks(iTask).line,'%03d'),nlChar);
    end
end
fprintf(fid,'%s',nlChar);
fprintf(fid,'EOF%s',datestr(now,'yyyymmddHHMMSS'));
fid = fclose(fid);
if fid == 0
    disp('Success!');
    if openTaskFile
        open(taskFile);
    end
else
   disp('Error. The task file did not close properly.'); 
end

% cleanup
clearvars('-except',w(:).name);