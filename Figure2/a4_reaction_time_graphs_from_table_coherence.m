clear; close all;

filename = 'table_reactiontime_MR_withoutexcluded.xlsx';
T = readtable(filename);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

% reactiontime per coherence 

reactiontime.young.per_coherence = [];

reactiontime.young.lowconf_per_coherence = [];
reactiontime.young.highconf_per_coherence = [];

reactiontime.older.per_coherence = [];

reactiontime.older.lowconf_per_coherence = [];
reactiontime.older.highconf_per_coherence = [];

reactiontime.young.per_confidence = [];
reactiontime.young.per_accuracy    = [];        
reactiontime.older.per_confidence = [];
reactiontime.older.per_accuracy = [];
reactiontime.young.confidence_accuracy = [];
reactiontime.young.accuracy_coherence = [];
reactiontime.older.confidence_accuracy = [];
reactiontime.older.accuracy_coherence  = []; 

reactiontime.older.incorrect_per_coherence = [];
reactiontime.older.correct_per_coherence = [];
reactiontime.young.incorrect_per_coherence = [];
reactiontime.young.correct_per_coherence = [];

 
for grp = 1:2
    for prt = participants{grp}'
        
        conf = T.Confidence(T.Participant == prt);
        acc = T.Accuracy(T.Participant == prt);
        coh = T.Coherence(T.Participant == prt);
        RT = T.ReactionTime(T.Participant == prt);
        
        coh1 = find(coh == 3);
        coh2 = find(coh == 6);
        coh3 = find(coh == 12);
        coh4 = find(coh == 24);
        
        lowconf = find(conf == 0);
        highconf = find(conf == 1);
        
        incorrect = find(acc == 0);
        correct = find(acc == 1);
        
        lowconf_coh1 = intersect(find(conf == 0), find(coh == 3));
        lowconf_coh2 = intersect(find(conf == 0), find(coh == 6));
        lowconf_coh3 = intersect(find(conf == 0), find(coh == 12));
        lowconf_coh4 = intersect(find(conf == 0), find(coh == 24));
        
        highconf_coh1 = intersect(find(conf == 1), find(coh == 3));
        highconf_coh2 = intersect(find(conf == 1), find(coh == 6));
        highconf_coh3 = intersect(find(conf == 1), find(coh == 12));
        highconf_coh4 = intersect(find(conf == 1), find(coh == 24));
        
        
        lowconf_incorrect = intersect(find(conf == 0), find(acc == 0));
        lowconf_correct = intersect(find(conf == 0), find(acc == 1));
        highconf_incorrect = intersect(find(conf == 1), find(acc == 0));
        highconf_correct = intersect(find(conf == 1), find(acc == 1));
        
        incorrect_easy = intersect(find(acc == 0), find(coh == 3 | coh == 6));
        correct_easy = intersect(find(acc == 1), find(coh == 3 | coh == 6));
        incorrect_difficult = intersect(find(acc == 0), find(coh == 12 | coh == 24));
        correct_difficult = intersect(find(acc == 1), find(coh == 12 | coh == 24));
        
        
        % all the coherences separately
        
        incorrect_coh1 = intersect(find(acc == 0), find(coh == 3));
        incorrect_coh2 = intersect(find(acc == 0), find(coh == 6));
        incorrect_coh3 = intersect(find(acc == 0), find(coh == 12));
        incorrect_coh4 = intersect(find(acc == 0), find(coh == 24));
        
        correct_coh1 = intersect(find(acc == 1), find(coh == 3));
        correct_coh2 = intersect(find(acc == 1), find(coh == 6));
        correct_coh3 = intersect(find(acc == 1), find(coh == 12));
        correct_coh4 = intersect(find(acc == 1), find(coh == 24));

        if grp == 1

            reactiontime.young.per_coherence = [reactiontime.young.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(RT(coh1), 'omitnan'), mean(RT(coh2), 'omitnan'), mean(RT(coh3), 'omitnan'), mean(RT(coh4), 'omitnan')];
            
           reactiontime.young.per_confidence = [reactiontime.young.per_confidence;
                length(lowconf), length(highconf),...
                mean(RT(lowconf), 'omitnan'), mean(RT(highconf), 'omitnan')];
            
            reactiontime.young.per_accuracy = [reactiontime.young.per_accuracy;
                length(incorrect), length(correct),...
                mean(RT(incorrect), 'omitnan'), mean(RT(correct), 'omitnan')];
            
            
            reactiontime.young.lowconf_per_coherence = [reactiontime.young.lowconf_per_coherence;...
                length(lowconf_coh1), length(lowconf_coh2), length(lowconf_coh3), length(lowconf_coh4),...
                mean(RT(lowconf_coh1), 'omitnan'), mean(RT(lowconf_coh2), 'omitnan'), mean(RT(lowconf_coh3), 'omitnan'), mean(RT(lowconf_coh4), 'omitnan')];
            
            reactiontime.young.highconf_per_coherence = [reactiontime.young.highconf_per_coherence;...
                length(highconf_coh1), length(highconf_coh2), length(highconf_coh3), length(highconf_coh4),...
                mean(RT(highconf_coh1), 'omitnan'), mean(RT(highconf_coh2), 'omitnan'), mean(RT(highconf_coh3), 'omitnan'), mean(RT(highconf_coh4), 'omitnan')];
            
            
            reactiontime.young.confidence_accuracy = [reactiontime.young.confidence_accuracy;...
                length(lowconf_incorrect), length(lowconf_correct), length(highconf_incorrect), length(highconf_correct),...
                mean(RT(lowconf_incorrect), 'omitnan'), mean(RT(lowconf_correct), 'omitnan'), mean(RT(highconf_incorrect), 'omitnan'), mean(RT(highconf_correct), 'omitnan')];
            
        
            reactiontime.young.accuracy_coherence = [reactiontime.young.accuracy_coherence;...
                length(incorrect_easy), length(correct_easy), length(incorrect_difficult), length(correct_difficult),...
                mean(RT(incorrect_easy), 'omitnan'), mean(RT(correct_easy), 'omitnan'), mean(RT(incorrect_difficult), 'omitnan'), mean(RT(correct_difficult), 'omitnan')];    
          
            % reaction time - accuracy x coherence
            reactiontime.young.incorrect_per_coherence = [reactiontime.young.incorrect_per_coherence;...
                length(incorrect_coh1), length(incorrect_coh2), length(incorrect_coh3), length(incorrect_coh4),...
                mean(RT(incorrect_coh1), 'omitnan'), mean(RT(incorrect_coh2), 'omitnan'), mean(RT(incorrect_coh3), 'omitnan'), mean(RT(incorrect_coh4), 'omitnan')];
            
            reactiontime.young.correct_per_coherence = [reactiontime.young.correct_per_coherence;...
                length(correct_coh1), length(correct_coh2), length(correct_coh3), length(correct_coh4),...
                mean(RT(correct_coh1), 'omitnan'), mean(RT(correct_coh2), 'omitnan'), mean(RT(correct_coh3), 'omitnan'), mean(RT(correct_coh4), 'omitnan')];
            
        else

 
            reactiontime.older.per_coherence = [reactiontime.older.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(RT(coh1), 'omitnan'), mean(RT(coh2), 'omitnan'), mean(RT(coh3), 'omitnan'), mean(RT(coh4), 'omitnan')];  
            
            reactiontime.older.per_confidence = [reactiontime.older.per_confidence;
                length(lowconf), length(highconf),...
                mean(RT(lowconf), 'omitnan'), mean(RT(highconf), 'omitnan')];
            
            reactiontime.older.per_accuracy = [reactiontime.older.per_accuracy;
                length(incorrect), length(correct),...
                mean(RT(incorrect), 'omitnan'), mean(RT(correct), 'omitnan')];
            
            reactiontime.older.lowconf_per_coherence = [reactiontime.older.lowconf_per_coherence;...
                length(lowconf_coh1), length(lowconf_coh2), length(lowconf_coh3), length(lowconf_coh4),...
                mean(RT(lowconf_coh1), 'omitnan'), mean(RT(lowconf_coh2), 'omitnan'), mean(RT(lowconf_coh3), 'omitnan'), mean(RT(lowconf_coh4), 'omitnan')];
            
            reactiontime.older.highconf_per_coherence = [reactiontime.older.highconf_per_coherence;...
                length(highconf_coh1), length(highconf_coh2), length(highconf_coh3), length(highconf_coh4),...
                mean(RT(highconf_coh1), 'omitnan'), mean(RT(highconf_coh2), 'omitnan'), mean(RT(highconf_coh3), 'omitnan'), mean(RT(highconf_coh4), 'omitnan')];
            
            reactiontime.older.confidence_accuracy = [reactiontime.older.confidence_accuracy;...
                length(lowconf_incorrect), length(lowconf_correct), length(highconf_incorrect), length(highconf_correct),...
                mean(RT(lowconf_incorrect), 'omitnan'), mean(RT(lowconf_correct), 'omitnan'), mean(RT(highconf_incorrect), 'omitnan'), mean(RT(highconf_correct), 'omitnan')];
            
            reactiontime.older.accuracy_coherence = [reactiontime.older.accuracy_coherence;...
                length(incorrect_easy), length(correct_easy), length(incorrect_difficult), length(correct_difficult),...
                mean(RT(incorrect_easy), 'omitnan'), mean(RT(correct_easy), 'omitnan'), mean(RT(incorrect_difficult), 'omitnan'), mean(RT(correct_difficult), 'omitnan')];    
    
            % reaction time - accuracy x coherence
            reactiontime.older.incorrect_per_coherence = [reactiontime.older.incorrect_per_coherence;...
                length(incorrect_coh1), length(incorrect_coh2), length(incorrect_coh3), length(incorrect_coh4),...
                mean(RT(incorrect_coh1), 'omitnan'), mean(RT(incorrect_coh2), 'omitnan'), mean(RT(incorrect_coh3), 'omitnan'), mean(RT(incorrect_coh4), 'omitnan')];
            
            reactiontime.older.correct_per_coherence = [reactiontime.older.correct_per_coherence;...
                length(correct_coh1), length(correct_coh2), length(correct_coh3), length(correct_coh4),...
                mean(RT(correct_coh1), 'omitnan'), mean(RT(correct_coh2), 'omitnan'), mean(RT(correct_coh3), 'omitnan'), mean(RT(correct_coh4), 'omitnan')];
        end
    end
