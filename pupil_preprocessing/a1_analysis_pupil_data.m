%% ANALYSIS PUPIL DATA
%Sara Oliveira 11 jan 2022
%edf files converted to ascii using the SR Research edf converter
clear; close all;

% Open eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Edit memory options
pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 0, 'option_scaleicarms', 1, 'option_rememberfolder', 0, 'option_donotusetoolboxes', 0, 'option_checkversion', 1);

participant = 31;
    %if (participant ~= 23 && participant ~= 31 && participant ~= 36)
       session = 2;
            for moment = 1:2
                for run = 1:4
                    data_dir = 'C:\Users\saraf\OneDrive - Universidade de Coimbra\Ambiente de Trabalho\task_pupil_ecg_v3\Data';
                    filename = [data_dir filesep 'Participant',num2str(participant),'_S',num2str(session),'_M',num2str(moment),'_R',num2str(run) filesep 'P',num2str(participant),'_',num2str(session),num2str(moment),num2str(run),'.asc'];
                    
                    % Read in the asc EyeLink file
                    asc = read_eyelink_ascNK_AU(filename);
                    
                    % Directory to save file
                    save_dir = 'C:\Users\saraf\OneDrive - Universidade de Coimbra\Ambiente de Trabalho\task_pupil_ecg_v3\Data\PupilData';
                    
                    % Create events and data structure, parse asc
                    [data, event, blinksmp, saccsmp] = asc2dat(asc);
                    
                    % Blink interpolation
                    [pupil_interpolated, newblinksmp, nanIdx, dat] = blink_interpolate(data, blinksmp, 1);
                                  
                    % Extract triggers from messages and create data 4 eeglab 
                    %pupil_data4eeglab = create_datastruct4eeglab(subject, session, pupil_data, pupil_interpolated, data, event, blinksmp, saccsmp, nanIdx)
                    pupil_data4eeglab = create_datastruct4eeglab(participant, session, pupil_interpolated, dat, event, blinksmp, saccsmp, nanIdx);
                    
                    EEG = pop_importdata('dataformat','array','nbchan',0,'data','pupil_data4eeglab','setname','pupil_data4eeglab','srate',data.fsample,'pnts',0,'xmin',0);
                    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
                    
                    EEG = eeg_checkset( EEG );
                    EEG = pop_chanevent(EEG, 7,'edge','leading','edgelen',0);
                    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
                    if data.fsample ~= 500
                        EEG = pop_resample( EEG, 500);
                    end
                    
                    filename = ['Participant',num2str(participant),'_',num2str(session),num2str(moment),num2str(run), '.set'];
                    
                    EEG = pop_saveset( EEG, 'filename',filename,'filepath', save_dir);
                end
           end
        %end
   %end
%end



