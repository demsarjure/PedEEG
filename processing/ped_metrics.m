%% load BCT
addpath('../../2019_03_03_BCT')
addpath('../../SmallWorldNess')

%% iterater over subjects
% dir
data_dir = '../data/ped/';
fc_dir = strcat(data_dir, 'fc');

% n metrics
n_metrics = 8;

% iterate over both groups
for g = 1:2
    if g == 1
        subject_suffix = '';
        group_suffix = '';
        n = 25;
    else
        subject_suffix = 'T_';
        group_suffix = '_T';
        n = 29;
    end
    
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

        % store name
        names(i) = subject;
        
        % load data
        load(strcat(fc_dir, '/', subject, '_mean_fc.mat'));
    
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
    
        % modularity
        [~, m(6)] = modularity_und(mean_fc);
    
        % hierarchical coefficient of regression
        m(7) = hcr(mean_fc);
    
        % degree variance
        m(8) = var(degrees_wei(mean_fc));
    
        % append
        M(i,:) = m;
    end
    
    % merge
    metrics = table(names', M);
    writetable(metrics, strcat(data_dir, 'metrics', group_suffix, '.csv'));
end
