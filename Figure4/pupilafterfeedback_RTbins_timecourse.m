% pupil after feedback divided into low/high confidence -
% correct/incorrect
clear; close all

pupil_afterfeedback_sure = cell(2, 1);
pupil_afterfeedback_unsure = cell(2, 1);

pupil_afterfeedback_fastRT = cell(2, 1);
pupil_afterfeedback_slowRT = cell(2, 1);

pupil_afterfeedback_correct = cell(2, 1);
pupil_afterfeedback_incorrect = cell(2, 1);

pupil_afterfeedback_surecorrect = cell(2, 1);
pupil_afterfeedback_sureincorrect = cell(2, 1);
pupil_afterfeedback_unsurecorrect = cell(2, 1);
pupil_afterfeedback_unsureincorrect = cell(2, 1);

pupil_afterfeedback_fastRTcorrect = cell(2, 1);
pupil_afterfeedback_fastRTincorrect = cell(2, 1);
pupil_afterfeedback_slowRTcorrect = cell(2, 1);
pupil_afterfeedback_slowRTincorrect = cell(2, 1);


participant_id = [];
group = [];

% pupil_afterfeedback = [];
% 
% pupil_afterfeedback_early = [];
% pupil_afterfeedback_late = [];


[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

data_dir = 'D:\Project_Exercise_SaraOliveira\Data\PupilData';
% excluded participants
excluded = [24, 26, 34, 37, 51, 54];

for participant = setdiff(1:57, excluded)     
    
    coherence = [];
    confidence = []; 
    accuracy = []; 
    reaction_time = [];

    
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

    EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  '6'  '7'  '8'  '9'  }, [-4  10], 'newname', 'stims', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
 
    % create large epochs to include stimulus 
    EEG = pop_epoch( EEG, {  '19'  '20'  }, [-7 3], 'newname', 'feedback', 'epochinfo', 'yes');
    dados_interpolados = EEG.data(6,:,:);
    EEG = pop_rmbase( EEG, [-200 0] ,[]);
    EEG.data(6,:,:) = dados_interpolados;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

    % delete epochs only based on time of interest from -1 to 3s locked
    % with response
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
    
    % find trials with reaction < 100 ms and exclude them from analyses -
    % impulsive responses
    impuls_RT = find(reaction_time < 100);
    if ~isempty(impuls_RT)
        EEG = pop_selectevent( EEG, 'omitepoch', impuls_RT,'deleteevents','off','deleteepochs','on','invertepochs','off');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
    end
    reaction_time(reaction_time < 100) = [];
    coherence(reaction_time < 100) = [];
    
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

    pupil_afterfeedback_sure{grp} = [pupil_afterfeedback_sure{grp}; squeeze(mean(EEG.data(3, 3001:end, confidence == 1), 3))];
    pupil_afterfeedback_unsure{grp} = [pupil_afterfeedback_unsure{grp}; squeeze(mean(EEG.data(3, 3001:end, confidence == 0), 3))];

    fastRT = find(reaction_time < median(reaction_time));
    slowRT = find(reaction_time >= median(reaction_time));
    
    pupil_afterfeedback_fastRT{grp} = [pupil_afterfeedback_fastRT{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT), 3))];
    pupil_afterfeedback_slowRT{grp} = [pupil_afterfeedback_slowRT{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRT), 3))];

    pupil_afterfeedback_correct{grp} = [pupil_afterfeedback_correct{grp}; squeeze(mean(EEG.data(3, 3001:end, accuracy == 1), 3))];
    pupil_afterfeedback_incorrect{grp} = [pupil_afterfeedback_incorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, accuracy == 0), 3))];

    surecorrect = intersect(find(confidence == 1), find(accuracy == 1));
    sureincorrect = intersect(find(confidence == 1), find(accuracy == 0)); 
    unsurecorrect = intersect(find(confidence == 0), find(accuracy == 1));
    unsureincorrect = intersect(find(confidence == 0), find(accuracy == 0));
    
    pupil_afterfeedback_surecorrect{grp} = [pupil_afterfeedback_surecorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, surecorrect ), 3))];
    pupil_afterfeedback_sureincorrect{grp} = [pupil_afterfeedback_sureincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, sureincorrect ), 3))];
    pupil_afterfeedback_unsurecorrect{grp} = [pupil_afterfeedback_unsurecorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, unsurecorrect), 3))];
    pupil_afterfeedback_unsureincorrect{grp} = [pupil_afterfeedback_unsureincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, unsureincorrect), 3))];

    fastRT_correct = intersect(fastRT, find(accuracy == 1));
    fastRTincorrect = intersect(fastRT, find(accuracy == 0));
    slowRTcorrect = intersect(slowRT, find(accuracy == 1));
    slowRTincorrect = intersect(slowRT, find(accuracy == 0));
    
    pupil_afterfeedback_fastRTcorrect{grp} = [pupil_afterfeedback_fastRTcorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRT_correct), 3))];
    pupil_afterfeedback_fastRTincorrect{grp} = [pupil_afterfeedback_fastRTincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, fastRTincorrect), 3))];
    pupil_afterfeedback_slowRTcorrect{grp} = [pupil_afterfeedback_slowRTcorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRTcorrect), 3))];
    pupil_afterfeedback_slowRTincorrect{grp} = [pupil_afterfeedback_slowRTincorrect{grp}; squeeze(mean(EEG.data(3, 3001:end, slowRTincorrect), 3))];


    
    group = [group; ones(length(EEG.epoch), 1)*grp];
    participant_id = [participant_id; ones(length(EEG.epoch), 1)*participant];
