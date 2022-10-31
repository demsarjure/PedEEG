% dir
data_dir = '../data/test/';
fc_dir = strcat(data_dir, 'fc');
thresh_dir = strcat(data_dir, 'fc_thresh/');

% bands
% theta
band.name = 'theta';
band.min_fc = 0.018;
bands(1) = band;
% alpha
band.name = 'alpha';
band.min_fc = 0.026;
bands(2) = band;
% beta
band.name = 'beta';
band.min_fc = 0.018;
bands(3) = band;

% iterate over all bands
m = length(bands);
for b = 1:m
    band = bands(b);
    band_suffix = strcat('_', band.name);

    % report
    disp(['===> Processing band ', band.name])

    % iterate over both groups
    for g = 1:2
        if g == 1
            subject_suffix = '';
            n = 27;
        else
            subject_suffix = 'T_';
            n = 30;
        end
        
        % iterate over all subjects
        for i = 1:n
            % report
            disp(['===> Processing ', num2str(i), '/', num2str(n)])
            
            % set subject
            subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));
        
            % load data
            load(strcat(fc_dir, '/', subject, band_suffix, '_mean_fc.mat'));
            
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
end
