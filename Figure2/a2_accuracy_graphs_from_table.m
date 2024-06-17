clear; close all;

filename = 'table_reactiontime_MR_withoutexcluded.xlsx';
T = readtable(filename);


for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 26, 31, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

% accuracy per coherence 
accuracy.young.per_coherence = [];

accuracy.young.lowconf_per_coherence = [];
accuracy.young.highconf_per_coherence = [];

accuracy.older.per_coherence = [];

accuracy.older.lowconf_per_coherence = [];
accuracy.older.highconf_per_coherence = [];


% accuracy per confidence level per age group
accuracy.young.low_confidence = [];
accuracy.young.high_confidence = [];
accuracy.older.low_confidence = [];
accuracy.older.high_confidence = [];

% accuracy per confidence level per age group per sex
accuracy.young.women_low_confidence = [];
accuracy.young.men_low_confidence = [];
accuracy.young.women_high_confidence = [];
accuracy.young.men_high_confidence = [];

accuracy.older.women_low_confidence = [];
accuracy.older.men_low_confidence = [];
accuracy.older.women_high_confidence = [];
accuracy.older.men_high_confidence = [];

accuracy.young.average = [];
accuracy.older.average = [];


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
        

        if grp == 1
            
            accuracy.young.average = [accuracy.young.average; mean(acc, 'omitnan')];
            
            accuracy.young.per_coherence = [accuracy.young.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(acc(coh1), 'omitnan'), mean(acc(coh2), 'omitnan'), mean(acc(coh3), 'omitnan'), mean(acc(coh4), 'omitnan')];
            
            
            accuracy.young.lowconf_per_coherence = [accuracy.young.lowconf_per_coherence;...
                length(lowconf_coh1), length(lowconf_coh2), length(lowconf_coh3), length(lowconf_coh4),...
                mean(acc(lowconf_coh1), 'omitnan'), mean(acc(lowconf_coh2), 'omitnan'), mean(acc(lowconf_coh3), 'omitnan'), mean(acc(lowconf_coh4), 'omitnan')];
            
            accuracy.young.highconf_per_coherence = [accuracy.young.highconf_per_coherence;...
                length(highconf_coh1), length(highconf_coh2), length(highconf_coh3), length(highconf_coh4),...
                mean(acc(highconf_coh1), 'omitnan'), mean(acc(highconf_coh2), 'omitnan'), mean(acc(highconf_coh3), 'omitnan'), mean(acc(highconf_coh4), 'omitnan')];
            
            
            % accuracy per confidence level
            accuracy.young.low_confidence = [accuracy.young.low_confidence; length(find(conf == 0)), mean(acc(conf == 0), 'omitnan')];
            accuracy.young.high_confidence = [accuracy.young.high_confidence; length(find(conf == 1)), mean(acc(conf == 1), 'omitnan')];
            
            % accuracy per confidence level per sex
            if sex == 1
                accuracy.young.women_low_confidence = [accuracy.young.women_low_confidence;...
                    length(intersect(find(conf == 0), find(sex == 1))), mean(acc(intersect(find(conf == 0), find(sex == 1))), 'omitnan')];
                accuracy.young.women_high_confidence = [accuracy.young.women_high_confidence;...
                    length(intersect(find(conf == 1), find(sex == 1))), mean(acc(intersect(find(conf == 1), find(sex == 1))), 'omitnan')];
            
            elseif sex == 2
                accuracy.young.men_low_confidence = [accuracy.young.men_low_confidence;...
                    length(intersect(find(conf == 0), find(sex == 2))), mean(acc(intersect(find(conf == 0), find(sex == 2))), 'omitnan')];
                accuracy.young.men_high_confidence = [accuracy.young.men_high_confidence;...
                    length(intersect(find(conf == 1), find(sex == 2))), mean(acc(intersect(find(conf == 1), find(sex == 2))), 'omitnan')];
            end
            
            
        else
            accuracy.older.average = [accuracy.older.average; mean(acc, 'omitnan')];
            
            accuracy.older.per_coherence = [accuracy.older.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(acc(coh1), 'omitnan'), mean(acc(coh2), 'omitnan'), mean(acc(coh3), 'omitnan'), mean(acc(coh4), 'omitnan')];  
            
            accuracy.older.lowconf_per_coherence = [accuracy.older.lowconf_per_coherence;...
                length(lowconf_coh1), length(lowconf_coh2), length(lowconf_coh3), length(lowconf_coh4),...
                mean(acc(lowconf_coh1), 'omitnan'), mean(acc(lowconf_coh2), 'omitnan'), mean(acc(lowconf_coh3), 'omitnan'), mean(acc(lowconf_coh4), 'omitnan')];
            
            accuracy.older.highconf_per_coherence = [accuracy.older.highconf_per_coherence;...
                length(highconf_coh1), length(highconf_coh2), length(highconf_coh3), length(highconf_coh4),...
                mean(acc(highconf_coh1), 'omitnan'), mean(acc(highconf_coh2), 'omitnan'), mean(acc(highconf_coh3), 'omitnan'), mean(acc(highconf_coh4), 'omitnan')];
            
            
            % accuracy per confidence level
            accuracy.older.low_confidence = [accuracy.older.low_confidence; length(find(conf == 0)), mean(acc(conf == 0), 'omitnan')];
            accuracy.older.high_confidence = [accuracy.older.high_confidence; length(find(conf == 1)), mean(acc(conf == 1), 'omitnan')];
            
            % accuracy per confidence level per sex
            if sex == 1
                accuracy.older.women_low_confidence = [accuracy.older.women_low_confidence;...
                    length(intersect(find(conf == 0), find(sex == 1))), mean(acc(intersect(find(conf == 0), find(sex == 1))), 'omitnan')];
                accuracy.older.women_high_confidence = [accuracy.older.women_high_confidence;...
                    length(intersect(find(conf == 1), find(sex == 1))), mean(acc(intersect(find(conf == 1), find(sex == 1))), 'omitnan')];
            elseif sex == 2
                accuracy.older.men_low_confidence = [accuracy.older.men_low_confidence;...
                    length(intersect(find(conf == 0), find(sex == 2))), mean(acc(intersect(find(conf == 0), find(sex == 2))), 'omitnan')];
                accuracy.older.men_high_confidence = [accuracy.older.men_high_confidence;...
                    length(intersect(find(conf == 1), find(sex == 2))), mean(acc(intersect(find(conf == 1), find(sex == 2))), 'omitnan')];
            end
            
        end
    end
