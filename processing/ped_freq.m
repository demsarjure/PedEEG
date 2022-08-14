%% init
addpath('../../eeglab2022.0')
addpath('../../fieldtrip')
run('../../eeglab2022.0/eeglab.m');
ft_defaults

% directories
data_dir = '../data/ped/';
eeg_dir = strcat(data_dir, 'eeg');

% iterate over both groups
for g = 1:2
    if g == 1
        subject_suffix = '';
        group_suffix = '';
        n = 25;
    else
        subject_suffix = 'T_';
        group_suffix = '_T';
        n = 29;
    end
    
    % storages
    names = strings(1,n);
    
    % metrics storage
    m = 0;
    M = zeros(n,1);
    
    % iterate over all subjects
    for i = 1:n
        % report
        disp(['===> Processing: ', num2str(i), '/', num2str(n)])
        
        % set subject
        subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));
    
        % store name
        names(i) = subject;
        
        % convert
        cleaned_set = strcat(subject, '_rest_cleaned.set');
        rest = pop_loadset(cleaned_set, eeg_dir);
        data = eeglab2fieldtrip(rest, 'raw', 'none');

        % surface laplacian
        cfg = [];
        cfg.method = 'finite';
        cfg.trials = 'all';
        data = ft_scalpcurrentdensity(cfg, data);

        % n_events
        n_events = size(data.trialinfo.type,1);
        
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
        
        % find peaks
        mean_ps = mean(fq.powspctrm);
        pks = findpeaks(mean_ps);
        
        % find max power
        if isempty(pks)
            m = NaN;
        else
            max_p = pks(1);
            ix = find(mean_ps == max_p);
            m = fq.freq(ix);
            for p = pks
                if (p > max_p)
                    ix = find(mean_ps == p);
                    m = fq.freq(ix);
                    max_p = p;
                end
            end
            
        end
        
        % append
        M(i,:) = m;
    end
    
    % merge
    metrics = table(names', M);
    writetable(metrics, strcat(data_dir, strcat('metrics_freq', group_suffix, '.csv')));
end