%% Main code for RT experiment with EyeLink and feedback and arousal modulation (white noise)
% Behavioral phases
% phase 1 - baseline period
% phase 2 - only in fMRI version (NOT NEEDED)
% phase 3 - decision period (750 ms)
% phase 4 - stim offset -> response
% phase 5 - response -> feedback
% phase 6 - ITI after feedback

% Behavioral output
% column 1 - coherence
% column 2 - direction
% column 3 - response
% column 4 - correct
% column 5 - confidence
% column 6 - RT
% column 7 - tone

close all; clear all; clc; dbstop if error;
addpath('D:\Project_Exercise_SaraOliveira\SaraOliveira_task\common_functions');

 
%% SETUP
setup.scanner      = 6;  % 1 = Roeterseiland, 2 = 7T AMC, 3 = 3T AMC (4 = O' Big Mac, 5 = O's laptop, 6 = lab 2.19)
setup.Eye          = true;
setup.feedback     = true;
setup.arouse       = true; % turn on sound noise
setup.fmri         = false; % switches keys at scanner
setup.debug        = false;
setup.example      = false;
setup.localizer    = false; % for EyeLink EDF file names
setup.startatblock = 1;
setup.cancel       = false;
showgraphs         = true; % generate plots

%-------------
% If example, don't record EyeLink data
%-------------
if setup.example
    setup.Eye = false;
    setup.arouse = false;
end
%-------------
% Ask for subject number, default = 0
%-------------
setup.participant       = input('Participant number? ');
if isempty(setup.participant)
    setup.participant   = 100;
end   
%-------------
% Ask for session number, default = 0 (1 or 2)
%-------------
setup.session           = input('Session?');
if isempty(setup.session)
    setup.session       = 0;
end
% %-------------
% % Ask for moment, default = 0 (1 - before or 2 - after exercise/cognitive)
% %-------------
setup.moment       = input('Moment? ');
if isempty(setup.moment)
    setup.moment   = 0;
end
%-------------
% Ask for run number, default = 0 (1, 2, 3 or 4 before and 1, 2, 3 or 4 after)
%-------------
setup.run               = input('Run? ');
if isempty(setup.run)
    setup.run           = 0;
end

%-------------
commandwindow;
% ListenChar(2);
%-------------

%-------------
% window1 settings
%-------------
window1 = define_window(setup); % acho que isto nao faz nada - comentei  MariaRibeiro
window1.skipChecks      = 1;
window1        = SetupPTB(window1, setup); %load all the psychtoolbox things

%-------------
% REFRESH RATE
%-------------
window1 = define_refresh(setup, window1);

%-------------
% Present loading text on the screen
%-------------
Screen('TextSize', window1.h, 30);
Screen('TextFont', window1.h, 'Trebuchet');
Screen('TextColor', window1.h, [255 255 255] );
Screen('DrawText', window1.h, 'Loading...', window1.center(1), window1.center(2));
Screen('Flip', window1.h);

%-------------
% INITIALIZE EXPERIMENTAL PARAMETERS
%-------------
freq = 48000;
audio           = [];
audio.freq      = 48000; % 48000 for Spinoza Roeterseiland, 2 Channel
% open default soundport, in stereo (to match the sound matrix we create)
audio.pahandle = PsychPortAudio('Open', [], [], 2, freq);

[setup, dots, fix, results, sound, flip] = config_Behavioral_2AFC(setup, window1, audio);
missedfile = audioread('nãorespondeuSom.mp3');   
correctfile = audioread('certoSom.mp3');
wrongfile = audioread('erradoSom.mp3');  

%-------------
% fixation cross colors for feedback
%-------------
white   = [255,255,255];
color   = white; %fixation cross white

%-------------
% INITIALIZE DOT COORDINATES
%-------------
stim = nan(setup.nblocks, setup.ntrials, setup.nframes, 2, dots.nDots);
for block = setup.startatblock : setup.nblocks
    for trial = 1 : setup.ntrials
        %-------------
        % Preload all the dot coordinates before starting the trial
        %-------------
        stim(block, trial, :, :, :)      = dots_limitedlifetime(setup, window1, dots, block, trial);
        if ~ isempty(Screen('windows')) %if there is a window1 open
            Screen('DrawText',window1.h, sprintf('Loading %d percent', ...
                round(sub2ind([setup.ntrials setup.nblocks ], trial, block)/setup.totalntrials*100)), ...
                window1.center(1), window1.center(2));
            Screen('Flip', window1.h);
        end
    end % end loop over trials
