% pupil before feedback divided into low/high confidence -
% correct/incorrect
clear; close all


var4table = [];


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

    
    coherence = [];
    confidence = []; 
    accuracy = []; 
    pupil_afterfeedback = cell(1, 5);

    reaction_time = [];
    
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG = []; CURRENTSET = [];
    EEG = pop_loadset('filename',filename,'filepath',data_dir);

    EEG = pop_epoch( EEG, {  '1'  '2'  '3'  '4'  '6'  '7'  '8'  '9'  }, [-4  10], 'newname', 'stims', 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    
    % find if there are epochs with no response
    no_response_trial = [];
    for ep = 1:length(EEG.epoch)
        response = intersect({  '11'  '12'  '13'  '14'  '15'  '16' '17' '18'  }, EEG.epoch(ep).eventtype);
        if isempty(response)
            no_response_trial = [no_response_trial; ep];
        end
    end
    
 
    % create large epochs to include stimulus 
    EEG = pop_epoch( EEG, {  '19'  '20'  }, [-7 3], 'newname', 'feedback', 'epochinfo', 'yes');
    dados_interpolados = EEG.data(6,:,:);
    EEG = pop_rmbase( EEG, [-200 0] ,[]);
    EEG.data(6,:,:) = dados_interpolados;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    
    

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
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0);
    
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


    % 5 averages 500 ms windows non-overlapping
    for bn = 1:5
        pupil_afterfeedback{bn} = [pupil_afterfeedback{bn}; squeeze(mean(EEG.data(3, 3501+250*bn:3750+250*bn, :)))];
    end
    
    % delete epochs only based on time of interest from -1 to 3s locked
    % with feedback
    epochs2delete = [];
    for trl = 1:size(EEG.data, 3)
        if sum(EEG.data(6, 3000:end, trl), 2) > size(EEG.data(6, 3000:end, trl), 2)/2
           epochs2delete = [epochs2delete; trl];
        end
    end
    
    % delete epochs with poor pupil data and impulsive responses RT < 100ms
    for bn = 1:5
        pupil_afterfeedback{bn}(epochs2delete) = NaN;
        pupil_afterfeedback{bn}(reaction_time<100) = NaN;
    end

    confidence(reaction_time<100) = NaN;
    accuracy(reaction_time<100) = NaN;
    reaction_time(reaction_time<100) = NaN;

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
        pupil_afterfeedback{1}(2:end-1), pupil_afterfeedback{2}(2:end-1), pupil_afterfeedback{3}(2:end-1), pupil_afterfeedback{4}(2:end-1), pupil_afterfeedback{5}(2:end-1), reaction_time(3:end), accuracy(3:end)];

end


%% TABLE - participant, group, deltaCoherence, confidence, accuracy, 'Pupil_1', 'Pupil_2', 'Pupil_3', 'Pupil_4', 'Pupil_5', deltaRT
table_afterfeedback = array2table(var4table);

table_afterfeedback.Properties.VariableNames = {'Participant', 'Group', 'PreRT', 'PreAcc', 'Confidence', 'Accuracy','ReactionTime'...
        'Pupil_1', 'Pupil_2', 'Pupil_3', 'Pupil_4', 'Pupil_5',  'PostRT', 'PostAcc'};

filename = 'table_afterfeedback_500msbins_postRT_acc.xlsx';

writetable(table_afterfeedback,filename)


%% graph
filename = 'table_pupilafterfeedback_deltaRT.xlsx';
T = readtable(filename);


for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% regression lines
for grp = 1:2
    figure;
    for p = participants{grp}'
        plot(T.Pupil_4(T.Participant == p), T.DeltaRT(T.Participant == p),  'o')
        lsline
        hold on
    end
end


% pupil size bins
deltaRT_pupilbins = cell(2, 1);

for grp = 1:2
    for p = participants{grp}'
        deltaRT = T.DeltaRT(T.Participant == p)*.001;
        pupil = mean([T.Pupil_3(T.Participant == p), T.Pupil_4(T.Participant == p), T.Pupil_5(T.Participant == p)], 2) ;
        
        [pupil_sorted,index] = sortrows(pupil);
        
        deltaRT_pupilbins{grp} = [deltaRT_pupilbins{grp}; mean(deltaRT(index(1:floor(length(index)/3))), 'omitnan'),...
            mean(deltaRT(index(floor(length(index)/3)+1:2*floor(length(index)/3))), 'omitnan'),...
            mean(deltaRT(index(2*floor(length(index)/3)+1:end)), 'omitnan')];
        
    end
end

%
figure;
hold on
plot([0 4], [0 0], ':k', 'LineWidth',1);

% plot individual points
for p = 1:size(deltaRT_pupilbins{1}, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1],deltaRT_pupilbins{1}(p, :),'o',...
        'MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1);
    hold on
end
for p = 1:size(deltaRT_pupilbins{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1],deltaRT_pupilbins{2}(p, :), 'd',...
    	'MarkerSize',8,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1);
end
% xlim([0; 5]);

% average values
mean_deltaRT_young = mean(deltaRT_pupilbins{1}, 1, 'omitnan');
mean_deltaRT_older = mean(deltaRT_pupilbins{2}, 1, 'omitnan');

SE_deltaRT_young = std(deltaRT_pupilbins{1}, [], 1, 'omitnan')/sqrt(size(deltaRT_pupilbins{1}, 1));
SE_deltaRT_older = std(deltaRT_pupilbins{2}, [], 1, 'omitnan')/sqrt(size(deltaRT_pupilbins{2}, 1));

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
ylabel('\Delta reaction time (s)','FontSize',30,'FontName','Arial');
xlabel('Pupil after feedback','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');
