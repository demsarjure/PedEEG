%% init
addpath('D:/Work/EEG/eeglab2022.0')
addpath('D:/Work/EEG/fieldtrip')
run('D:/Work/EEG/eeglab2022.0/eeglab.m');
ft_defaults

%% iterater over subjects
suffix = ''; % use T_ for test
n = 21; % use X for test

% dir
study_root = 'D:/Work/EEG/';
csv_dir = strcat(study_root, 'csv/');

% storages
names = strings(1,n);

% n metrics
n_metrics = 3;

% metrics storage
m = zeros(1,n_metrics);
M = zeros(n,n_metrics);

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % set subject
    subject = strcat('PED_', suffix, num2str(i, '%02.f'));
    directory = strcat('D:/Work/EEG/', subject);

    % store name
    names(i) = subject;
    
    % convert
    cleaned_set = strcat(subject, '_rest_cleaned.set');
    rest = pop_loadset(cleaned_set, directory);
    data = eeglab2fieldtrip(rest, 'raw', 'none');

    % surface laplacian
    cfg = [];
    cfg.method = 'finite';
    cfg.trials = 'all';
    data = ft_scalpcurrentdensity(cfg, data);
    
    % recreate sample info
    n_events = size(data.trialinfo.type,1);
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
writetable(metrics, strcat(csv_dir, 'metrics_freq_laplace.csv'));