end


%% plot
% coherence x group
figure;
% xticklabels(reactiontime);
hold on

mean_young = reactiontime.young.per_coherence(:, 5:end);
mean_older = reactiontime.older.per_coherence(:, 5:end);


% plot individual points
for p = 1:size(mean_young, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young(p, :),'o',...
        'MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1.5);
end
for p = 1:size(mean_older, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older(p, :), 'd',...
    	'MarkerSize',8,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_young = mean(mean_young, 1, 'omitnan');
mean_reactiontime_older = mean(mean_older, 1, 'omitnan');

SE_reactiontime_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_reactiontime_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 2 3 4],mean_reactiontime_young, SE_reactiontime_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 2 3 4],mean_reactiontime_older, SE_reactiontime_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 26;
ax.FontName = 'Arial';
set(gca, 'XTick',1:4, 'XTickLabel',{'3', '6', '12', '24'})
set(gca, 'XLim',[0 5])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel('Reaction time (s)','FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');



%% confidence x group
figure;
% xticklabels(reactiontime);
hold on

mean_young = reactiontime.young.per_confidence(:, 3:end);
mean_older = reactiontime.older.per_confidence(:, 3:end);


% plot individual points
for p = 1:size(mean_young, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young(p, :),'o',...
        'MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1.5);
end
for p = 1:size(mean_older, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older(p, :), 'd',...
    	'MarkerSize',8,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_young = mean(mean_young, 1, 'omitnan');
mean_reactiontime_older = mean(mean_older, 1, 'omitnan');

SE_reactiontime_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_reactiontime_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4],mean_reactiontime_young, SE_reactiontime_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],mean_reactiontime_older, SE_reactiontime_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 30;
ax.FontName = 'Arial';
set(gca, 'XTick', [1, 4], 'XTickLabel',{'Low conf' 'High conf'})
set(gca, 'XLim',[0 5])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel('Reaction time (s)','FontSize',34,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');

%% accuracy x group
figure;
% xticklabels(reactiontime);

mean_young = reactiontime.young.per_accuracy(:, 3:end);
mean_older = reactiontime.older.per_accuracy(:, 3:end);


% plot individual points
for p = 1:size(mean_young, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young(p, :),'o',...
        'MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1.5);
    hold on
end
for p = 1:size(mean_older, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older(p, :), 'd',...
    	'MarkerSize',8,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1.5);
end
xlim([0 5]);

% average values
mean_reactiontime_young = mean(mean_young, 1, 'omitnan');
mean_reactiontime_older = mean(mean_older, 1, 'omitnan');

SE_reactiontime_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_reactiontime_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4],mean_reactiontime_young, SE_reactiontime_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],mean_reactiontime_older, SE_reactiontime_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 30;
ax.FontName = 'Arial';
set(gca, 'XTick', [1, 4], 'XTickLabel',{'Incorrect' 'Correct'})
set(gca, 'XLim',[0 5])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel('Reaction time (s)','FontSize',34,'FontName','Arial');


