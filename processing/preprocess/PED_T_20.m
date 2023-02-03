%% init
addpath('../../../eeglab2022.0')
run('../../../eeglab2022.0/eeglab.m');

%% set subject
subject = 'PED_T_20';
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
side_electrodes = [1, 2, 29, 30, 60, 61];
bad_electrodes = [3, 6, 7, 10, 33, 36, 37, 62, 63, 64];
remove_electrodes = [side_electrodes, bad_electrodes];
rest = pop_select(rest_raw, 'nochannel', remove_electrodes);
rest.setname = 'rest_cleaned';

%% interpolate
rest = pop_interp(rest, rest_raw.chanlocs, 'spherical');
rest = pop_select(rest, 'nochannel', side_electrodes);

%% inspect manually
pop_eegplot(rest, 1, 1, 1);

%% plot spectral
figure; pop_spectopo(rest, 1, [0  360000], 'EEG' , 'percent', 50, 'freqrange', [2 25], 'electrodes', 'off');

%% downsample to 250hz
frequency = 250;
rest = pop_resample(rest, frequency);

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
good_epochs = [8:19, 26:32, 37:42, 78:102, 118:127, 137:164, 180:191, 196:201, 235:241, 244:250];

%% filter good epochs
rest = pop_select(rest, 'trial', good_epochs);

%% save
pop_saveset(rest, 'filename', strcat(subject, '_rest_cleaned.set'), 'filepath', '../../data/test/eeg/');
