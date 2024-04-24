function [edfFile] = ELconfig(window1, setup)

% setup the Eyelink initialization at the beginning of each block - code from ENS, Paris
dummymode = 0; % set to 1 to run in dummymode (using mouse as pseudo-eyetracker)
el = EyelinkInitDefaults(window1.h);

% turn the calibration background black - similar luminance as experiment
el.msgfontcolour    = window1.black;
el.imgtitlecolour   = window1.black;
el.calibrationtargetcolour = window1.black;
el.backgroundcolour = [118 118 118];

EyelinkUpdateDefaults(el);

% Initialization of the connection with the Eyelink Gazetracker
if ~EyelinkInit(dummymode, 1)
    fprintf('Eyelink Init aborted.\n');
sca

cleanup(useTrigger);  % cleanup function
    return
end

[v, vs ]    = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

% make sure that we get event data from the Eyelink
% Eyelink('command', 'file_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS'); %"file_sample_data" specifies what type of samples will be wrtten to the EDF file
% Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS'); %"link_sample_data" specifies what type of samples will be sent to link
% Eyelink('command', 'drift_correct_cr_disable = OFF'); % To enable the drift correction procedure to adjust the calibration rather than simply allowing a drift check

Eyelink('command', 'select_parser_configuration = 1'); % most sensitive configuration
%what do we want to record
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET');
Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET'); %"link_sample_data" specifies what type of samples will be sent to link
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');


% open edf file for recording data from Eyelink
% create a temporary name for this (has to be short)
EDFname = sprintf('P%d_%d%d%d', setup.participant, setup.session, setup.moment, setup.run);

edfFile = [EDFname '.edf'];
Eyelink('Openfile', edfFile);

% Calibrate the eye tracker
% set calibration type.
Eyelink('command','auto_calibration_messages = YES');
    % set calibration type.
Eyelink('command', 'calibration_type = HV9');
% you must send this command with value NO for custom calibration
% you must also reset it to YES for subsequent experiments
Eyelink('command', 'generate_default_targets = NO');

% modify calibration and validation target locations
calfact = .3;
Eyelink('command','calibration_samples = 10');
Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
    window1.width_px/2,window1.height_px/2,  window1.width_px/2,window1.height_px*calfact,...
    window1.width_px/2,window1.height_px-window1.height_px*calfact,  window1.width_px*calfact,window1.height_px/2,...
    window1.width_px-window1.width_px*calfact,window1.height_px/2, ...
    window1.width_px*calfact,window1.height_px*calfact, window1.width_px-window1.width_px*calfact,window1.height_px-window1.height_px*calfact,...
    window1.width_px-window1.width_px*calfact,window1.height_px*calfact, window1.width_px*calfact,window1.height_px-window1.height_px*calfact);

Eyelink('command','validation_samples = 10');
Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
Eyelink('command','validation_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
    window1.width_px/2,window1.height_px/2,  window1.width_px/2,window1.height_px*calfact,...
    window1.width_px/2,window1.height_px-window1.height_px*calfact,  window1.width_px*calfact,window1.height_px/2,...
    window1.width_px-window1.width_px*calfact,window1.height_px/2, ...
    window1.width_px*calfact,window1.height_px*calfact, window1.width_px-window1.width_px*calfact,window1.height_px-window1.height_px*calfact,...
    window1.width_px-window1.width_px*calfact,window1.height_px*calfact, window1.width_px*calfact,window1.height_px-window1.height_px*calfact);


EyelinkDoTrackerSetup(el);

% see email Marcus from SR research, 3 Feb 2015
Eyelink('command', 'set_idle_mode');
WaitSecs(0.05);

% start recording eye position
Eyelink('StartRecording');
% record a few samples before we actually start displaying
WaitSecs(0.1);
% mark zero-plot time in data file
Eyelink('message', 'start recording Eyelink');

end