end
%%

avg_acc_older = mean(accuracy.older.average)
std_acc_older = std(accuracy.older.average)

avg_acc_young = mean(accuracy.young.average)
std_acc_young = std(accuracy.young.average)


%% plot
% coherence x group
figure;
% xticklabels(accuracy);
hold on

mean_young = accuracy.young.per_coherence(:, 5:end)*100;
mean_older = accuracy.older.per_coherence(:, 5:end)*100;


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
mean_accuracy_young = mean(mean_young, 1, 'omitnan');
mean_accuracy_older = mean(mean_older, 1, 'omitnan');

SE_accuracy_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_accuracy_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 2 3 4],mean_accuracy_young, SE_accuracy_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 2 3 4],mean_accuracy_older, SE_accuracy_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Open Sans';
set(gca, 'XTick',1:4, 'XTickLabel',{'3', '6', '12', '24'})
set(gca, 'XLim',[0 5])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel('Accuracy (%)','FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Open Sans');
%% plot
% group x confidence
figure;
confidence = {'Low conf' 'High conf'};
xticklabels(confidence);
hold on

mean_response_young_lowconfidence = [accuracy.young.low_confidence(:, 2)].*100;
mean_response_young_highconfidence = [accuracy.young.high_confidence(:,2)].*100;
mean_response_older_lowconfidence = [accuracy.older.low_confidence(:, 2)].*100;
mean_response_older_highconfidence = [accuracy.older.high_confidence(:,2)].*100;

% plot individual points
for p = 1:length(mean_response_young_lowconfidence)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_lowconfidence(p) mean_response_young_highconfidence(p)],'-o',...
    'color','k','MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1.5);
end
for p = 1:length(mean_response_older_lowconfidence)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_lowconfidence(p), mean_response_older_highconfidence(p)],'-d',...
    'color','r','MarkerSize',8,'MarkerEdgeColor',[1 .5 .5],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_young = [mean(mean_response_young_lowconfidence, 'omitnan'), mean(mean_response_young_highconfidence, 'omitnan')];
all_accuracybefore_older = [mean(mean_response_older_lowconfidence, 'omitnan'), mean(mean_response_older_highconfidence, 'omitnan')];
SE_young = [std(mean_response_young_lowconfidence, 'omitnan')/sqrt(length(mean_response_young_lowconfidence)), std(mean_response_young_highconfidence, 'omitnan')/sqrt(length(mean_response_young_highconfidence))];
SE_older = [std(mean_response_older_lowconfidence, 'omitnan')/sqrt(length(mean_response_older_lowconfidence)), std(mean_response_older_highconfidence, 'omitnan')/sqrt(length(mean_response_older_highconfidence))];

