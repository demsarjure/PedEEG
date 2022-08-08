% dir
study_root = '../../';
csv_dir = strcat(study_root, 'PedEEG/data/ped/csv/');

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
        directory = strcat('../../', subject);
    
        % store name
        names(i) = subject;
        
        % load data
        load(strcat(directory, '/', subject, '_mean_fc.mat'));
        
        % to positive numbers
        mean_fc = mean_fc + abs(min(min(mean_fc)));
        
        % remove nans
        mean_fc(isnan(mean_fc)) = 0;
       
        % save
        writematrix(mean_fc, strcat(csv_dir, subject, '.csv'));
    end
end
