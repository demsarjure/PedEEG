%% init
addpath('../../../eeglab2022.0')
addpath('../../../fieldtrip')
run('../../../eeglab2022.0/eeglab.m');
ft_defaults

%% set subject
subject = 'PED_T_07';
disp(['Subject ', subject])

%% load the data
raw = pop_fileio(strcat('../../../data/test/eeg/', subject, '/', subject, '.vhdr'), 'dataformat', 'auto');
raw.setname = 'raw';

%% load electrode locations
raw = pop_editset(raw, 'run', [], 'chanlocs', '../../../64BPMR+ref.ced');

%% extract data with eyes closed
start = raw.event(8).latency;
stop = start + 360000 + 1;
rest_raw = eeg_eegrej(raw, [1 start; stop raw.pnts]);
rest_raw.setname = 'rest_raw';

%% filtering
rest_raw = pop_eegfiltnew(rest_raw, 'locutoff', 40, 'hicutoff', 0.5);

%% inspect manually
pop_eegplot(rest_raw, 1, 1, 1);

%% plot spectral
figure; pop_spectopo(rest_raw, 1, [0  360000], 'EEG' , 'percent', 50, 'freqrange', [2 25], 'electrodes', 'off');

%% remove bad electrodes
bad_electrodes = [21, 33, 34, 36, 37, 55, 62, 63];
rest = pop_select(rest_raw, 'nochannel', bad_electrodes);
rest.setname = 'rest_cleaned';

%% interpolate
rest = pop_interp(rest, rest_raw.chanlocs, 'spherical');

%% inspect manually
pop_eegplot(rest, 1, 1, 1);

%% plot spectral
figure; pop_spectopo(rest, 1, [0  360000], 'EEG' , 'percent', 50, 'freqrange', [2 25], 'electrodes', 'off');

%% downsample to 250hz
frequency = 250;
rest = pop_resample(rest, frequency);

%% rereferencing
%rest = pop_reref(rest, []);

%% create dummy events
n_events = 250;
event_duration = 1;
event = struct([]);
for i = 1:n_events
    event(i).type = i;
    event(i).duration = event_duration;
    event(i).timestamp = [];
    event(i).latency = (i - 1) * event_duration * frequency + 1;
    event(i).urevent = 1;
end
rest.event = event;

%% epoching
% create dummy epochs
rest = pop_epoch(rest, { }, [0  event_duration]);

%% manual inspection for picking good epochs
pop_eegplot(rest, 1, 1, 1);

%% use only 120 good
good_epochs = [4:15, 19:70, 159:214];

%% filter good epochs
rest = pop_select(rest, 'trial', good_epochs);

%% save
pop_saveset(rest, 'filename', strcat(subject, '_rest_cleaned.set'), 'filepath', '../../data/test/eeg/');
