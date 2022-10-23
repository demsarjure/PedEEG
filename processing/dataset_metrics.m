%% init
addpath('../../2019_03_03_BCT')
addpath('../../SmallWorldNess')

%% calculate metrics
% directories
data_dir = '../data/dataset/';
fc_dir = strcat(data_dir, 'fc');

% n metrics
n_metrics = 4;

% bands
% delta
band.name = 'delta';
bands(1) = band;
% theta
band.name = 'theta';
bands(2) = band;
% alpha
band.name = 'alpha';
bands(3) = band;
% beta
band.name = 'beta';
bands(4) = band;

% iterate over all bands
m = length(bands);
for b = 1:m
    band = bands(b);
    band_suffix = strcat('_', band.name);

    % report
    disp(['===> Processing band: ', band.name])

    % get files
    data_files = dir(fullfile(fc_dir, strcat('*', band_suffix, '*.mat')));
    n = length(data_files);

    % storages
    names = strings(1,n);

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
        full_path = strcat(data_files(i).folder, '/', + data_files(i).name);

        % load data
        load(full_path);

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
    writetable(metrics, strcat(data_dir, 'metrics', band_suffix, '.csv'));
end
