
% PARAMETERS
% ===========
%     stats: matrix from the getReportStats function
%         
%     ratedVolts: the desired rated voltage
%     
%     opVolts: the desired operating voltage
%     
%     time: time duration of hi-pot
% 
%     commonVolts: array of corresponding common volts 
% 
%     commonratios: array of corresponding common ratios. must be same 
%     dimension size as commonVolts
% 
%     occurences: array of pairs of data; each pair has a percentage and a
%     # telling the # of tests for that set of data each section for 
%     commonratio occured at.
% 
%     fails: array of pairs of data, has percentage and # of tests that
%     failed in that set of data for each section for common ratio occured
%     at
% 
%     standard: string of the standard used each of the sections
% 

function [finalMatrix] = tableWriterAndExporter(ratedVolts,opVolts,time,commonVolts,commonRatios,occurences,fails)
    fails{size(occurences,2)}
    ratedVoltsColumn=str2double(ratedVolts)*ones(size(occurences,2),1);
    opVoltsColumn=str2double(opVolts)*ones(size(occurences,2),1);
    timeColumn=time*ones(size(occurences,2),1);

    commonVoltsColumn=strings(size(occurences,2),1);
    commonRatiosColumn=strings(size(occurences,2),1);
    counter=1;
    for i=1:size(occurences,2)
        if i==1
            commonVolts(counter)
            commonVoltsColumn(i)='<'+string(commonVolts(counter));
            commonRatiosColumn(i)='<'+string(commonRatios(counter));
        elseif i==size(occurences,2)
            commonVoltsColumn(i)='>'+string(commonVolts(counter));
            commonRatiosColumn(i)='>'+string(commonRatios(counter));
        elseif rem(i,2)==0
            commonVoltsColumn(i)=string(commonVolts(counter));
            commonRatiosColumn(i)=string(commonRatios(counter));
        elseif rem(i,2)==1
            commonVoltsColumn(i)='>'+string(commonVolts(counter))+' and <'+string(commonVolts(counter+1));
            commonRatiosColumn(i)='>'+string(commonRatios(counter))+' and <'+string(commonRatios(counter+1));
            counter=counter+1;
        end
    end

    numOccurencesColumn=zeros(size(occurences,2),1);
    percentOccurencesColumn=strings(size(occurences,2),1);
    numFailsColumn=zeros(size(occurences,2),1);
    percentFailsColumn=strings(size(occurences,2),1);

    %number of tests is first value in pair, percent is second value in pair
    for i=1:size(occurences,2)
        numOccurencesColumn(i)=occurences{i}{1};
        percentOccurencesColumn(i)=string(occurences{i}{2})+'%';
        numFailsColumn(i)=fails{i}{1};
        percentFailsColumn(i)=string(fails{i}{2})+'%';
    end

    finalMatrix=[ratedVoltsColumn opVoltsColumn timeColumn...
        commonVoltsColumn commonRatiosColumn numOccurencesColumn percentOccurencesColumn numFailsColumn percentFailsColumn];

%     columnNames={'Matches' 'Below' 'Above' 'Removed'};
%     rowNames=arrayfun(@num2str,values,'un',0);
%     metricTable=array2table(displayMatrix,'VariableNames',columnNames,'RowNames',rowNames);


end
