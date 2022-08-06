%% init
addpath('../../eeglab2022.0')
addpath('../../fieldtrip')
run('../../eeglab2022.0/eeglab.m');
ft_defaults

%% iterater over subjects
subject_suffix = ''; % use T_ for test
fc_suffix = '_laplace'; % use '' for no surface laplacian
n = 25; % use 29 for test

% iterate over all subjects
for i = 1:n
    % report
    disp(['===> Processing: ', num2str(i), '/', num2str(n)])
    
    % set subject
    subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));
    directory = strcat('../../', subject);

    % convert
    cleaned_set = strcat(subject, '_rest_cleaned', fc_suffix, '.set');
    rest = pop_loadset(cleaned_set, directory);
    data = eeglab2fieldtrip(rest, 'raw', 'none');

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
    save(strcat(directory, '/', subject, '_mean_fc', fc_suffix, '.mat'), 'mean_fc');

    % connectome correlation
    cfg = [];
    cfg.method = 'corr';
    fc = ft_connectivityanalysis(cfg, data);
    mean_fc = fc.corr;

    % save the connectome
    save(strcat(directory, '/', subject, '_mean_fc_corr', fc_suffix, '.mat'), 'mean_fc');

    % connectome coherence
    cfg = [];
    cfg.method = 'coh';
    fc = ft_connectivityanalysis(cfg, freq);

    % mean
    mean_fc = mean(fc.cohspctrm, 3);

    % save the connectome
    save(strcat(directory, '/', subject, '_mean_fc_coh', fc_suffix, '.mat'), 'mean_fc');
end
