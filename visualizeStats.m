
%visualizeStats(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\TDT Historical MV Cable Data.xlsx"));
%visualizeStats(getReportStats("C:\Users\KONGB\Downloads\TDT Historical MV Cable Data-duplicateNew.xlsx","\\atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\STPData.mat"));
%visualizeStats(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"));
%visualizeStats(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data - RevSB.xlsx"));

%visualizeStats(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data - FOR TESTING.xlsx"));

%parameters
%'stats' is a double matrix of stats data from 'getReportStats' function
%'file_path' is file path of excel file.
function [numPDTestcount] = visualizeStats(stats)
    clc;

    %****************************************%
    %Test Dates
    %
%     figure(1)
%     produceBarGraph_fromStatsFunction(stats,1,"Distribution of Tests Done Per Year","Year",1);

    %****************************************%
    %Rated/Operating Voltages
    %
    
%     figure(2)
%     produceBarGraph_fromStatsFunction(stats,2,"Rated Voltages Per Cable","Rated Voltage (kV)",1);
%     figure(3)
%     produceBarGraph_fromStatsFunction(stats,3,"Operating Voltages Per Cable","Operating Voltage (kV)",1);

    %****************************************%
    %Time Duration of Hi-Pot

%     figure(4)
%     produceBarGraph_fromStatsFunction(stats,13,"AC Hi-Pot Test Duration","Time (Minutes)",1);

    %****************************************%
    %Hi-Pot Withstand Test Results (Pass/Fail)
    %

    title7="Hi-Pot Withstand Test Results";

    hold on;
    figure(5)
    produceBarGraph_fromStatsFunction(stats,7,title7,"Results",1);
    set(gca, 'XTickLabel',["Pass","Fail"]);
    hold off;
    savefig(title7);
    
    %****************************************%
    %Insulation
%     figure(6)
%     produceBarGraph_fromStatsFunction(stats,10,"Cable Insulations","Insulation Type",2);

    %****************************************%
    %Testing Type
%     figure(7)
%     produceBarGraph_fromStatsFunction(stats,11,"Testing Type","Type",2);

    %****************************************%
    %Looped AC Hi-Pot Withstand Voltage, PD Acceptance Voltage, and PDIV
    %and PDEV Values Graphing/Plotting

    figureCounter=8;
    min=0;
    column=-1;
    
    %testType controls what type of tests to check for
    testType={["Commissioning","Maintenance","Post-Repair"],["Maintenance","Post-Repair"],["Commissioning"]};
    testTypeText={["All Test Types"],["Maintenance and Post-Repair"],["Commisioning"]};
    ratedVoltages=["5","8","15","28","35","46"];
    operatingVoltages=["4.16","6.6","13.8","27.6","34.5","44"];

    %ac hipot voltages that withstandRatios occur at
    commonVolts={[0],[0],[19],[40],[0],[60],...
        [9],[13],[15,19,26],[29,40,42],[0],[60]...
        [0],[0],[13.8],[33],[0],[0]};

    %withstand ratios for ac hipots. first row is 1 min, second row is 5
    %min, third row is 15 min. values of 0 means no common ratio.
    withstandRatios={[0],[0],[2.38],[2.51],[0],[2.36],...
        [3.75],[3.41],[1.88,2.38,3.26],[1.82,2.51,2.64],[0],[2.36]...
        [0],[0],[1.73],[2.08],[0],[0]};

    % first row is common six PDIV ratio values @ 1 minute, then six PDEV ratio values @ 5 mins.
    % second row is six common PD acceptance voltages ratio for PDEV's @ 1
    % minute, then six values @ 5 mins.
%     pdIVEVRatios={[0],[0],[0],[1.63,1.88],[0],[0],[3.75],[3.41],[1.88,2.38],[1.63,2.64],[0],[1.65]...
%         [0],[0],[0],[1.32,1.63],[0],[0],[3.75],[3.41],[1.63,1.88,2.39],[1.63],[0],[1.57]};

    %pdIVEVRatios={[1,3.75],[1,3.41],[1,1.63,1.88,2.39,3.26],[1,1.63,2.64],[1,1.31,1.57],[1,1.57]};
    pdIVEVRatios={[1,2.91,3.75],[1,2.62,3.41],[1,1.88,2.38],[1,1.88,2.51],[1,1.31,1.57],[1,1.81,2.36]};

    %specificRatios{1,6}

    %ratioCounter keeps track of which graph youre on (1 through 24)
    ratioCounter=0;

    %keeps track which ratio/voltage ur on for ac hipot
    achipotCounter=0;

    %keeps track of which marix youre on produced from bargraph func
    matrixCounter=0;
    groupMatrix={};
    %6 operating cables by 3 test typings 
    numPDTestcount=zeros(6,3);

    %keeps track of all 3 type totalcounts
    totalCount=[0 0 0];

    columnNames={'Rated Voltage' 'Operating Voltage' 'Test Duration'...
        'AC Hi-Pot/Withstand Voltage (kV)' 'AC Hi-Pot/Withstand Voltage (xUo)'...
        '# of Occurences in Dataset (for specific combo)'...
        'Percentage of Total Occurences in Dataset (for specific combo)'...
        '# of Failures under Test (of Total)' 'Percentage of failures under Test (of Total)'};

    directory='\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\MATLAB Scripts\Brandon''s MATLAB Functions\Tables';

    %i values go from 1 to 8, representing the four metrics (withstand voltage, 
    % pd voltage, PDIV, PDEV) and grabbing graphs 
    % at 1 and 5 mins each (4 metrics x 2 time durations = 8)
%     for i=1:8
%         %k values loops from 1 to 6, representing the 6 operating voltage
%         %class indexes
%         for k=1:6
%             if i<=2
%                 titleString="AC Hi-Pot Withstand Voltage ";
%                 valueString="Withstand Voltage";
%                 column=4;
%             elseif i<=4
%                 titleString="PD Test Acceptance Voltage ";
%                 valueString="PD Acceptance Voltage";
%                 column=6;
%             elseif i<=6
%                 titleString="PDIV for ";
%                 valueString="PDIV for ";
%                 column=8;
%                 ratioCounter=ratioCounter+1;
%             else
%                 titleString="PDEV for ";
%                 valueString="PDEV for ";
%                 column=9;
%                 ratioCounter=ratioCounter+1;
%             end
%             if rem(i,2)==0
%                 min=5;
%             else
%                 min=1;
%             end
%             figure(figureCounter)
%             if i<=4
%                 produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,column,min),k,...
%                     titleString + operatingVoltages(k)+ "kV Cables @ " + string(min)+" Minutes",valueString+"/Uo",1);
%             else
%                 %specificRatios{ratioCounter}
%                 produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,column,min),k,...
%                     titleString + operatingVoltages(k) +"kV Cables @ " + string(min)+" Minutes",specificRatios{ratioCounter});
%             end
%             close(figure(figureCounter))
%             figureCounter=figureCounter+1;
%         end
%     end
    
    %BELOW LOOP IS FOR ONLY AC HIPOT and PDIV GRAPHS
    %1-3 values for @ 1 and 5 mins for achipot, 4 value for all mins pdiv
    for i=1:4
        %k values loops from 1 to 6, representing the 6 operating voltage
        %class indexes
        for k=1:6
            %j value loops from 1 to 3, representing the 3 tables for all
            %tests, maintenance+postrepair, and commissioning
            for j=1:3
                if i<=3
                    titleString="AC Hi-Pot Withstand Voltage ";
                    valueString="Withstand Voltage";
                    column=4;
                    matrixCounter=matrixCounter+1;
                    %only change achipot ratio and other values when done
                    %looping through all 3 test type combos
                    if j==1
                        achipotCounter=achipotCounter+1;
                    end
                elseif i<=4
                    titleString="PDIV for ";
                    valueString="PDIV for ";
                    column=8;
                    if j==1
                        ratioCounter=ratioCounter+1;
                    end
                end
                if rem(i,3)==0
                    min=15;
                elseif rem(i,3)==2
                    min=5;
                else
                    min=1;
                end
                figure(figureCounter)
                if i<=3
