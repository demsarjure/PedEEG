%% init
addpath('D:/Work/EEG/eeglab2021.1')
addpath('D:/Work/EEG/fieldtrip')
run('D:/Work/EEG/eeglab2021.1/eeglab.m');
ft_defaults

%% set subject
subject = 'PED_T_01';
directory = strcat('D:/Work/EEG/', subject);

%% convert
cleaned_set = strcat(subject, '_rest_cleaned.set');
rest = pop_loadset(cleaned_set, directory);
data = eeglab2fieldtrip(rest, 'raw', 'none');

%% recreate sample info
n_events = size(data.trialinfo.type,1);
data.sampleinfo = zeros(n_events, 2);
for i = 1:n_events
    frames = data.trialinfo.duration(i) * data.fsample;
    start_t = (i - 1) * frames + 1;
    end_t = start_t + frames - 1;
    data.sampleinfo(i, 1) = start_t;
    data.sampleinfo(i, 2) = end_t;
end

%% freq analysis
cfg = [];
cfg.method = 'mtmfft';
cfg.output = 'fourier';
cfg.tapsmofrq = 1;
cfg.pad = 'nextpow2';
freq = ft_freqanalysis(cfg, data);

%% connectome
cfg = [];
cfg.method = 'wpli_debiased';
fc = ft_connectivityanalysis(cfg, freq);

%% alpha frequencies only
ix_8 = find(fc.freq > 8);
ix_8 = ix_8(1);
ix_13 = find(fc.freq > 13);
ix_13 = ix_13(1);

%% mean
mean_fc = mean(fc.wpli_debiasedspctrm(:,:,ix_8:ix_13), 3);
%imagesc(mean_fc);

%% save
save(strcat(directory, '/', subject, '_mean_fc.mat'), 'mean_fc');
