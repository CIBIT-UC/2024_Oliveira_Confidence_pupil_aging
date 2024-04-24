%% LOAD AND APPEND ALL RUNS FOR EACH PARTICIPANT
clear all; clc;

% Open eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% edit memory options
pop_editoptions( 'option_storedisk', 0, 'option_savetwofiles', 0, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 0, 'option_scaleicarms', 1, 'option_rememberfolder', 0, 'option_donotusetoolboxes', 0, 'option_checkversion', 1);

data_dir = 'C:\Users\saraf\OneDrive - Universidade de Coimbra\Ambiente de Trabalho\task_pupil_ecg_v3\Data\PupilData';

% APPEND ALL RUNS FOR EACH PARTICIPANT
participant = 31;
    %if (participant ~= 23 && participant ~= 31 && participant ~= 36)
        session = 2;
            for moment = 1:2
                filename1 = ['Participant',num2str(participant),'_',num2str(session),num2str(moment),'1.set'];
                filename2 = ['Participant',num2str(participant),'_',num2str(session),num2str(moment),'2.set'];
                filename3 = ['Participant',num2str(participant),'_',num2str(session),num2str(moment),'3.set'];
                filename4 = ['Participant',num2str(participant),'_',num2str(session),num2str(moment),'4.set'];
                    
                [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
                EEG = pop_loadset('filename',filename1,'filepath',data_dir);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                EEG = pop_loadset('filename',filename2,'filepath',data_dir);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                EEG = pop_loadset('filename',filename3,'filepath',data_dir);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                EEG = pop_loadset('filename',filename4,'filepath',data_dir);
                [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
                
                %SAVE ALL RUNS IN ONE DATASET
                name = ['all_runs',num2str(participant)];
                EEG = eeg_checkset( EEG );
                EEG = pop_mergeset( ALLEEG, [1  2  3  4], 0);
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'setname',name,'gui','off'); 
                
                filename = ['Participant',num2str(participant),'_S', num2str(session),'_M',num2str(moment),'_AllRuns.set'];
                EEG = pop_saveset( EEG, 'filename',filename,'filepath', data_dir);
            end
        %end
   % end
%end


% %% LOAD AND APPEND ALL PARTICIPANTS IN ONE DATASET
% clear all; clc;
% 
% data_dir = 'C:\Users\saraf\OneDrive\Ambiente de Trabalho\task_pupil_ecg_v3\Data\PupilData';
% 
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% 
% for participant = 1:9
%     filename_participant = ['Participant',num2str(participant),'_AllRuns.set'];
% 
%     EEG = pop_loadset('filename',filename_participant,'filepath',data_dir);
%     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% end
% 
% EEG = eeg_checkset( EEG );
% EEG = pop_mergeset( ALLEEG, [1  2  3  4  5  6  7  8  9], 0);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'setname','all_participants','gui','off'); 
% 
% EEG = pop_saveset( EEG, 'filename','All_Participants','filepath', data_dir);