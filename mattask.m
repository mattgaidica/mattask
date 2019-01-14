% [ ] github auto-update?

% SETUP
tasksFilename = 'README.md';
useWorkingDir = true;
fileExtensions = {'.m'};
expression = '\[(x| )\].*';
nlChar = ['  ',newline]; % newline

% set working directory
if useWorkingDir
    workingDir = pwd;
else
    workingDir = uigetdir;
end

% list all files recursively
listing = struct;
for iExt = 1:numel(fileExtensions)
    listing = dir(['**/*',fileExtensions{iExt}]);
end
% remove self
listing = listing(~cellfun(@(S) strcmp([mfilename,'.m'],S), {listing.name}));
% [ ] can we skip files that have already been scanned AND have no tasks?

% extract tasks
tasks = {};
taskCount = 0;
for iFile = 1:numel(listing)
    fid = fopen(fullfile(listing(iFile).folder,listing(iFile).name));
    lnCount = 0;
    while ~feof(fid)
        lnCount = lnCount + 1;
        tline = fgetl(fid);
        matchStr = regexp(tline,expression,'match');
        if ~isempty(matchStr)
            taskCount = taskCount + 1;
            tasks(taskCount).task = matchStr{1};
            tasks(taskCount).file = iFile;
            tasks(taskCount).line = lnCount;
        end
    end
end

% generate .md file
fid = fopen(tasksFilename,'w');
fprintf(fid,'# Tasks %s',nlChar);
fprintf(fid,'*Last Updated %s*%s',datestr(now,'mmm.dd, yyyy'),[nlChar nlChar]);
curFilename = '';
if numel(tasks) == 0
    fprintf(fid,'No tasks.');
else
    for iTask = 1:numel(tasks)
        if isempty(curFilename) || ~strcmp(curFilename,listing(tasks(iTask).file).name)
            curFilename = listing(tasks(iTask).file).name;
            curFolder = listing(tasks(iTask).file).folder;
            fprintf(fid,'%s',nlChar);
            fprintf(fid,'%s%s**%s**%s',strrep(curFolder,workingDir,''),filesep,curFilename,nlChar);
        end
        fprintf(fid,'%s%s',['- ',tasks(iTask).task],nlChar);
    end
end
fprintf(fid,'%s',nlChar);
fprintf(fid,'EOF%s',datestr(now,'yyyymmddHHMMSS'));
fid = fclose(fid);