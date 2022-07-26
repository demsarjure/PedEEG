%% init
addpath('../2019_03_03_BCT')

%% calculate metrics
% directories
study_root = '../';

% data dir
dir_suffix = ''; % '', '_coh' or '_corr'
file_suffix = '_laplace' ; % '' or '_laplace'
data_dir = strcat(study_root, 'dataset/');
fc_dir = strcat(data_dir, 'fc', dir_suffix, '/');
csv_dir = strcat(data_dir, 'csv/');

% get files
data_files = dir(fullfile(fc_dir, strcat('*', file_suffix, '.mat')));
n = length(data_files);

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
    
    % remove nan rows and columns
    mean_fc = mean_fc(:,~all(isnan(mean_fc)));
    mean_fc = mean_fc(~all(isnan(mean_fc), 2),:);
    
    % to positive numbers
    mean_fc = mean_fc + abs(min(min(mean_fc)));
     
    % set diagonal to 0
    mean_fc(1:1+size(mean_fc,1):end) = 0;
    
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
writetable(metrics, strcat(csv_dir, 'metrics', dir_suffix, file_suffix, '.csv'));
