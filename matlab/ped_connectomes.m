
%% iterater over subjects
subject_suffix = ''; % use T_ for test
n = 21;
suffix = ''; % '', '_coh' or '_corr'

% dir
study_root = 'D:/Work/EEG/';
csv_dir = strcat(study_root, 'csv/fc/');

% storages
names = strings(1,n);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % set subject
    subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));
    directory = strcat('D:/Work/EEG/', subject);

    % store name
    names(i) = subject;
    
    % load data
    load(strcat(directory, '/', subject, '_mean_fc', suffix, '.mat'));
    
    % to positive numbers
    mean_fc = mean_fc + abs(min(min(mean_fc)));
    
    % remove nans
    mean_fc(isnan(mean_fc)) = 0;
   
    % save
    writematrix(mean_fc, strcat(csv_dir, subject, suffix, '.csv'));
end
