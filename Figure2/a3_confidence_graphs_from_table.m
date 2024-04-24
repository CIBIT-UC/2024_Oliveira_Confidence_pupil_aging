clear; close all;

filename = 'table_reactiontime_MR.xlsx';
T = readtable(filename);


for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

% confidence per coherence 

confidence.older.per_coherence = []; 
confidence.older.accuracy = [];
confidence.young.accuracy = [];
confidence.older.incorrect_per_coherence = [];
confidence.older.correct_per_coherence = [];
confidence.young.per_coherence = [];
confidence.young.incorrect_per_coherence = [];
confidence.young.correct_per_coherence = [];

confidence.young.women_accuracy = [];
confidence.older.women_accuracy = [];
confidence.young.men_accuracy = [];
confidence.older.men_accuracy = [];

confidence.young.average = [];
confidence.older.average = [];


for grp = 1:2
    for prt = participants{grp}'
        
        conf = T.Confidence(T.Participant == prt);
        acc = T.Accuracy(T.Participant == prt);
        coh = T.Coherence(T.Participant == prt);
        sex = unique(T.Sex(T.Participant == prt));
        
        coh1 = find(coh == 3);
        coh2 = find(coh == 6);
        coh3 = find(coh == 12);
        coh4 = find(coh == 24);
        
        
