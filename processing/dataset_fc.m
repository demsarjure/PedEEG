%% init
addpath('../../eeglab2022.0')
addpath('../../fieldtrip')
run('../../eeglab2022.0/eeglab.m');
ft_defaults

%% calculate fc
% directories
study_root = '../../';

% data dir
rest_dir = strcat(study_root, 'dataset/rest/');
fc_dir = '../data/dataset/fc/';

% get files
data_files = dir(fullfile(rest_dir, '*.mat'));
n = length(data_files);

% bands
% delta
band.name = 'delta';
band.low_f = 0.5;
band.high_f = 4;
bands(1) = band;
% theta
band.name = 'theta';
band.low_f = 4;
band.high_f = 7;
bands(2) = band;
% alpha
band.name = 'alpha';
band.low_f = 8;
band.high_f = 13;
bands(3) = band;
% beta
band.name = 'beta';
band.low_f = 15;
band.high_f = 25;
bands(4) = band;

% iterate over all bands
m = length(bands);
for b = 1:m
    band = bands(b);
    band_suffix = strcat('_', band.name);

    % report
    disp(['===> Processing band: ', band.name])

    % iterate over all subjects
    for i = 1:n
        % report
        disp(['===> Processing subject: ', num2str(i), '/', num2str(n)])

        % get id
        [path, name, ext] = fileparts(data_files(i).name);

        % get full path
        full_path = strcat(data_files(i).folder, '/', + data_files(i).name);

        % load data
        load(full_path);

        % downsample to 250hz
        frequency = 250;
        EEG = pop_resample(EEG, frequency);

        % cut out 120x1 events
        n_events = 120;
        event_duration = 1;
        start = EEG.event(1).latency;
        stop = start + ((n_events + 1) * event_duration * frequency) + 1;
        EEG = eeg_eegrej(EEG, [1 start; stop EEG.pnts]);

        % epoching
        event = struct([]);
        for j = 1:(n_events+1)
            event(j).type = j;
            event(j).duration = event_duration;
            event(j).timestamp = [];
            event(j).latency = (j - 1) * event_duration * 250;
            event(j).urevent = j;
        end
        EEG.event = event;

        % create dummy epochs
        EEG = pop_epoch(EEG, { }, [0  event_duration]);

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

        % freq analysis
        cfg = [];
        cfg.method = 'mtmfft';
        cfg.output = 'fourier';
        cfg.foilim = [band.low_f, band.high_f];
        cfg.tapsmofrq = 1;
        cfg.pad = 'nextpow2';
        freq = ft_freqanalysis(cfg, data);

        % connectome wpli_debiased
        cfg = [];
        cfg.method = 'wpli_debiased';
        fc = ft_connectivityanalysis(cfg, freq);

        % mean
        mean_fc = mean(fc.wpli_debiasedspctrm, 3);

        % remove nan rows and columns
        mean_fc = mean_fc(:,~all(isnan(mean_fc)));
        mean_fc = mean_fc(~all(isnan(mean_fc), 2),:);

        % to positive numbers
        mean_fc = mean_fc + abs(min(min(mean_fc)));

        % set diagonal to 0
        mean_fc(1:1+size(mean_fc,1):end) = 0;

        % save the connectome
        save(strcat(fc_dir, name, band_suffix, '_mean_fc.mat'), 'mean_fc');
    end
end
