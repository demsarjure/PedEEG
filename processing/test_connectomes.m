% dir
data_dir = '../data/test/';
fc_dir = strcat(data_dir, 'fc');
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
    disp(['===> Processing band ', band.name])

    % iterate over both groups
    for g = 1:2
        if g == 1
            subject_suffix = '';
            n = 28;
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
            
            % save
            writematrix(mean_fc, strcat(csv_dir, subject, band_suffix, '.csv'));
        end
    end
end