%                     %make sure to update this call with the specificRatios
%                     [ratioStats,failStats,totalCount(j)] = produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,column,testType{j},min),k,...
%                         titleString + testTypeText{j} + ' ' +operatingVoltages(k)+ "kV Cables @ " + string(min)+" Minutes",valueString+"/Uo",...
%                         1,withstandRatios{achipotCounter});
%                     %mm=failStats{size(failStats),2}
%                     outputMatrix{matrixCounter} = tableWriterAndExporter(ratedVoltages(k),operatingVoltages(k),min,...
%                         commonVolts{achipotCounter},withstandRatios{achipotCounter},ratioStats,failStats);
%                     %j==3 is if done all 3 test type groups for that
%                     %operating voltage and test duration
%                     if j==3
%                         %groupCounter keeps track of which outputMatrix is
%                         %being added to groupMatrix;
%                         groupCounter=[2 1 0];
%                         for m=1:3
%                             emptyMatrix=strings(2,size(outputMatrix{m},2));
%                             emptyMatrix(1,1)=testTypeText{m};
%                             emptyMatrix(1,6)=string(totalCount(m));
%                             emptyMatrix(1,7)='100%';
%                             %groupMatrix holds the 3 matrices for the 3 test type groups
%                             groupMatrix=[groupMatrix;outputMatrix{matrixCounter-groupCounter(m)};emptyMatrix];
%                             metricTable=array2table(groupMatrix,'VariableNames',columnNames);
%                         end
%                         writetable(metricTable,fullfile(directory,...
%                         strrep(titleString +operatingVoltages(k)...
%                         + "kV Cables @ " + string(min)+" Minutes",'.','_')+'.xlsx'));
%                         groupMatrix={};
%                     end
                else
                    numPDTestcount(k,j)=produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,column,testType{j}),k,...
                        titleString + testTypeText{j}+' '+ operatingVoltages(k) +"kV Cables",pdIVEVRatios{ratioCounter});
                end
                close(figure(figureCounter))
                figureCounter=figureCounter+1;
            end
        end
    end
    text='Number of PD Tests Conducted: '+string(numPDTestcount)

