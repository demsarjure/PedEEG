%% init
addpath('../../eeglab2022.0')
run('../../eeglab2022.0/eeglab.m');

%% calculate fc
% directories
study_root = '../../';

% data dir
rest_dir = strcat(study_root, 'dataset/rest/');
fc_dir = strcat(study_root, 'PedEEG/data/dataset/fc');
csv_dir = strcat(study_root, 'PedEEG/data/dataset/csv/');

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
fc_files = dir(fullfile(fc_dir, strcat('*.mat')));
n = length(data_files);

% n metrics
n_metrics = 4;

% storages
names = strings(1,n);
m = zeros(1,n_metrics);
M = zeros(n,n_metrics);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % store name
    split_name = split(name,'_');
    names(i) = split_name(1);
    
    % get full path
    full_path = strcat(data_files(i).folder, '/', + data_files(i).name);
    
    % load data
    load(full_path);
    
    % electrodes
    y_electrodes = [EEG.chanlocs.Y];
    epsilon = 0.001;

    left = find(y_electrodes > epsilon);
    middle = find(y_electrodes < epsilon & y_electrodes >- epsilon);
    right = find(y_electrodes < -epsilon);
    
    % load fc
    fc_path = strcat(fc_files(i).folder, '/', + fc_files(i).name);
    load(fc_path);
    
    % magnitude
    mean_fc = abs(mean_fc);

    % set diagonal to 0
    nodes = size(mean_fc, 1);
    mean_fc(1:nodes+1:end) = 0;
        
    % calculate inter hemispheric   
    i_mean_fc = mean_fc;
    
    % set all connections with middle electrodes to 0
    i_mean_fc(middle,:) = 0;
    i_mean_fc(:,middle) = 0;
    
    % iterate over all rows and columns
    n_electrodes = size(mean_fc, 1);
    for x = 1:n_electrodes
        for y = (x+1):n_electrodes
            % set bottom half to 0
            mean_fc(y,x) = 0;
            i_mean_fc(y,x) = 0;
            
            % if x is on left and y is on left or
            % if x is on right and y is on right or
            % then remove the connection
            if ((any(left == x) && any(left == y)) || (any(right == x) && any(right == y)))
                i_mean_fc(x,y) = 0;
            end
        end
    end

    % interhemispheric metric
    m(1) = sum(i_mean_fc, 'all') / sum(mean_fc, 'all');
    
    % total interhemispheric
    m(2) = sum(i_mean_fc, 'all');
    
    % mean
    m(3) = mean(i_mean_fc, 'all');
    
    % max
    m(4) = max(i_mean_fc, [], 'all');
    
    % append
    M(i,:) = m;
end

% save
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics_inter.csv'));
