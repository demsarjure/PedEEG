%% load BCT
addpath('D:/Work/EEG/2019_03_03_BCT')

%% set subject
subject = 'PED_08';
directory = strcat('D:/Work/EEG/', subject);

%% characteristic path
load(strcat(directory, '/', subject, '_mean_fc.mat'));

% absolute
cp_matrix = abs(mean_fc);

cp_matrix(isnan(cp_matrix)) = 0;
cp = charpath(cp_matrix);
