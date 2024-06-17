% pupil before feedback divided into low/high confidence -
% correct/incorrect
clear; close all

pupil_b4feedback = cell(2, 1);

pupil_b4feedback_sure = cell(2, 1);
pupil_b4feedback_unsure = cell(2, 1);

pupil_b4feedback_sure_easy = cell(2, 1);
pupil_b4feedback_sure_difficult = cell(2, 1);
pupil_b4feedback_unsure_easy = cell(2, 1);
pupil_b4feedback_unsure_difficult = cell(2, 1);


pupil_b4feedback_fastRT_easy = cell(2, 1);
pupil_b4feedback_fastRT_difficult = cell(2, 1);
pupil_b4feedback_slowRT_easy = cell(2, 1);
pupil_b4feedback_slowRT_difficult = cell(2, 1);
    

pupil_b4feedback_correct = cell(2, 1);
pupil_b4feedback_incorrect = cell(2, 1);

pupil_b4feedback_surecorrect = cell(2, 1);
pupil_b4feedback_sureincorrect = cell(2, 1);
pupil_b4feedback_unsurecorrect = cell(2, 1);
pupil_b4feedback_unsureincorrect = cell(2, 1);

pupil_b4feedback_fastRT = cell(2, 1);
pupil_b4feedback_slowRT = cell(2, 1);
pupil_b4feedback_fastRTcorrect = cell(2, 1);
pupil_b4feedback_fastRTincorrect = cell(2, 1);
pupil_b4feedback_slowRTcorrect = cell(2, 1);
pupil_b4feedback_slowRTincorrect = cell(2, 1);

numbertrials_fastRTcorrect = cell(2, 1);
numbertrials_fastRTincorrect = cell(2, 1);
numbertrials_slowRTcorrect = cell(2, 1);
numbertrials_slowRTincorrect = cell(2, 1);

numbertrials_surecorrect = cell(2, 1);
numbertrials_sureincorrect = cell(2, 1);
numbertrials_unsurecorrect = cell(2, 1);
numbertrials_unsureincorrect = cell(2, 1);



% addpath('C:\eeglab\eeglab2023.0')
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

data_dir = 'D:\Project_Exercise_SaraOliveira\Data\PupilData';
excluded = [24, 26, 34, 37, 51, 54];

