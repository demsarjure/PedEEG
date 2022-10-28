% dir
data_dir = '../data/validation/';
fc_dir = strcat(data_dir, 'fc/');
thresh_dir = strcat(data_dir, 'fc_thresh/');

% bands
% theta
band.name = 'theta';
band.min_fc = 0.02;
bands(1) = band;
% alpha
band.name = 'alpha';
band.min_fc = 0.023;
bands(2) = band;
% beta
band.name = 'beta';
band.min_fc = 0.015;
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

        % thresholding
        % subtract min
        mean_fc = mean_fc - band.min_fc;
            
        % set negative to 0
        mean_fc = max(mean_fc, 0);

        % set diagonal to 0
        mean_fc(1:1+size(mean_fc, 1):end) = 0;
            
        % save
        save(strcat(thresh_dir, '/', subject, band_suffix, '_mean_fc.mat'), 'mean_fc');
    end
end