end

time = EEG.times(3001:end)/1000;


%% GRAPH BOTH GROUPS TOGETHER - group x accuracy
group = {'YOUNG', 'OLDER'};
line_width = [3.5, 1.5];
    figure;
for grp = 1:2
    all_feedback_correct = mean(pupil_afterfeedback_correct{grp}, 1, 'omitnan');
    SE_feedback_correct = std(pupil_afterfeedback_correct{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_correct{grp}, 1));
    all_feedback_incorrect = mean(pupil_afterfeedback_incorrect{grp}, 1, 'omitnan');
    SE_feedback_incorrect = std(pupil_afterfeedback_incorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_incorrect{grp}, 1));


    plot(time, all_feedback_correct,'color',[0, 158, 115]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_correct + SE_feedback_correct, all_feedback_correct - SE_feedback_correct,[0, 158, 115]./255, [0, 158, 115]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_incorrect, '--','color',[213, 94, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_incorrect + SE_feedback_incorrect, all_feedback_incorrect - SE_feedback_incorrect,[213, 94, 0]./255,[213, 94, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on
end

% plot horizontal line showing sig effect of accuracy p < .01 -> .5 - 2 s
plot([.5, 2],[-.07 -.07], 'k','color',[0 0 0],'LineWidth',6);
% plot horizontal line showing sig interaction group x accuracy p < .01 -> .5-3 s
plot([.5, 3],[-.08 -.08], 'k','color',[0.5 0.5 0.5],'LineWidth',6);


hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.1 0.1]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

%% GRAPHS BOTH GROUPS TOGETHER - group x confidence
% group = {'Young', 'Older'};
figure;
line_width = [3.5, 1.5];
for grp = 1:2
    all_feedback_sure = mean(pupil_afterfeedback_sure{grp}, 1, 'omitnan');
    SE_feedback_sure = std(pupil_afterfeedback_sure{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sure{grp}, 1));
    all_feedback_unsure = mean(pupil_afterfeedback_unsure{grp}, 1, 'omitnan');
    SE_feedback_unsure = std(pupil_afterfeedback_unsure{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsure{grp}, 1));


    plot(time, all_feedback_sure,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_sure + SE_feedback_sure, all_feedback_sure - SE_feedback_sure, [86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsure, '--','color',[230, 159, 0]./255, 'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_unsure + SE_feedback_unsure, all_feedback_unsure - SE_feedback_unsure,[230, 159, 0]./255,[230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on

end

% plot horizontal line showing sig effect of confidence p < .01 -> 1.5 - 3 s
plot([1.5,3],[-.07 -.07], 'k','color',[0 0 0],'LineWidth',6);
% plot horizontal line showing sig interaction group x confidence < .01 -> .5-3 s
plot([2, 2.5],[-.08 -.08], 'k','color',[0.5 0.5 0.5],'LineWidth',6);

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.09 0.06]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


%% GRAPHS BOTH GROUPS TOGETHER - group x confidence x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES

figure;
line_width = [3.5, 1.5];

for grp = 1:2
    all_feedback_surecorrect = mean(pupil_afterfeedback_surecorrect{grp}, 1, 'omitnan');
    SE_feedback_surecorrect = std(pupil_afterfeedback_surecorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_surecorrect{grp}, 1));
    all_feedback_unsurecorrect = mean(pupil_afterfeedback_unsurecorrect{grp}, 1, 'omitnan');
    SE_feedback_unsurecorrect = std(pupil_afterfeedback_unsurecorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsurecorrect{grp}, 1));


    plot(time, all_feedback_surecorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_surecorrect + SE_feedback_surecorrect, all_feedback_surecorrect - SE_feedback_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_unsurecorrect + SE_feedback_unsurecorrect, all_feedback_unsurecorrect - SE_feedback_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on
end


% plot horizontal line showing sig interaction confidence x accuracy p < .01 -> .5-3 s
plot([.5, 2.5],[-.08 -.08], 'k','LineWidth',6);

% plot horizontal line showing sig effect of confidence in correct trials p < .01 -> .5-1 s
plot([.5, 1],[-.09 -.09], 'color',[0.5 0.5 0.5],'LineWidth',6);

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.1 0.12]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title([group{grp}, ' - CORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


% INCORRECT RESPONSES
figure;
for grp = 1:2
    all_feedback_sureincorrect = mean(pupil_afterfeedback_sureincorrect{grp}, 1, 'omitnan');
    SE_feedback_sureincorrect = std(pupil_afterfeedback_sureincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sureincorrect{grp}, 1));
    all_feedback_unsureincorrect = mean(pupil_afterfeedback_unsureincorrect{grp}, 1, 'omitnan');
    SE_feedback_unsureincorrect = std(pupil_afterfeedback_unsureincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsureincorrect{grp}, 1));


    plot(time, all_feedback_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_sureincorrect + SE_feedback_sureincorrect, all_feedback_sureincorrect - SE_feedback_sureincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsureincorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_unsureincorrect + SE_feedback_unsureincorrect, all_feedback_unsureincorrect - SE_feedback_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on

end

% plot horizontal line showing sig interaction confidence x accuracy p < .01 -> .5-3 s
plot([.5, 2.5],[-.08 -.08], 'k','LineWidth',6);

% plot horizontal line showing sig effect of confidence in incorrect trials p < .01 -> 1.5-2 s
plot([1.5, 2.5],[-.09 -.09], 'color',[0.5 0.5 0.5],'LineWidth',6);

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.1 0.12]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title([group{grp}, ' - INCORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


%% GRAPHS BOTH GROUPS TOGETHER - group x RTbin x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES

figure;
line_width = [3.5, 1.5];

for grp = 1:2
    all_feedback_surecorrect = mean(pupil_afterfeedback_fastRTcorrect{grp}, 1, 'omitnan');
    SE_feedback_surecorrect = std(pupil_afterfeedback_fastRTcorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_fastRTcorrect{grp}, 1));
    all_feedback_unsurecorrect = mean(pupil_afterfeedback_slowRTcorrect{grp}, 1, 'omitnan');
    SE_feedback_unsurecorrect = std(pupil_afterfeedback_slowRTcorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_slowRTcorrect{grp}, 1));


    plot(time, all_feedback_surecorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_surecorrect + SE_feedback_surecorrect, all_feedback_surecorrect - SE_feedback_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_unsurecorrect + SE_feedback_unsurecorrect, all_feedback_unsurecorrect - SE_feedback_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on
end

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.1 0.115]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
% title([group{grp}, ' - CORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


% INCORRECT RESPONSES
figure;
for grp = 1:2
    all_feedback_sureincorrect = mean(pupil_afterfeedback_fastRTincorrect{grp}, 1, 'omitnan');
    SE_feedback_sureincorrect = std(pupil_afterfeedback_fastRTincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_fastRTincorrect{grp}, 1));
    all_feedback_unsureincorrect = mean(pupil_afterfeedback_slowRTincorrect{grp}, 1, 'omitnan');
    SE_feedback_unsureincorrect = std(pupil_afterfeedback_slowRTincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_slowRTincorrect{grp}, 1));


    plot(time, all_feedback_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_sureincorrect + SE_feedback_sureincorrect, all_feedback_sureincorrect - SE_feedback_sureincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsureincorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',line_width(grp));
    hold on
    jbfill(time, all_feedback_unsureincorrect + SE_feedback_unsureincorrect, all_feedback_unsureincorrect - SE_feedback_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
    hold on
    plot([min(xlim()),max(xlim())],[0,0], 'k:','LineWidth',1.5);
    hold on

end

hold off;
box off;
ax = gca;
ax.LineWidth = 2;
c = ax.Color;
ax.FontSize = 26;
ax.FontName = 'Arial';
xlim([-.2 3]);
ylim([-0.1 0.115]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
%     title([group{grp}, ' - INCORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

%% Figure 3.4a) - group x accuracy
group = {'YOUNG', 'OLDER'};
for grp = 1:2
    all_feedback_correct = mean(pupil_afterfeedback_correct{grp}, 1, 'omitnan');
    SE_feedback_correct = std(pupil_afterfeedback_correct{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_correct{grp}, 1));
    all_feedback_incorrect = mean(pupil_afterfeedback_incorrect{grp}, 1, 'omitnan');
    SE_feedback_incorrect = std(pupil_afterfeedback_incorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_incorrect{grp}, 1));

    figure;
    plot(time, all_feedback_correct,'color',[0, 158, 115]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_correct + SE_feedback_correct, all_feedback_correct - SE_feedback_correct,[0, 158, 115]./255, [0, 158, 115]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_incorrect, '--','color',[213, 94, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_incorrect + SE_feedback_incorrect, all_feedback_incorrect - SE_feedback_incorrect,[213, 94, 0]./255,[213, 94, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.1]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

%% Effect of Group
all_feedback_correct_young = mean(pupil_afterfeedback_correct{1,1}, 1, 'omitnan');
SE_feedback_correct_young = std(pupil_afterfeedback_correct{1,1}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_correct{1,1}, 1));
all_feedback_correct_old = mean(pupil_afterfeedback_correct{2,1}, 1, 'omitnan');
SE_feedback_correct_old = std(pupil_afterfeedback_correct{2,1}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_correct{2,1}, 1));
all_feedback_incorrect_young = mean(pupil_afterfeedback_incorrect{1,1}, 1, 'omitnan');
SE_feedback_incorrect_young = std(pupil_afterfeedback_incorrect{1,1}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_incorrect{1,1}, 1));
all_feedback_incorrect_old = mean(pupil_afterfeedback_incorrect{2,1}, 1, 'omitnan');
SE_feedback_incorrect_old = std(pupil_afterfeedback_incorrect{2,1}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_incorrect{2,1}, 1));

figure;
plot(time, all_feedback_correct_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_feedback_correct_young + SE_feedback_correct_young, all_feedback_correct_young - SE_feedback_correct_young,'k', 'k', 1, 0.2);
hold on
plot(time, all_feedback_correct_old, '--', 'color', 'r','LineWidth',1.5);
hold on
jbfill(time, all_feedback_correct_old + SE_feedback_correct_old, all_feedback_correct_old - SE_feedback_correct_old,'r', 'r', 1, 0.2);
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
ylim([-0.07 0.1]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('CORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

figure;
plot(time, all_feedback_incorrect_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_feedback_incorrect_young + SE_feedback_incorrect_young, all_feedback_incorrect_young - SE_feedback_incorrect_young,'k', 'k', 1, 0.2);
hold on
plot(time, all_feedback_incorrect_old, '--','color','r','LineWidth',1.5);
hold on
jbfill(time, all_feedback_incorrect_old + SE_feedback_incorrect_old, all_feedback_incorrect_old - SE_feedback_incorrect_old,'r', 'r', 1, 0.2);
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
ylim([-0.07 0.1]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('INCORRECT','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');



%% Figure 3.4b) - group x confidence
% group = {'Young', 'Older'};
for grp = 1:2
    all_feedback_sure = mean(pupil_afterfeedback_sure{grp}, 1, 'omitnan');
    SE_feedback_sure = std(pupil_afterfeedback_sure{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sure{grp}, 1));
    all_feedback_unsure = mean(pupil_afterfeedback_unsure{grp}, 1, 'omitnan');
    SE_feedback_unsure = std(pupil_afterfeedback_unsure{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsure{grp}, 1));

    figure;
    plot(time, all_feedback_sure,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_sure + SE_feedback_sure, all_feedback_sure - SE_feedback_sure, [86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsure, '--','color',[230+25, 159+50, 50]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_unsure + SE_feedback_unsure, all_feedback_unsure - SE_feedback_unsure,[230+25, 159+50, 50]./255, [230+25, 159+50, 50]./255, 1, 0.2);
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
    ylim([-0.07 0.1]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

%% Effect of Group
all_feedback_sure_young = mean(pupil_afterfeedback_sure{1,1}, 1, 'omitnan');
SE_feedback_sure_young = std(pupil_afterfeedback_sure{1,1}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sure{1,1}, 1));
all_feedback_sure_old = mean(pupil_afterfeedback_sure{2,1}, 1, 'omitnan');
SE_feedback_sure_old = std(pupil_afterfeedback_sure{2,1}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sure{2,1}, 1));
all_feedback_unsure_young = mean(pupil_afterfeedback_unsure{1,1}, 1, 'omitnan');
SE_feedback_unsure_young = std(pupil_afterfeedback_unsure{1,1}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsure{1,1}, 1));
all_feedback_unsure_old = mean(pupil_afterfeedback_unsure{2,1}, 1, 'omitnan');
SE_feedback_unsure_old = std(pupil_afterfeedback_unsure{2,1}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsure{2,1}, 1));

figure;
plot(time, all_feedback_sure_young,'color','k','LineWidth',1.5);
hold on
jbfill(time, all_feedback_sure_young + SE_feedback_sure_young, all_feedback_sure_young - SE_feedback_sure_young,'k', 'k', 1, 0.2);
hold on
plot(time, all_feedback_sure_old, '--', 'color','r','LineWidth',1.5);
hold on
jbfill(time, all_feedback_sure_old + SE_feedback_sure_old, all_feedback_sure_old - SE_feedback_sure_old,'r', 'r', 1, 0.2);
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
ylim([-0.07 0.1]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('HIGH CONFIDENCE','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');

figure;
plot(time, all_feedback_unsure_young,'color', 'k','LineWidth',1.5);
hold on
jbfill(time, all_feedback_unsure_young + SE_feedback_unsure_young, all_feedback_unsure_young - SE_feedback_unsure_young, 'k', 'k', 1, 0.2);
hold on
plot(time, all_feedback_unsure_old, '--','color', 'r','LineWidth',1.5);
hold on
jbfill(time, all_feedback_unsure_old + SE_feedback_unsure_old, all_feedback_unsure_old - SE_feedback_unsure_old,'r', 'r', 1, 0.2);
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
ylim([-0.07 0.1]);
xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
title('LOW CONFIDENCE','FontSize',30,'FontName','Arial', 'FontWeight', 'normal');


%% Figure 3.4c) - group x confidence x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES
for grp = 1:2
    all_feedback_surecorrect = mean(pupil_afterfeedback_surecorrect{grp}, 1, 'omitnan');
    SE_feedback_surecorrect = std(pupil_afterfeedback_surecorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_surecorrect{grp}, 1));
    all_feedback_unsurecorrect = mean(pupil_afterfeedback_unsurecorrect{grp}, 1, 'omitnan');
    SE_feedback_unsurecorrect = std(pupil_afterfeedback_unsurecorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsurecorrect{grp}, 1));

    figure;
    plot(time, all_feedback_surecorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_surecorrect + SE_feedback_surecorrect, all_feedback_surecorrect - SE_feedback_surecorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsurecorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_unsurecorrect + SE_feedback_unsurecorrect, all_feedback_unsurecorrect - SE_feedback_unsurecorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.12]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - CORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