%%
% accuracy x coherence - young group
% reactiontime.young.accuracy_coherence =  incorrect_easy,  correct_easy,   incorrect_difficult, correct_difficult   

mean_young_incorrect = [mean(reactiontime.young.incorrect_per_coherence(:, 5), 2, 'omitnan'),...
    mean(reactiontime.young.incorrect_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(reactiontime.young.incorrect_per_coherence(:, 7), 2, 'omitnan'),...
    mean(reactiontime.young.incorrect_per_coherence(:, 8), 2, 'omitnan')];

mean_young_correct = [mean(reactiontime.young.correct_per_coherence(:, 5), 2, 'omitnan'),...
    mean(reactiontime.young.correct_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(reactiontime.young.correct_per_coherence(:, 7), 2, 'omitnan'),...
    mean(reactiontime.young.correct_per_coherence(:, 8), 2, 'omitnan')];


figure
% plot individual points
for p = 1:size(mean_young_correct, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1 3+rand*0.2-0.1 4+rand*0.2-0.1],mean_young_correct(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[0+50, 158+50, 115+50]./255,'LineStyle','none','LineWidth',1.5);
    hold on
end

for p = 1:size(mean_young_incorrect, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1 3+rand*0.2-0.1 4+rand*0.2-0.1],mean_young_incorrect(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[213+42, 94+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_young_incorrect = mean(mean_young_incorrect, 1, 'omitnan');
mean_reactiontime_young_correct = mean(mean_young_correct, 1, 'omitnan');

SE_reactiontime_young_incorrect = std(mean_young_incorrect, [], 1, 'omitnan')/sqrt(size(mean_young_incorrect, 1));
SE_reactiontime_young_correct = std(mean_young_correct, [], 1, 'omitnan')/sqrt(size(mean_young_correct, 1));

hold on
p1 = errorbar([1 2 3 4], mean_reactiontime_young_incorrect, SE_reactiontime_young_incorrect, '--', 'color',[213, 94, 0]./255,'LineWidth', 2.5);
hold on
p2 = errorbar([1 2 3 4], mean_reactiontime_young_correct, SE_reactiontime_young_correct, 'color',[0, 158, 115]./255,'LineWidth', 2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 2, 3, 4], 'XTickLabel',{'3' '6' '12' '24'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim([0.4 3.1])
ylabel({'Reaction time', '(s)'},'FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');
%%
% accuracy x coherence - older group
% reactiontime.older.accuracy_coherence =  incorrect_easy,  correct_easy,   incorrect_difficult, correct_difficult   

mean_older_incorrect = [mean(reactiontime.older.incorrect_per_coherence(:, 5), 2, 'omitnan'),...
    mean(reactiontime.older.incorrect_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(reactiontime.older.incorrect_per_coherence(:, 7), 2, 'omitnan'),...
    mean(reactiontime.older.incorrect_per_coherence(:, 8), 2, 'omitnan')];

mean_older_correct = [mean(reactiontime.older.correct_per_coherence(:, 5), 2, 'omitnan'),...
    mean(reactiontime.older.correct_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(reactiontime.older.correct_per_coherence(:, 7), 2, 'omitnan'),...
    mean(reactiontime.older.correct_per_coherence(:, 8), 2, 'omitnan')];


figure
% plot individual points
for p = 1:size(mean_older_correct, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1 3+rand*0.2-0.1 4+rand*0.2-0.1],mean_older_correct(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[0+50, 158+50, 115+50]./255,'LineStyle','none','LineWidth',1.5);
    hold on
end

for p = 1:size(mean_older_incorrect, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1 3+rand*0.2-0.1 4+rand*0.2-0.1],mean_older_incorrect(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[213+42, 94+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_older_incorrect = mean(mean_older_incorrect, 1, 'omitnan');
mean_reactiontime_older_correct = mean(mean_older_correct, 1, 'omitnan');

SE_reactiontime_older_incorrect = std(mean_older_incorrect, [], 1, 'omitnan')/sqrt(size(mean_older_incorrect, 1));
SE_reactiontime_older_correct = std(mean_older_correct, [], 1, 'omitnan')/sqrt(size(mean_older_correct, 1));

hold on
p1 = errorbar([1 2 3 4], mean_reactiontime_older_incorrect, SE_reactiontime_older_incorrect, '--', 'color',[213, 94, 0]./255,'LineWidth', 2.5);
hold on
p2 = errorbar([1 2 3 4], mean_reactiontime_older_correct, SE_reactiontime_older_correct, 'color',[0, 158, 115]./255,'LineWidth', 2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 2, 3, 4], 'XTickLabel',{'3' '6' '12' '24'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim([0.4 3.1])
ylabel({'Reaction time', '(s)'},'FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');

%%
% accuracy x coherence - young group
% reactiontime.young.accuracy_coherence =  incorrect_easy,  correct_easy,   incorrect_difficult, correct_difficult   

figure;

hold on

mean_young_incorrect = reactiontime.young.accuracy_coherence(:, [5, 7]);
mean_young_correct = reactiontime.young.accuracy_coherence(:, [6, 8]);

% plot individual points
for p = 1:size(mean_young_correct, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_correct(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[0+50, 158+50, 115+50]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_young_incorrect, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_incorrect(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[213+42, 94+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_young_incorrect = mean(mean_young_incorrect, 1, 'omitnan');
mean_reactiontime_young_correct = mean(mean_young_correct, 1, 'omitnan');

SE_reactiontime_young_incorrect = std(mean_young_incorrect, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_reactiontime_young_correct = std(mean_young_correct, [], 1, 'omitnan')/sqrt(size(mean_young, 1));

hold on
p1 = errorbar([1 4], mean_reactiontime_young_incorrect, SE_reactiontime_young_incorrect, '--', 'color',[213, 94, 0]./255 , 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_reactiontime_young_correct, SE_reactiontime_young_correct, 'color', [0, 158, 115]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel('Reaction time (s)','FontSize',32,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%%
% accuracy x coherence - older group
% reactiontime.older.accuracy_coherence =  incorrect_easy,  correct_easy,   incorrect_difficult, correct_difficult   

figure;

hold on

mean_older_incorrect = reactiontime.older.accuracy_coherence(:, [5, 7]);
mean_older_correct = reactiontime.older.accuracy_coherence(:, [6, 8]);

% plot individual points
for p = 1:size(mean_older_correct, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_correct(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[0+50, 158+50, 115+50]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_older_incorrect, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_incorrect(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[213+42, 94+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_older_incorrect = mean(mean_older_incorrect, 1, 'omitnan');
mean_reactiontime_older_correct = mean(mean_older_correct, 1, 'omitnan');

SE_reactiontime_older_incorrect = std(mean_older_incorrect, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
SE_reactiontime_older_correct = std(mean_older_correct, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4], mean_reactiontime_older_incorrect, SE_reactiontime_older_incorrect, '--', 'color',[213, 94, 0]./255 , 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_reactiontime_older_correct, SE_reactiontime_older_correct, 'color', [0, 158, 115]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel('Reaction time (s)','FontSize',32,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');


%%
% coherence x confidence - young group
figure;
% reactiontime = {'Incorrect' 'Correct'};
% xticklabels(reactiontime);
hold on

mean_young_lowconf = [mean(reactiontime.young.lowconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(reactiontime.young.lowconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_young_highconf = [mean(reactiontime.young.highconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(reactiontime.young.highconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;

% plot individual points
for p = 1:size(mean_young_highconf, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_highconf(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[230+25, 159+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_young_lowconf, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_lowconf(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[86+50, 180+50, 233+22]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_young_lowconf = mean(mean_young_lowconf, 1, 'omitnan');
mean_reactiontime_young_highconf = mean(mean_young_highconf, 1, 'omitnan');

SE_reactiontime_young_lowconf = std(mean_young_lowconf, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_reactiontime_young_highconf = std(mean_young_highconf, [], 1, 'omitnan')/sqrt(size(mean_young, 1));

hold on
p1 = errorbar([1 4], mean_reactiontime_young_lowconf, SE_reactiontime_young_lowconf, '--', 'color',[86, 180, 233]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_reactiontime_young_highconf, SE_reactiontime_young_highconf, 'color', [230, 159, 0]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel('reactiontime (%)','FontSize',32,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%% coherence x confidence - older group
figure;
% reactiontime = {'Incorrect' 'Correct'};
% xticklabels(reactiontime);
hold on

mean_older_lowconf = [mean(reactiontime.older.lowconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(reactiontime.older.lowconf_per_coherence(:, 7:8), 2, 'omitnan')];
mean_older_highconf = [mean(reactiontime.older.highconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(reactiontime.older.highconf_per_coherence(:, 7:8), 2, 'omitnan')];

% plot individual points
for p = 1:size(mean_older_highconf, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_highconf(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[230+25, 159+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_older_lowconf, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_lowconf(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[86+50, 180+50, 233+22]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_reactiontime_older_lowconf = mean(mean_older_lowconf, 1, 'omitnan');
mean_reactiontime_older_highconf = mean(mean_older_highconf, 1, 'omitnan');

SE_reactiontime_older_lowconf = std(mean_older_lowconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
SE_reactiontime_older_highconf = std(mean_older_highconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4], mean_reactiontime_older_lowconf, SE_reactiontime_older_lowconf, '--', 'color',[86, 180, 233]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_reactiontime_older_highconf, SE_reactiontime_older_highconf, 'color', [230, 159, 0]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel('Reaction time (s)','FontSize',32,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

