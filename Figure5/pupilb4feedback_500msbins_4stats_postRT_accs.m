% pupil before feedback divided into low/high confidence -
% correct/incorrect
clear; close all

% participants id for both sexes
female = [1, 2, 4, 5, 6, 8, 10, 11, 13, 14, 22, 28, 29, 30, 35, 38, 39, 41, 50, 52, 55, 56];
male = [3, 7, 9, 12, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 32, 33, 40, 53, 57];

var4table = [];
pupil_b4feedback = cell(1, 5);

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
        filename = ['Participant',num2str(participant),'_S1_M1_AllRuns.set']; % older participants with mental activity session first
    elseif ((participant >= 31 && participant <= 35) || (participant >= 38 && participant <= 40)) && participant ~= 34
        filename = ['Participant',num2str(participant),'_S2_M1_AllRuns.set']; % older participants with physical activity session first
    else
        continue
    end
    
    if ismember(participant, female) % sex of participant 31 missing
        sx = 1;
    else
        sx = 2;
    end


    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG = []; CURRENTSET = [];
    EEG = pop_loadset('filename',filename,'filepath',data_dir);

    % epochs aligned with stimulus
    EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  '6'  '7'  '8'  '9'  }, [-3  6], 'newname', 'stims', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    dados_interpolados = EEG.data(6,:,:);
    EEG = pop_rmbase( EEG, [-200 0] ,[]);
    EEG.data(6,:,:) = dados_interpolados;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    
    % find if there are epochs with no response
    no_response_trial = [];
    for ep = 1:length(EEG.epoch)
        response = intersect({  '11'  '12'  '13'  '14'  '15'  '16' '17' '18'  }, EEG.epoch(ep).eventtype);
        if isempty(response)
            no_response_trial = [no_response_trial; ep];
        end
    end
    
    % create large epochs aligned with response to include stimulus 
    EEG = pop_epoch( EEG, {  '11'  '12'  '13'  '14'  '15'  '16' '17' '18'  }, [-3  3], 'newname', 'responses', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off'); 
    coherence = []; reaction_time = [];
    for ep = 1:length(EEG.epoch)
        if ismember('1', EEG.epoch(ep).eventtype) || ismember('6', EEG.epoch(ep).eventtype)
            coherence = [coherence; 3]; 
            idx = find(ismember(EEG.epoch(ep).eventtype, {'1', '6'}));
            reaction_time = [reaction_time; -cell2mat(EEG.epoch(ep).eventlatency(idx))];
        elseif ismember('2', EEG.epoch(ep).eventtype) || ismember('7', EEG.epoch(ep).eventtype)
            coherence = [coherence; 6];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'2', '7'}));
            reaction_time = [reaction_time; -cell2mat(EEG.epoch(ep).eventlatency(idx))];
        elseif ismember('3', EEG.epoch(ep).eventtype) || ismember('8', EEG.epoch(ep).eventtype)
            coherence = [coherence; 12];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'3', '8'}));
            reaction_time = [reaction_time; -cell2mat(EEG.epoch(ep).eventlatency(idx))];
        elseif ismember('4', EEG.epoch(ep).eventtype) || ismember('9', EEG.epoch(ep).eventtype)
            coherence = [coherence; 24];
            idx = find(ismember(EEG.epoch(ep).eventtype, {'4', '9'}));
            reaction_time = [reaction_time; -cell2mat(EEG.epoch(ep).eventlatency(idx))];
        end
    end
    confidence = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('13', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('17', EEG.epoch(ep).eventtype)
            confidence = [confidence; 1];
        else
            confidence = [confidence; 0];
        end
    end
    
    accuracy = [];
    for ep = 1:length(EEG.epoch)
        if ismember('11', EEG.epoch(ep).eventtype) || ismember('12', EEG.epoch(ep).eventtype) || ismember('15', EEG.epoch(ep).eventtype) || ismember('16', EEG.epoch(ep).eventtype)
            accuracy  = [accuracy ; 1];
        else
            accuracy  = [accuracy ; 0];
        end
    end
    
%     pupil_beforefeedback = [pupil_beforefeedback; squeeze(mean(EEG.data(3, 2500:end, :), 2))];
    
    % 5 averages 500 ms windows non-overlapping from 500ms after response
    % up to 3000 ms
    pupil_b4feedback = cell(1, 5);
    for bn = 1:5
        pupil_b4feedback{bn} = squeeze(mean(EEG.data(3, 1501+250*bn:1750+250*bn, :)));
    end
    
    % delete epochs only based on time of interest from -1 to 3s locked
    % with response
    epochs2delete = [];
    for trl = 1:size(EEG.data, 3)
        if sum(EEG.data(6, 1001:end, trl), 2) > size(EEG.data(6, 1001:end, trl), 2)/2
           epochs2delete = [epochs2delete; trl];
        end
    end
    
    for bn = 1:5
        pupil_b4feedback{bn}(epochs2delete) = NaN;
        pupil_b4feedback{bn}(reaction_time<100) = NaN;
    end
    
    % discard impulsive responses with RT < 100 ms
    confidence(reaction_time<100) = NaN;
    accuracy(reaction_time<100) = NaN;
    reaction_time(reaction_time<100) = NaN;

    
    for bn = 1:5
        pupil_b4feedback{bn}(reaction_time<100) = NaN;
    end
    
    % if there was a trial with no response, the RT of the trial after
    % should not be used turn into NaN
    if ~isempty(no_response_trial)
        for r = 1:length(no_response_trial)
            if no_response_trial(1) == 1
                if r > 1
                    reaction_time(no_response_trial(r)-r+2) = NaN;
                    accuracy(no_response_trial(r)-r+2) = NaN;
                    confidence(no_response_trial(r)-r+2) = NaN;
                end
            else
                reaction_time(no_response_trial(r)-r+1) = NaN;
                accuracy(no_response_trial(r)-r+1) = NaN;
                confidence(no_response_trial(r)-r+2) = NaN;
            end
        end    
    end
        
    group = ones(length(reaction_time)-2, 1)*grp;
%     sex = [sex; ones(length(deltaRT), 1)*sx];
    participant_id = ones(length(reaction_time)-2, 1)*participant;
    
    var4table = [var4table; participant_id, group, reaction_time(1:end-2), accuracy(1:end-2), confidence(2:end-1), accuracy(2:end-1),reaction_time(2:end-1)...
        pupil_b4feedback{1}(2:end-1), pupil_b4feedback{2}(2:end-1), pupil_b4feedback{3}(2:end-1), pupil_b4feedback{4}(2:end-1), pupil_b4feedback{5}(2:end-1), reaction_time(3:end), accuracy(3:end)];

end


%% TABLE - participant, group, deltaCoherence, confidence, accuracy, 'Pupil_1', 'Pupil_2', 'Pupil_3', 'Pupil_4', 'Pupil_5', deltaRT
table_pupilbeforefeedback = array2table(var4table);

table_pupilbeforefeedback.Properties.VariableNames = {'Participant', 'Group', 'PreRT', 'PreAcc', 'Confidence', 'Accuracy','ReactionTime'...
        'Pupil_1', 'Pupil_2', 'Pupil_3', 'Pupil_4', 'Pupil_5',  'PostRT', 'PostAcc'};

filename = 'table_pupilb4feedback_500msbins_postRT_acc.xlsx';

writetable(table_pupilbeforefeedback,filename)

%%
filename = 'table_pupilb4feedback_500msbins_postRT_acc.xlsx';
T = readtable(filename);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end


%% pupil size bins
postRT_pupilbins = cell(2, 1);

for grp = 1:2
    for p = participants{grp}'
        postRT = T.PostRT(T.Participant == p)*.001;
        pupil = T.Pupil_5(T.Participant == p);
        
        [pupil_sorted,index] = sortrows(pupil);
        
        postRT_pupilbins{grp} = [postRT_pupilbins{grp}; mean(postRT(index(1:floor(length(index)/3))), 'omitnan'),...
            mean(postRT(index(floor(length(index)/3)+1:2*floor(length(index)/3))), 'omitnan'),...
            mean(postRT(index(2*floor(length(index)/3)+1:end)), 'omitnan')];
        
    end
end

%
figure;
hold on

% plot individual points
for p = 1:size(postRT_pupilbins{1}, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1],postRT_pupilbins{1}(p, :),'o',...
        'MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1);
    hold on
end
for p = 1:size(postRT_pupilbins{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1],postRT_pupilbins{2}(p, :), 'd',...
    	'MarkerSize',8,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1);
end
% xlim([0; 5]);

% average values
mean_deltaRT_young = mean(postRT_pupilbins{1}, 1, 'omitnan');
mean_deltaRT_older = mean(postRT_pupilbins{2}, 1, 'omitnan');

SE_deltaRT_young = std(postRT_pupilbins{1}, [], 1, 'omitnan')/sqrt(size(postRT_pupilbins{1}, 1));
SE_deltaRT_older = std(postRT_pupilbins{2}, [], 1, 'omitnan')/sqrt(size(postRT_pupilbins{2}, 1));

hold on
p1 = errorbar([1 2 3],mean_deltaRT_young, SE_deltaRT_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 2 3],mean_deltaRT_older, SE_deltaRT_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',1:3, 'XTickLabel',{'Low' 'Median' 'High'})
set(gca, 'XLim',[0 4])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');
xlabel('Pre-feedback pupil','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');


