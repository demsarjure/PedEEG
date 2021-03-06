%% init
addpath('D:/Work/EEG/eeglab2022.0')
addpath('D:/Work/EEG/fieldtrip')
run('D:/Work/EEG/eeglab2022.0/eeglab.m');
ft_defaults

%% iterater over subjects
suffix = ''; % use T_ for test
n = 21;

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % set subject
    subject = strcat('PED_', suffix, num2str(i, '%02.f'));
    directory = strcat('D:/Work/EEG/', subject);

    % convert
    cleaned_set = strcat(subject, '_rest_cleaned_laplace.set');
    rest = pop_loadset(cleaned_set, directory);
    data = eeglab2fieldtrip(rest, 'raw', 'none');

    % surface laplacian
    cfg = [];
    cfg.method = 'finite';
    cfg.trials = 'all';
    data = ft_scalpcurrentdensity(cfg, data);
    
    % recreate sample info
    n_events = 120;
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
    cfg.foilim = [8, 13];
    cfg.tapsmofrq = 1;
    cfg.pad = 'nextpow2';
    freq = ft_freqanalysis(cfg, data);

    % connectome wpli_debiased
    cfg = [];
    cfg.method = 'wpli_debiased';
    fc = ft_connectivityanalysis(cfg, freq);

    % mean
    mean_fc = mean(fc.wpli_debiasedspctrm, 3);

    % save the connectome
    save(strcat(directory, '/', subject, '_mean_fc_laplace.mat'), 'mean_fc');

    % connectome correlation
    cfg = [];
    cfg.method = 'corr';
    fc = ft_connectivityanalysis(cfg, data);
    mean_fc = fc.corr;

    % save the connectome
    save(strcat(directory, '/', subject, '_mean_fc_corr_laplace.mat'), 'mean_fc');

    % connectome coherence
    cfg = [];
    cfg.method = 'coh';
    fc = ft_connectivityanalysis(cfg, freq);

    % mean
    mean_fc = mean(fc.cohspctrm, 3);

    % save the connectome
    save(strcat(directory, '/', subject, '_mean_fc_coh_laplace.mat'), 'mean_fc');
end
