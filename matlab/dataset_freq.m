%% init
addpath('D:/Work/EEG/eeglab2021.1')
addpath('D:/Work/EEG/fieldtrip')
run('D:/Work/EEG/eeglab2021.1/eeglab.m');
ft_defaults

%% iterate over subjects
% directories
study_root = 'D:/Work/EEG/';

% data dir
data_dir = strcat(study_root, 'dataset/');
rest_dir = strcat(data_dir, 'rest/');
csv_dir = strcat(data_dir, 'csv/');

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
n = length(data_files);

% storages
n_metrics = 3;
m = zeros(1,n_metrics);
M = zeros(n,n_metrics);
names = strings(1,n);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % get id
    [path, name, ext] = fileparts(data_files(i).name);
    
    % store name
    split_name = split(name,'_');
    names(i) = split_name(1);
    
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
    
    % psd
    ps = pop_spectopo(rest, 1, [0  300000], 'EEG' , 'percent', 50, 'freqrange', [8 13], 'electrodes', 'off');
    Fs = rest.srate;
    N = size(ps, 2);
    psd = (1/(Fs*N)) * abs(ps).^2;
    psd(2:end-1) = 2*psd(2:end-1);

    m(1) = mean(mean(psd));
    
    % AP
    freq = 7:0.5:14;
    cfg = [];
    cfg.output = 'pow';
    cfg.method = 'mtmfft';
    cfg.foi = freq;
    cfg.tapsmofrq = 1;
    fq = ft_freqanalysis(cfg, data);
    
    % naive method
    [m, ix] = max(mean(fq.powspctrm));
    m(2) = fq.freq(ix);
    
    % find peaks
    mean_ps = mean(fq.powspctrm);
    pks = findpeaks(mean_ps);
    
    % find max power
    if isempty(pks)
        m(3) = -1;
    else
        max_p = pks(1);
        ix = find(mean_ps == max_p);
        m(3) = fq.freq(ix);
        for p = pks
            if (p > max_p)
                ix = find(mean_ps == p);
                m(3) = fq.freq(ix);
                max_p = p;
            end
        end
        
    end
    
    % append
    M(i,:) = m;
end

% merge
metrics = table(names', M);
writetable(metrics, strcat(csv_dir, 'metrics_freq.csv'));
