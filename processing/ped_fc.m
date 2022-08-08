%% init
addpath('../../eeglab2022.0')
addpath('../../fieldtrip')
run('../../eeglab2022.0/eeglab.m');
ft_defaults

%% functional connectome calculation
% directories
data_dir = '../data/ped/';
eeg_dir = strcat(data_dir, 'eeg');
fc_dir = strcat(data_dir, 'fc');

% iterate over both groups
for g = 1:2
    if g == 1
        subject_suffix = '';
        n = 25;
    else
        subject_suffix = 'T_';
        n = 29;
    end

    % iterate over all subjects
    for i = 1:n
        % report
        disp(['===> Processing: ', num2str(i), '/', num2str(n)])
        
        % set subject
        subject = strcat('PED_', subject_suffix, num2str(i, '%02.f'));
    
        % convert
        cleaned_set = strcat(subject, '_rest_cleaned.set');
        rest = pop_loadset(cleaned_set, eeg_dir);
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
        
        % remove nan rows and columns
        mean_fc = mean_fc(:,~all(isnan(mean_fc)));
        mean_fc = mean_fc(~all(isnan(mean_fc), 2),:);
        
        % to positive numbers
        mean_fc = mean_fc + abs(min(min(mean_fc)));
         
        % set diagonal to 0
        mean_fc(1:1+size(mean_fc,1):end) = 0;

        % save the connectome
        save(strcat(fc_dir, '/', subject, '_mean_fc.mat'), 'mean_fc');
    end
end