for participant = setdiff(1:57, excluded)   
    grp = 2; 
    if participant < 21 || participant == 50
        filename = ['Participant',num2str(participant),'_AllRuns.set'];
        grp = 1; % young group
    elseif ((participant >= 21 && participant <= 30) || participant == 41  || ismember(participant, [52, 53, 55, 56, 57])) && participant ~= 24
        filename = ['Participant',num2str(participant),'_S1_M1_AllRuns.set'];
    elseif ((participant >= 31 && participant <= 35) || (participant >= 38 && participant <= 40)) && participant ~= 34
        filename = ['Participant',num2str(participant),'_S2_M1_AllRuns.set'];
    else
        continue
    end
      

    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG = []; CURRENTSET = [];
    EEG = pop_loadset('filename',filename,'filepath',data_dir);


    EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  '6'  '7'  '8'  '9'  }, [-7  7.5], 'newname', 'stims', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    dados_interpolados = EEG.data(6,:,:);
    EEG = pop_rmbase( EEG, [-200 0] ,[]);
    EEG.data(6,:,:) = dados_interpolados;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    EEG = pop_epoch( EEG, {  '11'  '12'  '13'  '14'  '15'  '16' '17'  '18'  }, [-7  3], 'newname', 'responses', 'epochinfo', 'yes');
    
    % exclude epochs where more than 50% of teh data points were
    % interpolated in a time window between -1 and 3 s locked with the
    % response
    epochs2delete = [];
    for trl = 1:size(EEG.data, 3)
        if sum(EEG.data(6, 3001:end, trl), 2) > (size(EEG.data, 2)-3000)/2
           epochs2delete = [epochs2delete; trl];
        end
    end
    if ~isempty(epochs2delete)
        EEG = pop_selectevent( EEG, 'omitepoch', epochs2delete ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
    end
    
    pupil_b4feedback{grp} = [pupil_b4feedback{grp}; squeeze(mean(EEG.data(3, :, :), 3))];
    
    reaction_time = []; coherence = [];
    for ep = 1:length(EEG.epoch)
        display(num2str(ep))
        if ismember('1', EEG.epoch(ep).eventtype) || ismember('6', EEG.epoch(ep).eventtype)
            coherence = [coherence; 3]; 
            idx = find(ismember(EEG.epoch(ep).eventtype, {'1', '6'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            if cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1))) > 0
                reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            elseif length(idx2)>1
                 reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(2))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            end
        elseif ismember('2', EEG.epoch(ep).eventtype) || ismember('7', EEG.epoch(ep).eventtype)
            coherence = [coherence; 6];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'2', '7'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            if cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1))) > 0
                reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            elseif length(idx2)>1
                 reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(2))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            end
        elseif ismember('3', EEG.epoch(ep).eventtype) || ismember('8', EEG.epoch(ep).eventtype)
            coherence = [coherence; 12];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'3', '8'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            if cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1))) > 0
                reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            elseif length(idx2)>1
                 reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(2))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            end
        elseif ismember('4', EEG.epoch(ep).eventtype) || ismember('9', EEG.epoch(ep).eventtype)
            coherence = [coherence; 24];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'4', '9'}));
            idx2 = find(ismember(EEG.epoch(ep).eventtype, {'11', '12', '13', '14', '15', '16', '17', '18'}));
            if cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1))) > 0
                reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(1))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            elseif length(idx2)>1
                 reaction_time = [reaction_time; cell2mat(EEG.epoch(ep).eventlatency(idx2(2))) - cell2mat(EEG.epoch(ep).eventlatency(idx(1)))];
            end
        end
    end

    % find trials withj reaction > 100 ms and exclude them from analyses -
    % impulsive responses
    
    impuls_RT = find(reaction_time < 100); 
    if ~isempty(impuls_RT)
        EEG = pop_selectevent( EEG, 'omitepoch', impuls_RT ,'deleteevents','off','deleteepochs','on','invertepochs','off');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
    end
    reaction_time(reaction_time < 100) = [];
    coherence(reaction_time < 100) = [];
    
    % find trials sure - events 
    ep_sure = [];
    ep_unsure = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('13', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype) 
            ep_sure = [ep_sure; ep];
        elseif ismember('12', EEG.epoch(ep).eventtype) || ismember('14', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype) || ismember('18', EEG.epoch(ep).eventtype) 
            ep_unsure = [ep_unsure; ep];
        end
    end
    
    if ~isempty(ep_sure)
        pupil_b4feedback_sure{grp} = [pupil_b4feedback_sure{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_sure), 3))];
    else
        pupil_b4feedback_sure{grp} = [pupil_b4feedback_sure{grp}; NaN(1, 2000)];
    end
    
    if ~isempty(ep_unsure)
        pupil_b4feedback_unsure{grp} = [pupil_b4feedback_unsure{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_unsure), 3))];
    else
        pupil_b4feedback_unsure{grp} = [pupil_b4feedback_unsure{grp}; NaN(1, 2000)];
    end

  
    % find trials correct - events 
    ep_correct = [];
    ep_incorrect = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('12', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype) 
            ep_correct = [ep_correct; ep];
        elseif ismember('13', EEG.epoch(ep).eventtype) || ismember('14', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype) || ismember('18', EEG.epoch(ep).eventtype) 
            ep_incorrect = [ep_incorrect; ep];
        end
    end
    
    if ~isempty(ep_correct)
        pupil_b4feedback_correct{grp} = [pupil_b4feedback_correct{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_correct), 3))];
    else
        pupil_b4feedback_correct{grp} = [pupil_b4feedback_correct{grp}; NaN(1, 2000)];
    end
    
    if ~isempty(ep_incorrect)
        pupil_b4feedback_incorrect{grp} = [pupil_b4feedback_incorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_incorrect), 3))];
    else
        pupil_b4feedback_incorrect{grp} = [pupil_b4feedback_incorrect{grp}; NaN(1, 2000)];
    end
    

    % find trials sure-correct - events 
    ep_surecorrect = [];
    ep_sureincorrect = [];
    ep_unsurecorrect = [];
    ep_unsureincorrect = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) 
            ep_surecorrect = [ep_surecorrect; ep];
        elseif ismember('12', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype) 
            ep_unsurecorrect = [ep_unsurecorrect; ep];
        elseif ismember('13', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype) 
            ep_sureincorrect =[ep_sureincorrect; ep ];
        elseif ismember('14', EEG.epoch(ep).eventtype) || ismember('18', EEG.epoch(ep).eventtype) 
            ep_unsureincorrect = [ep_unsureincorrect; ep];
        end
    end
    
    if ~isempty(ep_surecorrect)
        pupil_b4feedback_surecorrect{grp} = [pupil_b4feedback_surecorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_surecorrect), 3))];
    else
        pupil_b4feedback_surecorrect{grp} = [pupil_b4feedback_surecorrect{grp}; NaN(1, 2000)];
    end
    
    if ~isempty(ep_sureincorrect)
        pupil_b4feedback_sureincorrect{grp} = [pupil_b4feedback_sureincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_sureincorrect), 3))];
    else
        pupil_b4feedback_sureincorrect{grp} = [pupil_b4feedback_sureincorrect{grp}; NaN(1, 2000)];
    end
    
    if ~isempty(ep_unsurecorrect)
        pupil_b4feedback_unsurecorrect{grp} = [pupil_b4feedback_unsurecorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_unsurecorrect), 3))];
    else
        pupil_b4feedback_unsurecorrect{grp} = [pupil_b4feedback_unsurecorrect{grp}; NaN(1, 2000)];
    end
    
    if ~isempty(ep_unsureincorrect)
        pupil_b4feedback_unsureincorrect{grp} = [pupil_b4feedback_unsureincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, ep_unsureincorrect), 3))];
    else
        pupil_b4feedback_unsureincorrect{grp} = [pupil_b4feedback_unsureincorrect{grp}; NaN(1, 2000)];
    end
    
    % create vector with accuracy
    accuracy = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('12', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype)
            accuracy  = [accuracy ; 1];
        else
            accuracy  = [accuracy ; 0];
        end
    end
    
    % find trials with fast and slow RTs
    fastRT = find(reaction_time < median(reaction_time));
    slowRT = find(reaction_time >= median(reaction_time));
    
    pupil_b4feedback_fastRT{grp} = [pupil_b4feedback_fastRT{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT), 3))];
    pupil_b4feedback_slowRT{grp} = [pupil_b4feedback_slowRT{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRT), 3))];
    
    fastRT_correct = intersect(fastRT, find(accuracy == 1));
    fastRTincorrect = intersect(fastRT, find(accuracy == 0));
    slowRTcorrect = intersect(slowRT, find(accuracy == 1));
    slowRTincorrect = intersect(slowRT, find(accuracy == 0));
    
    pupil_b4feedback_fastRTcorrect{grp} = [pupil_b4feedback_fastRTcorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT_correct), 3))];
    pupil_b4feedback_fastRTincorrect{grp} = [pupil_b4feedback_fastRTincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRTincorrect), 3))];
    pupil_b4feedback_slowRTcorrect{grp} = [pupil_b4feedback_slowRTcorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRTcorrect), 3))];
    pupil_b4feedback_slowRTincorrect{grp} = [pupil_b4feedback_slowRTincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRTincorrect), 3))];

    
    % epochs with high/low confidence for each of motion coherence
    % create vector with confidence
    confidence = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('13', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype)
            confidence  = [confidence; 1];
        elseif ismember('12', EEG.epoch(ep).eventtype) || ismember('14', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype) || ismember('18', EEG.epoch(ep).eventtype)
            confidence  = [confidence ; 0];
        end
    end
    
    sure_easy = intersect(find(coherence>10), find(confidence == 1));
    sure_difficult = intersect(find(coherence<10), find(confidence == 1));
    unsure_easy = intersect(find(coherence>10), find(confidence == 0));
    unsure_difficult = intersect(find(coherence<10), find(confidence == 0));
    
    pupil_b4feedback_sure_easy{grp} = [pupil_b4feedback_sure_easy{grp}; squeeze(mean(EEG.data(3, 3001:end, sure_easy), 3))];
    pupil_b4feedback_sure_difficult{grp} = [pupil_b4feedback_sure_difficult{grp}; squeeze(mean(EEG.data(3, 3001:end, sure_difficult), 3))];
    pupil_b4feedback_unsure_easy{grp} = [pupil_b4feedback_unsure_easy{grp}; squeeze(mean(EEG.data(3, 3001:end, unsure_easy), 3))];
    pupil_b4feedback_unsure_difficult{grp} = [pupil_b4feedback_unsure_difficult{grp}; squeeze(mean(EEG.data(3, 3001:end, unsure_difficult), 3))];
    
    
    % using RT bins instead
    fastRT_easy = intersect(find(coherence>10), fastRT);
    fastRT_difficult = intersect(find(coherence<10), fastRT);
    slowRT_easy = intersect(find(coherence>10), slowRT);
    slowRT_difficult = intersect(find(coherence<10), slowRT);
    
    
    pupil_b4feedback_fastRT_easy{grp} = [pupil_b4feedback_fastRT_easy{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT_easy), 3))];
    pupil_b4feedback_fastRT_difficult{grp} = [pupil_b4feedback_fastRT_difficult{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT_difficult), 3))];
    pupil_b4feedback_slowRT_easy{grp} = [pupil_b4feedback_slowRT_easy{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRT_easy), 3))];
    pupil_b4feedback_slowRT_difficult{grp} = [pupil_b4feedback_slowRT_difficult{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRT_difficult), 3))];
    
    
    numbertrials_fastRTcorrect{grp} = [numbertrials_fastRTcorrect{grp}; length(fastRT_correct)];
    numbertrials_fastRTincorrect{grp} = [numbertrials_fastRTincorrect{grp}; length(fastRTincorrect)];
    numbertrials_slowRTcorrect{grp} = [numbertrials_slowRTcorrect{grp}; length(slowRTcorrect)];
    numbertrials_slowRTincorrect{grp} = [numbertrials_slowRTincorrect{grp}; length(slowRTincorrect)];

    numbertrials_surecorrect{grp} = [numbertrials_surecorrect{grp}; length(ep_surecorrect)];
    numbertrials_sureincorrect{grp} = [numbertrials_sureincorrect{grp}; length(ep_sureincorrect)];
    numbertrials_unsurecorrect{grp} = [numbertrials_unsurecorrect{grp}; length(ep_unsurecorrect)];
    numbertrials_unsureincorrect{grp} = [numbertrials_unsureincorrect{grp}; length(ep_unsureincorrect)];

