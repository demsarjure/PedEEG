%% init
addpath('D:/Work/EEG/eeglab2022.0')
run('D:/Work/EEG/eeglab2022.0/eeglab.m');

%% load the data and electrode locations from subject 1
EEG = pop_fileio(strcat('D:/Work/EEG/PED_01/PED_01.vhdr'), 'dataformat', 'auto');
EEG = pop_editset(EEG, 'run', [], 'chanlocs', 'D:/Work/EEG/64BPMR+ref.ced');

%% electrodes
y_electrodes = [EEG.chanlocs.Y];
epsilon = 0.001;

left = find(y_electrodes > epsilon);
middle = find(y_electrodes < epsilon & y_electrodes >- epsilon);
right = find(y_electrodes < -epsilon);

%% iterater over subjects
subject_suffix = ''; % use T_ for test
n = 21; % use X for test
suffix = '_laplace'; % '', '_coh', '_corr', '_laplace', '_coh_laplace' or '_corr_laplace'

% dir
study_root = 'D:/Work/EEG/';
csv_dir = strcat(study_root, 'csv/');

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
writetable(metrics, strcat(csv_dir, 'metrics_inter', suffix, '.csv'));