% dir
data_dir = '../data/dataset/';
fc_dir = strcat(data_dir, 'fc/');
csv_dir = strcat(data_dir, 'fc_csv/');

% get files
data_files = dir(fullfile(fc_dir, strcat('*.mat')));
n = length(data_files);

% storages
names = strings(1,n);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % store name
    split_name = split(name,'_');
    subject = split_name{1};
    names(i) = subject;
    
    % get full path
    full_path = strcat(data_files(i).folder, '/', + data_files(i).name);
    
    % load data
    load(full_path);

    % remove nan rows and columns
    mean_fc = mean_fc(:,~all(isnan(mean_fc)));
    mean_fc = mean_fc(~all(isnan(mean_fc), 2),:);
   
    % save
    writematrix(mean_fc, strcat(csv_dir, subject, '.csv'));
end
