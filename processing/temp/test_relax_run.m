%% RELAX works with absolute paths :(
eeg_path='D:/Work/EEG/';

%% init
addpath(strcat(eeg_path, 'eeglab2022.0'));
addpath(strcat(eeg_path, 'FastICA_25'));
addpath(strcat(eeg_path, 'mwf'));
addpath(strcat(eeg_path, 'eeglab2022.0/plugins/RELAX-1.1.1'));
run(strcat(eeg_path, 'eeglab2022.0/eeglab.m'));

%% prepare RELAX_cfg
% locations are already in .set files
RELAX_cfg.caploc=[];

% folder
RELAX_cfg.myPath=strcat(eeg_path, 'data/test/set/');
%RELAX_cfg.FilesToProcess=numel(RELAX_cfg.files);

% process a single file
RELAX_cfg.filename=strcat('PED_21.set');
RELAX_cfg.FilesToProcess=1;

% List all files in directory
cd(RELAX_cfg.myPath);
RELAX_cfg.dirList=dir('*.set');
RELAX_cfg.files={RELAX_cfg.dirList.name};
if isempty(RELAX_cfg.files)
    disp('No files found..')
end

RELAX_cfg.Do_MWF_Once=1; % 1 = Perform the MWF cleaning a second time (1 for yes, 0 for no).
RELAX_cfg.Do_MWF_Twice=1; % 1 = Perform the MWF cleaning a second time (1 for yes, 0 for no).
RELAX_cfg.Do_MWF_Thrice=1; % 1 = Perform the MWF cleaning a second time (1 for yes, 0 for no). I think cleaning drift in this is a good idea.
RELAX_cfg.Perform_wICA_on_ICLabel=1; % 1 = Perform wICA on artifact components marked by ICLabel (1 for yes, 0 for no).
RELAX_cfg.Perform_ICA_subtract=0; % 1 = Perform ICA subtract on artifact components marked by ICLabel (1 for yes, 0 for no) (non-optimal, intended to be optionally used separately to wICA rather than additionally)
RELAX_cfg.ICA_method='fastica_symm';
RELAX_cfg.Report_all_ICA_info='no'; % set to yes to provide detailed report of ICLabel artifact information. Runs ~20s slower per file.

RELAX_cfg.computerawmetrics=1; % Compute blink and muscle metrics from the raw data?
RELAX_cfg.computecleanedmetrics=1; % Compute SER, ARR, blink and muscle metrics from the cleaned data?

RELAX_cfg.MWFRoundToCleanBlinks=2; % Which round to clean blinks in (1 for the first, 2 for the second...)
RELAX_cfg.ProbabilityDataHasNoBlinks=1; % 0 = data almost certainly has blinks, 1 = data might not have blinks, 2 = data definitely doesn't have blinks.
% 0 = eg. task related data where participants are focused with eyes open, 
% 1 = eg. eyes closed recordings, but with participants who might still open their eyes at times, 
% 2 = eg. eyes closed resting with highly compliant participants and recordings that were strictly made only when participants had their eyes closed.

RELAX_cfg.DriftSeverityThreshold=10; %MAD from the median of all electrodes. This could be set lower and would catch less severe drift 
RELAX_cfg.ProportionWorstEpochsForDrift=0.20; % Maximum proportion of epochs to include in the mask from drift artifact type.

RELAX_cfg.ExtremeVoltageShiftThreshold=20; % Threshold MAD from the median all epochs for each electrode against the same electrode in different epochs. This could be set lower and would catch less severe voltage shifts within the epoch
RELAX_cfg.ExtremeAbsoluteVoltageThreshold=500; % microvolts max or min above which will be excluded from cleaning and deleted from data
RELAX_cfg.ExtremeImprobableVoltageDistributionThreshold=8; % Threshold SD from the mean of all epochs for each electrode against the same electrode in different epochs. This could be set lower and would catch less severe improbable data
RELAX_cfg.ExtremeSingleChannelKurtosisThreshold=8; % Threshold kurtosis of each electrode against the same electrode in different epochs. This could be set lower and would catch less severe kurtosis 
RELAX_cfg.ExtremeAllChannelKurtosisThreshold=8; % Threshold kurtosis across all electrodes. This could be set lower and would catch less severe kurtosis
RELAX_cfg.ExtremeDriftSlopeThreshold=-4; % slope of log frequency log power below which to reject as drift without neural activity
RELAX_cfg.ExtremeBlinkShiftThreshold=8; % How many MAD from the median across blink affected epochs to exclude as extreme data 
% (applies the higher value out of this value and the
% RELAX_cfg.ExtremeVoltageShiftThreshold above as the
% threshold, which caters for the fact that blinks don't affect
% the median, so without this, if data is clean and blinks are
% large, blinks can get excluded as extreme outliers)
            
% Clean periods that last for a shorter duration than the following value to be marked as artifacts, 
% and pad short artifact periods out into artifact periods of at least the following length when 
% they are shorter than this value to reduce rank deficiency issues in MWF cleaning). 
% Note that it's better to include clean periods in the artifact mask rather than the including artifact in the clean mask.
RELAX_cfg.MinimumArtifactDuration=1200; % in ms. It's better to make this value longer than 1000ms, as doing so will catch diminishing artifacts that aren't detected in a neighbouring 1000ms period, which might still be bad
RELAX_cfg.MinimumBlinkArtifactDuration=800; % blink marking is based on the maximum point of the blink rather than the 1000ms divisions for muscle artifacts, so this can be shorter than the value above (blinks do not typically last >500ms)

