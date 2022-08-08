% dir
data_dir = '../data/ped/';
fc_dir = strcat(data_dir, 'fc');
csv_dir = strcat(data_dir, 'fc_csv/');

% iterate over both groups
for g = 1:2
    if g == 1
        subject_suffix = '';
        n = 25;
    else
        subject_suffix = 'T_';
        n = 29;
    end
    
    % storages
    names = strings(1,n);
    
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
        
        % to positive numbers
        mean_fc = mean_fc + abs(min(min(mean_fc)));
        
        % remove nans
        mean_fc(isnan(mean_fc)) = 0;
       
        % save
        writematrix(mean_fc, strcat(csv_dir, subject, '.csv'));
    end
end
