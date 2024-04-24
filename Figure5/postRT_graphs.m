clear; close all;
% table created with reactiontime_analysisLMM.m
filename = 'table_reactiontime_MR.xlsx';
T = readtable(filename);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

var4table = [];
for grp = 1:2
    for prt = participants{grp}'
        
        accuracy = T.Accuracy(T.Participant == prt);
        reaction_time = T.ReactionTime(T.Participant == prt);
        confidence = T.Confidence(T.Participant == prt);
        coherence = T.Coherence(T.Participant == prt);

        group = ones(length(reaction_time)-2, 1)*grp;
        participant_id = ones(length(reaction_time)-2, 1)*prt;
    
        var4table = [var4table; participant_id, group, reaction_time(1:end-2), accuracy(1:end-2), coherence(2:end-1), confidence(2:end-1), accuracy(2:end-1),reaction_time(2:end-1)...
            reaction_time(3:end), accuracy(3:end)];
        
    end
end

%% TABLE - without excluded participants already
table_reactiontime = array2table(var4table);

table_reactiontime.Properties.VariableNames = {'Participant', 'Group', 'PreRT', 'PreAcc', 'Coherence','Confidence', 'Accuracy','ReactionTime'...
        'PostRT', 'PostAcc'};

filename = 'postRT.xlsx';

writetable(table_reactiontime,filename)

%%
clear; close all
filename = 'postRT.xlsx';
T = readtable(filename);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end


% post RT - group x accuracy x confidence

postRT_perconfidence = cell(2, 1); % high conf low conf
postRT_peraccuracy = cell(2, 1); % correct, incorrect

postRT_peracc_perconf= cell(2, 1); % correct high conf low conf; incorrect high conf low conf

postRT_peracc_perconf_percoh = cell(2, 1); % correct high conf low conf x 4 coh; incorrect high conf low conf x 4 coh

postRT_perconf_percoh = cell(2, 1); % high conf low conf x 4 coh