RELAX_cfg.BlinkElectrodes={'FP1';'FPZ';'FP2';'AF3';'AF4';'F3';'F1';'FZ';'F2';'F4'}; % sets the electrodes to average for blink detection using the IQR method. These should be frontal electrodes maximally affected by blinks. The order is the order of preference for icablinkmetrics.
% A single HOEG electrode for each side is selected by the script, prioritized in the following order (if the electrode in position 1 isn't present, the script will check for electrode in position 2, and so on...).
RELAX_cfg.HEOGLeftpattern = ["AF7", "F7", "FT7", "F5", "T7", "FC5", "C5", "TP7", "AF3"]; % sets left side electrodes to use for horizontal eye movement detection. These should be lateral electrodes maximally effected by blinks.
RELAX_cfg.HEOGRightpattern = ["AF8", "F8","FT8","F6","T8", "FC6", "C6", "TP8", "AF4"]; % sets right side electrodes to use for horizontal eye movement detection. These should be lateral electrodes maximally effected by blinks.
RELAX_cfg.BlinkMaskFocus=150; % this value decides how much data before and after the right and left base of the eye blink to mark as part of the blink artifact window. 
% I found 100ms on either side of the blink bases works best with a delay of 7 on the MWF. However, it also seemed to create too short artifact masks at times, which may lead to insufficient rank for MWF, so I left the default as 150ms.
RELAX_cfg.HorizontalEyeMovementType=2; % 1 to use the IQR method, 2 to use the MAD method for identifying threshold. IQR method less effective for smaller sample sizes (shorter files).
RELAX_cfg.HorizontalEyeMovementThreshold=2; % MAD deviation from the median that will be marked as horizontal eye movement if both lateral electrodes show activity above this for a certain duration (duration set below).
RELAX_cfg.HorizontalEyeMovementThresholdIQR=1.5; % If IQR method set above, IQR deviation that will be marked as horizontal eye movement if both lateral electrodes show activity above this for a certain duration (duration set below).
RELAX_cfg.HorizontalEyeMovementTimepointsExceedingThreshold=25; % The number of timepoints (ms) that exceed the horizontal eye movement threshold within the test period (set below) before the period is marked as horizontal eye movement.
RELAX_cfg.HorizontalEyeMovementTimepointsTestWindow=(2*RELAX_cfg.HorizontalEyeMovementTimepointsExceedingThreshold)-1; % Window duration to test for horizontal eye movement, set to 2x the value above by default.
RELAX_cfg.HorizontalEyeMovementFocus=200; % Buffer window, masking periods earlier and later than the time where horizontal eye movements exceed the threshold.

RELAX_cfg.HighPassFilter=0.25; % Sets the high pass filter. 1Hz is best for ICA decomposition if you're examining just oscillatory data, 0.25Hz seems to be the highest before ERPs are adversely affected by filtering 
%(lower than 0.2Hz may be better, but I find a minority of my files show drift at 0.3Hz even).
if RELAX_cfg.HighPassFilter>0.25
    Warning='You have high pass filtered above 0.25, which can adversely affect ERP analyses';
end
RELAX_cfg.LowPassFilter=80; % If you filter out data below 75Hz, you can't use the objective muscle detection method
RELAX_cfg.LineNoiseFrequency=50; % Frequencies for bandstop filter in order to address line noise (set to 60 in countries with 60Hz line noise, and 50 in countries with 50Hz line noise).

RELAX_cfg.ElectrodesToDelete={'Fp1'; 'Fp2'; 'TP9'; 'TP10'; 'FT9'; 'FT10';};
% If your EEG recording includes non-scalp electrodes or electrodes that you want to delete before cleaning, you can set them to be deleted here. 
% The RELAX cleaning pipeline does not need eye, heart, or mastoid electrodes for effective cleaning.

RELAX_cfg.KeepAllInfo=0; % setting this value to 1 keeps all the details from the MWF pre-processing and MWF computation. Helpful for debugging if necessary but makes for large file sizes.
RELAX_cfg.saveextremesrejected=0; % setting this value to 1 tells the script to save the data after only filtering, extreme channels have been rejected and extreme periods have been noted
RELAX_cfg.saveround1=0; % setting this value to 1 tells the script to save the first round of MWF pre-processing
RELAX_cfg.saveround2=0; % setting this value to 1 tells the script to save the second round of MWF pre-processing
RELAX_cfg.saveround3=0; % setting this value to 1 tells the script to save the third round of MWF pre-processing

RELAX_cfg.OnlyIncludeTaskRelatedEpochs=0; % If this =1, the MWF clean and artifact templates will only include data within 5 seconds of a task trigger (other periods will be marked as NaN, which the MWF script ignores).

RELAX_cfg.MuscleSlopeThreshold=-0.59; %log-frequency log-power slope threshold for muscle artifact. Less stringent = -0.31, Middle Stringency = -0.59 or more stringent = -0.72, more negative thresholds remove more muscle.
RELAX_cfg.MaxProportionOfDataCanBeMarkedAsMuscle=0.50;  % Maximum amount of data periods to be marked as muscle artifact for cleaning by the MWF. You want at least a reasonable amount of both clean and artifact templates for effective cleaning.
% I set this reasonably high, because otherwise muscle artifacts could considerably influence the clean mask and add noise into the data
RELAX_cfg.ProportionOfMuscleContaminatedEpochsAboveWhichToRejectChannel=0.05; % If the proportion of epochs showing muscle activity from an electrode is higher than this, the electrode is deleted. 
% Set muscle proportion before deletion to 1 to not delete electrodes based on muscle activity
RELAX_cfg.ProportionOfExtremeNoiseAboveWhichToRejectChannel=0.05; % If the proportion of all epochs from a single electrode that are marked as containing extreme artifacts is higher than this, the electrode is deleted

RELAX_cfg.MaxProportionOfElectrodesThatCanBeDeleted=0.40; % Sets the maximum proportion of electrodes that are allowed to be deleted after PREP's bad electrode deletion step

RELAX_cfg.MWFDelayPeriod=8; % The MWF includes both spatial and temporal information when filtering out artifacts. Longer delays apparently improve performance. 

%% run
[RELAX_cfg, FileNumber, CleanedMetrics, RawMetrics, RELAXProcessingRoundOneAllParticipants, RELAXProcessingRoundTwoAllParticipants, RELAXProcessing_wICA_AllParticipants,...
        RELAXProcessing_ICA_AllParticipants, RELAXProcessingRoundThreeAllParticipants, RELAX_issues_to_check, RELAXProcessingExtremeRejectionsAllParticipants] = RELAX_Wrapper (RELAX_cfg);