end % end loop over blocks

%% -------------
% OUTPUT FILE 
%-------------
for block = setup.startatblock : setup.nblocks
    % Get Time Stamp
    outfile1name = sprintf('Phases_Participant%d_s%d_m%d_r%d.txt',setup.participant, num2str(setup.session), setup.moment, setup.run); % name of output file
    outfile1 = ['Data/Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run) '/' outfile1name];
    fid1 = fopen(outfile1name,'w');
    % Conditions and Behavior
    outfile2name = sprintf('Behav_Participant%d_s%d_m%d_r%d.txt',setup.participant,num2str(setup.session), setup.moment,setup.run); % name of output file
    outfile2 = ['Data/Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run) '/' outfile2name];    
    fid2 = fopen(outfile2name,'w');
end

%create folder for each participant in the Data folder
F = 'Data';
mkdir(F, ['Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run)])

%% INSTRUCTIONS
%-------------
% VARIABLE TO COUNT TOTAL POINTS IN THE TASK
points = 0;
%-------------

% TRIGGER DISABLED FOR RUNNING DURING SCANNING!
DisableKeysForKbCheck('t'); 
%--------------------------
Screen('FillRect', window1.h, [118 118 118]);

if setup.feedback
    Screen('TextSize', window1.h, 30);            
    DrawFormattedText(window1.h, ['Por favor, desligue ou tire o som ao telemóvel. \n'...
        'Obrigada! \n\n',...
        'NÃO SE ESQUEÇA: OLHE SEMPRE PARA O PONTO DE FIXAÇÃO! \n\n\n'...
        'Carregue numa tecla para avançar.'], 'center', 'center');    
    Screen('Flip', window1.h);
end

WaitSecs(.1); KbWait(); WaitSecs(.1); 

DrawFormattedText(window1.h, ['Caso tenha alta confiança na resposta utilize as TECLAS EXTERIORES "z" e "m", \n\n '...
    'receberá 5 pontos se a resposta estiver certa e perderá 5 se estiver errada. \n\n\n '...
    'Caso tenha baixa confiança na resposta utilize as TECLAS INTERIORES "x" e "n",  \n\n'...
    'receberá 3 pontos se a resposta estiver certa e perderá 3 se estiver errada. \n\n\n'...
    'Caso NÃO RESPONDA perderá 10 pontos. \n\n\n'...
    'Carregue numa tecla para começar.'],  'center', 'center');
Screen('Flip', window1.h);

WaitSecs(.1); KbWait(); WaitSecs(.5);

%-------------
% Initialize EyeLink
%-------------
if setup.Eye == true
    edfFile = ELconfig(window1, setup);
    Eyelink ('Message', sprintf('EyeLink configured at %d', GetSecs));           
end 
fprintf('EyeLink configured at %d \n', GetSecs);

BEGIN  = GetSecs;

%% LOOP OVER BLOCKS
for block = setup.startatblock : setup.nblocks
    %-------------
    % Initialize EyeLink (if more than one block)
    %-------------
    if setup.Eye
        if block > 1
            edfFile = ELconfig(window1, setup, block);
        end
        % beginning of pupil time course
        Eyelink ('Message', sprintf('measuring started at %d', GetSecs));           
        %WaitSecs(2);
    end 
    fprintf('measuring started at %d \n', GetSecs);

    %% LOOP OVER TRIALS
    for trial = 1 : setup.ntrials
        %-------------
        % BASELINE STAGE BEGINS
        % PHASE 1
        %-------------        
        if setup.Eye 
            Eyelink ('Message', sprintf('trial %i phase 1 started at %d ', trial, GetSecs));
        end
%         fprintf('trial %i phase 1 started at %d \n', trial, GetSecs); 
        if trial == 1
            TimingCnt = GetSecs + window1.frameDur - window1.slack;
        else 
            TimingCnt = flip.pupilrebound2.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;
        end
        
        for frameNum = 1:ceil(setup.fixtime(block,trial)*window1.frameRate)
            window1      = dots_noise(window1, dots);
            window1      = drawFixationABC(window1, white); % fixation
            Screen('DrawingFinished', window1.h); % helps with managing the flip performance
            
            [flip.fix.VBL(block, trial, frameNum), ...
                flip.fix.StimOns(block, trial, frameNum), ...
                flip.fix.FlipTS(block, trial, frameNum), ...
                flip.fix.Missed(block, trial, frameNum), ...
                flip.fix.beampos(block, trial, frameNum)] = Screen('Flip', window1.h, TimingCnt);
            TimingCnt = flip.fix.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;
        end % frames
        
        % phase 1
        results.outputPhase(trial, 1) = flip.fix.StimOns(block, trial, 1);  
     
        %-------------
        % PHASE 2      
        % phase 2 - only for fMRI version
        results.outputPhase(trial, 2) = NaN;  
        
     %% DECISION STAGE BEGINS 
     %-------------
     % PHASE 3
     % Dot motion: coherence + noise
     % 750 ms
     %-------------         
        %-------------
        % PRESENT STIMULUS for a fixed duration or until RT
        %-------------
        TimingCnt = flip.fix.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;           
        %-------------
        % Play arousal tone at signal onset
        %-------------
        if setup.arouse
            tone = sound.tones(block,trial);
            PsychPortAudio('FillBuffer', audio.pahandle, sound.tonebuf);
            PsychPortAudio('SetLoop', audio.pahandle, sound.tonepos(tone,1), sound.tonepos(tone,2));
        end
   
        for frameNum = 1:setup.nframes            
            %-------------
            % Draw all dots at once
            %-------------
            window1  = drawAllDots(window1, dots, block, trial, stim, frameNum);
            %-------------
            % Draw the fixation and flip
            %-------------
            if frameNum == 1 && setup.arouse
                PsychPortAudio('Start', audio.pahandle, 1, TimingCnt); %like flip 
                if setup.Eye
                    Eyelink ('Message', sprintf('trial %i stimulus at %d coherence %f direction %d ', trial, GetSecs, dots.coherence(block,trial), dots.direction(block,trial)));
                end
%                 fprintf('trial %i stimulus at %d coherence %f direction %d \n', trial, GetSecs, dots.coherence(block,trial), dots.direction(block,trial));
            elseif frameNum == setup.nframes
                fix.flip   = 0; % end flip
            end
            
            window1  = drawFixationABC(window1, white); % fixation
            Screen('DrawingFinished', window1.h); % helps with managing the flip performance
            
            [flip.stim.VBL(block, trial, frameNum), ...
                flip.stim.StimOns(block, trial, frameNum), ...
                flip.stim.FlipTS(block, trial, frameNum), ...
                flip.stim.Missed(block, trial, frameNum), ...
                flip.stim.beampos(block, trial, frameNum)] = Screen('Flip', window1.h, TimingCnt);
            TimingCnt = flip.stim.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;            

            [keyIsDown, secs, keyCode] = KbCheck();
            if keyIsDown %&& isnan(results.RT(block,trial)) % if they did not already respond during the stimulus
                keypressed = KbName(keyCode);
                if ischar(keypressed)
                    %-------------
                    % Only break if keypressed is a char - avoids crashes when two keys are pressed at the same time (keypressed will be a cell)
                    %-------------
                    %-------------
                    % Log responses in Results
                    %-------------       
                        if ~isempty(keypressed) 
                            %-------------
                            % Calculate RT
                            %-------------
                            results.RT(block, trial)    = secs - flip.stim.VBL(block,trial, 1);
                            %-------------
                            % Record the actual button press
                            %-------------
                            results.key{block, trial}   = keypressed;
                            %-------------
                            % Record the answer
                            %-------------
                            switch keypressed
                                case {'z','x'}
                                    results.response(block, trial) = 180;
                                    if keypressed == 'z'
                                        results.confidence(block, trial) = 1;
                                    elseif keypressed == 'x'
                                        results.confidence(block, trial) = 0;
                                    end
                                case {'m','n'}
                                    results.response(block, trial) = 0;                                    
                                    if keypressed == 'm'
                                        results.confidence(block, trial) = 1;
                                    elseif keypressed == 'n'
                                        results.confidence(block, trial) = 0;
                                    end
                                case 'ESCAPE'  %if escape is pressed, exit the experiment
                                    disp('ESCAPE key pressed')
                                    setup.cancel = true;
                                    results.response(block, trial) = NaN;
                                    results.confidence(block, trial) = NaN;
                                    if setup.Eye
                                        % close the eyelink
                                        Eyelink('StopRecording');
                                        Eyelink('CloseFile');
                                    end 
                                case 'esc'  %if escape is pressed, exit the experiment
                                    disp('esc key pressed')
                                    setup.cancel = true;
                                    results.response(block, trial) = NaN;
                                    results.confidence(block, trial) = NaN;
                                    if setup.Eye
                                        % close the eyelink
                                        Eyelink('StopRecording');
                                        Eyelink('CloseFile');
                                    end 
                                case 'q'    %if q is pressed, exit the experiment
                                    disp('Q key pressed')
                                    setup.cancel = true;
                                    results.response(block, trial) = NaN;
                                    results.confidence(block, trial) = NaN;
                                    if setup.Eye
                                        % close the eyelink
                                        Eyelink('StopRecording');
                                        Eyelink('CloseFile');
                                    end 
                                otherwise %if any other key was pressed, fill in a NaN
                                    disp('other key pressed')
                                    results.response(block, trial) = NaN;
                                    results.confidence(block, trial) = NaN;
                            end % end switch

                        else %if keypressed is empty, the maximum response time was reached and no response recorded
                            results.response(block, trial) = NaN;
                            results.confidence(block, trial) = NaN;
                            results.RT(block, trial)    = NaN;
                        end % if keypressed & not pulse
                    %-------------
                    % CODE CORRECT RESPONSE
                    %-------------  
                    if results.response(block, trial) == dots.direction(block,trial) % correct
                        results.correct(block,trial) = true;
                        if (keypressed == 'z') || (keypressed == 'm')
                            points = points + 5;
                        elseif (keypressed == 'x') || (keypressed == 'n')
                            points = points + 3;
                        end
                    elseif isnan(results.response(block, trial)) % missed
                        results.correct(block,trial) = NaN;
                        results.RT(block,trial) = NaN; %set RT to NaN to easily filter out trials without a response
                    else
                        results.correct(block,trial) = false; % wrong trial
                        if (keypressed == 'z') || (keypressed == 'm')
                            points = points - 5;
                        elseif (keypressed == 'x') || (keypressed == 'n')
                            points = points - 3;
                        end
                    end
                    if setup.Eye                        
                        Eyelink ('Message', sprintf('trial %i key %i at %d response %d RT %d accuracy %d ', trial, find(keyCode==1), secs, results.response(block,trial), results.RT(block,trial), results.correct(block,trial))); 
                        %RT, response e accuracy
                    end
%                     fprintf('trial %i key %i at %d response %d RT %d accuracy %d \n', trial, find(keyCode==1), secs, results.response(block,trial), results.RT(block,trial), results.correct(block,trial));
                    %-------------
                    % Exit the loop over frames if a response is made
                    %-------------  
                    break                              
                elseif ischar(keypressed) && strcmp(keypressed, 't')
                    %-------------
                    % log pulse timing
                    %-------------
                    pressedCodes                                        = find(keyCode == 1);
                    results.pulsecount                                  = results.pulsecount + 1;
                    results.scannerpulses.key(results.pulsecount)       = KbName(pressedCodes);
                    results.scannerpulses.trialtime(results.pulsecount) = secs - BEGIN;
                    results.scannerpulses.seconds(results.pulsecount)   = secs;
                    if setup.Eye                        
                        Eyelink ('Message', sprintf('trial %i key 116 at %d ', trial, results.scannerpulses.seconds(results.pulsecount))); WaitSecs(.0005);
                    end
                end %ischar & strcmp
            elseif ~isnan(results.RT(block,trial))
                % already responded, so break loop
                % disp('breaking at frame '); disp(frameNum);
                break
            else
                keypressed = [];
            end % keyisdown           

        end % stim frames
                
        % phase 3
        results.outputPhase(trial, 3) = flip.stim.StimOns(block, trial, 1);  
        
    %% DELAY PERIOD (stim offset - before response)        
     %-------------
     % PHASE 4
     % random dot motion until a response is made
     %-------------
        TimingCnt = flip.stim.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;
    
        for frameNum = 1:ceil(setup.maxRT*window1.frameRate)
                window1      = dots_noise(window1, dots);
                window1      = drawFixationABC(window1, white); % fixation
                Screen('DrawingFinished', window1.h); % helps with managing the flip performance
                
                [flip.waitRT.VBL(block, trial, frameNum), ...
                    flip.waitRT.StimOns(block, trial, frameNum), ...
                    flip.waitRT.FlipTS(block, trial, frameNum), ...
                    flip.waitRT.Missed(block, trial, frameNum), ...
                    flip.waitRT.beampos(block, trial, frameNum)] = Screen('Flip', window1.h, TimingCnt);
                TimingCnt = flip.waitRT.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;      
    
                %-------------
                % Check for response given
                %-------------
                [keyIsDown, secs, keyCode] = KbCheck();

                if isnan(results.RT(block,trial)) % if they did not already respond during the stimulus
                    keypressed = KbName(keyCode);
                    if ischar(keypressed)
                        %-------------
                        % Only break if keypressed is a char - avoids crashes when two keys are pressed at the same time (keypressed will be a cell)
                        %-------------
                        %-------------
                        % Log responses in Results
                        %-------------       
                            if ~isempty(keypressed) 
                                %-------------
                                % Calculate RT
                                %-------------
                                results.RT(block, trial)    = secs - flip.stim.VBL(block,trial, 1);
                                %-------------
                                % Record the actual button press
                                %-------------
                                results.key{block, trial}   = keypressed;
                                %-------------
                                % Record the answer
                                %-------------
                                switch keypressed
                                    case {'z','x'}
                                        results.response(block, trial) = 180;                                    
                                        if keypressed == 'z'
                                            results.confidence(block, trial) = 1;
                                        elseif keypressed == 'x'
                                            results.confidence(block, trial) = 0;
                                        end
                                    case {'m','n'}
                                        results.response(block, trial) = 0;                                    
                                        if keypressed == 'm'
                                            results.confidence(block, trial) = 1;
                                        elseif keypressed == 'n'
                                            results.confidence(block, trial) = 0;
                                        end
                                    case 'ESCAPE' % if escape is pressed, exit the experiment
                                        disp('ESCAPE key pressed')
                                        setup.cancel = true;
                                        results.response(block, trial) = NaN;
                                        results.confidence(block, trial) = NaN;
                                        if setup.Eye
                                            % close the eyelink
                                            Eyelink('StopRecording');
                                            Eyelink('CloseFile');
                                        end 
                                    case 'esc' % if escape is pressed, exit the experiment
                                        disp('esc key pressed')
                                        setup.cancel = true;
                                        results.response(block, trial) = NaN;
                                        results.confidence(block, trial) = NaN;
                                        if setup.Eye
                                            % close the eyelink
                                            Eyelink('StopRecording');
                                            Eyelink('CloseFile');
                                        end 
                                    case 'q' % if q is pressed, exit the experiment
                                        disp('Q key pressed')
                                        setup.cancel = true;
                                        results.response(block, trial) = NaN;
                                        results.confidence(block, trial) = NaN;
                                        if setup.Eye
                                            % close the eyelink
                                            Eyelink('StopRecording');
                                            Eyelink('CloseFile');
                                        end 
                                    otherwise % if any other key was pressed, fill in a NaN
                                        disp('other key pressed')
                                        results.response(block, trial) = NaN;
                                        results.confidence(block, trial) = NaN;
                                end % end switch

                            else %if keypressed is empty, the maximum response time was reached and no response recorded
                                results.response(block, trial) = NaN;
                                results.confidence(block, trial) = NaN;
                                results.RT(block, trial)    = NaN;
                            end % if keypressed & not pulse
                        %-------------
                        % CODE CORRECT RESPONSE
                        %-------------  
                        if results.response(block, trial) == dots.direction(block,trial) % correct
                            results.correct(block,trial) = true;
                            if (keypressed == 'z') || (keypressed == 'm')
                                points = points + 5;
                            elseif (keypressed == 'x') || (keypressed == 'n')
                                points = points + 3;
                            end
                        elseif isnan(results.response(block, trial)) % missed
                            results.correct(block,trial) = NaN;
                            results.RT(block,trial) = NaN; %set RT to NaN to easily filter out trials without a response
                        else
                            results.correct(block,trial) = false; % wrong trial
                            if (keypressed == 'z') || (keypressed == 'm')
                                points = points - 5;
                            elseif (keypressed == 'x') || (keypressed == 'n')
                                points = points - 3;
                            end
                        end
                        if setup.Eye                        
                            Eyelink ('Message', sprintf('trial %i key %i at %d response %d RT %d accuracy %d ', trial, find(keyCode==1), secs, results.response(block,trial), results.RT(block,trial), results.correct(block,trial))); 
                            %RT, response e accuracy
                        end
                        fprintf('trial %i key %i at %d response %d RT %d accuracy %d \n', trial, find(keyCode==1), secs, results.response(block,trial), results.RT(block,trial), results.correct(block,trial));
                        %-------------
                        % Exit the loop over frames if a response is made
                        %-------------  
                        break                              
                    elseif ischar(keypressed) && strcmp(keypressed, 't')
                        %-------------
                        % log pulse timing
                        %-------------
                        pressedCodes                                        = find(keyCode == 1);
                        results.pulsecount                                  = results.pulsecount + 1;
                        results.scannerpulses.key(results.pulsecount)       = KbName(pressedCodes);
                        results.scannerpulses.trialtime(results.pulsecount) = secs - BEGIN;
                        results.scannerpulses.seconds(results.pulsecount)   = secs;
                        if setup.Eye                        
                            Eyelink ('Message', sprintf('trial %i response at %d ', trial, results.scannerpulses.seconds(results.pulsecount))); WaitSecs(.0005);
                        end
                    end %ischar & strcmp
                elseif ~isnan(results.RT(block,trial))
                    % already responded, so break loop
                    % disp('breaking at frame '); disp(frameNum);
                    break
                else
                    keypressed = [];
                end % keyisdown           
        end % for setup.maxRT
        
        % phase 4
        results.outputPhase(trial, 4) = flip.waitRT.StimOns(block, trial, 1);    
       
    %% DELAY PERIOD (before feedback)  
    % Rebound time BEFORE feedback: setup.pupilreboundtime 
    % Rebound time AFTER feedback: setup.pupilreboundtime2
    %-------------
    % PHASE 5
    % Dot motion: noise
    % Rebound time BEFORE feedback: setup.pupilreboundtime
    %-------------    
        TimingCnt = flip.waitRT.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;
        %-------------    
        % Wait for the pupil to return to baseline AFTER decision and BEFORE feedback
        %-------------
        for frameNum = 1:ceil(setup.pupilreboundtime(block, trial)*window1.frameRate)
            window1      = dots_noise(window1, dots);
            window1      = drawFixationABC(window1, white); % fixation
            Screen('DrawingFinished', window1.h); % helps with managing the flip performance
    
            [flip.pupilrebound1.VBL(block, trial, frameNum), ...
                flip.pupilrebound1.StimOns(block, trial, frameNum), ...
                flip.pupilrebound1.FlipTS(block, trial, frameNum), ...
                flip.pupilrebound1.Missed(block, trial, frameNum), ...
                flip.pupilrebound1.beampos(block, trial, frameNum)] = Screen('Flip', window1.h, TimingCnt);
            TimingCnt = flip.pupilrebound1.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;  

        end % for setup.pupilroundtime 
        
        % phase 5
        results.outputPhase(trial, 5) = flip.pupilrebound1.StimOns(block, trial, 1);    
        
        
        %% ITI (including and after feedback)   
        %-------------
        % PHASE 6
        % Dot motion: noise
        % Rebound time AFTER feedback: setup.pupilreboundtime2
        %-------------
        %-------------
        % Present feedback if setup.feedback
        %-------------
            %-------------
            % Correct
            %-------------
            if results.correct(block,trial) == true && setup.feedback
                Soundbuffer = PsychPortAudio('CreateBuffer', audio.pahandle, correctfile');
                PsychPortAudio('FillBuffer', audio.pahandle, Soundbuffer);
                PsychPortAudio('Start', audio.pahandle);
                if setup.Eye
                    Eyelink ('Message', sprintf('trial %i phase 6 feedback at %d accuracy %d ', trial, GetSecs, results.correct(block,trial)));
                end
%                 fprintf('trial %i phase 6 feedback at %d accuracy %d \n', trial, GetSecs, results.correct(block,trial));

            %-------------
            % Incorrect
            %-------------
            elseif results.correct(block,trial) == false && setup.feedback 
                Soundbuffer = PsychPortAudio('CreateBuffer', audio.pahandle, wrongfile');
                PsychPortAudio('FillBuffer', audio.pahandle, Soundbuffer);
                PsychPortAudio('Start', audio.pahandle);   
                if setup.Eye
                    Eyelink ('Message', sprintf('trial %i phase 6 feedback at %d accuracy %d ', trial, GetSecs, results.correct(block,trial)));
                end
%                 fprintf('trial %i phase 6 feedback at %d accuracy %d \n', trial, GetSecs, results.correct(block,trial));

            %-------------
            % Missed
            %-------------                        
            elseif isnan(results.correct(block,trial)) % always show!
                Soundbuffer = PsychPortAudio('CreateBuffer', audio.pahandle, missedfile');
                PsychPortAudio('FillBuffer', audio.pahandle, Soundbuffer);
                PsychPortAudio('Start', audio.pahandle); 
                if setup.Eye
                    Eyelink ('Message', sprintf('trial %i phase 6 feedback at %d accuracy %d ', trial, GetSecs, results.correct(block,trial)));
                end
%                 fprintf('trial %i phase 6 feedback at %d accuracy %d \n', trial, GetSecs, results.correct(block,trial));
            end % feedback                        
            
        %-------------
        % Waits for the pupil to return to baseline AFTER feedback (equal to the ITI)
        %-------------
        TimingCnt = flip.pupilrebound1.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;  

        for frameNum = 1:ceil(setup.pupilreboundtime2(block, trial)*window1.frameRate),       
            window1      = dots_noise(window1, dots);
            window1      = drawFixationABC(window1, white); % fixation
            Screen('DrawingFinished', window1.h); % helps with managing the flip performance

            [flip.pupilrebound2.VBL(block, trial, frameNum), ...
                flip.pupilrebound2.StimOns(block, trial, frameNum), ...
                flip.pupilrebound2.FlipTS(block, trial, frameNum), ...
                flip.pupilrebound2.Missed(block, trial, frameNum), ...
                flip.pupilrebound2.beampos(block, trial, frameNum)] = Screen('Flip', window1.h, TimingCnt);
            TimingCnt = flip.pupilrebound2.VBL(block, trial, frameNum) + window1.frameDur - window1.slack;
        end % for setup.pupilreboundtime2

        %-------------
        % Trial end time
        %-------------
        % phase 6
        results.outputPhase(trial, 6) = flip.pupilrebound2.StimOns(block, trial, 1);        
        trialend = GetSecs;
%         fprintf('trial %i ended at %d \n', trial, trialend); %nao devia ser trialend em vez de trialend-BEGIN?

        %-------------
        % Break out of all trials if ESC was pressed
        %-------------
        if setup.cancel
            warning('experiment was manually terminated');
            break
        end
        %-------------
        % Send EyeLink trial info
        %-------------       
        % For output file
        results.output(trial, 1) = dots.coherence(block,trial);
        results.output(trial, 2) = dots.direction(block,trial);
        results.output(trial, 3) = results.response(block,trial);
        results.output(trial, 4) = results.correct(block,trial);
        results.output(trial, 5) = results.confidence(block,trial);
        results.output(trial, 6) = results.RT(block,trial);
        results.output(trial, 7) = sound.tones(block,trial);
        
        dlmwrite(outfile1,results.outputPhase-BEGIN,'\t');     
        dlmwrite(outfile2,results.output,'\t');     
        
        %Remove 10 points if the participant doesn't answer
        if isnan(results.response(block,trial))
         points = points - 10;
        end

    end % END LOOP OVER TRIALS
    
    ENDED = GetSecs; % block
    
    %-------------
    % Log Timing
    %-------------   
    results.timing(block, 1) = BEGIN;
    results.timing(block, 2) = ENDED; 
        
    %-------------
    % End of pupil time course
    %-------------
    if setup.Eye
        Eyelink ('Message', sprintf('measuring ended at %d', GetSecs));           
    end
%     fprintf('measuring ended at %d \n', GetSecs);
    %-------------    
    PCORR = floor(nansumOly(results.correct(block,:))/setup.ntrials*100);

    %-------------    
    % save the EL file for this block
    %-------------
    if setup.Eye == true
        fprintf('Receiving data file ''%s''\n', edfFile );
        mkdir('Data', ['Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run)]);
        eyefilename = sprintf('P%d_%d%d%d.edf', setup.participant, setup.session, setup.moment, setup.run);
        setup.eyefilename = ['Data/Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run) '/' eyefilename];      
        Eyelink('CloseFile');
        Eyelink('WaitForModeReady', 500);
        try
            status              = Eyelink('ReceiveFile', edfFile, setup.eyefilename); %this collects the file from the eyelink
            disp(status);
            disp(['File ' setup.eyefilename ' saved to disk']);
        catch
            warning(['File ' setup.eyefilename ' not saved to disk']);
        end
    end
    %-------------
    % Break out of all trials if ESC was pressed
    %-------------
    if setup.cancel
        warning('experiment was manually terminated');
        break
    end
    
    %-------------
    % Close the eyelink
    %-------------
    if setup.Eye == true
        Eyelink('command', 'generate_default_targets = YES');
        Eyelink('StopRecording');
        Eyelink('CloseFile');
    end
    
    %Do the percentage
    max_points = 5 * setup.ntrials;
    min_points = -(10 * setup.ntrials);
    percentage = 0;
    if points >= 0
        percentage = (points/max_points) * 50 + 50;
    else
        percentage = 50 - (points/min_points) * 50;
    end 

    geldstring = ['Acabou o bloco número ' num2str(setup.run) '! \n\n'...
        'Obteve um total de ' num2str(points)  ' pontos em ' num2str(max_points) ' possíveis, em ' num2str(setup.ntrials) ' ensaios. \n\n'...
        'O que corresponde a uma percentagem de ' num2str(percentage) '%. \n'];

    DrawFormattedText(window1.h, geldstring, 'center','center');
    Screen('Flip', window1.h);

    WaitSecs(.1); KbWait(); WaitSecs(.1); 

    % Also show this info in the command window1
    fprintf('Acabou o bloco número %d! \nObteve um total de %d pontos em %d trials, e o seu tempo médio de resposta foi %.2f segundos. \n', block, points, setup.ntrials, nanmeanOly(results.RT(block,:)));
    fprintf('Acertou %d de %d trials.',nansumOly(results.correct(block,:)),setup.ntrials);
    
    %-------------
    % OUTPUT files!
    %-------------
    % MAT file
    if ~setup.example
        matfilename = sprintf('Participant%d_s%d_m%d_r%d.mat',setup.participant, setup.session, setup.moment,setup.run); % setup.run
        setup.filename = ['Data/Participant' num2str(setup.participant) '_S' num2str(setup.session) '_M' num2str(setup.moment) '_R' num2str(setup.run) '/' matfilename];
        save(setup.filename, '-mat', 'setup', 'window1', 'stim', 'dots', 'fix', 'results', 'audio', 'sound', 'flip');
    end
    
    fclose(fid1);        
    fclose(fid2);
    
end % END LOOP OVER BLOCKS

%-------------
% Exit gracefully
%-------------
disp(' Done!');
Screen('CloseAll'); ShowCursor;
PsychPortAudio('Stop', audio.pahandle);
sca;


ListenChar(0);