%         lowconf_coh1 = intersect(find(conf == 0), find(coh == 3));
%         lowconf_coh2 = intersect(find(conf == 0), find(coh == 6));
%         lowconf_coh3 = intersect(find(conf == 0), find(coh == 12));
%         lowconf_coh4 = intersect(find(conf == 0), find(coh == 24));
%         
%         highconf_coh1 = intersect(find(conf == 1), find(coh == 3));
%         highconf_coh2 = intersect(find(conf == 1), find(coh == 6));
%         highconf_coh3 = intersect(find(conf == 1), find(coh == 12));
%         highconf_coh4 = intersect(find(conf == 1), find(coh == 24));
        
        incorrect = find(acc == 0);
        correct = find(acc == 1);
        
        incorrect_coh1 = intersect(find(acc == 0), find(coh == 3));
        incorrect_coh2 = intersect(find(acc == 0), find(coh == 6));
        incorrect_coh3 = intersect(find(acc == 0), find(coh == 12));
        incorrect_coh4 = intersect(find(acc == 0), find(coh == 24));
        
        correct_coh1 = intersect(find(acc == 1), find(coh == 3));
        correct_coh2 = intersect(find(acc == 1), find(coh == 6));
        correct_coh3 = intersect(find(acc == 1), find(coh == 12));
        correct_coh4 = intersect(find(acc == 1), find(coh == 24));


        

        if grp == 1

            
            confidence.young.average = [confidence.young.average; mean(conf, 'omitnan')];
            
            
            confidence.young.per_coherence = [confidence.young.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(conf(coh1), 'omitnan'), mean(conf(coh2), 'omitnan'), mean(conf(coh3), 'omitnan'), mean(conf(coh4), 'omitnan')];

            
            confidence.young.accuracy = [confidence.young.accuracy;
                length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
                
            
            confidence.young.incorrect_per_coherence = [confidence.young.incorrect_per_coherence;...
                length(incorrect_coh1), length(incorrect_coh2), length(incorrect_coh3), length(incorrect_coh4),...
                mean(conf(incorrect_coh1), 'omitnan'), mean(conf(incorrect_coh2), 'omitnan'), mean(conf(incorrect_coh3), 'omitnan'), mean(conf(incorrect_coh4), 'omitnan')];
            
            confidence.young.correct_per_coherence = [confidence.young.correct_per_coherence;...
                length(correct_coh1), length(correct_coh2), length(correct_coh3), length(correct_coh4),...
                mean(conf(correct_coh1), 'omitnan'), mean(conf(correct_coh2), 'omitnan'), mean(conf(correct_coh3), 'omitnan'), mean(conf(correct_coh4), 'omitnan')];


            % confidence per accuracy level per sex
            if sex == 1
                confidence.young.women_accuracy = [confidence.young.women_accuracy;...
                    length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
            
            elseif sex == 2
                confidence.young.men_accuracy = [confidence.young.men_accuracy;...
                    length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
            end

            
        else
            
            confidence.older.average = [confidence.older.average; mean(conf, 'omitnan')];
            
            confidence.older.per_coherence = [confidence.older.per_coherence;
                length(coh1), length(coh2), length(coh3), length(coh4),...
                mean(conf(coh1), 'omitnan'), mean(conf(coh2), 'omitnan'), mean(conf(coh3), 'omitnan'), mean(conf(coh4), 'omitnan')];
            
            confidence.older.accuracy = [confidence.older.accuracy;
                length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
            
            
            confidence.older.incorrect_per_coherence = [confidence.older.incorrect_per_coherence;...
                length(incorrect_coh1), length(incorrect_coh2), length(incorrect_coh3), length(incorrect_coh4),...
                mean(conf(incorrect_coh1), 'omitnan'), mean(conf(incorrect_coh2), 'omitnan'),...
                mean(conf(incorrect_coh3), 'omitnan'), mean(conf(incorrect_coh4), 'omitnan')];
            
            confidence.older.correct_per_coherence = [confidence.older.correct_per_coherence;...
                length(correct_coh1), length(correct_coh2), length(correct_coh3), length(correct_coh4),...
                mean(conf(correct_coh1), 'omitnan'), mean(conf(correct_coh2), 'omitnan'),...
                mean(conf(correct_coh3), 'omitnan'), mean(conf(correct_coh4), 'omitnan')];


            % confidence per accuracy level per sex
            if sex == 1
                confidence.older.women_accuracy = [confidence.older.women_accuracy;...
                    length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
            
            elseif sex == 2
                confidence.older.men_accuracy = [confidence.older.men_accuracy;...
                    length(incorrect), length(correct), mean(conf(incorrect), 'omitnan'), mean(conf(correct), 'omitnan')];
            end
            
        end
    end
end


%% plot
% coherence x group
figure;
% xticklabels(confidence);
hold on

mean_young = confidence.young.per_coherence(:, 5:end)*100;
mean_older = confidence.older.per_coherence(:, 5:end)*100;


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
mean_confidence_young = mean(mean_young, 1, 'omitnan');
mean_confidence_older = mean(mean_older, 1, 'omitnan');

SE_confidence_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_confidence_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 2 3 4],mean_confidence_young, SE_confidence_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 2 3 4],mean_confidence_older, SE_confidence_older, '--', 'color','r', 'LineWidth',2.5);

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
ylabel({'High confidence', '(%)'},'FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');


%% confidence x accuracy  x group
figure;
% xticklabels(confidence);
hold on

mean_young = confidence.young.accuracy(:, 3:4)*100;
mean_older = confidence.older.accuracy(:, 3:4)*100;

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
mean_confidence_young = mean(mean_young, 1, 'omitnan');
mean_confidence_older = mean(mean_older, 1, 'omitnan');

SE_confidence_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_confidence_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4],mean_confidence_young, SE_confidence_young,'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],mean_confidence_older, SE_confidence_older, '--', 'color','r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 30;
ax.FontName = 'Open Sans';
set(gca, 'XTick',[1, 4], 'XTickLabel',{'Incorrect', 'Correct'})
set(gca, 'XLim',[0 5])
% ax.XTick([1 2 3 4]);
% ax.XTickLabel({'3', '6', '12', '24'});
% xlim([0 5]); %ylim([-0.1 0.3])
ylim padded
ylabel({'High confidence', '(%)'},'FontSize',34,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',20,'FontName','Cambria');

%% 
% confidence x coherence (difficult easy) x accuracy - 


mean_older_incorrect = [mean(confidence.older.incorrect_per_coherence(:, 5), 2, 'omitnan'),...
    mean(confidence.older.incorrect_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(confidence.older.incorrect_per_coherence(:, 7), 2, 'omitnan'),...
    mean(confidence.older.incorrect_per_coherence(:, 8), 2, 'omitnan')].*100;

mean_older_correct = [mean(confidence.older.correct_per_coherence(:, 5), 2, 'omitnan'),...
    mean(confidence.older.correct_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(confidence.older.correct_per_coherence(:, 7), 2, 'omitnan'),...
    mean(confidence.older.correct_per_coherence(:, 8), 2, 'omitnan')].*100;


figure;
hold on

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
mean_confidence_older_incorrect = mean(mean_older_incorrect, 1, 'omitnan');
mean_confidence_older_correct = mean(mean_older_correct, 1, 'omitnan');

SE_confidence_older_incorrect = std(mean_older_incorrect, [], 1, 'omitnan')/sqrt(size(mean_older_incorrect, 1));
SE_confidence_older_correct = std(mean_older_correct, [], 1, 'omitnan')/sqrt(size(mean_older_correct, 1));

hold on
p1 = errorbar([1 2 3 4], mean_confidence_older_incorrect, SE_confidence_older_incorrect, '--', 'color',[213, 94, 0]./255,'LineWidth',2.5);
hold on
p2 = errorbar([1 2 3 4], mean_confidence_older_correct, SE_confidence_older_correct, 'color',[0, 158, 115]./255,'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Open Sans';
set(gca, 'XTick',[1, 2, 3, 4], 'XTickLabel',{'3' '6' '12' '24'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel({'High confidence', '(%)'},'FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%% young
mean_young_incorrect = [mean(confidence.young.incorrect_per_coherence(:, 5), 2, 'omitnan'),...
    mean(confidence.young.incorrect_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(confidence.young.incorrect_per_coherence(:, 7), 2, 'omitnan'),...
    mean(confidence.young.incorrect_per_coherence(:, 8), 2, 'omitnan')].*100;

mean_young_correct = [mean(confidence.young.correct_per_coherence(:, 5), 2, 'omitnan'),...
    mean(confidence.young.correct_per_coherence(:, 6), 2, 'omitnan'), ...
    mean(confidence.young.correct_per_coherence(:, 7), 2, 'omitnan'),...
    mean(confidence.young.correct_per_coherence(:, 8), 2, 'omitnan')].*100;


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
mean_confidence_young_incorrect = mean(mean_young_incorrect, 1, 'omitnan');
mean_confidence_young_correct = mean(mean_young_correct, 1, 'omitnan');

SE_confidence_young_incorrect = std(mean_young_incorrect, [], 1, 'omitnan')/sqrt(size(mean_young_incorrect, 1));
SE_confidence_young_correct = std(mean_young_correct, [], 1, 'omitnan')/sqrt(size(mean_young_correct, 1));

hold on
p1 = errorbar([1 2 3 4], mean_confidence_young_incorrect, SE_confidence_young_incorrect, '--', 'color',[213, 94, 0]./255,'LineWidth', 2.5);
hold on
p2 = errorbar([1 2 3 4], mean_confidence_young_correct, SE_confidence_young_correct, 'color',[0, 158, 115]./255,'LineWidth', 2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 28;
ax.FontName = 'Open Sans';
set(gca, 'XTick',[1, 2, 3, 4], 'XTickLabel',{'3' '6' '12' '24'})
set(gca, 'XLim',[0 5])

xlim([0 5]); ylim padded
ylabel({'High confidence', '(%)'},'FontSize',34,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');


%% confidence x accuracy  x group x sex

for sx = 1:2
    figure;
    % xticklabels(confidence);
    hold on
    if sx == 1
        mean_young = confidence.young.women_accuracy(:, 3:4)*100;
        mean_older = confidence.older.women_accuracy(:, 3:4)*100;
    else
        mean_young = confidence.young.men_accuracy(:, 3:4)*100;
        mean_older = confidence.older.men_accuracy(:, 3:4)*100;
    end
    
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
    mean_confidence_young = mean(mean_young, 1, 'omitnan');
    mean_confidence_older = mean(mean_older, 1, 'omitnan');
    
    SE_confidence_young = std(mean_young, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
    SE_confidence_older = std(mean_older, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
    
    hold on
    p1 = errorbar([1 4],mean_confidence_young, SE_confidence_young,'color','k', 'LineWidth',2.5);
    hold on
    p2 = errorbar([1 4],mean_confidence_older, SE_confidence_older, '--', 'color','r', 'LineWidth',2.5);
    
    hold off;
    box off;
    ax = gca;
    c = ax.Color;
    ax.LineWidth = 2;
    ax.FontSize = 28;
    ax.FontName = 'Open Sans';
    set(gca, 'XTick',[1, 4], 'XTickLabel',{'Incorrect', 'Correct'})
    set(gca, 'XLim',[0 5])
    % ax.XTick([1 2 3 4]);
    % ax.XTickLabel({'3', '6', '12', '24'});
    % xlim([0 5]); %ylim([-0.1 0.3])
    ylim padded
    ylabel('High confidence (%)','FontSize',32,'FontName','Arial');
    % p = [p1 p2];
    % legend(p,'Young','Older','FontSize',20,'FontName','Cambria');


end


%%
% confidence x coherence (difficult easy) x accuracy - young group
figure;
% confidence = {'Incorrect' 'Correct'};
% xticklabels(confidence);
hold on

mean_young_incorrect = [mean(confidence.young.incorrect_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.young.incorrect_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_young_correct = [mean(confidence.young.correct_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.young.correct_per_coherence(:, 7:8), 2, 'omitnan')].*100;

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
mean_confidence_young_incorrect = mean(mean_young_incorrect, 1, 'omitnan');
mean_confidence_young_correct = mean(mean_young_correct, 1, 'omitnan');

SE_confidence_young_incorrect = std(mean_young_incorrect, [], 1, 'omitnan')/sqrt(size(mean_young, 1));
SE_confidence_young_correct = std(mean_young_correct, [], 1, 'omitnan')/sqrt(size(mean_young, 1));

hold on
p1 = errorbar([1 4], mean_confidence_young_incorrect, SE_confidence_young_incorrect, '--', 'color',[213, 94, 0]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_confidence_young_correct, SE_confidence_young_correct, 'color', [0, 158, 115]./255, 'LineWidth',2.5);

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
ylabel('High confidence (%)','FontSize',32,'FontName','Open Sans');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%%
% confidence x coherence (difficult easy) x accuracy - older group
figure;
% confidence = {'Incorrect' 'Correct'};
% xticklabels(confidence);
hold on

mean_older_incorrect = [mean(confidence.older.incorrect_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.older.incorrect_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_older_correct = [mean(confidence.older.correct_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.older.correct_per_coherence(:, 7:8), 2, 'omitnan')].*100;

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
mean_confidence_older_incorrect = mean(mean_older_incorrect, 1, 'omitnan');
mean_confidence_older_correct = mean(mean_older_correct, 1, 'omitnan');

SE_confidence_older_incorrect = std(mean_older_incorrect, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
SE_confidence_older_correct = std(mean_older_correct, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4], mean_confidence_older_incorrect, SE_confidence_older_incorrect, '--', 'color',[213, 94, 0]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_confidence_older_correct, SE_confidence_older_correct, 'color', [0, 158, 115]./255, 'LineWidth',2.5);

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
ylabel('High confidence (%)','FontSize',32,'FontName','Open Sans');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%% coherence x confidence - older group
figure;
% confidence = {'Incorrect' 'Correct'};
% xticklabels(confidence);
hold on

mean_older_lowconf = [mean(confidence.older.lowconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.older.lowconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;
mean_older_highconf = [mean(confidence.older.highconf_per_coherence(:, 5:6), 2, 'omitnan'), mean(confidence.older.highconf_per_coherence(:, 7:8), 2, 'omitnan')].*100;

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
mean_confidence_older_lowconf = mean(mean_older_lowconf, 1, 'omitnan');
mean_confidence_older_highconf = mean(mean_older_highconf, 1, 'omitnan');

SE_confidence_older_lowconf = std(mean_older_lowconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));
SE_confidence_older_highconf = std(mean_older_highconf, [], 1, 'omitnan')/sqrt(size(mean_older, 1));

hold on
p1 = errorbar([1 4], mean_confidence_older_lowconf, SE_confidence_older_lowconf, '--', 'color',[86, 180, 233]./255, 'LineWidth',2.5);
hold on
p2 = errorbar([1 4], mean_confidence_older_highconf, SE_confidence_older_highconf, 'color', [230, 159, 0]./255, 'LineWidth',2.5);

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
ylabel('confidence (%)','FontSize',32,'FontName','Open Sans');
% p = [p1 p2];
% legend(p,'Incor','Correc','FontSize',20,'FontName','Cambria');

%% plot - figure 3.5b
% group x confidence
figure;
confidence = {'Unsure' 'Sure'};
xticklabels(confidence);
hold on

mean_response_young_lowconfidence = [confidence.young.low_confidence(:, 2)];
mean_response_young_highconfidence = [confidence.young.high_confidence(:,2)];
mean_response_older_lowconfidence = [confidence.older.low_confidence(:, 2)];
mean_response_older_highconfidence = [confidence.older.high_confidence(:,2)];

% plot individual points
for p = 1:length(mean_response_young_lowconfidence)
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_young_lowconfidence(p) mean_response_young_highconfidence(p)],'-o',...
    'color',[0.300 0.7470 1],'MarkerSize',8,'MarkerEdgeColor',[0.300 0.7470 1],'LineStyle','none','LineWidth',1.5);
end
for p = 1:length(mean_response_older_lowconfidence)
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[mean_response_older_lowconfidence(p), mean_response_older_highconfidence(p)],'-o',...
    'color',[1 0.6250 0.3980],'MarkerSize',8,'MarkerEdgeColor',[1 0.6250 0.3980],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_confidencebefore_young = [mean(mean_response_young_lowconfidence, 'omitnan'), mean(mean_response_young_highconfidence, 'omitnan')];
all_confidencebefore_older = [mean(mean_response_older_lowconfidence, 'omitnan'), mean(mean_response_older_highconfidence, 'omitnan')];
SE_young = [std(mean_response_young_lowconfidence, 'omitnan')/sqrt(length(mean_response_young_lowconfidence)), std(mean_response_young_highconfidence, 'omitnan')/sqrt(length(mean_response_young_highconfidence))];
SE_older = [std(mean_response_older_lowconfidence, 'omitnan')/sqrt(length(mean_response_older_lowconfidence)), std(mean_response_older_highconfidence, 'omitnan')/sqrt(length(mean_response_older_highconfidence))];

hold on
p1 = errorbar([1 4],all_confidencebefore_young,SE_young,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_older,SE_older,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Unsure' 'Sure'};
xticks([1 4]);

xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.3])
ylabel('confidence Response (% of mean)','FontSize',34,'FontName','Cambria');
p = [p1 p2];
legend(p,'Young','Older','FontSize',30,'FontName','Cambria');


%% plot - figure 3.5c
% group x RT
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);
hold on

mean_response_young_slowRT = [confidence.young.slowRT(:, 2)];
mean_response_young_fastRT = [confidence.young.fastRT(:,2)];
mean_response_older_slowRT = [confidence.older.slowRT(:, 2)];
mean_response_older_fastRT = [confidence.older.fastRT(:,2)];

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
all_confidencebefore_young = [mean(mean_response_young_slowRT, 'omitnan'), mean(mean_response_young_fastRT, 'omitnan')];
all_confidencebefore_older = [mean(mean_response_older_slowRT, 'omitnan'), mean(mean_response_older_fastRT, 'omitnan')];
SE_young = [std(mean_response_young_slowRT, 'omitnan')/sqrt(length(mean_response_young_slowRT)), std(mean_response_young_fastRT, 'omitnan')/sqrt(length(mean_response_young_fastRT))];
SE_older = [std(mean_response_older_slowRT, 'omitnan')/sqrt(length(mean_response_older_slowRT)), std(mean_response_older_fastRT, 'omitnan')/sqrt(length(mean_response_older_fastRT))];

hold on
p1 = errorbar([1 4],all_confidencebefore_young,SE_young,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_older,SE_older,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('confidence Response','FontSize',34,'FontName','Cambria');
p = [p1 p2];
legend(p,'Young','Older','FontSize',30,'FontName','Cambria');


%% Figure 3.5d)
% group X confidence X confidence

% YOUNG GROUP
figure;
confidence = {'Unsure' 'Sure'};
xticklabels(confidence);    
hold on

mean_response_young_unsurecorrect = [confidence.young.low_conf_correct(:, 2)];
mean_response_young_surecorrect = [confidence.young.high_conf_correct(:, 2)];
mean_response_young_unsureincorrect = [confidence.young.low_conf_incorrect(:, 2)];
mean_response_young_sureincorrect = [confidence.young.high_conf_incorrect(:, 2)];

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
all_confidencebefore_young_correct = [mean(mean_response_young_unsurecorrect, 'omitnan'), mean(mean_response_young_surecorrect, 'omitnan')];
SE_young_correct = [std(mean_response_young_unsurecorrect, 'omitnan')/sqrt(length(mean_response_young_unsurecorrect)), std(mean_response_young_surecorrect, 'omitnan')/sqrt(length(mean_response_young_surecorrect))];
all_confidencebefore_young_incorrect = [mean(mean_response_young_unsureincorrect, 'omitnan'), mean(mean_response_young_sureincorrect, 'omitnan')];
SE_young_incorrect = [std(mean_response_young_unsureincorrect, 'omitnan')/sqrt(length(mean_response_young_unsureincorrect)), std(mean_response_young_sureincorrect, 'omitnan')/sqrt(length(mean_response_young_sureincorrect))];

hold on
p1 = errorbar([1 4],all_confidencebefore_young_correct,SE_young_correct,'color',[0 0.62 0.451], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_young_incorrect,SE_young_incorrect,'color',[0.294 0 0.573], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Unsure' 'Sure'};
xticks([1 4]);

xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.3])
ylabel('confidence Response','FontSize',34,'FontName','Cambria');
title('Young Adults','FontSize',24,'FontName','Cambria')
p = [p1 p2];
legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');


% OLDER GROUP
figure;
confidence = {'Unsure' 'Sure'};
xticklabels(confidence);    
hold on

mean_response_older_unsurecorrect = [confidence.older.low_conf_correct(:, 2)];
mean_response_older_surecorrect = [confidence.older.high_conf_correct(:, 2)];
mean_response_older_unsureincorrect = [confidence.older.low_conf_incorrect(:, 2)];
mean_response_older_sureincorrect = [confidence.older.high_conf_incorrect(:, 2)];

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
all_confidencebefore_older_correct = [mean(mean_response_older_unsurecorrect, 'omitnan'), mean(mean_response_older_surecorrect, 'omitnan')];
SE_older_correct = [std(mean_response_older_unsurecorrect, 'omitnan')/sqrt(length(mean_response_older_unsurecorrect)), std(mean_response_older_surecorrect, 'omitnan')/sqrt(length(mean_response_older_surecorrect))];
all_confidencebefore_older_incorrect = [mean(mean_response_older_unsureincorrect, 'omitnan'), mean(mean_response_older_sureincorrect, 'omitnan')];
SE_older_incorrect = [std(mean_response_older_unsureincorrect, 'omitnan')/sqrt(length(mean_response_older_unsureincorrect)), std(mean_response_older_sureincorrect, 'omitnan')/sqrt(length(mean_response_older_sureincorrect))];

hold on
p1 = errorbar([1 4],all_confidencebefore_older_correct,SE_older_correct,'color',[0 0.62 0.451], 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_older_incorrect,SE_older_incorrect,'color',[0.294 0 0.573], 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Unsure' 'Sure'};
xticks([1 4]);

xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.3])
ylabel('confidence Response','FontSize',34,'FontName','Cambria');
title('Older Adults','FontSize',24,'FontName','Cambria')
p = [p1 p2];
legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');


%% Figure 3.5e)
% group X reactiontime X confidence

% YOUNG GROUP
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);  
hold on

% plot individual points
for p = 1:length(confidence.young.slowRT_correct(:, 2))
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.slowRT_correct(p, 2) confidence.young.fastRT_correct(p, 2)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.slowRT_incorrect(p, 2), confidence.young.fastRT_incorrect(p, 2)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_confidencebefore_young_correct = [mean(confidence.young.slowRT_correct(:, 2), 'omitnan'), mean(confidence.young.fastRT_correct(:, 2), 'omitnan')];
SE_young_correct = [std(confidence.young.slowRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.young.slowRT_correct(:, 2))), std(confidence.young.fastRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.young.fastRT_correct(:, 2)))];
all_confidencebefore_young_incorrect = [mean(confidence.young.slowRT_incorrect(:, 2), 'omitnan'), mean(confidence.young.fastRT_incorrect(:, 2), 'omitnan')];
SE_young_incorrect = [std(confidence.young.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.young.slowRT_incorrect(:, 2))), std(confidence.young.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.young.fastRT_incorrect(:, 2)))];

hold on
p1 = errorbar([1 4],all_confidencebefore_young_correct,SE_young_correct,'color',"#009E73", 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_young_incorrect,SE_young_incorrect,'color',"#4B0092", 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('confidence Response','FontSize',34,'FontName','Cambria');
title('Young Adults','FontSize',24,'FontName','Cambria')
p = [p1 p2];


% OLDER GROUP
figure;
reactiontime = {'Slow RT' 'Fast RT'};
xticklabels(reactiontime);    
hold on

% plot individual points
for p = 1:length(confidence.older.slowRT_correct(:, 2))
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.slowRT_correct(p, 2) confidence.older.fastRT_correct(p, 2)],'-o',...
    'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
    hold on
    plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.slowRT_incorrect(p, 2), confidence.older.fastRT_incorrect(p, 2)],'-o',...
    'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
end
xlim([0; 5]);

% average values
all_confidencebefore_older_correct = [mean(confidence.older.slowRT_correct(:, 2), 'omitnan'), mean(confidence.older.fastRT_correct(:, 2), 'omitnan')];
SE_older_correct = [std(confidence.older.slowRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.older.slowRT_correct(:, 2))), std(confidence.older.fastRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.older.fastRT_correct(:, 2)))];
all_confidencebefore_older_incorrect = [mean(confidence.older.slowRT_incorrect(:, 2), 'omitnan'), mean(confidence.older.fastRT_incorrect(:, 2), 'omitnan')];
SE_older_incorrect = [std(confidence.older.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.older.slowRT_incorrect(:, 2))), std(confidence.older.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.older.fastRT_incorrect(:, 2)))];

hold on
p1 = errorbar([1 4],all_confidencebefore_older_correct,SE_older_correct,'color',"#009E73", 'LineWidth',2.5);
hold on
p2 = errorbar([1 4],all_confidencebefore_older_incorrect,SE_older_incorrect,'color',"#4B0092", 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 34;
ax.FontName = 'Cambria';
XTickLabel = {'Slow RT' 'Fast RT'};
xticks([1 4]);

xlabel('Reaction Time','FontSize',34,'FontName','Cambria'); 
xlim([0 5]); ylim([-0.1 0.2])
ylabel('confidence Response','FontSize',34,'FontName','Cambria');
title('Older Adults','FontSize',24,'FontName','Cambria')
p = [p1 p2];
% legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');





% %% plot
% % confidence x confidence
% 
% figure;
% confidence = {'Low' 'High'};
% xticklabels(confidence);    
% hold on
% 
% mean_response_unsurecorrect = [confidence.young.low_conf_correct(:, 2); confidence.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [confidence.young.high_conf_correct(:, 2); confidence.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [confidence.young.low_conf_incorrect(:, 2); confidence.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [confidence.young.high_conf_incorrect(:, 2); confidence.older.high_conf_incorrect(:, 2)];
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
% all_confidencebefore_correct = [mean(mean_response_unsurecorrect, 'omitnan'), mean(mean_response_surecorrect, 'omitnan')];
% SE_correct = [std(mean_response_unsurecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect)), std(mean_response_surecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect))];
% hold on
% p1 = errorbar([1 4],all_confidencebefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_confidencebefore_incorrect = [mean(mean_response_unsureincorrect, 'omitnan'), mean(mean_response_sureincorrect, 'omitnan')];
% SE_incorrect = [std(mean_response_unsureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect)), std(mean_response_sureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect))];
% 
% p2 = errorbar([1 4],all_confidencebefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('confidence Response','FontSize',34,'FontName','Cambria');
% % title({'Median confidence response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');
% 
% %% plot number of trials
% 
% figure;
% confidence = {'Unsure' 'Sure'};
% xticklabels(confidence);    
% hold on
% 
% mean_response_unsurecorrect = [confidence.young.low_conf_correct(:, 1); confidence.older.low_conf_correct(:, 1)];
% mean_response_surecorrect = [confidence.young.high_conf_correct(:, 1); confidence.older.high_conf_correct(:, 1)];
% mean_response_unsureincorrect = [confidence.young.low_conf_incorrect(:, 1); confidence.older.low_conf_incorrect(:, 1)];
% mean_response_sureincorrect = [confidence.young.high_conf_incorrect(:, 1); confidence.older.high_conf_incorrect(:, 1)];
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
% all_confidencebefore_correct = [mean(mean_response_unsurecorrect, 'omitnan'), mean(mean_response_surecorrect, 'omitnan')];
% SE_correct = [std(mean_response_unsurecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect)), std(mean_response_surecorrect, 'omitnan')/sqrt(length(mean_response_unsurecorrect))];
% hold on
% p1 = errorbar([1 4],all_confidencebefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_confidencebefore_incorrect = [mean(mean_response_unsureincorrect, 'omitnan'), mean(mean_response_sureincorrect, 'omitnan')];
% SE_incorrect = [std(mean_response_unsureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect)), std(mean_response_sureincorrect, 'omitnan')/sqrt(length(mean_response_unsureincorrect))];
% 
% p2 = errorbar([1 4],all_confidencebefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('# of trials','FontSize',34,'FontName','Cambria');
% % title({'Median confidence response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');
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
% for p = 1:length(confidence.young.low_confidence(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.low_confidence(p, 2) confidence.young.high_confidence(p, 2)],'-o',...
%     'color',[0 0.4470 0.7410],'MarkerSize',8,'MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% for p = 1:length(confidence.older.low_confidence(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.low_confidence(p, 2), confidence.older.high_confidence(p, 2)],'-o',...
%     'color',[0.8500 0.3250 0.0980],'MarkerSize',8,'MarkerEdgeColor',[0.8500 0.3250 0.0980],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% xlim([0; 5]);
% 
% % average values
% confidencebefore_young = [mean(confidence.young.low_confidence(:, 2), 'omitnan'), mean(confidence.young.high_confidence(:, 2), 'omitnan')];
% SE_young  = [std(confidence.young.low_confidence(:, 2), 'omitnan')/sqrt(length(confidence.young.low_confidence(:, 2))), std(confidence.young.high_confidence(:, 2), 'omitnan')/sqrt(length(confidence.young.high_confidence(:, 2)))];
% hold on
% p1 = errorbar([1 4], confidencebefore_young, SE_young ,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
% hold on
% 
% confidencebefore_older = [mean(confidence.older.low_confidence(:, 2), 'omitnan'), mean(confidence.older.high_confidence(:, 2), 'omitnan')];
% SE_older  = [std(confidence.older.low_confidence(:, 2), 'omitnan')/sqrt(length(confidence.older.low_confidence(:, 2))), std(confidence.older.high_confidence(:, 2), 'omitnan')/sqrt(length(confidence.older.high_confidence(:, 2)))];
% hold on
% p2 = errorbar([1 4], confidencebefore_older, SE_older ,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('confidence Response','FontSize',34,'FontName','Cambria');
% % title({'Median confidence response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');
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
% for p = 1:length(confidence.young.slowRT(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.slowRT(p, 2) confidence.young.fastRT(p, 2)],'-o',...
%     'color',[0 0.4470 0.7410],'MarkerSize',8,'MarkerEdgeColor',[0 0.4470 0.7410],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% for p = 1:length(confidence.older.slowRT(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.slowRT(p, 2), confidence.older.fastRT(p, 2)],'-o',...
%     'color',[0.8500 0.3250 0.0980],'MarkerSize',8,'MarkerEdgeColor',[0.8500 0.3250 0.0980],'LineStyle','none','LineWidth',1.5);
%     hold on
% end
% xlim([0; 5]);
% 
% % average values
% confidencebefore_young = [mean(confidence.young.slowRT(:, 2), 'omitnan'), mean(confidence.young.fastRT(:, 2), 'omitnan')];
% SE_young  = [std(confidence.young.slowRT(:, 2), 'omitnan')/sqrt(length(confidence.young.slowRT(:, 2))), std(confidence.young.fastRT(:, 2), 'omitnan')/sqrt(length(confidence.young.fastRT(:, 2)))];
% hold on
% p1 = errorbar([1 4], confidencebefore_young, SE_young ,'color',[0 0.4470 0.7410], 'LineWidth',2.5);
% hold on
% 
% confidencebefore_older = [mean(confidence.older.slowRT(:, 2), 'omitnan'), mean(confidence.older.fastRT(:, 2), 'omitnan')];
% SE_older  = [std(confidence.older.slowRT(:, 2), 'omitnan')/sqrt(length(confidence.older.slowRT(:, 2))), std(confidence.older.fastRT(:, 2), 'omitnan')/sqrt(length(confidence.older.fastRT(:, 2)))];
% hold on
% p2 = errorbar([1 4], confidencebefore_older, SE_older ,'color',[0.8500 0.3250 0.0980], 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% % XTickLabel = {'Unsure' 'Sure'};
% xticks([1 4]);
% 
% % xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); %ylim([-0.1 0.3])
% ylabel('confidence Response','FontSize',34,'FontName','Cambria');
% % title({'Median confidence response in the period before', 'feedback as a function of confidence level'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% legend(p,'Young','Older','FontSize',15,'FontName','Cambria');
% 
% 
% %% confidence based on RT vs confidence - young
%             
% 
% figure;
% reaction_time = {'Slow RT' 'Fast RT'};
% xticklabels(reaction_time); 
% hold on
% 
% mean_response_unsurecorrect = [confidence.young.low_conf_correct(:, 2); confidence.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [confidence.young.high_conf_correct(:, 2); confidence.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [confidence.young.low_conf_incorrect(:, 2); confidence.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [confidence.young.high_conf_incorrect(:, 2); confidence.older.high_conf_incorrect(:, 2)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(confidence.young.slowRT_correct(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.slowRT_correct(p, 2) confidence.young.fastRT_correct(p, 2)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.young.slowRT_incorrect(p, 2), confidence.young.fastRT_incorrect(p, 2)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_confidencebefore_correct = [mean(confidence.young.slowRT_correct(:, 2), 'omitnan'), mean(confidence.young.fastRT_correct(:, 2), 'omitnan')];
% SE_correct = [std(confidence.young.slowRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.young.slowRT_correct(:, 2))), std(confidence.young.fastRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.young.fastRT_correct(:, 2)))];
% hold on
% p1 = errorbar([1 4],all_confidencebefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_confidencebefore_incorrect = [mean(confidence.young.slowRT_incorrect(:, 2), 'omitnan'), mean(confidence.young.fastRT_incorrect(:, 2), 'omitnan')];
% SE_incorrect = [std(confidence.young.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.young.slowRT_incorrect(:, 2))), std(confidence.young.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.young.fastRT_incorrect(:, 2)))];
% 
% p2 = errorbar([1 4],all_confidencebefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% XTickLabel = {'SlowRT' 'FastRT'};
% xticks([1 4]);
% 
% % xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('confidence Response','FontSize',34,'FontName','Cambria');
% title({'Young'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');
% 
% 
% %% confidence based on RT vs confidence - older
% figure;
% reaction_time = {'Slow RT' 'Fast RT'};
% xticklabels(reaction_time); 
% hold on
% 
% mean_response_unsurecorrect = [confidence.older.low_conf_correct(:, 2); confidence.older.low_conf_correct(:, 2)];
% mean_response_surecorrect = [confidence.older.high_conf_correct(:, 2); confidence.older.high_conf_correct(:, 2)];
% mean_response_unsureincorrect = [confidence.older.low_conf_incorrect(:, 2); confidence.older.low_conf_incorrect(:, 2)];
% mean_response_sureincorrect = [confidence.older.high_conf_incorrect(:, 2); confidence.older.high_conf_incorrect(:, 2)];
% 
% % plot individual points
% % unsure correct - sure correct
% for p = 1:length(confidence.older.slowRT_correct(:, 2))
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.slowRT_correct(p, 2) confidence.older.fastRT_correct(p, 2)],'-o',...
%     'color',[0.2 0.82 0.651],'MarkerSize',8,'MarkerEdgeColor',[0.2 0.82 0.651],'LineStyle','none','LineWidth',1.5);
%     hold on
%     plot([1+rand*0.2-0.1, 4+rand*0.2-0.1],[confidence.older.slowRT_incorrect(p, 2), confidence.older.fastRT_incorrect(p, 2)],'-o',...
%     'color',[0.494 0.2 0.773],'MarkerSize',8,'MarkerEdgeColor',[0.494 0.2 0.773],'LineStyle','none','LineWidth',1.5);
% end
% xlim([0; 5]);
% 
% % average values
% all_confidencebefore_correct = [mean(confidence.older.slowRT_correct(:, 2), 'omitnan'), mean(confidence.older.fastRT_correct(:, 2), 'omitnan')];
% SE_correct = [std(confidence.older.slowRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.older.slowRT_correct(:, 2))), std(confidence.older.fastRT_correct(:, 2), 'omitnan')/sqrt(length(confidence.older.fastRT_correct(:, 2)))];
% hold on
% p1 = errorbar([1 4],all_confidencebefore_correct,SE_correct,'color',"#009E73", 'LineWidth',2.5);
% hold on
% 
% all_confidencebefore_incorrect = [mean(confidence.older.slowRT_incorrect(:, 2), 'omitnan'), mean(confidence.older.fastRT_incorrect(:, 2), 'omitnan')];
% SE_incorrect = [std(confidence.older.slowRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.older.slowRT_incorrect(:, 2))), std(confidence.older.fastRT_incorrect(:, 2), 'omitnan')/sqrt(length(confidence.older.fastRT_incorrect(:, 2)))];
% 
% p2 = errorbar([1 4],all_confidencebefore_incorrect,SE_incorrect,'color',"#4B0092", 'LineWidth',2.5);
% 
% hold off;
% box off;
% ax = gca;
% c = ax.Color;
% ax.LineWidth = 2;
% ax.FontSize = 34;
% ax.FontName = 'Cambria';
% XTickLabel = {'SlowRT' 'FastRT'};
% xticks([1 4]);
% 
% % xlabel('confidence Level','FontSize',34,'FontName','Cambria'); 
% xlim([0 5]); ylim([-0.1 0.3])
% ylabel('confidence Response','FontSize',34,'FontName','Cambria');
% title({'Older'},'FontSize',30,'FontName','Sans Serife Font');
% p = [p1 p2];
% % legend(p,'Correct','Incorrect','FontSize',30,'FontName','Cambria');