%% init
addpath('D:/Work/EEG/eeglab2021.1')
addpath('D:/Work/EEG/fieldtrip')
run('D:/Work/EEG/eeglab2021.1/eeglab.m');
ft_defaults
addpath('D:/Work/EEG/2019_03_03_BCT')

%% calculate fc
% directories
study_root = 'D:/Work/EEG/';

% data dir
data_dir = strcat(study_root, 'dataset/');
rest_dir = strcat(data_dir, 'rest/');
fc_dir = strcat(data_dir, 'fc/');

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
n = length(data_files);

% iterate over all subjects
for i = 1:n
    % report
    disp(['Processing: ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % get full path
    full_path = strcat(data_files(i).folder, '\', + data_files(i).name);
    
    % load data
    load(full_path);
    
    % downsample to 250hz
    frequency = 250;
    EEG = pop_resample(EEG, frequency);

    % cut out 60x2 events
    n_events = 60;
    event_duration = 2;
    start = EEG.event(1).latency;
    stop = start + ((n_events + 1) * event_duration * frequency) + 1;
    EEG = eeg_eegrej(EEG, [1 start; stop EEG.pnts]);

    % epoching
    event_duration = 2;
    event = struct([]);
    for j = 1:(n_events+1)
        event(j).type = j;
        event(j).duration = 2;
        event(j).timestamp = [];
        event(j).latency = (j - 1) * event_duration * 250;
        event(j).urevent = j;
    end
    EEG.event = event;

    % create dummy epochs
    EEG = pop_epoch(EEG, { }, [0  2]);

    % EEGlab to fieldtrip
    data = eeglab2fieldtrip(EEG, 'raw', 'none');
    
    % recreate sample info
    data.sampleinfo = zeros(n_events, 2);
    for j = 1:n_events
        frames = data.trialinfo.duration(j) * data.fsample;
        start_t = (j - 1) * frames + 1;
        end_t = start_t + frames - 1;
        data.sampleinfo(j, 1) = start_t;
        data.sampleinfo(j, 2) = end_t;
    end
    
    % freq analysis
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.output = 'fourier';
    cfg.tapsmofrq = 1;
    cfg.pad = 'nextpow2';
    freq = ft_freqanalysis(cfg, data);

    % connectome
    cfg = [];
    cfg.method = 'wpli_debiased';
    fc = ft_connectivityanalysis(cfg, freq);

    % alpha frequencies only
    ix_8 = find(fc.freq > 8);
    ix_8 = ix_8(1);
    ix_13 = find(fc.freq > 13);
    ix_13 = ix_13(1);
    
    % mean
    mean_fc = mean(fc.wpli_debiasedspctrm(:,:,ix_8:ix_13), 3);

    % save the connectome
    save(strcat(fc_dir, name, '_mean_fc.mat'), 'mean_fc');
end
