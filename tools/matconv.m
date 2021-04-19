workDir = uigetdir(); %gets directory
myFiles = dir(fullfile(workDir,'*.mat')); %gets all wav files in struct
for k = 1:length(myFiles)
    clear('val', 'dataout');
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(workDir, baseFileName);
    fprintf(1, 'Now processing %s\n', fullFileName);
    load(fullFileName);
    dataout = val;
    save(fullFileName,'dataout');
    % all of your actions for filtering and plotting go here
end