hold on
p1 = errorbar([1 4],all_accuracybefore_young,SE_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_older,SE_older, '--','color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 30;
ax.FontName = 'Open Sans';
% XTickLabel = {'Low' 'High'};
xticks([1 4]);

% xlabel('Confidence','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([25 100])
ylabel('Accuracy (%)','FontSize',34,'FontName','Open Sans');
p = [p1 p2];
% legend(p,'Young','Older','FontSize',30,'FontName','Open Sans');

%%
% coherence x confidence - young group
figure;
% accuracy = {'Incorrect' 'Correct'};
% xticklabels(accuracy);
hold on

mean_young_lowconf = [mean(accuracy.young.lowconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(accuracy.young.lowconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_young_highconf = [mean(accuracy.young.highconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(accuracy.young.highconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;

% plot individual points
for p = 1:size(mean_young_highconf, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_highconf(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[86+50, 180+50, 233+22]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_young_lowconf, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_young_lowconf(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[230+25, 159+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_accuracy_young_lowconf = mean(mean_young_lowconf, 1, 'omitnan');
mean_accuracy_young_highconf = mean(mean_young_highconf, 1, 'omitnan');

SE_accuracy_young_lowconf = std(mean_young_lowconf, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_accuracy_young_highconf = std(mean_young_highconf, [], 1, 'omitnan')/sqrt(size(mean_young, 1));

hold on
p1 = errorbar([1 4], mean_accuracy_young_lowconf, SE_accuracy_young_lowconf, '--', 'color',[230, 159, 0]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_accuracy_young_highconf, SE_accuracy_young_highconf, 'color', [86, 180, 233]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Open Sans';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim([0 100])
ylabel('Accuracy (%)','FontSize',32,'FontName','Open Sans');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Open Sans');

%% coherence x confidence - older group
figure;
% accuracy = {'Incorrect' 'Correct'};
% xticklabels(accuracy);
hold on

mean_older_lowconf = [mean(accuracy.older.lowconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(accuracy.older.lowconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_older_highconf = [mean(accuracy.older.highconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(accuracy.older.highconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;

% plot individual points
for p = 1:size(mean_older_highconf, 1)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_highconf(p, :),'o',...
    'color', [0.2 0.82 0.651].*1.2,'MarkerSize',8,'MarkerEdgeColor',[86+50, 180+50, 233+22]./255,'LineStyle','none','LineWidth',1.5);
end

for p = 1:size(mean_older_lowconf, 1)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],mean_older_lowconf(p, :), 'd',...
    'color',[0.494 0.2 0.773].*1.2,'MarkerSize',8,'MarkerEdgeColor',[230+25, 159+50, 50]./255,'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
mean_accuracy_older_lowconf = mean(mean_older_lowconf, 1, 'omitnan');
mean_accuracy_older_highconf = mean(mean_older_highconf, 1, 'omitnan');

SE_accuracy_older_lowconf = std(mean_older_lowconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
SE_accuracy_older_highconf = std(mean_older_highconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4], mean_accuracy_older_lowconf, SE_accuracy_older_lowconf, '--', 'color',[230, 159, 0]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_accuracy_older_highconf, SE_accuracy_older_highconf, 'color', [86, 180, 233]./255, 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Open Sans';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'difficult' 'easy'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim([0 100])
ylabel('Accuracy (%)','FontSize',32,'FontName','Open Sans');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Open Sans');




%% plot - women only effect of confidence in accuracy
% group x confidence x sex

for sx = 1:2
    figure;
    confidence = {'Low' 'High'};
    xticklabels(confidence);
    hold on
    if sx == 1
        mean_response_young_lowconfidence = [accuracy.young.women_low_confidence(:, 2)].*100;
        mean_response_young_highconfidence = [accuracy.young.women_high_confidence(:,2)].*100;
        mean_response_older_lowconfidence = [accuracy.older.women_low_confidence(:, 2)].*100;
        mean_response_older_highconfidence = [accuracy.older.women_high_confidence(:,2)].*100;
    else
        mean_response_young_lowconfidence = [accuracy.young.men_low_confidence(:, 2)].*100;
        mean_response_young_highconfidence = [accuracy.young.men_high_confidence(:,2)].*100;
        mean_response_older_lowconfidence = [accuracy.older.men_low_confidence(:, 2)].*100;
        mean_response_older_highconfidence = [accuracy.older.men_high_confidence(:,2)].*100;
    end
    
    % plot individual points
    for p = 1:length(mean_response_young_lowconfidence)
        plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_lowconfidence(p) mean_response_young_highconfidence(p)],'-o',...
        'color','k','MarkerSize',8,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',1.5);
    end
    for p = 1:length(mean_response_older_lowconfidence)
        hold on
        plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_lowconfidence(p), mean_response_older_highconfidence(p)],'-o',...
        'color','r','MarkerSize',8,'MarkerEdgeColor',[1 .5 .5],'LineStyle','none','LineWidth',1.5);
    end
    xlim([0; 5]);
    
    % average values
    all_accuracybefore_young = [mean(mean_response_young_lowconfidence, 'omitnan'), mean(mean_response_young_highconfidence, 'omitnan')];
    all_accuracybefore_older = [mean(mean_response_older_lowconfidence, 'omitnan'), mean(mean_response_older_highconfidence, 'omitnan')];
    SE_young = [std(mean_response_young_lowconfidence, 'omitnan')/sqrt(length(mean_response_young_lowconfidence)), std(mean_response_young_highconfidence, 'omitnan')/sqrt(length(mean_response_young_highconfidence))];
    SE_older = [std(mean_response_older_lowconfidence, 'omitnan')/sqrt(length(mean_response_older_lowconfidence)), std(mean_response_older_highconfidence, 'omitnan')/sqrt(length(mean_response_older_highconfidence))];
    
    hold on
    p1 = errorbar([1 4],all_accuracybefore_young,SE_young,'color','k', 'LineWidth',2.5);
    hold on
    p2 = errorbar([1 4],all_accuracybefore_older,SE_older,'color','r', 'LineWidth',2.5);
    
    hold off;
    box off;
    ax = gca;
    c = ax.Color;
    ax.LineWidth = 2;
    ax.FontSize = 34;
    ax.FontName = 'Open Sans';
    % XTickLabel = {'Low' 'High'};
    xticks([1 4]);
    
    xlabel('Confidence','FontSize',34,'FontName','Open Sans'); 
    xlim([0 5]); ylim([25 100])
    ylabel('Accuracy (%)','FontSize',34,'FontName','Open Sans');
    p = [p1 p2];
    % legend(p,'Young','Older','FontSize',30,'FontName','Open Sans');

end

%% plot - figure 3.5c
% group x RT
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);
hold on

mean_response_young_slowRT = [accuracy.young.slowRT(:, 2)];
mean_response_young_fastRT = [accuracy.young.fastRT(:,2)];
mean_response_older_slowRT = [accuracy.older.slowRT(:, 2)];
mean_response_older_fastRT = [accuracy.older.fastRT(:,2)];

% plot individual points
for p = 1:length(mean_response_young_slowRT)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_slowRT(p) mean_response_young_fastRT(p)],'-o',...
    'color',[0.300 0.7470 1],'MarkerSize',8,'MarkerEdgeColor',[0.300 0.7470 1],'LineStyle','none','LineWidth',1.5);
end
for p = 1:length(mean_response_older_slowRT)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_slowRT(p), mean_response_older_fastRT(p)],'-o',...
    'color',[1 0.6250 0.3980],'MarkerSize',8,'MarkerEdgeColor',[1 0.6250 0.3980],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_young = [mean(mean_response_young_slowRT, 'omitnan'), mean(mean_response_young_fastRT, 'omitnan')];
all_accuracybefore_older = [mean(mean_response_older_slowRT, 'omitnan'), mean(mean_response_older_fastRT, 'omitnan')];
SE_young = [std(mean_response_young_slowRT, 'omitnan')/sqrt(length(mean_response_young_slowRT)), std(mean_response_young_fastRT, 'omitnan')/sqrt(length(mean_response_young_fastRT))];
SE_older = [std(mean_response_older_slowRT, 'omitnan')/sqrt(length(mean_response_older_slowRT)), std(mean_response_older_fastRT, 'omitnan')/sqrt(length(mean_response_older_fastRT))];

hold on
p1 = errorbar([1 4],all_accuracybefore_young,SE_young,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_older,SE_older,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Open Sans';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
p = [p1 p2];
legend(p,'Young','Older','FontSize',30,'FontName','Open Sans');


%% Figure 3.5d)
% group X confidence X accuracy

% YOUNG GROUP
figure;
confidence = {'Unsure' 'Sure'};
xticklabels(confidence);    
hold on

mean_response_young_unsurecorrect = [accuracy.young.low_conf_correct(:, 2)];
mean_response_young_surecorrect = [accuracy.young.high_conf_correct(:, 2)];
mean_response_young_unsureincorrect = [accuracy.young.low_conf_incorrect(:, 2)];
mean_response_young_sureincorrect = [accuracy.young.high_conf_incorrect(:, 2)];

% plot individual points
% unsure correct - sure correct
for p = 1:length(mean_response_young_unsurecorrect)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_unsurecorrect(p) mean_response_young_surecorrect(p)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_unsureincorrect(p), mean_response_young_sureincorrect(p)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_young_correct = [mean(mean_response_young_unsurecorrect, 'omitnan'), mean(mean_response_young_surecorrect, 'omitnan')];
SE_young_correct = [std(mean_response_young_unsurecorrect, 'omitnan')/sqrt(length(mean_response_young_unsurecorrect)), std(mean_response_young_surecorrect, 'omitnan')/sqrt(length(mean_response_young_surecorrect))];
all_accuracybefore_young_incorrect = [mean(mean_response_young_unsureincorrect, 'omitnan'), mean(mean_response_young_sureincorrect, 'omitnan')];
SE_young_incorrect = [std(mean_response_young_unsureincorrect, 'omitnan')/sqrt(length(mean_response_young_unsureincorrect)), std(mean_response_young_sureincorrect, 'omitnan')/sqrt(length(mean_response_young_sureincorrect))];

hold on
p1 = errorbar([1 4],all_accuracybefore_young_correct,SE_young_correct,'color',[0 0.62 0.451], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_young_incorrect,SE_young_incorrect,'color',[0.294 0 0.573], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Open Sans';
XTickLabel = {'Unsure' 'Sure'};
xticks([1 4]);

xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([-0.1 0.3])
ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
title('Young Adults','FontSize',24,'FontName','Open Sans')
p = [p1 p2];
legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');


% OLDER GROUP
figure;
confidence = {'Unsure' 'Sure'};
xticklabels(confidence);    
hold on

mean_response_older_unsurecorrect = [accuracy.older.low_conf_correct(:, 2)];
mean_response_older_surecorrect = [accuracy.older.high_conf_correct(:, 2)];
mean_response_older_unsureincorrect = [accuracy.older.low_conf_incorrect(:, 2)];
mean_response_older_sureincorrect = [accuracy.older.high_conf_incorrect(:, 2)];

% plot individual points
% unsure correct - sure correct
for p = 1:length(mean_response_older_unsurecorrect)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_unsurecorrect(p) mean_response_older_surecorrect(p)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_unsureincorrect(p), mean_response_older_sureincorrect(p)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_older_correct = [mean(mean_response_older_unsurecorrect, 'omitnan'), mean(mean_response_older_surecorrect, 'omitnan')];
SE_older_correct = [std(mean_response_older_unsurecorrect, 'omitnan')/sqrt(length(mean_response_older_unsurecorrect)), std(mean_response_older_surecorrect, 'omitnan')/sqrt(length(mean_response_older_surecorrect))];
all_accuracybefore_older_incorrect = [mean(mean_response_older_unsureincorrect, 'omitnan'), mean(mean_response_older_sureincorrect, 'omitnan')];
SE_older_incorrect = [std(mean_response_older_unsureincorrect, 'omitnan')/sqrt(length(mean_response_older_unsureincorrect)), std(mean_response_older_sureincorrect, 'omitnan')/sqrt(length(mean_response_older_sureincorrect))];

hold on
p1 = errorbar([1 4],all_accuracybefore_older_correct,SE_older_correct,'color',[0 0.62 0.451], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_older_incorrect,SE_older_incorrect,'color',[0.294 0 0.573], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Open Sans';
XTickLabel = {'Unsure' 'Sure'};
xticks([1 4]);

xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([-0.1 0.3])
ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
title('Older Adults','FontSize',24,'FontName','Open Sans')
p = [p1 p2];
legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');


%% Figure 3.5e)
% group X reactiontime X accuracy

% YOUNG GROUP
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);  
hold on

% plot individual points
for p = 1:length(accuracy.young.slowRT_correct(:, 2))
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.slowRT_correct(p, 2) accuracy.young.fastRT_correct(p, 2)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.slowRT_incorrect(p, 2), accuracy.young.fastRT_incorrect(p, 2)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_young_correct = [mean(accuracy.young.slowRT_correct(:, 2), 'omitnan'), mean(accuracy.young.fastRT_correct(:, 2), 'omitnan')];
SE_young_correct = [std(accuracy.young.slowRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.young.slowRT_correct(:, 2))), std(accuracy.young.fastRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.young.fastRT_correct(:, 2)))];
all_accuracybefore_young_incorrect = [mean(accuracy.young.slowRT_incorrect(:, 2), 'omitnan'), mean(accuracy.young.fastRT_incorrect(:, 2), 'omitnan')];
SE_young_incorrect = [std(accuracy.young.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.young.slowRT_incorrect(:, 2))), std(accuracy.young.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.young.fastRT_incorrect(:, 2)))];

hold on
p1 = errorbar([1 4],all_accuracybefore_young_correct,SE_young_correct,'color',"#009E73", 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_young_incorrect,SE_young_incorrect,'color',"#4B0092", 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Open Sans';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
title('Young Adults','FontSize',24,'FontName','Open Sans')
p = [p1 p2];


% OLDER GROUP
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);    
hold on

% plot individual points
for p = 1:length(accuracy.older.slowRT_correct(:, 2))
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.slowRT_correct(p, 2) accuracy.older.fastRT_correct(p, 2)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.slowRT_incorrect(p, 2), accuracy.older.fastRT_incorrect(p, 2)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_accuracybefore_older_correct = [mean(accuracy.older.slowRT_correct(:, 2), 'omitnan'), mean(accuracy.older.fastRT_correct(:, 2), 'omitnan')];
SE_older_correct = [std(accuracy.older.slowRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.older.slowRT_correct(:, 2))), std(accuracy.older.fastRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.older.fastRT_correct(:, 2)))];
all_accuracybefore_older_incorrect = [mean(accuracy.older.slowRT_incorrect(:, 2), 'omitnan'), mean(accuracy.older.fastRT_incorrect(:, 2), 'omitnan')];
SE_older_incorrect = [std(accuracy.older.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.older.slowRT_incorrect(:, 2))), std(accuracy.older.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.older.fastRT_incorrect(:, 2)))];

hold on
p1 = errorbar([1 4],all_accuracybefore_older_correct,SE_older_correct,'color',"#009E73", 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_accuracybefore_older_incorrect,SE_older_incorrect,'color',"#4B0092", 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Open Sans';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Open Sans'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
title('Older Adults','FontSize',24,'FontName','Open Sans')
p = [p1 p2];
% legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');





% %% plot
% % confidence x accuracy
% 
% figure;
% confidence = {'Low' 'High'};
% xticklabels(confidence);    
% hold on
% 
% mean_response_unsurecorrect = [accuracy.young.low_conf_correct(:, 2); accuracy.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [accuracy.young.high_conf_correct(:, 2); accuracy.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [accuracy.young.low_conf_incorrect(:, 2); accuracy.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [accuracy.young.high_conf_incorrect(:, 2); accuracy.older.high_conf_incorrect(:, 2)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(mean_response_unsurecorrect)
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_unsurecorrect(p) mean_response_surecorrect(p)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_unsureincorrect(p), mean_response_sureincorrect(p)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_accuracybefore_correct = [mean(mean_response_unsurecorrect, 'omitnan'), mean(mean_response_surecorrect, 'omitnan')];
% SE_correct = [std(mean_response_unsurecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect)), std(mean_response_surecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect))];
% hold on
% p1 = errorbar([1 4],all_accuracybefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_accuracybefore_incorrect = [mean(mean_response_unsureincorrect, 'omitnan'), mean(mean_response_sureincorrect, 'omitnan')];
% SE_incorrect = [std(mean_response_unsureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect)), std(mean_response_sureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect))];
% 
% p2 = errorbar([1 4],all_accuracybefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
% % title({'Median accuracy response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');
% 
% %% plot number of trials
% 
% figure;
% confidence = {'Unsure' 'Sure'};
% xticklabels(confidence);    
% hold on
% 
% mean_response_unsurecorrect = [accuracy.young.low_conf_correct(:, 1); accuracy.older.low_conf_correct(:, 1)];
% mean_response_surecorrect = [accuracy.young.high_conf_correct(:, 1); accuracy.older.high_conf_correct(:, 1)];
% mean_response_unsureincorrect = [accuracy.young.low_conf_incorrect(:, 1); accuracy.older.low_conf_incorrect(:, 1)];
% mean_response_sureincorrect = [accuracy.young.high_conf_incorrect(:, 1); accuracy.older.high_conf_incorrect(:, 1)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(mean_response_unsurecorrect)
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_unsurecorrect(p) mean_response_surecorrect(p)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_unsureincorrect(p), mean_response_sureincorrect(p)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_accuracybefore_correct = [mean(mean_response_unsurecorrect, 'omitnan'), mean(mean_response_surecorrect, 'omitnan')];
% SE_correct = [std(mean_response_unsurecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect)), std(mean_response_surecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect))];
% hold on
% p1 = errorbar([1 4],all_accuracybefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_accuracybefore_incorrect = [mean(mean_response_unsureincorrect, 'omitnan'), mean(mean_response_sureincorrect, 'omitnan')];
% SE_incorrect = [std(mean_response_unsureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect)), std(mean_response_sureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect))];
% 
% p2 = errorbar([1 4],all_accuracybefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('# of trials','FontSize',34,'FontName','Open Sans');
% % title({'Median accuracy response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');
% 
% 
% %% young vs older - confidence
% 
% figure;
% confidence = {'Unsure' 'Sure'};
% xticklabels(confidence);    
% hold on
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(accuracy.young.low_confidence(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.low_confidence(p, 2) accuracy.young.high_confidence(p, 2)],'-o',...
%     'color',[0 0.4470 0.7410],'MarkerSize',8,'MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% for p = 1:length(accuracy.older.low_confidence(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.low_confidence(p, 2), accuracy.older.high_confidence(p, 2)],'-o',...
%     'color',[0.8500 0.3250 0.0980],'MarkerSize',8,'MarkerEdgeColor',[0.8500 0.3250 0.0980],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% xlim([0; 5]);
% 
% % average values
% accuracybefore_young = [mean(accuracy.young.low_confidence(:, 2), 'omitnan'), mean(accuracy.young.high_confidence(:, 2), 'omitnan')];
% SE_young  = [std(accuracy.young.low_confidence(:, 2), 'omitnan')/sqrt(length(accuracy.young.low_confidence(:, 2))), std(accuracy.young.high_confidence(:, 2), 'omitnan')/sqrt(length(accuracy.young.high_confidence(:, 2)))];
% hold on
% p1 = errorbar([1 4], accuracybefore_young, SE_young ,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
% hold on
% 
% accuracybefore_older = [mean(accuracy.older.low_confidence(:, 2), 'omitnan'), mean(accuracy.older.high_confidence(:, 2), 'omitnan')];
% SE_older  = [std(accuracy.older.low_confidence(:, 2), 'omitnan')/sqrt(length(accuracy.older.low_confidence(:, 2))), std(accuracy.older.high_confidence(:, 2), 'omitnan')/sqrt(length(accuracy.older.high_confidence(:, 2)))];
% hold on
% p2 = errorbar([1 4], accuracybefore_older, SE_older ,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
% % title({'Median accuracy response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');
% 
% 
% %% young vs older - confidence based on reaction time
% figure;
% reaction_time = {'Slow RT' 'Fast RT'};
% xticklabels(reaction_time);    
% hold on
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(accuracy.young.slowRT(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.slowRT(p, 2) accuracy.young.fastRT(p, 2)],'-o',...
%     'color',[0 0.4470 0.7410],'MarkerSize',8,'MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% for p = 1:length(accuracy.older.slowRT(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.slowRT(p, 2), accuracy.older.fastRT(p, 2)],'-o',...
%     'color',[0.8500 0.3250 0.0980],'MarkerSize',8,'MarkerEdgeColor',[0.8500 0.3250 0.0980],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% xlim([0; 5]);
% 
% % average values
% accuracybefore_young = [mean(accuracy.young.slowRT(:, 2), 'omitnan'), mean(accuracy.young.fastRT(:, 2), 'omitnan')];
% SE_young  = [std(accuracy.young.slowRT(:, 2), 'omitnan')/sqrt(length(accuracy.young.slowRT(:, 2))), std(accuracy.young.fastRT(:, 2), 'omitnan')/sqrt(length(accuracy.young.fastRT(:, 2)))];
% hold on
% p1 = errorbar([1 4], accuracybefore_young, SE_young ,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
% hold on
% 
% accuracybefore_older = [mean(accuracy.older.slowRT(:, 2), 'omitnan'), mean(accuracy.older.fastRT(:, 2), 'omitnan')];
% SE_older  = [std(accuracy.older.slowRT(:, 2), 'omitnan')/sqrt(length(accuracy.older.slowRT(:, 2))), std(accuracy.older.fastRT(:, 2), 'omitnan')/sqrt(length(accuracy.older.fastRT(:, 2)))];
% hold on
% p2 = errorbar([1 4], accuracybefore_older, SE_older ,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% % XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% % xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
% % title({'Median accuracy response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',15,'FontName','Open Sans');
% 
% 
% %% confidence based on RT vs accuracy - young
%             
% 
% figure;
% reaction_time = {'Slow RT' 'Fast RT'};
% xticklabels(reaction_time); 
% hold on
% 
% mean_response_unsurecorrect = [accuracy.young.low_conf_correct(:, 2); accuracy.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [accuracy.young.high_conf_correct(:, 2); accuracy.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [accuracy.young.low_conf_incorrect(:, 2); accuracy.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [accuracy.young.high_conf_incorrect(:, 2); accuracy.older.high_conf_incorrect(:, 2)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(accuracy.young.slowRT_correct(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.slowRT_correct(p, 2) accuracy.young.fastRT_correct(p, 2)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.young.slowRT_incorrect(p, 2), accuracy.young.fastRT_incorrect(p, 2)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_accuracybefore_correct = [mean(accuracy.young.slowRT_correct(:, 2), 'omitnan'), mean(accuracy.young.fastRT_correct(:, 2), 'omitnan')];
% SE_correct = [std(accuracy.young.slowRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.young.slowRT_correct(:, 2))), std(accuracy.young.fastRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.young.fastRT_correct(:, 2)))];
% hold on
% p1 = errorbar([1 4],all_accuracybefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_accuracybefore_incorrect = [mean(accuracy.young.slowRT_incorrect(:, 2), 'omitnan'), mean(accuracy.young.fastRT_incorrect(:, 2), 'omitnan')];
% SE_incorrect = [std(accuracy.young.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.young.slowRT_incorrect(:, 2))), std(accuracy.young.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.young.fastRT_incorrect(:, 2)))];
% 
% p2 = errorbar([1 4],all_accuracybefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% XTickLabel = {'SlowRT' 'FastRT'};
% xticks([1 4]);
% 
% % xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
% title({'Young'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');
% 
% 
% %% confidence based on RT vs accuracy - older
% figure;
% reaction_time = {'Slow RT' 'Fast RT'};
% xticklabels(reaction_time); 
% hold on
% 
% mean_response_unsurecorrect = [accuracy.older.low_conf_correct(:, 2); accuracy.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [accuracy.older.high_conf_correct(:, 2); accuracy.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [accuracy.older.low_conf_incorrect(:, 2); accuracy.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [accuracy.older.high_conf_incorrect(:, 2); accuracy.older.high_conf_incorrect(:, 2)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(accuracy.older.slowRT_correct(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.slowRT_correct(p, 2) accuracy.older.fastRT_correct(p, 2)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[accuracy.older.slowRT_incorrect(p, 2), accuracy.older.fastRT_incorrect(p, 2)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_accuracybefore_correct = [mean(accuracy.older.slowRT_correct(:, 2), 'omitnan'), mean(accuracy.older.fastRT_correct(:, 2), 'omitnan')];
% SE_correct = [std(accuracy.older.slowRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.older.slowRT_correct(:, 2))), std(accuracy.older.fastRT_correct(:, 2), 'omitnan')/sqrt(length(accuracy.older.fastRT_correct(:, 2)))];
% hold on
% p1 = errorbar([1 4],all_accuracybefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_accuracybefore_incorrect = [mean(accuracy.older.slowRT_incorrect(:, 2), 'omitnan'), mean(accuracy.older.fastRT_incorrect(:, 2), 'omitnan')];
% SE_incorrect = [std(accuracy.older.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.older.slowRT_incorrect(:, 2))), std(accuracy.older.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(accuracy.older.fastRT_incorrect(:, 2)))];
% 
% p2 = errorbar([1 4],all_accuracybefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Open Sans';
% XTickLabel = {'SlowRT' 'FastRT'};
% xticks([1 4]);
% 
% % xlabel('Confidence Level','FontSize',34,'FontName','Open Sans'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('accuracy Response','FontSize',34,'FontName','Open Sans');
% title({'Older'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Open Sans');