end

time = EEG.times(3001:end)/1000;

% average number of trials
young_fastRTcorrect = mean(numbertrials_fastRTcorrect{1})
young_fastRTincorrect = mean(numbertrials_fastRTincorrect{1})

older_fastRTcorrect = mean(numbertrials_fastRTcorrect{2})
older_fastRTincorrect = mean(numbertrials_fastRTincorrect{2})

young_slowRTcorrect = mean(numbertrials_slowRTcorrect{1})
young_slowRTincorrect = mean(numbertrials_slowRTincorrect{1})

older_slowRTcorrect = mean(numbertrials_slowRTcorrect{2})
older_slowRTincorrect = mean(numbertrials_slowRTincorrect{2})


% average number of trials
young_surecorrect = mean(numbertrials_surecorrect{1})
young_sureRTincorrect = mean(numbertrials_sureincorrect{1})

older_surecorrect = mean(numbertrials_surecorrect{2})
older_sureincorrect = mean(numbertrials_sureincorrect{2})

young_unsurecorrect = mean(numbertrials_unsurecorrect{1})
young_unsureincorrect = mean(numbertrials_unsureincorrect{1})

older_unsurecorrect = mean(numbertrials_unsurecorrect{2})
older_unsureincorrect = mean(numbertrials_unsureincorrect{2})