% INCORRECT RESPONSES
for grp = 1:2
    all_feedback_sureincorrect = mean(pupil_afterfeedback_sureincorrect{grp}, 1, 'omitnan');
    SE_feedback_sureincorrect = std(pupil_afterfeedback_sureincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_sureincorrect{grp}, 1));
    all_feedback_unsureincorrect = mean(pupil_afterfeedback_unsureincorrect{grp}, 1, 'omitnan');
    SE_feedback_unsureincorrect = std(pupil_afterfeedback_unsureincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_unsureincorrect{grp}, 1));

    figure;
    plot(time, all_feedback_sureincorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_sureincorrect + SE_feedback_sureincorrect, all_feedback_sureincorrect - SE_feedback_sureincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_unsureincorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_unsureincorrect + SE_feedback_unsureincorrect, all_feedback_unsureincorrect - SE_feedback_unsureincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.12]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - INCORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

%% confidence from reaction time
% group x confidence
% group = {'Young', 'Older'};
group = {'YOUNG', 'OLDER'};
for grp = 1:2
    all_feedback_fastRT = mean(pupil_afterfeedback_fastRT{grp}, 1, 'omitnan');
    SE_feedback_fastRT = std(pupil_afterfeedback_fastRT{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_fastRT{grp}, 1));
    all_feedback_slowRT = mean(pupil_afterfeedback_slowRT{grp}, 1, 'omitnan');
    SE_feedback_slowRT = std(pupil_afterfeedback_slowRT{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_slowRT{grp}, 1));

    figure;
    plot(time, all_feedback_fastRT,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_fastRT + SE_feedback_fastRT, all_feedback_fastRT - SE_feedback_fastRT, [86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_slowRT, '--','color',[230+25, 159+50, 50]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_slowRT + SE_feedback_slowRT, all_feedback_slowRT - SE_feedback_slowRT,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.1]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' ADULTS'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end


%% CONFIDENCE FROM REACTION TIME - group x confidence x accuracy
% group = {'Young', 'Older'};
% CORRECT RESPONSES
for grp = 1:2
    all_feedback_fastRTcorrect = mean(pupil_afterfeedback_fastRTcorrect{grp}, 1, 'omitnan');
    SE_feedback_fastRTcorrect = std(pupil_afterfeedback_fastRTcorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_fastRTcorrect{grp}, 1));
    all_feedback_slowRTcorrect = mean(pupil_afterfeedback_slowRTcorrect{grp}, 1, 'omitnan');
    SE_feedback_slowRTcorrect = std(pupil_afterfeedback_slowRTcorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_slowRTcorrect{grp}, 1));

    figure;
    plot(time, all_feedback_fastRTcorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_fastRTcorrect + SE_feedback_fastRTcorrect, all_feedback_fastRTcorrect - SE_feedback_fastRTcorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_slowRTcorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_slowRTcorrect + SE_feedback_slowRTcorrect, all_feedback_slowRTcorrect - SE_feedback_slowRTcorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.12]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - CORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end