%     %latest 15 min achipot calls below
%     achipotCounter2=0;
%     matrixCounter2=0;
%     %i=3 and 4 is 13.8 and 27.6 voltage indexes
%     for i=3:4
%         matrixCounter2=matrixCounter2+1;
%         titleString="AC Hi-Pot Withstand Voltage ";
%         %k=1:3 for the three test types
%         for k=1:3
%             if k==1
%                 achipotCounter2=achipotCounter2+1;
%             end
%             figure(figureCounter)
%             figureCounter=figureCounter+1;
%             [ratioStats,failStats,totalCount(k)] = produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,4,testType{k},16),i,...
%                     titleString + testTypeText{k} + ' ' +operatingVoltages(i)+ "kV Cables @ 15 Minutes","Withstand Voltage/Uo",...
%                     1,withstandRatios{achipotCounter});
% 
%             outputMatrix{matrixCounter2} = tableWriterAndExporter(ratedVoltages(i),operatingVoltages(i),15,...
%                 commonVolts{achipotCounter},withstandRatios{achipotCounter},ratioStats,failStats);
%             if k==3
%                 %groupCounter keeps track of which outputMatrix is
%                 %being added to groupMatrix;
%                 groupCounter=[2 1 0];
%                 for m=1:3
%                     emptyMatrix=strings(2,size(outputMatrix{m},2));
%                     emptyMatrix(1,1)=testTypeText{m};
%                     emptyMatrix(1,6)=string(totalCount(m));
%                     emptyMatrix(1,7)='100%';
%                     %groupMatrix holds the 3 matrices for the 3 test type groups
%                     groupMatrix=[groupMatrix;outputMatrix{matrixCounter2-groupCounter(m)};emptyMatrix];
%                     metricTable=array2table(groupMatrix,'VariableNames',columnNames);
%                 end
%                 writetable(metricTable,fullfile(directory,...
%                 strrep(titleString +operatingVoltages(k)...
%                 + "kV Cables @ 15 Minutes",'.','_')+'.xlsx'));
%                 groupMatrix={};
%             end
%             close(figure(figureCounter))
%         end
%     end

    %15 min ac-hipot calls below
%     figure(100)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,4,15),3,...
%                     "AC Hi-Pot Withstand Voltage " + operatingVoltages(3)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     close all
%     figure(101)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,6,15),3,...
%                     "PD Test Acceptance Voltage " + operatingVoltages(3)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     figure(102)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,8,15),3,...
%                      "PDIV for " + operatingVoltages(3) +"kV Cables @ " +"15 Minutes",[0]);
%     figure(103)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,9,15),3,...
%                      "PDEV for " + operatingVoltages(3) +"kV Cables @ " +"15 Minutes",[0]);
%     close all
%     
%     figure(104)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,4,15),4,...
%                     "AC Hi-Pot Withstand Voltage " + operatingVoltages(4)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     figure(105)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,6,15),4,...
%                     "PD Test Acceptance Voltage " + operatingVoltages(4)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     figure(106)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,8,15),4,...
%                      "PDIV for " + operatingVoltages(4) +"kV Cables @ " +"15 Minutes",[0]);
%     figure(107)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,9,15),4,...
%                      "PDEV for " + operatingVoltages(4) +"kV Cables @ " +"15 Minutes",[0]);
%     close all
% 
%     figure(108)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,4,15),6,...
%                     "AC Hi-Pot Withstand Voltage " + operatingVoltages(6)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     figure(109)
%     produceBarGraph_fromStatsFunction(operatingVoltageSorter(stats,6,15),6,...
%                     "PD Test Acceptance Voltage " + operatingVoltages(6)+ "kV Cables @ " + "15 Minutes","Withstand Voltage/Uo",1);
%     figure(110)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,8,15),6,...
%                      "PDIV for " + operatingVoltages(6) +"kV Cables @ " +"15 Minutes",[0]);
%     figure(111)
%     produceScatterPlot_fromStatsFunction(operatingVoltageSorter(stats,9,15),6,...
%                      "PDEV for " + operatingVoltages(6) +"kV Cables @ " +"15 Minutes",[0]);

    close all
    
    finished="Finished Visualizing"
    graphs=stats;
end