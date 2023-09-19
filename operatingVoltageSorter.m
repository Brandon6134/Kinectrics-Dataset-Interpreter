%operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4);
%operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),6,15);

%operatingVoltageSorter takes the desired data and sorts them by
%operating voltage and divides by Uo, then outputs a matrix that is sorted. e.g. column 1 of
%the matrix has data only from 4.16kV operating voltage cables @ 5 mins. column 1
%has NaN values for tests for other operating cables, wrong # of mins, or no test was done.
%desired data is withstand voltage, PD voltage, PDIV and PDEV.

%Breakdown of matrix 'sortedData'
%Column 1: Values for OV(operating voltage) of 4.16kV
%Column 2: Values for OV of 6.6kV
%Column 3: Values for OV of 13.8kV
%Column 4: Values for OV of 27.6kV
%Column 5: Values for OV of 34.5kV
%Column 6: Values for OV of 44kV
%Column 7: greaterThanFlag

%--------------------------
%MANDATORY PARAMETERS
%Stats is the output from the 'getReportStats.m' function
%Index is the column # that the desired data is placed in the matrix stats 
% (e.g. value of 4 for withstand volts)
%--------------------------

%--------------------------
%OPTIONAL PARAMETERS
%'types' is a string array that contains the desired types of test
%(commissioning,maintenence,post-repair)
%'minutes' is the number of minutes the desired test is done at (should be 1 or
%5 minutes entered). 
%--------------------------

function [sortedData] = operatingVoltageSorter(stats,index,types,minutes)
    %clc;
    operatingVolts=stats(1:size(stats,1),3);
    timeDuration=stats(1:size(stats,1),5);
    testType=stats(1:size(stats,1),11);
    targetData=stats(1:size(stats,1),index);
    greaterThanFlags=stats(1:size(stats,1),12);
    passFlags=stats(1:size(stats,1),7);

    %sortedData's columns 1 through 6 are the six operating voltages.
    %column 7 contains greaterThanFlags and column 8 contains passFlags.
    sortedData=strings(size(operatingVolts,1),8);

    %if minutes isn't entered, will not check for minutes by setting equal
    %to -1. if type of test isn't entered, will not check for type of test
    %by setting equal to specific string code of 'Z'.
    if nargin < 3
        types=['Z'];
        minutes=-1;
    elseif nargin < 4
        minutes=-1;
    end

    count=0;
    for i=1:size(operatingVolts,1)
        %loop through each value in the desired type of tests and check if
        %test matches. if finds matching minute and type of test, break out
        %of the 'for loop' below that loops through the desired test types.
        %if break isn't present, will only save the last desired type as it
        %will overwrite the other test type data with NaN.
        for k=1:size(types,2)
            %if # of minutes matches, then checks if operating voltage matches.
            %if minutes parameter wasnt given value, then doesn't check min.
            %same logic if types isn't given, doesnt check.
            if (str2double(timeDuration(i))==minutes || minutes==-1)...
                    && (strcmp(testType(i),types(k)) || strcmp(types(k),'Z'))
                if strcmp(operatingVolts(i),"4.16")
                    sortedData(i,1)=string(str2double(targetData(i))/(4.16/sqrt(3)));
                    %sets the value for place of 4.16kV, and all other OV as NaN
                    sortedData(i,2:6)=NaN;
                    break;
                elseif strcmp(operatingVolts(i),"6.6") || strcmp(operatingVolts(i),"6.3")
                    sortedData(i,2)=string(str2double(targetData(i))/(6.6/sqrt(3)));
                    sortedData(i,1)=NaN;
                    sortedData(i,3:6)=NaN;
                    break;
                elseif strcmp(operatingVolts(i),"13.8")
                    sortedData(i,3)=string(str2double(targetData(i))/(13.8/sqrt(3)));
                    sortedData(i,1:2)=NaN;
                    sortedData(i,4:6)=NaN;
                    break;
                elseif strcmp(operatingVolts(i),"27.6")
                    sortedData(i,4)=string(str2double(targetData(i))/(27.6/sqrt(3)));
                    sortedData(i,1:3)=NaN;
                    sortedData(i,5:6)=NaN;
                    break;
                elseif strcmp(operatingVolts(i),"34.5")
                    sortedData(i,5)=string(str2double(targetData(i))/(34.5/sqrt(3)));
                    sortedData(i,1:4)=NaN;
                    sortedData(i,6)=NaN;
                    break;
                elseif strcmp(operatingVolts(i),"44")
                    sortedData(i,6)=string(str2double(targetData(i))/(44/sqrt(3)));
                    sortedData(i,1:5)=NaN;
                    break;
                else
                    sortedData(i,1:6)=NaN;
                end
            %if # of mins doesn't match, then set values to NaN
            else
                sortedData(i,1:6)=NaN;
            end
            sortedData(i,7)=greaterThanFlags(i);
            sortedData(i,8)=passFlags(i);
        end
    end
    %finished="Volt Sorter Completed Running"
end