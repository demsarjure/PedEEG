% dir
data_dir = '../data/validation/';
fc_dir = strcat(data_dir, 'fc/');
csv_dir = strcat(data_dir, 'fc_csv/');

% bands
% theta
band.name = 'theta';
bands(1) = band;
% alpha
band.name = 'alpha';
bands(2) = band;
% beta
band.name = 'beta';
bands(3) = band;

% iterate over all bands
m = length(bands);
for b = 1:m
    band = bands(b);
    band_suffix = strcat('_', band.name);

    % report
    disp(['===> Processing band: ', band.name])

    % get files
    data_files = dir(fullfile(fc_dir, strcat('*', band_suffix,'*.mat')));
    n = length(data_files);

    % iterate over all subjects
    for i = 1:n
        % report
        disp(['===> Processing: ', num2str(i), '/', num2str(n)])
        
        % get id
        [path, name, ext] = fileparts(data_files(i).name);
        
        % get name
        split_name = split(name,'_');
        subject = split_name{1};
        
        % get full path
        full_path = strcat(data_files(i).folder, '/', + data_files(i).name);
        
        % load data
        load(full_path);

        % save
        writematrix(mean_fc, strcat(csv_dir, subject, band_suffix, '.csv'));
    end
end
