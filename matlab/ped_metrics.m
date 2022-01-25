%% load BCT
addpath('D:/Work/EEG/2019_03_03_BCT')
addpath('D:/Work/EEG/SmallWorldNess')

%% iterater over subjects
subject_suffix = ''; % use T_ for test
n = 21;
suffix = ''; % '', '_coh' or '_corr'

% dir
study_root = 'D:/Work/EEG/';
csv_dir = strcat(study_root, 'csv/');

% storages
names = strings(1,n);

% n metrics
n_metrics = 4;

% metrics storage
m = zeros(1,n_metrics);
M = zeros(n,n_metrics);

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
        
    % calculate metrics
    % characteristic path
    m(1) = charpath(mean_fc);
    
    % global efficiency
    m(2) = efficiency_wei(mean_fc);
    
    % clustering coefficient
    m(3) = mean(clustering_coef_wu(mean_fc));
    
    % small worldness
    [m(4), ~, ~] = small_world_ness(mean_fc, m(1), m(3), 1);
    
    % append
    M(i,:) = m;
end

% merge
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics', suffix, '.csv'));