% INCORRECT RESPONSES
for grp = 1:2
    all_feedback_fastRTincorrect = mean(pupil_afterfeedback_fastRTincorrect{grp}, 1, 'omitnan');
    SE_feedback_fastRTincorrect = std(pupil_afterfeedback_fastRTincorrect{grp}, [], 1, 'omitnan')/sqrt(size(pupil_afterfeedback_fastRTincorrect{grp}, 1));
    all_feedback_slowRTincorrect = mean(pupil_afterfeedback_slowRTincorrect{grp}, 1, 'omitnan');
    SE_feedback_slowRTincorrect = std(pupil_afterfeedback_slowRTincorrect{grp}, 1, 'omitnan')/sqrt(size(pupil_afterfeedback_slowRTincorrect{grp}, 1));

    figure;
    plot(time, all_feedback_fastRTincorrect,'color',[86, 180, 233]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_fastRTincorrect + SE_feedback_fastRTincorrect, all_feedback_fastRTincorrect - SE_feedback_fastRTincorrect,[86, 180, 233]./255, [86, 180, 233]./255, 1, 0.2);
    hold on
    plot(time, all_feedback_slowRTincorrect, '--', 'color',[230, 159, 0]./255,'LineWidth',1.5);
    hold on
    jbfill(time, all_feedback_slowRTincorrect + SE_feedback_slowRTincorrect, all_feedback_slowRTincorrect - SE_feedback_slowRTincorrect,[230, 159, 0]./255, [230, 159, 0]./255, 1, 0.2);
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
    ylim([-0.07 0.12]);
    xlabel('Time (s)','FontSize',30,'FontName','Arial'); ylabel('Pupil Response (%)','FontSize',30,'FontName','Arial');
    title([group{grp}, ' - INCORRECT'],'FontSize',30,'FontName','Arial', 'FontWeight', 'normal');
end