%% functions
% extract triggers and create data structure for eeglab with pupil data
function pupil_data4eeglab = create_datastruct4eeglab(subject, session, pupil_interpolated, data, event, blinksmp, saccsmp, nanIdx)

    %TRIGERS
    % 1 - Left (180) and Coherence 0.03 
    % 2 - Left (180) and Coherence 0.06
    % 3 - Left (180) and Coherence 0.12
    % 4 - Left (180) and Coherence 0.24
    % 5 - Left (180) and Coherence 0.48
    % 6 - Right (0) and Coherence 0.03 
    % 7 - Right (0) and Coherence 0.06
    % 8 - Right (0) and Coherence 0.12
    % 9 - Right (0) and Coherence 0.24
    % 10 - Right (0) and Coherence 0.48
    % 11 - Left (180), High Confidence ('z' - 90) and Correct
    % 12 - Left (180), Low Confidence ('x' - 88) and Correct
    % 13 - Left (180), High Confidence ('m' - 77) and Wrong
    % 14 - Left (180), Low Confidence ('n' - 78) and Wrong
    % 15 - Right (0), High Confidence ('m' - 77) and Correct
    % 16 - Right (0), Low Confidence ('n' - 78) and Correct
    % 17 - Right (0), High Confidence ('z' - 90) and Wrong
    % 18 - Right (0), Low Confidence ('x' - 88) and Wrong   
    % 19 - Correct
    % 20 - Wrong
    % 30 - Blink offset
    % 40 - Saccade offset

    triggers = zeros(length(pupil_interpolated), 1);
    index = []; 
    
    for i = 1:size(event, 1)
        %FOR STIMULUS
        if contains(event(i).value,'stimulus')
            coh = strfind(event(i).value, 'coherence');
            coherence = event(i).value(coh+10:coh+13);
            direc = strfind(event(i).value, 'direction');
            direction = event(i).value(direc+10:end); 
            if strcmp(coherence, '0.03') && contains(direction, '180') 
                triggers(event(i).sample) = 1;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.03') && ~contains(direction, '180') 
                triggers(event(i).sample) = 6;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.06') && contains(direction, '180') 
                triggers(event(i).sample) = 2;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.06') && ~contains(direction, '180') 
                triggers(event(i).sample) = 7;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.12') && contains(direction, '180') 
                triggers(event(i).sample) = 3;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.12') && ~contains(direction, '180') 
                triggers(event(i).sample) = 8;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.24') && contains(direction, '180') 
                triggers(event(i).sample) = 4;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.24') && ~contains(direction, '180') 
                triggers(event(i).sample) = 9;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.48') && contains(direction, '180') 
                triggers(event(i).sample) = 5;
                move_blink_sac_triggers;
            elseif strcmp(coherence, '0.48') && ~contains(direction, '180') 
                triggers(event(i).sample) = 10;
                move_blink_sac_triggers;
            end
        end
    
        %FOR RESPONSE
        if contains(event(i).value,'response')
            direc = strfind(event(i-1).value, 'direction');
            direction = event(i-1).value(direc+10:direc+11); 
            key = strfind(event(i).value,'key');
            key_pressed = event(i).value(key+4:key+5);
            accur = strfind(event(i).value,'accuracy');
            accuracy = event(i).value(accur+9);
            if contains(direction,'18') && strcmp(key_pressed,'90') && strcmp(accuracy,'1')
                triggers(event(i).sample) = 11;
                move_blink_sac_triggers;
            elseif contains(direction,'18') && strcmp(key_pressed,'88') && strcmp(accuracy,'1')
                triggers(event(i).sample) = 12;
                move_blink_sac_triggers;
            elseif contains(direction,'18') && strcmp(key_pressed,'77') && strcmp(accuracy,'0')
                triggers(event(i).sample) = 13;
                move_blink_sac_triggers;
            elseif contains(direction,'18') && strcmp(key_pressed,'78') && strcmp(accuracy,'0')
                triggers(event(i).sample) = 14;
                move_blink_sac_triggers;
            elseif ~contains(direction,'18') && strcmp(key_pressed,'77') && strcmp(accuracy,'1')
                triggers(event(i).sample) = 15;
                move_blink_sac_triggers;
            elseif ~contains(direction,'18') && strcmp(key_pressed,'78') && strcmp(accuracy,'1')
                triggers(event(i).sample) = 16;
                move_blink_sac_triggers;
            elseif ~contains(direction,'18') && strcmp(key_pressed,'90') && strcmp(accuracy,'0')
                triggers(event(i).sample) = 17;
                move_blink_sac_triggers;
            elseif ~contains(direction,'18') && strcmp(key_pressed,'88') && strcmp(accuracy,'0')
                triggers(event(i).sample) = 18;
                move_blink_sac_triggers;
            end
        end

        %FOR FEEDBACK
        if contains(event(i).value,'feedback')
            accur = strfind(event(i).value,'accuracy');
            accuracy = event(i).value(accur+9);
            if strcmp(accuracy,'1')
                triggers(event(i).sample) = 19;
                move_blink_sac_triggers;
            elseif strcmp(accuracy,'0')
                triggers(event(i).sample) = 20;
                move_blink_sac_triggers;
            end
        end
    end


    triggers(blinksmp(:, 2)) = 30; % blink offset
    triggers(saccsmp(:, 2)) = 40; % saccade offset
    
%     pupil_data4eeglab(1, :) = (pupil_data-mean(pupil_data))/mean(pupil_data); %percent signal change 
    
    %WITHOUT NORMALIZATION
    pupil_data4eeglab(1,:) = pupil_interpolated;
    %NORMALIZATION - Z SCORE
    pupil_data4eeglab(2, :) = zscore(pupil_interpolated);
    %pupil_data4eeglab(2, :) = (pupil_interpolated - mean(pupil_interpolated)) / std(pupil_interpolated);
    %NORMALIZATION - PERCENTAGE OF THE MEAN
    pupil_data4eeglab(3, :) = (pupil_interpolated - mean(pupil_interpolated))/mean(pupil_interpolated); % before regressing out effect of blinks and saccades
    
    pupil_data4eeglab(4, :) = data.gazex-mean(data.gazex); % gaze data with blinks linearly interpolated - demeaned
    pupil_data4eeglab(5, :) = data.gazey-mean(data.gazey);
    
    interpolated_data = zeros(length(pupil_data4eeglab(1, :)), 1);
    interpolated_data(nanIdx) = 1;
    pupil_data4eeglab(6, :) = interpolated_data;
    pupil_data4eeglab(7, :) = triggers;
    
    
    function move_blink_sac_triggers
        % make sure blink and saccade triggers do not fall on stimuli triggers or just next to it
        if ~isempty(find(blinksmp(:, 2) == event(i).sample, 1)), index = [i; index]; 
        elseif ~isempty(find(blinksmp(:, 2) == event(i).sample)+1), index = [i; index]; 
        end
        blinksmp(blinksmp(:, 2) == event(i).sample, 2) = blinksmp(blinksmp(:, 2) == event(i).sample, 2)-5;
        blinksmp(blinksmp(:, 2) == event(i).sample-1, 2) = blinksmp(blinksmp(:, 2) == event(i).sample-1, 2)-5;
        saccsmp(saccsmp(:, 2) == event(i).sample, 2) = saccsmp(saccsmp(:, 2) == event(i).sample, 2)-5;
        saccsmp(saccsmp(:, 2) == event(i).sample-1, 2) = saccsmp(saccsmp(:, 2) == event(i).sample-1, 2)-5;
    end
end