%% init
addpath('../../eeglab2022.0')
addpath('../../FastICA_25')
addpath('../../mwf')
run('../../eeglab2022.0/eeglab.m');

%% convert all to .set
in_data_dir = '../../data/test/eeg/';
out_data_dir = '../../data/test/set/';

% iterate over both groups
for g = 1:2
    if g == 1
        subject_suffix = '';
        n = 28;
        % markers for start of eyes closed resting state
        events = [7, 7, 7, 8, 7, 8, 7, 7, 7, 7, 7, 7, 8, 7, 7, 7, 7, 7, 5, 7, 7, 8, 7, 8, 7, 7, 8];
    else
        subject_suffix = 'T_';
        n = 30;
        % markers for start of eyes closed resting state
        events = [7, 7, 12, 8, 8, 8, 8, 7, 8, 7, 8, 8, 7, 8, 8, 8, 7, 8, 8, 8, 8, 8, 8, 8, 8, 7, 8, 8, 8];
    end

    % report
    disp(['===> Processing group ', num2str(g)])

    % iterate over all subjects
    for i = 1:n
        % report
        disp(['===> Converting ', num2str(i), '/', num2str(n)])

        % set subject
        subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));

        % load the data
        EEG = pop_fileio(strcat(in_data_dir, subject, '/', subject, '.vhdr'), 'dataformat', 'auto');
        
        % extract data with eyes closed
        start = EEG.event(7).latency;
        stop = start + 300000 + 1;
        
        % keep only middle 2 minutes
        midpoint = floor(stop - start);
        start = midpoint - 60000;
        stop = midpoint + 60000 + 1;
        
        % reject
        EEG = eeg_eegrej(EEG, [1 start; stop EEG.pnts]);
        
        % add electrode data
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', '../../64BPMR+ref.ced');
        
        % save as .set
        pop_saveset(EEG, 'filename', strcat(subject, '.set'), 'filepath', out_data_dir);
    end
end