addpath('C:\matlab_toolboxes')

%% GRAPH WITH BOTH GROUPS TOGETHER
%Effect of Accuracy

group = {'YOUNG', 'OLDER'};
line_width = [3.5, 1.5];
    figure;
for grp = 1:2
    all_response_correct = mean(pupil_b4feedback_correct{grp}, 1, 'omitnan');
    SE_response_correct = std(pupil_b4feedback_correct{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_correct{grp}, 1));
    all_response_incorrect = mean(pupil_b4feedback_incorrect{grp}, 1, 'omitnan');
    SE_response_incorrect = std(pupil_b4feedback_incorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_incorrect{grp}, 1));


    plot(time, all_response_correct,'color',[0, 158, 115]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_correct + SE_response_correct, all_response_correct - SE_response_correct,[0, 158, 115]./255,[0, 158, 115]./255, 1, 0.2);
    hold on
    plot(time, all_response_incorrect, '--', 'color',[213, 94, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_incorrect + SE_response_incorrect, all_response_incorrect - SE_response_incorrect,[213, 94, 0]./255, [213, 94, 0]./255, 1, 0.2);
%     hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
    hold on;

end

% plot horizontal line showing sig effect of accuracy p < .01 -> 1 - 1.5 s
plot([1, 1.5],[-.02 -.02], 'k','color',[0 0 0],'LineWidth',6);

box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.18]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil response (%)','FontSize',30,'FontName','Arial');


