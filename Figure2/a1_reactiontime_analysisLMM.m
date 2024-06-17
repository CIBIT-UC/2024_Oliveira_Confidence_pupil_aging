%% VARIABLES
clear all; clc;

behaviour_mat = []; % participant, group, coherence, confidence, accuracy, reaction time
data_dir = 'D:\Project_Exercise_SaraOliveira\Data';

% participants id for both sexes
female = [1, 2, 4, 5, 6, 8, 10, 11, 13, 14, 22, 28, 29, 30, 35, 38, 39, 41, 50, 52, 55, 56];
male = [3, 7, 9, 12, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27, 32, 33, 40, 53, 57];

excluded = [24, 26, 34, 37, 51, 54];


% YOUNGER ADULTS
for p = [1:20, 50]
    session = 1;
    moment = 1;
    if ismember(p, female)
        sex = 1;
    else
        sex = 2;
    end
    for run = 1:4

        filename = [data_dir filesep 'Participant',num2str(p),'_S',num2str(session),'_M',num2str(moment),'_R',num2str(run) filesep 'Participant',num2str(p),'_s',num2str(session),'_m',num2str(moment),'_r',num2str(run),'.mat'];
        load(filename,"results");
        
        % create variable with one for fast RT and 2 for slow RT
        reaction_time = results.RT';
        [B,I] = sortrows(reaction_time);
        RT_bin = ones(length(reaction_time), 1);
        RT_bin(I(floor(length(I)/2)+1:end)) = 0;
        
        % participant, group, SEX, coherence, confidence, accuracy
        behaviour_mat = [behaviour_mat; ones(size(results.output, 1), 1)*p, ones(size(results.output, 1), 1)*1, ones(size(results.output, 1), 1)*sex,...
           results.output(:, 1).*100, ...
           results.confidence', results.correct', results.RT', RT_bin];
        
    end
end


% OLDER ADULTS
for p = setdiff(21:57, excluded)   
    if ismember(p, female)
        sex = 1;
    else
        sex = 2;
    end
    %PARTICIPANTS WHO DID THE MENTAL SESSION FIRST
    if ((p >= 21 && p <= 30) || p == 41  || ismember(p, [52, 53, 55, 56, 57])) && p ~= 24
        session = 1;
        moment = 1;
        for run = 1:4
            data_dir = 'D:\Project_Exercise_SaraOliveira\Data';
            filename = [data_dir filesep 'Participant',num2str(p),'_S',num2str(session),'_M',num2str(moment),'_R',num2str(run) filesep 'Participant',num2str(p),'_s',num2str(session),'_m',num2str(moment),'_r',num2str(run),'.mat'];
            load(filename,"results");
            % create variable with one for fast RT and 2 for slow RT
            reaction_time = results.RT';
            [B,I] = sortrows(reaction_time);
            RT_bin = ones(length(reaction_time), 1);
            RT_bin(I(floor(length(I)/2)+1:end)) = 0;
            
            % participant, group, sex, coherence, confidence, accuracy,
            % reaction time, reaction time bins
            behaviour_mat = [behaviour_mat; ones(size(results.output, 1), 1)*p, ones(size(results.output, 1), 1)*2, ones(size(results.output, 1), 1)*sex,...
               results.output(:, 1).*100, ...
               results.confidence', results.correct', results.RT', RT_bin];

        end
    %PARTICIPANTS WHO DID THE PHYSICAL SESSION FIRST
    elseif ((p >= 31 && p <= 35) || (p >= 38 && p <= 40)) && p ~= 34
        session = 2;
        moment = 1;
        for run = 1:4
            data_dir = 'D:\Project_Exercise_SaraOliveira\Data';
            filename = [data_dir filesep 'Participant',num2str(p),'_S',num2str(session),'_M',num2str(moment),'_R',num2str(run) filesep 'Participant',num2str(p),'_s',num2str(session),'_m',num2str(moment),'_r',num2str(run),'.mat'];
            load(filename,"results");
            % create variable with one for fast RT and 2 for slow RT
            reaction_time = results.RT';
            [B,I] = sortrows(reaction_time);
            RT_bin = ones(length(reaction_time), 1);
            RT_bin(I(floor(length(I)/2)+1:end)) = 0;
            
            % participant, group, sex, coherence, confidence, accuracy,
            % reaction time, RT bin
            behaviour_mat = [behaviour_mat; ones(size(results.output, 1), 1)*p, ones(size(results.output, 1), 1)*2, ones(size(results.output, 1), 1)*sex,...
               results.output(:, 1).*100, ...
               results.confidence', results.correct', results.RT', RT_bin];

        end
    end
end

%% discard impulsive responses with reaction time < 100 ms

% find(behaviour_mat(:, 7)<.100)

behaviour_mat(behaviour_mat(:, 7)<.100, 5:8) = NaN;



%% TABLE

table_reactiontime = array2table(behaviour_mat);
table_reactiontime.Properties.VariableNames = {'Participant', 'Group', 'Sex', 'Coherence', 'Confidence', 'Accuracy', 'ReactionTime', 'RT_bin'};

filename = 'table_reactiontime_MR_withoutexcluded.xlsx';

writetable(table_reactiontime,filename)