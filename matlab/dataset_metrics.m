%% init
addpath('D:/Work/EEG/2019_03_03_BCT')

%% calculate metrics
% directories
study_root = 'D:/Work/EEG/';

% data dir
suffix = '_corr'; % '', '_coh' or '_corr'
data_dir = strcat(study_root, 'dataset/');
fc_dir = strcat(data_dir, 'fc', suffix, '/');
csv_dir = strcat(data_dir, 'csv/');

% get files
data_files = dir(fullfile(fc_dir, '*.mat'));
n = length(data_files);

% storages
names = strings(1,n);

% n metrics
n_metrics = 3;

% metrics storage
m = zeros(1,n_metrics);
M = zeros(n,n_metrics);

% iterate over all subjects
for i = 1:n
    % report
    disp(['Processing: ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % store name
    split_name = split(name,'_');
    names(i) = split_name(1);
    
    % get full path
    full_path = strcat(data_files(i).folder, '\', + data_files(i).name);
    
    % load data
    load(full_path);
    
    % remove nans
    mean_fc = mean_fc + abs(min(min(mean_fc)));
    mean_fc(isnan(mean_fc)) = 0;
        
    % calculate metrics
    % characteristic path
    m(1) = charpath(mean_fc);
    
    % global efficiency
    m(2) = efficiency_wei(mean_fc);
    
    % clustering coefficient
    m(3) = mean(clustering_coef_wu(mean_fc));
    
    % append
    M(i,:) = m;
end

% merge
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics', suffix, '.csv'));
