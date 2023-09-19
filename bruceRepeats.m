%bruceRepeats("C:\Users\KONGB\Downloads\bruce comparing.xlsx",1,2);

function [repeats] = bruceRepeats(file,columnA,columnB)
    clc;
    [num,text,raw]=xlsread(file);

    BA_init=string(text(1:size(text,1),1));
    BB_init=string(text(1:size(text,1),2));
    BA=unique(rmmissing(BA_init));
    BB=unique(rmmissing(BB_init));

    counter=1;
    for i=1:size(BA,1)
        for k=1:size(BB,1)
            if strcmp(BA(i),BB(k))
                repeats(counter,1)=BA(i);
                counter=counter+1;
            end
        end
    end
        

%     %rmmissing removes NaN values and unique removes duplicate entries plus
%     %organizes the data from least to greatest
%     metric=unique(rmmissing(stats(1:size(stats,1),stats_index)));
% 
%     %below line removes any blanks
%     metric=metric(metric~="");
%     metric_counter=zeros(1,size(metric,1));
    text="Function ran successfully"
end