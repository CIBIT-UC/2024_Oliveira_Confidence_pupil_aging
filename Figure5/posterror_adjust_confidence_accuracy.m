clear; close all;
% table created with reactiontime_analysisLMM.m
filename = 'table_reactiontime_MR.xlsx';
T = readtable(filename);

for grp = 1:2
    participants{grp} = unique(T.Participant(T.Group == grp));
end

% excluded participants - outliers 24, 34, 37 - group = 2
participants{2}(ismember(participants{2}, [24, 26, 34, 37])) = []; 

RT_posterror_postcorrect = cell(2, 1);

RT_posthighconf_postlowconf = cell(2, 1);

for grp = 1:2
    for prt = participants{grp}'
        
        acc = T.Accuracy(T.Participant == prt);
        RT = T.ReactionTime(T.Participant == prt);
        coh = T.Coherence(T.Participant == prt);
        conf = T.Confidence(T.Participant == prt);
        
        % robust poste-error slowing - Dutilh et al 2012
        % find RT after errors - for correct trials
        % find RT after correct that are also pre-error - for correct
        % trials 
        RT_posterror = [];
        RT_postcorrect = [];
        PostErrorSlowing= [];
        for trl = 1:length(RT)-3
            if acc(trl) == 1 && acc(trl + 1) == 1 && acc(trl + 2) == 0 && acc(trl + 3) == 1
                RT_posterror = [RT_posterror; RT(trl + 3)];
                RT_postcorrect = [RT_postcorrect; RT(trl + 1)];
                PostErrorSlowing = [PostErrorSlowing; RT(trl + 3)-RT(trl + 1)];
            end
        end
        
        RT_posterror_postcorrect{grp} = [RT_posterror_postcorrect{grp}; mean(RT_posterror, 'omitnan'),  mean(RT_postcorrect, 'omitnan'),...
            mean(PostErrorSlowing, 'omitnan')];
        
        % find RT after high conf - correct/correct
        % find RT after low conf - correct/correct
        
        
        RT_posthighlowconf = [];
        for trl = 1:length(RT)-3
            if conf(trl) == 1 && conf(trl + 1) == 1 && conf(trl + 2) == 0 && conf(trl + 3) == 1
                RT_posthighlowconf = [RT_posthighlowconf; RT(trl + 1), RT(trl + 3), RT(trl + 3)-RT(trl + 1)];
            end
        end
        
        if isempty(RT_posthighlowconf)
            RT_posthighconf_postlowconf{grp} = [RT_posthighconf_postlowconf{grp}; prt, NaN(1, 3)];
        else
            RT_posthighconf_postlowconf{grp} = [RT_posthighconf_postlowconf{grp}; prt, mean(RT_posthighlowconf(:, 1), 'omitnan'),...
                mean(RT_posthighlowconf(:, 2), 'omitnan'), mean(RT_posthighlowconf(:, 3), 'omitnan')];
        end
        
    end
end

[H,P,CI] = ttest(RT_posterror_postcorrect{1}(:, 1), RT_posterror_postcorrect{1}(:, 2))

[H,P,CI] = ttest(RT_posterror_postcorrect{2}(:, 1), RT_posterror_postcorrect{2}(:, 2))

[H,P,CI] = ttest(RT_posterror_postcorrect{2}(:, 3))
[H,P,CI] = ttest(RT_posterror_postcorrect{1}(:, 3))

mean(RT_posterror_postcorrect{1}(:, 1))
mean(RT_posterror_postcorrect{1}(:, 2))

mean(RT_posterror_postcorrect{2}(:, 1))
mean(RT_posterror_postcorrect{2}(:, 2))


% post low confidence slowing
[H,P,CI] = ttest(RT_posthighconf_postlowconf{1}(:, 2), RT_posthighconf_postlowconf{1}(:, 3))

[H,P,CI] = ttest(RT_posthighconf_postlowconf{2}(:, 2), RT_posthighconf_postlowconf{2}(:, 3))

mean(RT_posthighconf_postlowconf{1}(:, 2))
mean(RT_posthighconf_postlowconf{1}(:, 3))

mean(RT_posthighconf_postlowconf{2}(:, 2), 'omitnan')
mean(RT_posthighconf_postlowconf{2}(:, 3), 'omitnan')


% post-low confidence slowing - percentage
youngPLCS = RT_posthighconf_postlowconf{1}(:, 4)./RT_posthighconf_postlowconf{1}(:, 2)*100;

olderPLCS = RT_posthighconf_postlowconf{2}(:, 4)./RT_posthighconf_postlowconf{2}(:, 2)*100;

[H,P,CI, stats] = ttest2(youngPLCS, olderPLCS)

[H,P,CI, stats] = ttest(youngPLCS)
[H,P,CI, stats] = ttest(olderPLCS)

[H,P,CI, stats] = ttest([youngPLCS; olderPLCS])


% PES
youngPES = RT_posterror_postcorrect{1}(:, 3)./RT_posterror_postcorrect{1}(:, 2)*100

olderPES = RT_posterror_postcorrect{2}(:, 3)./RT_posterror_postcorrect{2}(:, 2)*100


[H,P,CI, stats] = ttest2(youngPES, olderPES)

[H,P,CI, stats] = ttest(youngPES)
[H,P,CI, stats] = ttest(olderPES)

%% figure both groups together - average delta RT as a fuction of delta coherence

mean_young = mean(RT_posterror_postcorrect{1}(:, 1:2), 1, 'omitnan');
se_young = std(RT_posterror_postcorrect{1}(:, 1:2), [], 1, 'omitnan')./sqrt(size(RT_posterror_postcorrect{1}, 1));

mean_older = mean(RT_posterror_postcorrect{2}(:, 1:2), 1, 'omitnan');
se_older = std(RT_posterror_postcorrect{2}(:, 1:2), [], 1, 'omitnan')./sqrt(size(RT_posterror_postcorrect{2}, 1));

figure;
hold on
% plot([0 4], [0 0], ':k', 'LineWidth',1);


% xlim([0; 5]);

bar([1, 2, 4, 5], [mean_young, mean_older],'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',1.5)

hold on
p1 = errorbar([1 2],mean_young, se_young,'Color', [0 0 0],'LineStyle','none','LineWidth',1);
hold on
p2 = errorbar([4 5],mean_older, se_older,'Color', [0 0 0], 'LineStyle','none','LineWidth',1);
hold on
% plot individual points
for p = 1:size(RT_posterror_postcorrect{1}, 1)
    plot([1+rand*0.2-0.1, 2+rand*0.2-0.1],RT_posterror_postcorrect{1}(p, 1:2),'o',...
        'MarkerSize',6,'MarkerEdgeColor','k','LineStyle','none','LineWidth',.5);
end
for p = 1:size(RT_posterror_postcorrect{2}, 1)
    hold on
    plot([4+rand*0.2-0.1, 5+rand*0.2-0.1],RT_posterror_postcorrect{2}(p, 1:2), 'd',...
    	'MarkerSize',6,'MarkerEdgeColor','k', 'LineStyle','none','LineWidth',.5);
end
hold off;
box off;
ax = gca;
% c = ax.Color;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontName = 'Arial';
set(gca, 'XTick',[1 2 4 5], 'XTickLabel',{'Post error' 'Post correct' 'Post error' 'Post correct'})
set(gca, 'XLim',[0 6])

ylim padded%ylim([-1 .5]); %
ylabel('Reaction time (s)','FontSize',30,'FontName','Arial');





