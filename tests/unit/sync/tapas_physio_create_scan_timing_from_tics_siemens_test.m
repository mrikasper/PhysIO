function tests = tapas_physio_create_scan_timing_from_tics_siemens_test()
% Tests Siemens Tics scan timing for multiband acquisitions.

tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testFolder = fileparts(mfilename('fullpath'));
repoRoot = fileparts(fileparts(fileparts(testFolder)));
testCase.TestData.pathFixture = ...
    matlab.unittest.fixtures.PathFixture( ...
    fullfile(repoRoot, 'code'), IncludingSubfolders=true);
testCase.applyFixture(testCase.TestData.pathFixture);
end

function test_collapses_simultaneous_multiband_slices(testCase)
testFolder = tempname;
mkdir(testFolder);
testCase.addTeardown(@() rmdir(testFolder, 's'));
infoFile = fullfile(testFolder, 'multiband_Info.log');
write_multiband_info_log(infoFile);

t = (0:0.0025:0.05)';
logFiles.scan_timing = infoFile;
verbose.level = 0;
verbose.fig_handles = [];

[volumeLocations, sliceLocations] = ...
    tapas_physio_create_scan_timing_from_tics_siemens( ...
    t, 0, logFiles, verbose);

verifyEqual(testCase, volumeLocations, [5; 13]);
verifyEqual(testCase, sliceLocations, [5; 9; 13; 17]);
end

function write_multiband_info_log(fileName)
fileId = fopen(fileName, 'w');
cleanup = onCleanup(@() fclose(fileId));
fprintf(fileId, 'LogDataType = ACQUISITION_INFO\n\n');
fprintf(fileId, 'VOLUME SLICE ACQ_START_TICS ACQ_FINISH_TICS ECHO\n\n');
fprintf(fileId, '0 0 4 5 0\n');
fprintf(fileId, '0 2 4 5 0\n');
fprintf(fileId, '0 1 8 9 0\n');
fprintf(fileId, '0 3 8 9 0\n');
fprintf(fileId, '1 0 12 13 0\n');
fprintf(fileId, '1 2 12 13 0\n');
fprintf(fileId, '1 1 16 17 0\n');
fprintf(fileId, '1 3 16 17 0\n');
end