%% GRAPH WITH BOTH GROUPS TOGETHER - group x confidence x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES
figure; line_width = [3.5, 1.5];
for grp = 1:2
    all_response_surecorrect = mean(pupil_b4feedback_surecorrect{grp}, 1, 'omitnan');
    SE_response_surecorrect = std(pupil_b4feedback_surecorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_surecorrect{grp}, 1));
    all_response_unsurecorrect = mean(pupil_b4feedback_unsurecorrect{grp}, 1, 'omitnan');
    SE_response_unsurecorrect = std(pupil_b4feedback_unsurecorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsurecorrect{grp}, 1));

    plot(time, all_response_surecorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_surecorrect + SE_response_surecorrect, all_response_surecorrect - SE_response_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsurecorrect + SE_response_unsurecorrect, all_response_unsurecorrect - SE_response_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

% plot horizontal line showing CONFIDENCE ACCURACY INTERACTION p < .01 -> 1-3 s
plot([.5, 3],[-.02 -.02], 'k','color',[0 0 0],'LineWidth',6);

% plot horizontal line showing group x confidence x accuracy interaction < .01 -> 1.5-2 s
plot([1.5, 2],[-.04 -.04],'color',[0.5 0.5 0.5],'LineWidth',6);

% % plot horizontal line showing effect of confidence < .01 -> 1-3 s
% plot([.5, 3],[-.04 -.04],'color',[0.5 0.5 0.5],'LineWidth',6);


hold off
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

% INCORRECT RESPONSES
    figure;
for grp = 1:2
    all_response_sureincorrect = mean(pupil_b4feedback_sureincorrect{grp}, 1, 'omitnan');
    SE_response_sureincorrect = std(pupil_b4feedback_sureincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sureincorrect{grp}, 1));
    all_response_unsureincorrect = mean(pupil_b4feedback_unsureincorrect{grp}, 1, 'omitnan');
    SE_response_unsureincorrect = std(pupil_b4feedback_unsureincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsureincorrect{grp}, 1));


    plot(time, all_response_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_sureincorrect + SE_response_sureincorrect, all_response_sureincorrect - SE_response_sureincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsureincorrect, '--','color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsureincorrect + SE_response_unsureincorrect, all_response_unsureincorrect - SE_response_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

% plot horizontal line showing CONFIDENCE ACCURACY INTERACTION p < .01 -> 1-3 s
plot([.5, 3],[-.02 -.02], 'k','color',[0 0 0],'LineWidth',6);

% plot horizontal line showing group x confidence x accuracy interaction < .01 -> 1.5-2 s
plot([1.5, 2],[-.04 -.04],'color',[0.5 0.5 0.5],'LineWidth',6);

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


%% GRAPH WITH BOTH GROUPS TOGETHER - group x RT bins x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES


figure; line_width = [3.5, 1.5];
for grp = 1:2
    all_response_surecorrect = mean(pupil_b4feedback_fastRTcorrect{grp}, 1, 'omitnan');
    SE_response_surecorrect = std(pupil_b4feedback_fastRTcorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_fastRTcorrect{grp}, 1));
    all_response_unsurecorrect = mean(pupil_b4feedback_slowRTcorrect{grp}, 1, 'omitnan');
    SE_response_unsurecorrect = std(pupil_b4feedback_slowRTcorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_slowRTcorrect{grp}, 1));

    plot(time, all_response_surecorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_surecorrect + SE_response_surecorrect, all_response_surecorrect - SE_response_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsurecorrect + SE_response_unsurecorrect, all_response_unsurecorrect - SE_response_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

hold off
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


% INCORRECT RESPONSES
    figure;
for grp = 1:2
    all_response_sureincorrect = mean(pupil_b4feedback_fastRTincorrect{grp}, 1, 'omitnan');
    SE_response_sureincorrect = std(pupil_b4feedback_fastRTincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_fastRTincorrect{grp}, 1));
    all_response_unsureincorrect = mean(pupil_b4feedback_slowRTincorrect{grp}, 1, 'omitnan');
    SE_response_unsureincorrect = std(pupil_b4feedback_slowRTincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_slowRTincorrect{grp}, 1));


    plot(time, all_response_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_sureincorrect + SE_response_sureincorrect, all_response_sureincorrect - SE_response_sureincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsureincorrect, '--','color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsureincorrect + SE_response_unsureincorrect, all_response_unsureincorrect - SE_response_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

%% GRAPHS BOTH GROUPS TOGETHER
% GROUP X COHERENCE X CONFIDENCE

% EASY MOTION CONDITION
figure; line_width = [3.5, 1.5];
for grp = 1:2
    all_response_sure_easy = mean(pupil_b4feedback_sure_easy{grp}, 1, 'omitnan');
    SE_response_sure_easy = std(pupil_b4feedback_sure_easy{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sure_easy{grp}, 1));
    all_response_unsure_easy = mean(pupil_b4feedback_unsure_easy{grp}, 1, 'omitnan');
    SE_response_unsure_easy = std(pupil_b4feedback_unsure_easy{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsure_easy{grp}, 1));

    plot(time, all_response_sure_easy,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_sure_easy + SE_response_sure_easy, all_response_sure_easy - SE_response_sure_easy,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsure_easy, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsure_easy + SE_response_unsure_easy, all_response_unsure_easy - SE_response_unsure_easy,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

% plot horizontal line showing group x coherence x confidence INTERACTION p < .01 -> 2-3 s
plot([2, 3],[-.02 -.02], 'k','LineWidth',6);

hold off
box off;
ax = gca;
ax.LineWidth = 2;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

% DIFFICULT MOTION CONDITION
    figure;
for grp = 1:2
    all_response_sure_difficult = mean(pupil_b4feedback_sure_difficult{grp}, 1, 'omitnan');
    SE_response_sure_difficult = std(pupil_b4feedback_sure_difficult{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sure_difficult{grp}, 1));
    all_response_unsure_difficult = mean(pupil_b4feedback_unsure_difficult{grp}, 1, 'omitnan');
    SE_response_unsure_difficult = std(pupil_b4feedback_unsure_difficult{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsure_difficult{grp}, 1));


    plot(time, all_response_sure_difficult,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_sure_difficult + SE_response_sure_difficult, all_response_sure_difficult - SE_response_sure_difficult,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsure_difficult, '--','color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_unsure_difficult + SE_response_unsure_difficult, all_response_unsure_difficult - SE_response_unsure_difficult,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end

% plot horizontal line showing group x coherence x confidence INTERACTION p < .01 -> 2-3 s
plot([2, 3],[-.02 -.02], 'k','LineWidth',6);

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');    

%% GRAPHS BITH GROUPS TOGETHER
% GROUP X COHERENCE X RT BINS

% EASY MOTION CONDITION
figure; line_width = [3.5, 1.5];
for grp = 1:2
    all_response_fastRT_easy = mean(pupil_b4feedback_fastRT_easy{grp}, 1, 'omitnan');
    SE_response_fastRT_easy = std(pupil_b4feedback_fastRT_easy{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_fastRT_easy{grp}, 1));
    all_response_slowRT_easy = mean(pupil_b4feedback_slowRT_easy{grp}, 1, 'omitnan');
    SE_response_slowRT_easy = std(pupil_b4feedback_slowRT_easy{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_slowRT_easy{grp}, 1));

    plot(time, all_response_fastRT_easy,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_fastRT_easy + SE_response_fastRT_easy, all_response_fastRT_easy - SE_response_fastRT_easy,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_slowRT_easy, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_slowRT_easy + SE_response_slowRT_easy, all_response_slowRT_easy - SE_response_slowRT_easy,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end



hold off
box off;
ax = gca;
ax.LineWidth = 2;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

% DIFFICULT MOTION CONDITION
    figure;
for grp = 1:2
    all_response_fastRT_difficult = mean(pupil_b4feedback_fastRT_difficult{grp}, 1, 'omitnan');
    SE_response_fastRT_difficult = std(pupil_b4feedback_fastRT_difficult{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_fastRT_difficult{grp}, 1));
    all_response_slowRT_difficult = mean(pupil_b4feedback_slowRT_difficult{grp}, 1, 'omitnan');
    SE_response_slowRT_difficult = std(pupil_b4feedback_slowRT_difficult{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_slowRT_difficult{grp}, 1));


    plot(time, all_response_fastRT_difficult,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_fastRT_difficult + SE_response_fastRT_difficult, all_response_fastRT_difficult - SE_response_fastRT_difficult,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_slowRT_difficult, '--','color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_response_slowRT_difficult + SE_response_slowRT_difficult, all_response_slowRT_difficult - SE_response_slowRT_difficult,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',line_width(grp));

end


hold off;
box off;
ax = gca;
ax.LineWidth = 2;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([-.05 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');  

%% Effect of Group
all_response_correct_young = mean(pupil_b4feedback_correct{1,1}, 1, 'omitnan');
SE_response_correct_young = std(pupil_b4feedback_correct{1,1}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_correct{1,1}, 1));
all_response_correct_old = mean(pupil_b4feedback_correct{2,1}, 1, 'omitnan');
SE_response_correct_old = std(pupil_b4feedback_correct{2,1}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_correct{2,1}, 1));
all_response_incorrect_young = mean(pupil_b4feedback_incorrect{1,1}, 1, 'omitnan');
SE_response_incorrect_young = std(pupil_b4feedback_incorrect{1,1}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_incorrect{1,1}, 1));
all_response_incorrect_old = mean(pupil_b4feedback_incorrect{2,1}, 1, 'omitnan');
SE_response_incorrect_old = std(pupil_b4feedback_incorrect{2,1}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_incorrect{2,1}, 1));

figure;
plot(time, all_response_correct_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_response_correct_young + SE_response_correct_young, all_response_correct_young - SE_response_correct_young,'k','k', 1, 0.2);
hold on
plot(time, all_response_correct_old, '--','color','r','LineWidth',1.5);
hold on
jbfill(time, all_response_correct_old + SE_response_correct_old, all_response_correct_old - SE_response_correct_old,'r', 'r', 1, 0.2);
% hold on
% plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([0 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

figure;
plot(time, all_response_incorrect_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_response_incorrect_young + SE_response_incorrect_young, all_response_incorrect_young - SE_response_incorrect_young,'k', 'k', 1, 0.2);
hold on
plot(time, all_response_incorrect_old, '--','color','r','LineWidth',1.5);
hold on
jbfill(time, all_response_incorrect_old + SE_response_incorrect_old, all_response_incorrect_old - SE_response_incorrect_old,'r', 'r', 1, 0.2);
% hold on
% plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 28;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([0 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');



%% Figure 3.4b) - group x confidence
%Effect of Confidence level
% group = {'Young', 'Older'};
for grp = 1:2
    all_response_sure = mean(pupil_b4feedback_sure{grp}, 1, 'omitnan');
    SE_response_sure = std(pupil_b4feedback_sure{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sure{grp}, 1));
    all_response_unsure = mean(pupil_b4feedback_unsure{grp}, 1, 'omitnan');
    SE_response_unsure = std(pupil_b4feedback_unsure{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsure{grp}, 1));

    figure;
    plot(time, all_response_sure,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_sure + SE_response_sure, all_response_sure - SE_response_sure,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsure, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_unsure + SE_response_unsure, all_response_unsure - SE_response_unsure,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
%     hold on
%     plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
    hold off;
    box off;
    ax = gca;
    ax.LineWidth = 2;
    c = ax.Color;
    ax.FontSize = 26;
    ax.FontName = 'Arial';
    xlim([-1 3]);
    ylim([0 0.22]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

%% Effect of Group
all_response_sure_young = mean(pupil_b4feedback_sure{1,1}, 1, 'omitnan');
SE_response_sure_young = std(pupil_b4feedback_sure{1,1}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sure{1,1}, 1));
all_response_sure_old = mean(pupil_b4feedback_sure{2,1}, 1, 'omitnan');
SE_response_sure_old = std(pupil_b4feedback_sure{2,1}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sure{2,1}, 1));
all_response_unsure_young = mean(pupil_b4feedback_unsure{1,1}, 1, 'omitnan');
SE_response_unsure_young = std(pupil_b4feedback_unsure{1,1}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsure{1,1}, 1));
all_response_unsure_old = mean(pupil_b4feedback_unsure{2,1}, 1, 'omitnan');
SE_response_unsure_old = std(pupil_b4feedback_unsure{2,1}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsure{2,1}, 1));

figure;
plot(time, all_response_sure_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_response_sure_young + SE_response_sure_young, all_response_sure_young - SE_response_sure_young,'k','k', 1, 0.2);
hold on
plot(time, all_response_sure_old,'--', 'color','r','LineWidth',1.5);
hold on
jbfill(time, all_response_sure_old + SE_response_sure_old, all_response_sure_old - SE_response_sure_old,'r', 'r', 1, 0.2);
% hold on
% plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([0 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('HIGH CONFIDENCE','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

figure;
plot(time, all_response_unsure_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_response_unsure_young + SE_response_unsure_young, all_response_unsure_young - SE_response_unsure_young,'k', 'k', 1, 0.2);
hold on
plot(time, all_response_unsure_old, '--', 'color', 'r','LineWidth',1.5);
hold on
jbfill(time, all_response_unsure_old + SE_response_unsure_old, all_response_unsure_old - SE_response_unsure_old,'r', 'r', 1, 0.2);
% hold on
% plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-1 3]);
ylim([0 0.22]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('LOW CONFIDENCE','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

%% Figure 3.4c) - group x confidence x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES
for grp = 1:2
    all_response_surecorrect = mean(pupil_b4feedback_surecorrect{grp}, 1, 'omitnan');
    SE_response_surecorrect = std(pupil_b4feedback_surecorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_surecorrect{grp}, 1));
    all_response_unsurecorrect = mean(pupil_b4feedback_unsurecorrect{grp}, 1, 'omitnan');
    SE_response_unsurecorrect = std(pupil_b4feedback_unsurecorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsurecorrect{grp}, 1));

    figure;
    plot(time, all_response_surecorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_surecorrect + SE_response_surecorrect, all_response_surecorrect - SE_response_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_unsurecorrect + SE_response_unsurecorrect, all_response_unsurecorrect - SE_response_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
    hold off;
    box off;
    ax = gca;
    ax.LineWidth = 2;
    c = ax.Color;
    ax.FontSize = 26;
    ax.FontName = 'Arial';
    xlim([-1 3]);
    ylim([0 0.22]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - CORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

% INCORRECT RESPONSES
for grp = 1:2
    all_response_sureincorrect = mean(pupil_b4feedback_sureincorrect{grp}, 1, 'omitnan');
    SE_response_sureincorrect = std(pupil_b4feedback_sureincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_b4feedback_sureincorrect{grp}, 1));
    all_response_unsureincorrect = mean(pupil_b4feedback_unsureincorrect{grp}, 1, 'omitnan');
    SE_response_unsureincorrect = std(pupil_b4feedback_unsureincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_b4feedback_unsureincorrect{grp}, 1));

    figure;
    plot(time, all_response_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_sureincorrect + SE_response_sureincorrect, all_response_sureincorrect - SE_response_sureincorrect,[86+50, 180+50, 233+22]./255, [86+50, 180+50, 233+22]./255, 1, 0.2);
    hold on
    plot(time, all_response_unsureincorrect, '--','color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_response_unsureincorrect + SE_response_unsureincorrect, all_response_unsureincorrect - SE_response_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k--','color',[0.5 0.5 0.5],'LineWidth',1.5);
    hold off;
    box off;
    ax = gca;
    ax.LineWidth = 2;
    c = ax.Color;
    ax.FontSize = 28;
    ax.FontName = 'Arial';
    xlim([-1 3]);
    ylim([-0.05 0.22]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - INCORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end
