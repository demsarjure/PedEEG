%% load BCT
addpath('../../2019_03_03_BCT')
addpath('../../SmallWorldNess')

%% iterater over subjects
subject_suffix = ''; % use T_ for test
group_suffix = ''; % use _T for test
n = 25; % use 29 for test 25 for control
suffix = '_laplace'; % '', '_coh', '_corr', '_laplace', '_coh_laplace' or '_corr_laplace'

% dir
study_root = '../../';
csv_dir = strcat(study_root, 'PedEEG/data/ped/');

% storages
names = strings(1,n);

% n metrics
n_metrics = 5;

% metrics storage
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
    
    % set diagonal to 0
    nodes = size(mean_fc, 1);
    mean_fc(1:nodes+1:end) = 0;

    % calculate metrics
    % characteristic path
    m(1) = charpath(mean_fc);

    % global efficiency
    m(2) = efficiency_wei(mean_fc);

    % clustering coefficient
    m(3) = mean(clustering_coef_wu(mean_fc));
    
    % small worldness
    [m(4), ~, ~] = small_world_ness(mean_fc, m(1), m(3), 1);

    % betweenness centrality
    m(5) = mean(betweenness_wei(mean_fc));

    % append
    M(i,:) = m;
end

% merge
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics', group_suffix, suffix, '.csv'));
