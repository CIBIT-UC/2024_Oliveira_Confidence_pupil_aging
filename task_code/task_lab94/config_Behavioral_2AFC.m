function [setup, dots, fix, results, sound, flip] = config_Behavioral_2AFC(setup, window1, audio)
% function for the configuration of the experimental design

% we created 5 levels of coherence for all people
setup.cohlevel1 = 0.03; 
setup.cohlevel2 = 0.06;  
setup.cohlevel3 = 0.12;
setup.cohlevel4 = 0.24;

setup.directions        = [180 0]; % up or down [90 270]
setup.totalntrials      = 48; % number of trials for this whole experiment %50!!! 90 %must be divisible by nblocks
setup.nblocks           = 1; % 1 %number of blocks (only one single block for each fmri run)
setup.ntrials           = setup.totalntrials/setup.nblocks; % total number of trials per block
setup.boldbase          = 10; % for fmri, the seconds of pre and post baseline for BOLD 
setup.TR                = 2; % to calculate frames for fmri mode (waiting for trigger to proceed)
    
% Timing...
% baseline pupil
setup.fixtime           = transpose(.5 + (5-1)*rand(setup.ntrials,1)) ;     % 2*ones(setup.nblocks, setup.ntrials); 
setup.viewingtime       = .75; %.75 % want 750 ms for real experiment; % maximum viewing duration in seconds
setup.maxRT             = 3 - setup.viewingtime; %2.25 %maximum time after stim offset for a response in seconds
setup.nframes           = ceil(setup.viewingtime * window1.frameRate); % number of frames the stimulus is displayed
 
if setup.feedback
    %  pupil rebound time BEFORE feedback
    setup.pupilreboundtime  = 3 + rand(setup.nblocks, setup.ntrials);
else
    % no pupil rebound1 time needed because no feedback
    % 50 ms after stim offset
    setup.pupilreboundtime  = .05*ones(setup.nblocks, setup.ntrials);
end
%  ITI (is also pupil rebound time AFTER feedback)
setup.pupilreboundtime2     = 1.5 + rand(setup.nblocks, setup.ntrials); %ITI


%% (output) dots: set stimuli (dots) parameters

% preallocate dots structure
[dots, fix]     = setupDots(window1, setup);

% !! this is very important, since it will determine which is the correct
% response on each individual trial
dots.direction          = repmat(setup.directions', [setup.ntrials setup.nblocks])';
dots.direction          = dots.direction(1:setup.nblocks,1:setup.ntrials); % get right number of trials
for i = 1:size(dots.direction,1) % shuffle
    dots.direction(i,:) = dots.direction(i,randperm(size(dots.direction,2)));  
end

% coherence levels, 2/3 hard, 1/3 easy
% nhard                   = floor(.67*setup.ntrials);
% neasy                   = setup.ntrials-nhard;
nlevel = floor(1/4*setup.ntrials);
dots.coherence = repmat([ones(1,nlevel)*setup.cohlevel1 ones(1,nlevel)*setup.cohlevel2 ones(1,nlevel)*setup.cohlevel3 ones(1,nlevel)*setup.cohlevel4],[setup.nblocks 1]);
for i = 1:size(dots.coherence,1) % shuffle
    dots.coherence(i,:) = dots.coherence(i,randperm(size(dots.coherence,2))); %randperm(size(dots.coherence,2))
end


%% audio

sound               = setupSounds(audio, setup);
sound.tones         = repmat([1 2]', [setup.ntrials setup.nblocks])';
sound.tones         = sound.tones(1:setup.nblocks,1:setup.ntrials);
for i = 1:size(sound.tones,1) % shuffle
    sound.tones(i,:) = sound.tones(i,randperm(size(sound.tones,2)));  
end   

%% (output) results: preallocate results structures

results.response                = NaN(setup.nblocks,setup.ntrials);
results.correct                 = NaN(setup.nblocks,setup.ntrials);
results.confidence              = NaN(setup.nblocks,setup.ntrials);
results.RT                      = NaN(setup.nblocks,setup.ntrials);
results.timing                  = NaN(setup.nblocks,2); % begin and end of block
%results.arousal                = NaN(setup.nblocks, setup.ntrials);
results.outputPhase             = NaN(setup.ntrials, 6); % for phases timing output
results.output                  = NaN(setup.ntrials, 6);  


% preallocate a full flip structure to store the output of every dynamic flip
flip.fix.VBL                = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.fixtime))/window1.frameDur));
flip.fix.StimOns            = flip.fix.VBL;
flip.fix.FlipTS             = flip.fix.VBL;
flip.fix.Missed             = flip.fix.VBL;
flip.fix.beampos            = flip.fix.VBL;

flip.stim.VBL               = nan(setup.nblocks, setup.ntrials, setup.nframes);
flip.stim.StimOns           = flip.stim.VBL;
flip.stim.FlipTS            = flip.stim.VBL;
flip.stim.Missed            = flip.stim.VBL;
flip.stim.beampos           = flip.stim.VBL;

flip.waitRT.VBL               = nan(setup.nblocks, setup.ntrials, ceil(setup.maxRT/window1.frameDur));
flip.waitRT.StimOns           = flip.waitRT.VBL;
flip.waitRT.FlipTS            = flip.waitRT.VBL;
flip.waitRT.Missed            = flip.waitRT.VBL;
flip.waitRT.beampos           = flip.waitRT.VBL;

flip.pupilrebound1.VBL        = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.pupilreboundtime))/window1.frameDur));
flip.pupilrebound1.StimOns    = flip.pupilrebound1.VBL;
flip.pupilrebound1.FlipTS     = flip.pupilrebound1.VBL;
flip.pupilrebound1.Missed     = flip.pupilrebound1.VBL;
flip.pupilrebound1.beampos    = flip.pupilrebound1.VBL;

flip.pupilrebound2.VBL        = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.pupilreboundtime2))/window1.frameDur));
flip.pupilrebound2.StimOns    = flip.pupilrebound2.VBL;
flip.pupilrebound2.FlipTS     = flip.pupilrebound2.VBL;
flip.pupilrebound2.Missed     = flip.pupilrebound2.VBL;
flip.pupilrebound2.beampos    = flip.pupilrebound2.VBL;

flip.bold1.VBL        = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.boldbase))/window1.frameDur));
flip.bold1.StimOns    = flip.bold1.VBL;
flip.bold1.FlipTS     = flip.bold1.VBL;
flip.bold1.Missed     = flip.bold1.VBL;
flip.bold1.beampos    = flip.bold1.VBL;

flip.bold2.VBL        = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.boldbase))/window1.frameDur));
flip.bold2.StimOns    = flip.bold2.VBL;
flip.bold2.FlipTS     = flip.bold2.VBL;
flip.bold2.Missed     = flip.bold2.VBL;
flip.bold2.beampos    = flip.bold2.VBL;

flip.trigger.VBL        = nan(setup.nblocks, setup.ntrials, ceil(max(max(setup.TR))/window1.frameDur));
flip.trigger.StimOns    = flip.trigger.VBL;
flip.trigger.FlipTS     = flip.trigger.VBL;
flip.trigger.Missed     = flip.trigger.VBL;
flip.trigger.beampos    = flip.trigger.VBL;

disp('configExperiment completed successfully')

end % end of the configExperiment function