%% init
addpath('../../eeglab2022.0')
addpath('../../fieldtrip')
run('../../eeglab2022.0/eeglab.m');
ft_defaults

%% iterate over subjects
% directories
study_root = '../../';

% data dir
rest_dir = strcat(study_root, 'data/validation/mat/');
data_dir = '../data/validation/';

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
n = length(data_files);

% storages
m = 0;
M = zeros(n,1);
names = strings(1,n);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % store name
    split_name = split(name,'_');
    names(i) = split_name(1);
    
    % get full path
    full_path = strcat(data_files(i).folder, '/', + data_files(i).name);
    
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
    
    % surface laplacian
    cfg = [];
    cfg.method = 'finite';
    cfg.trials = 'all';
    data = ft_scalpcurrentdensity(cfg, data);
    
    % recreate sample info
    data.sampleinfo = zeros(n_events, 2);
    for j = 1:n_events
        frames = data.trialinfo.duration(j) * data.fsample;
        start_t = (j - 1) * frames + 1;
        end_t = start_t + frames - 1;
        data.sampleinfo(j, 1) = start_t;
        data.sampleinfo(j, 2) = end_t;
    end
      
    % AP
    freq = 7:0.5:14;
    cfg = [];
    cfg.output = 'pow';
    cfg.method = 'mtmfft';
    cfg.foi = freq;
    cfg.tapsmofrq = 1;
    fq = ft_freqanalysis(cfg, data);
    
    % find peak
    [~, ix] = max(mean(fq.powspctrm));
    m = fq.freq(ix);
    
    % no peak
    if m == 7 || m == 14
        m = -1;
    end
    
    % append
    M(i,:) = m;
end

% merge
metrics = table(names', M);
writetable(metrics, strcat(data_dir, 'metrics_freq.csv'));
