%% init
addpath('D:/Work/EEG/eeglab2022.0')
run('D:/Work/EEG/eeglab2022.0/eeglab.m');

%% calculate fc
% directories
study_root = 'D:/Work/EEG/';

% data dir
data_dir = strcat(study_root, 'dataset/');
rest_dir = strcat(data_dir, 'rest/');
fc_dir = strcat(data_dir, 'fc/');
csv_dir = strcat(data_dir, 'csv/');

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
fc_suffix = '_laplace'; % '' or '_laplace'
fc_files = dir(fullfile(fc_dir, '*', fc_suffix, '.mat'));
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
    full_path = strcat(data_files(i).folder, '\', + data_files(i).name);
    
    % load data
    load(full_path);
    
    % electrodes
    y_electrodes = [EEG.chanlocs.Y];
    epsilon = 0.001;

    left = find(y_electrodes > epsilon);
    middle = find(y_electrodes < epsilon & y_electrodes >- epsilon);
    right = find(y_electrodes < -epsilon);
    
    % load fc
    fc_path = strcat(fc_files(i).folder, '\', + fc_files(i).name);
    load(fc_path);
    
    % to positive numbers
    mean_fc = mean_fc + abs(min(min(mean_fc)));
    
    % remove nans
    mean_fc(isnan(mean_fc)) = 0;
        
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
writetable(metrics, strcat(csv_dir, 'metrics_inter', fc_suffix, '.csv'));