for grp = 1:2
    for prt = 1:length(participants{grp})
        
        acc = T.Accuracy(T.Participant == participants{grp}(prt));
        conf = T.Confidence(T.Participant == participants{grp}(prt));
        coh = T.Coherence(T.Participant == participants{grp}(prt));
        postRT = T.PostRT(T.Participant == participants{grp}(prt));
        postAcc = T.PostAcc(T.Participant == participants{grp}(prt));
        preAcc = T.PreAcc(T.Participant == participants{grp}(prt));


        postRT_peracc_perconf{grp}(prt, :) = [mean(postRT(conf == 1 & acc == 1 & postAcc == 1 & preAcc == 1), 'omitnan'), mean(postRT(conf == 0 & acc == 1 & postAcc == 1 & preAcc == 1), 'omitnan'),...
            mean(postRT(conf == 1 & acc == 0 & postAcc == 1 & preAcc == 1), 'omitnan'), mean(postRT(conf == 0 & acc == 0 & postAcc == 1 & preAcc == 1), 'omitnan')];

        postRT_perconfidence{grp}(prt, :) = [mean(postRT(conf == 1 & postAcc == 1 & preAcc == 1), 'omitnan'), mean(postRT(conf == 0 & postAcc == 1 & preAcc == 1), 'omitnan')];
        postRT_peraccuracy{grp}(prt, :) = [mean(postRT(acc == 1 & postAcc == 1 & preAcc == 1), 'omitnan'), mean(postRT(acc == 0 & postAcc == 1 & preAcc == 1), 'omitnan')];

        % (correct high conf correct low conf ; incorrect high conf incorrect low conf) x 4 coh
        postRT_peracc_perconf_percoh{grp}(prt, :) = [mean(postRT(conf == 1 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 1 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 1 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 1 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan'), ...
            mean(postRT(conf == 0 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 0 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 0 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 0 & acc == 1 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan'), ...
            mean(postRT(conf == 1 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 1 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 1 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 1 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan'), ...
            mean(postRT(conf == 0 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 0 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 0 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 0 & acc == 0 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan')];
        
        
       % high conf low conf x 4 coh
       postRT_perconf_percoh{grp}(prt, :) = [mean(postRT(conf == 1 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 1 & postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 1 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 1 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan'), ...
            mean(postRT(conf == 0 & postAcc == 1 & preAcc == 1 & coh == 3), 'omitnan'), mean(postRT(conf == 0& postAcc == 1 & preAcc == 1 & coh == 6), 'omitnan'),...
            mean(postRT(conf == 0 & postAcc == 1 & preAcc == 1 & coh == 12), 'omitnan'), mean(postRT(conf == 0 & postAcc == 1 & preAcc == 1 & coh == 24), 'omitnan')];

    end
end


[h,p,ci,stats] = ttest(postRT_perconfidence{1}(:, 1), postRT_perconfidence{1}(:, 2))

mean(postRT_perconfidence{1}(:, 1))
mean(postRT_perconfidence{1}(:, 2))

mean(postRT_perconfidence{2}(:, 1))
mean(postRT_perconfidence{2}(:, 2), 'omitnan')



% figure both groups together - post RT correct high conf lowconf incoree

mean_young = mean(postRT_peracc_perconf{1}, 1, 'omitnan');
se_young = std(postRT_peracc_perconf{1}, [], 1, 'omitnan')./sqrt([length(postRT_peracc_perconf{1}(~isnan(postRT_peracc_perconf{1}(:, 1)), 1)), length(postRT_peracc_perconf{1}(~isnan(postRT_peracc_perconf{1}(:, 2)), 2)), ...
    length(postRT_peracc_perconf{1}(~isnan(postRT_peracc_perconf{1}(:, 3)), 3)), length(postRT_peracc_perconf{1}(~isnan(postRT_peracc_perconf{1}(:, 4)), 4))]);

mean_older = mean(postRT_peracc_perconf{2}, 1, 'omitnan');
se_older = std(postRT_peracc_perconf{2}, [], 1, 'omitnan')./sqrt([length(postRT_peracc_perconf{2}(~isnan(postRT_peracc_perconf{2}(:, 1)), 1)), length(postRT_peracc_perconf{2}(~isnan(postRT_peracc_perconf{2}(:, 2)), 2)), ...
    length(postRT_peracc_perconf{2}(~isnan(postRT_peracc_perconf{2}(:, 3)), 3)), length(postRT_peracc_perconf{2}(~isnan(postRT_peracc_perconf{2}(:, 4)), 4))]);


figure;
hold on
% plot([0 4], [0 0], ':k', 'LineWidth',1);

% plot individual points
for p = 1:size(postRT_peracc_perconf{1}, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf{1}(p, :),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[.5 .5 .5],'LineStyle','none','LineWidth',.75);
end
for p = 1:size(postRT_peracc_perconf{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf{2}(p, :), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[1 0.5 0.5], 'LineStyle','none','LineWidth',1);
end
% xlim([0; 5]);


hold on
p1 = errorbar([1 2],mean_young(1:2), se_young(1:2),'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([1 2],mean_older(1:2), se_older(1:2), '--', 'color', 'r', 'LineWidth',2.5);
hold on
p1 = errorbar([3 4],mean_young(3:4), se_young(3:4),'color','k', 'LineWidth',2.5);
hold on
p2 = errorbar([3 4],mean_older(3:4), se_older(3:4), '--', 'color', 'r', 'LineWidth',2.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',[1, 2, 3, 4], 'XTickLabel',{'Post high conf', 'Post low conf', 'Post high conf', 'Post low conf'})
set(gca, 'XLim',[0 5])

% ylim([-2.2, .5])%ylim padded
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');
% xlabel('Confidence','FontSize',30,'FontName','Arial');


%%
% HIGH CONFIDENCE VS LOW CONFIDENCE AS A FUNCTION OF MOTION COHERENCE
% postRT_perconf_percoh{grp}(prt, :)
length_young = [];
for i = 1:size(postRT_perconf_percoh{1}, 2)
    length_young(i) = size(postRT_perconf_percoh{1}(~isnan(postRT_perconf_percoh{1}(:, i)), i), 1);
end

mean_young_high_conf = mean(postRT_perconf_percoh{1}(:, 1:4), 1, 'omitnan');
mean_young_low_conf = mean(postRT_peracc_perconf_percoh{1}(:, 5:8), 1, 'omitnan');

se_young_high_conf = std(postRT_perconf_percoh{1}(:, 1:4), [], 1, 'omitnan')./sqrt(length_young(1:4));
se_young_low_conf = std(postRT_perconf_percoh{1}(:, 5:8), [],1, 'omitnan')./sqrt(length_young(5:8));


length_older= [];
for i = 1:size(postRT_perconf_percoh{2}, 2)
    length_older(i) = size(postRT_perconf_percoh{2}(~isnan(postRT_perconf_percoh{2}(:, i)), i), 1);
end

mean_older_high_conf = mean(postRT_perconf_percoh{2}(:, 1:4), 1, 'omitnan');
mean_older_low_conf = mean(postRT_perconf_percoh{2}(:, 5:8), 1, 'omitnan');

se_older_high_conf = std(postRT_perconf_percoh{2}(:, 1:4), [], 1, 'omitnan')./sqrt(length_older(1:4));
se_older_low_conf = std(postRT_perconf_percoh{2}(:, 5:8), [],1, 'omitnan')./sqrt(length_older(5:8));

% coherence x confidence  - young
% correct
figure;
hold on
% plot([0 4], [0 0], ':k', 'LineWidth',1);

% plot individual points
% high confidence 
for p = 1:size(postRT_perconf_percoh{1}(:, 1:4), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1 , 4+rand*0.2-0.1],postRT_perconf_percoh{1}(p, 1:4),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[86+50, 180+50, 255]./255,'LineWidth',1);%, 'MarkerFaceColor', [86+50, 180+50, 255]./255);
end
for p = 1:size(postRT_perconf_percoh{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_perconf_percoh{2}(p, 1:4), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[86+35, 180+35, 255]./255, 'LineStyle','none','LineWidth',1);
end

% low confidence 
for p = 1:size(postRT_perconf_percoh{1}(:, 5:8), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_perconf_percoh{1}(p, 5:8),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[255, 159+50, 50]./255,'LineWidth',1);%, 'MarkerFaceColor',[255, 159+50, 50]./255);
end
for p = 1:size(postRT_perconf_percoh{2}(:, 5:8), 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_perconf_percoh{1}(p, 5:8), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[255, 159+35, 35]./255, 'LineStyle','none','LineWidth',1);
end
xlim([0; 5]);


hold on
p1 = errorbar([1 2 3 4],mean_young_high_conf, se_young_high_conf,'color',[86, 180, 233]./255, 'LineWidth',3);
hold on
p2 = errorbar([1 2 3 4],mean_young_low_conf, se_young_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',3);

hold on
p1 = errorbar([1 2 3 4],mean_older_high_conf, se_older_high_conf,'color',[86, 180, 233]./255, 'LineWidth',1.5);
hold on
p2 = errorbar([1 2 3 4],mean_older_low_conf, se_older_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',1.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',1:4, 'XTickLabel',{'3', '6', '12', '24'})
set(gca, 'XLim',[0 5])

ylim padded%ylim([-1 .5]); %
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');



%%
        % (correct high conf correct low conf ; incorrect high conf incorrect low conf) x 4 coh
% postRT_peracc_perconf_percoh{grp}(prt, :)

for i = 1:size(postRT_peracc_perconf_percoh{1}, 2)
    length_young(i) = size(postRT_peracc_perconf_percoh{1}(~isnan(postRT_peracc_perconf_percoh{1}(:, i)), i), 1);
end

mean_young_correct_high_conf = mean(postRT_peracc_perconf_percoh{1}(:, 1:4), 1, 'omitnan');
mean_young_correct_low_conf = mean(postRT_peracc_perconf_percoh{1}(:, 5:8), 1, 'omitnan');
mean_young_incorrect_high_conf = mean(postRT_peracc_perconf_percoh{1}(:, 9:12), 1, 'omitnan');
mean_young_incorrect_low_conf = mean(postRT_peracc_perconf_percoh{1}(:, 13:16), 1, 'omitnan');

se_young_correct_high_conf = std(postRT_peracc_perconf_percoh{1}(:, 1:4), [], 1, 'omitnan')./sqrt(length_young(1:4));
se_young_correct_low_conf = std(postRT_peracc_perconf_percoh{1}(:, 5:8), [],1, 'omitnan')./sqrt(length_young(5:8));
se_young_incorrect_high_conf = std(postRT_peracc_perconf_percoh{1}(:, 9:12), [],1, 'omitnan')./sqrt(length_young(9:12));
se_young_incorrect_low_conf = std(postRT_peracc_perconf_percoh{1}(:, 13:16), [],1, 'omitnan')./sqrt(length_young(13:16));


for i = 1:size(postRT_peracc_perconf_percoh{2}, 2)
    length_older(i) = size(postRT_peracc_perconf_percoh{2}(~isnan(postRT_peracc_perconf_percoh{2}(:, i)), i), 1);
end

mean_older_correct_high_conf = mean(postRT_peracc_perconf_percoh{2}(:, 1:4), 1, 'omitnan');
mean_older_correct_low_conf = mean(postRT_peracc_perconf_percoh{2}(:, 5:8), 1, 'omitnan');
mean_older_incorrect_high_conf = mean(postRT_peracc_perconf_percoh{2}(:, 9:12), 1, 'omitnan');
mean_older_incorrect_low_conf = mean(postRT_peracc_perconf_percoh{2}(:, 13:16), 1, 'omitnan');

se_older_correct_high_conf = std(postRT_peracc_perconf_percoh{2}(:, 1:4), [], 1, 'omitnan')./sqrt(length_older(1:4));
se_older_correct_low_conf = std(postRT_peracc_perconf_percoh{2}(:, 5:8), [],1, 'omitnan')./sqrt(length_older(5:8));
se_older_incorrect_high_conf = std(postRT_peracc_perconf_percoh{2}(:, 9:12), [],1, 'omitnan')./sqrt(length_older(9:12));
se_older_incorrect_low_conf = std(postRT_peracc_perconf_percoh{2}(:, 13:16), [],1, 'omitnan')./sqrt(length_older(13:16));


% coherence x confidence  - young
% correct
figure;
hold on
% plot([0 4], [0 0], ':k', 'LineWidth',1);


% plot individual points
% high confidence correct
for p = 1:size(postRT_peracc_perconf_percoh{1}(:, 1:4), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1 , 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 1:4),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[86+50, 180+50, 255]./255,'LineWidth',1);%, 'MarkerFaceColor', [86+50, 180+50, 255]./255);
end
for p = 1:size(postRT_peracc_perconf_percoh{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{2}(p, 1:4), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[86+35, 180+35, 255]./255, 'LineStyle','none','LineWidth',1);
end

% low confidence correct
for p = 1:size(postRT_peracc_perconf_percoh{1}(:, 5:8), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 5:8),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[255, 159+50, 50]./255,'LineWidth',1);%, 'MarkerFaceColor',[255, 159+50, 50]./255);
end
for p = 1:size(postRT_peracc_perconf_percoh{2}(:, 5:8), 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 5:8), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[255, 159+35, 35]./255, 'LineStyle','none','LineWidth',1);
end
xlim([0; 5]);


hold on
p1 = errorbar([1 2 3 4],mean_young_correct_high_conf, se_young_correct_high_conf,'color',[86, 180, 233]./255, 'LineWidth',3);
hold on
p2 = errorbar([1 2 3 4],mean_young_correct_low_conf, se_young_correct_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',3);

hold on
p1 = errorbar([1 2 3 4],mean_older_correct_high_conf, se_older_correct_high_conf,'color',[86, 180, 233]./255, 'LineWidth',1.5);
hold on
p2 = errorbar([1 2 3 4],mean_older_correct_low_conf, se_older_correct_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',1.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',1:4, 'XTickLabel',{'3', '6', '12', '24'})
set(gca, 'XLim',[0 5])

ylim padded%ylim([-1 .5]); %
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');

%% coherence x confidence  - incorrect
figure;
hold on
% plot([0 4], [0 0], ':k', 'LineWidth',1);


% plot individual points
% high confidence incorrect
for p = 1:size(postRT_peracc_perconf_percoh{1}(:, 1:4), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1 , 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 1:4),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[86+50, 180+50, 255]./255,'LineWidth',1);%, 'MarkerFaceColor', [86+50, 180+50, 255]./255);
end
for p = 1:size(postRT_peracc_perconf_percoh{2}, 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{2}(p, 1:4), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[86+35, 180+35, 255]./255, 'LineStyle','none','LineWidth',1);
end

% low confidence incorrect
for p = 1:size(postRT_peracc_perconf_percoh{1}(:, 5:8), 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 5:8),'o',...
        'MarkerSize',6,'MarkerEdgeColor',[255, 159+50, 50]./255,'LineWidth',1);%, 'MarkerFaceColor',[255, 159+50, 50]./255);
end
for p = 1:size(postRT_peracc_perconf_percoh{2}(:, 5:8), 1)
    hold on
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1, 3+rand*0.2-0.1, 4+rand*0.2-0.1],postRT_peracc_perconf_percoh{1}(p, 5:8), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor',[255, 159+35, 35]./255, 'LineStyle','none','LineWidth',1);
end
xlim([0; 5]);


hold on
p1 = errorbar([1 2 3 4],mean_young_incorrect_high_conf, se_young_incorrect_high_conf,'color',[86, 180, 233]./255, 'LineWidth',3);
hold on
p2 = errorbar([1 2 3 4],mean_young_incorrect_low_conf, se_young_incorrect_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',3);

hold on
p1 = errorbar([1 2 3 4],mean_older_incorrect_high_conf, se_older_incorrect_high_conf,'color',[86, 180, 233]./255, 'LineWidth',1.5);
hold on
p2 = errorbar([1 2 3 4],mean_older_incorrect_low_conf, se_older_incorrect_low_conf, '--', 'color',[230, 159, 0]./255, 'LineWidth',1.5);

hold off;
box off;
ax = gca;
c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',1:4, 'XTickLabel',{'3', '6', '12', '24'})
set(gca, 'XLim',[0 5])

ylim padded%ylim([-1 .5]); %
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');
xlabel('Motion coherence (%)','FontSize',30,'FontName','Arial');

