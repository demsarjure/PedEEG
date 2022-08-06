%% init
addpath('../../eeglab2022.0')
run('../../eeglab2022.0/eeglab.m');

%% load the data and electrode locations from subject 1
EEG = pop_fileio(strcat('../../PED_01/PED_01.vhdr'), 'dataformat', 'auto');
EEG = pop_editset(EEG, 'run', [], 'chanlocs', '../../64BPMR+ref.ced');

%% electrodes
y_electrodes = [EEG.chanlocs.Y];
epsilon = 0.001;

left = find(y_electrodes > epsilon);
middle = find(y_electrodes < epsilon & y_electrodes >- epsilon);
right = find(y_electrodes < -epsilon);

%% iterater over subjects
subject_suffix = 'T_'; % use T_ for test
group_suffix = '_T'; % use _T for test
n = 29; % use 29 for test
suffix = '_laplace'; % '', '_coh', '_corr', '_laplace', '_coh_laplace' or '_corr_laplace'

% dir
study_root = '../../';
csv_dir = strcat(study_root, 'PedEEG/data/ped/csv/');

% n metrics
n_metrics = 18;

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
    directory = strcat('../../', subject);

    % store name
    names(i) = subject;
    
    % load data
    load(strcat(directory, '/', subject, '_mean_fc', suffix, '.mat'));
    
    % to positive numbers
    mean_fc = mean_fc + abs(min(min(mean_fc)));
    
    % remove nans
    mean_fc(isnan(mean_fc)) = 0;

    % set all connections with middle electrodes to 0
    mean_fc(middle,:) = 0;
    mean_fc(:,middle) = 0;

    % number of electrodes
    n_electrodes = size(mean_fc, 1);

    % calculate inter hemispheric   
    i_mean_fc = mean_fc;

    % iterate over all rows and columns
    for x = 1:n_electrodes
        for y = (x+1):n_electrodes
            % set bottom half to 0
            mean_fc(y,x) = 0;
            i_mean_fc(y,x) = 0;
            
            % if x is on left and y is on left or
            % if x is on right and y is on right
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
    
    % create left and right connectomes
    mean_fc_left = zeros(n_electrodes);
    mean_fc_right = zeros(n_electrodes);

    for x = 1:n_electrodes
        for y = (x+1):n_electrodes
            % if both left add to left
            if (any(left == x) && any(left == y))
                mean_fc_left(x,y) = mean_fc(x,y);
                mean_fc_left(y,x) = mean_fc(y,x);
            end
            % if both right add to right
            if (any(right == x) && any(right == y))
                mean_fc_right(x,y) = mean_fc(x,y);
                mean_fc_right(y,x) = mean_fc(y,x);
            end
        end
    end

    % remove zero columns
    keep_rows = sum(abs(mean_fc_left), 2) > 0;
    keep_columns = sum(abs(mean_fc_left), 1) > 0;
    mean_fc_left = mean_fc_left(keep_rows,keep_columns);
    keep_rows = sum(abs(mean_fc_right), 2) > 0;
    keep_columns = sum(abs(mean_fc_right), 1) > 0;
    mean_fc_right = mean_fc_right(keep_rows,keep_columns);

    % left
    m(5) = charpath(mean_fc_left);
    m(6) = efficiency_wei(mean_fc_left);
    m(7) = mean(clustering_coef_wu(mean_fc_left));
    [m(8), ~, ~] = small_world_ness(mean_fc_left, m(1), m(3), 1);
    m(9) = assortativity_wei(mean_fc_left, 0);
    m(10) = mean(betweenness_wei(mean_fc_left));
    m(11) = mean(degrees_wei(mean_fc_left));

    % right
    m(12) = charpath(mean_fc_left);
    m(13) = efficiency_wei(mean_fc_left);
    m(14) = mean(clustering_coef_wu(mean_fc_left));
    [m(15), ~, ~] = small_world_ness(mean_fc_left, m(1), m(3), 1);
    m(16) = assortativity_wei(mean_fc_left, 0);
    m(17) = mean(betweenness_wei(mean_fc_left));
    m(18) = mean(degrees_wei(mean_fc_left));

    % append
    M(i,:) = m;
end

% save
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics_inter', group_suffix, suffix, '.csv'));
