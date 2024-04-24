dot_coherence = [0.03 0.06 0.12 0.24 0.48];
correct = zeros(1,5);
confidence = zeros(1,5);
coherence = zeros(1,5);

for i = 1:30
    if results.output(i,1) == 0.03
        coherence(1,1) = coherence(1,1) + 1;
        %to correct percentage
        if results.output(i,4) == 1
            correct(1,1) = correct(1,1) + 1;
        elseif results.output(i,4) == 0
            correct(1,1) = correct(1,1);
        end
        %to confidence percentage
        if results.output(i,5) == 1
            confidence(1,1) = confidence(1,1) + 1;
        elseif results.output(i,5) == 0
            confidence(1,1) = confidence(1,1);
        end

    elseif results.output(i,1) == 0.06
        coherence(1,2) = coherence(1,2) + 1;
        %to correct percentage
        if results.output(i,4) == 1
            correct(1,2) = correct(1,2) + 1;
        elseif results.output(i,4) == 0
            correct(1,2) = correct(1,2);
        end
        %to confidence percentage
        if results.output(i,5) == 1
            confidence(1,2) = confidence(1,2) + 1;
        elseif results.output(i,5) == 0
            confidence(1,2) = confidence(1,2);
        end

    elseif results.output(i,1) == 0.12
        coherence(1,3) = coherence(1,3) + 1;
        %to correct percentage
        if results.output(i,4) == 1
            correct(1,3) = correct(1,3) + 1;
        elseif results.output(i,4) == 0
            correct(1,3) = correct(1,3);
        end
        %to confidence percentage
        if results.output(i,5) == 1
            confidence(1,3) = confidence(1,3) + 1;
        elseif results.output(i,5) == 0
            confidence(1,3) = confidence(1,3);
        end

    elseif results.output(i,1) == 0.24
        coherence(1,4) = coherence(1,4) + 1;
        %to correct percentage
        if results.output(i,4) == 1
            correct(1,4) = correct(1,4) + 1;
        elseif results.output(i,4) == 0
            correct(1,4) = correct(1,4);
        end
        %to confidence percentage
        if results.output(i,5) == 1
            confidence(1,4) = confidence(1,4) + 1;
        elseif results.output(i,5) == 0
            confidence(1,4) = confidence(1,4);
        end

    elseif results.output(i,1) == 0.48
        coherence(1,5) = coherence(1,5) + 1;
        %to correct percentage
        if results.output(i,4) == 1
            correct(1,5) = correct(1,5) + 1;
        elseif results.output(i,4) == 0
            correct(1,5) = correct(1,5);
        end
        %to confidence percentage
        if results.output(i,5) == 1
            confidence(1,5) = confidence(1,5) + 1;
        elseif results.output(i,5) == 0
            confidence(1,5) = confidence(1,5);
        end
    end
end

correct_perc = correct ./ coherence;
confidence_perc = confidence ./ coherence;

conf = [0 1];
confidence_level = zeros(1,2);
correct_level = zeros(1,2);

for i = 1:30
    %if confidence is low
    if results.output(i,5) == 0
        confidence_level(1,1) = confidence_level(1,1) + 1;
        if results.output(i,4) == 0
            correct_level(1,1) = correct_level(1,1);
        elseif results.output(i,4) == 1
            correct_level(1,1) = correct_level(1,1) + 1;
        end
    %if confidence is high
    elseif results.output(i,5) == 1
        confidence_level(1,2) = confidence_level(1,2) + 1;
        if results.output(i,4) == 0
            correct_level(1,2) = correct_level(1,2);
        elseif results.output(i,4) == 1
            correct_level(1,2) = correct_level(1,2) + 1;
        end
    end
end

correct_level_perc = correct_level ./ confidence_level;

figure(1)
subplot(3,1,1)
bar(dot_coherence,correct_perc,'red')
title("Percentage of correct responses for each coherences")
xlabel('coherence'); ylabel('% correct');

subplot(3,1,2)
bar(dot_coherence,confidence_perc,'blue')
title("Percentage of confidence for each coherences")
xlabel('coherence'); ylabel('% confidence');

subplot(3,1,3)
bar(conf,correct_level_perc)
title("Percentage of correct responses for each confidence level")
xlabel('confidence level'); ylabel('% correct');

export = gcf;
exportgraphics(export, "Data7.png");

 
