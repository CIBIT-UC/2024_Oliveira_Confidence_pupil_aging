% pupil before feedback divided into low/high confidence -
% correct/incorrect
clear; close all

% participants id for both sexes
female = [1, 2, 4, 5, 6, 8, 10, 11, 13, 14, 22, 28, 29, 30, 35, 38, 39, 41];
male = [3, 7, 9, 12, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 32, 33, 40];

participant_id = [];
group = [];
sex = [];
coherence = [];
confidence = []; 
accuracy = []; 
pupil_afterfeedback = cell(1, 5);

reaction_time = [];
RT_bin = [];

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

data_dir = 'D:\Project_Exercise_SaraOliveira\Data\PupilData';

for participant = 1:41    
    grp = 2; 
    if participant < 21
        filename = ['Participant',num2str(participant),'_AllRuns.set'];
        grp = 1; % young group
    elseif ((participant >= 21 && participant <= 30) || participant == 41) && participant ~= 24
        filename = ['Participant',num2str(participant),'_S1_M1_AllRuns.set'];
    elseif ((participant >= 31 && participant <= 35) || (participant >= 38 && participant <= 40)) && participant ~= 34
        filename = ['Participant',num2str(participant),'_S2_M1_AllRuns.set'];
    else
        continue
    end

    if ismember(participant, female) % sex from participant 31 is missing
        sx = 1;
    else
        sx = 2;
    end
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG = []; CURRENTSET = [];
    EEG = pop_loadset('filename',filename,'filepath',data_dir);

    EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  '6'  '7'  '8'  '9'  }, [-4  10], 'newname', 'stims', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
 
    % create large epochs to include stimulus 
    EEG = pop_epoch( EEG, {  '19'  '20'  }, [-7 3], 'newname', 'feedback', 'epochinfo', 'yes');
    dados_interpolados = EEG.data(6,:,:);
    EEG = pop_rmbase( EEG, [-200 0] ,[]);
    EEG.data(6,:,:) = dados_interpolados;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

    % delete epochs only based on time of interest from -1 to 3s locked
    % with feedback
    epochs2delete = [];
    for trl = 1:size(EEG.data, 3)
        if sum(EEG.data(6, 3000:end, trl), 2) > size(EEG.data(6, 3000:end, trl), 2)/2
           epochs2delete = [epochs2delete; trl];
        end
    end
    if ~isempty(epochs2delete)
        EEG = pop_selectevent( EEG, 'omitepoch', epochs2delete ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
    else
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
    end

    % select time only [-7 a 0.5] 
    EEG = pop_select( EEG, 'time',[-7 0.5] );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname','feedback_toRT','gui','off');  

    for ep = 1:length(EEG.epoch)
        if ismember('1', EEG.epoch(ep).eventtype) || ismember('6', EEG.epoch(ep).eventtype)
            coherence = [coherence; 3]; 
            idx = find(ismember(EEG.epoch(ep).eventtype, {'1', '6'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
        elseif ismember('2', EEG.epoch(ep).eventtype) || ismember('7', EEG.epoch(ep).eventtype)
            coherence = [coherence; 6];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'2', '7'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
        elseif ismember('3', EEG.epoch(ep).eventtype) || ismember('8', EEG.epoch(ep).eventtype)
            coherence = [coherence; 12];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'3', '8'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
        elseif ismember('4', EEG.epoch(ep).eventtype) || ismember('9', EEG.epoch(ep).eventtype)
            coherence = [coherence; 24];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'4', '9'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
        end
    end

    %Regressar ao feedback de -7 a 3
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',3,'study',0);
    
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('13', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype)
            confidence = [confidence; 1];
        else
            confidence = [confidence; 0];
        end
    end
    
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('12', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype)
            accuracy  = [accuracy ; 1];
        else
            accuracy  = [accuracy ; 0];
        end
    end

%     pupil_afterfeedback = [pupil_afterfeedback; squeeze(mean(EEG.data(3, 4000:end, :)))];
    % pupil_afterfeedback_early = [pupil_afterfeedback_early; squeeze(mean(EEG.data(3, 3500:4250, :)))];   %pupila de 0 a 1.5s
    % pupil_afterfeedback_late = [pupil_afterfeedback_late; squeeze(mean(EEG.data(3, 4250:end, :)))];   %pupila de 1.5 a 3s

    % 7 averages 500 ms windows non-overlapping
    for bn = 1:5
        pupil_afterfeedback{bn} = [pupil_afterfeedback{bn}; squeeze(mean(EEG.data(3, 3501+250*bn:3750+250*bn, :)))];
    end
    
    % calculate which trials have fast reaction times - median split
    RT = reaction_time(length(reaction_time)-length(EEG.epoch)+1:end);
    [B,I] = sortrows(RT);
    RT_bin_tmp = ones(length(RT), 1);
    RT_bin_tmp(I(floor(length(I)/2)+1:end)) = 0;
    
    RT_bin = [RT_bin; RT_bin_tmp];
    
    group = [group; ones(length(EEG.epoch), 1)*grp];
    sex = [sex; ones(length(EEG.epoch), 1)*sx];
    participant_id = [participant_id; ones(length(EEG.epoch), 1)*participant];
end
%%
find(reaction_time<100)

all_varibl = [participant_id, group, sex, coherence, confidence, accuracy, reaction_time, RT_bin, ...
    pupil_afterfeedback{1},pupil_afterfeedback{2},pupil_afterfeedback{3},pupil_afterfeedback{4},pupil_afterfeedback{5}];

all_varibl(reaction_time<100, 5:end) = NaN;


%% TABLE
table_pupilafterfeedback  = array2table(all_varibl);

table_pupilafterfeedback .Properties.VariableNames = {'Participant', 'Group', 'Sex', 'Coherence', 'Confidence', 'Accuracy', 'ReactionTime', 'RT_bin',...
        'Pupil_1', 'Pupil_2', 'Pupil_3', 'Pupil_4', 'Pupil_5'};

filename = 'table_pupilafterfeedback_500msbins.xlsx';

writetable(table_pupilafterfeedback,filename)


%% number of trials in table
filename = 'table_pupilafterfeedback_500msbins.xlsx';
T = readtable(filename);


numbertrials_surecorrect = cell(2, 1);
numbertrials_sureincorrect = cell(2, 1);
numbertrials_unsurecorrect = cell(2, 1);
numbertrials_unsureincorrect = cell(2, 1);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 26, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

for grp = 1:2
    for prt = participants{grp}'
        
        conf = T.Confidence(T.Participant == prt);
        acc = T.Accuracy(T.Participant == prt);
        coh = T.Coherence(T.Participant == prt);
        sex = T.Sex(T.Participant == prt);
        
        coh1 = find(coh == 3);
        coh2 = find(coh == 6);
        coh3 = find(coh == 12);
        coh4 = find(coh == 24);
        
        
        lowconf_coh1 = intersect(find(conf == 0), find(coh == 3));
        lowconf_coh2 = intersect(find(conf == 0), find(coh == 6));
        lowconf_coh3 = intersect(find(conf == 0), find(coh == 12));
        lowconf_coh4 = intersect(find(conf == 0), find(coh == 24));
        
        highconf_coh1 = intersect(find(conf == 1), find(coh == 3));
        highconf_coh2 = intersect(find(conf == 1), find(coh == 6));
        highconf_coh3 = intersect(find(conf == 1), find(coh == 12));
        highconf_coh4 = intersect(find(conf == 1), find(coh == 24));
        
        
        surecorrect = intersect(find(conf == 1), find(acc == 1));
        sureincorrect = intersect(find(conf == 1), find(acc == 0));
        unsurecorrect = intersect(find(conf == 0), find(acc == 1));
        unsureincorrect = intersect(find(conf == 0), find(acc == 0));

        numbertrials_surecorrect{grp} = [numbertrials_surecorrect{grp}; length(surecorrect)];
        numbertrials_sureincorrect{grp} = [numbertrials_sureincorrect{grp}; length(sureincorrect)];
        numbertrials_unsurecorrect{grp} = [numbertrials_unsurecorrect{grp}; length(unsurecorrect)];
        numbertrials_unsureincorrect{grp} = [numbertrials_unsureincorrect{grp}; length(unsureincorrect)];

    end
end

% average number of trials
young_surecorrect = mean(numbertrials_surecorrect{1})
young_sureRTincorrect = mean(numbertrials_sureincorrect{1})

older_surecorrect = mean(numbertrials_surecorrect{2})
older_sureincorrect = mean(numbertrials_sureincorrect{2})

young_unsurecorrect = mean(numbertrials_unsurecorrect{1})
young_unsureincorrect = mean(numbertrials_unsureincorrect{1})

older_unsurecorrect = mean(numbertrials_unsurecorrect{2})
older_unsureincorrect = mean(numbertrials_unsureincorrect{2})

















