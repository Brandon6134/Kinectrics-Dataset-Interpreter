
%produceScatterPlot_fromStatsFunction(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\TDT Historical MV Cable Data.xlsx"),8,"PDIV");
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),9,5),3,"PDEV for 13.8kV Cables @ 5 Minutes");
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),8,5),3,"PDIV for 13.8kV Cables @ 5 Minutes",[1.88,2.38]);
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),9,5),3,"PDEV for 13.8kV Cables @ 5 Minutes",[1.88,2.38]);
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),9,5),3,"PDEV for 13.8kV Cables @ 5 Minutes",specificRatios2{1,6});
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),8),5,"PDIV for 34.5kV Cables",[0]);
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data - RevSB.xlsx"),8),4,"TEST PDIV for 27.6kV Cables",[1,1.88,2.51]);
%produceScatterPlot_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data - RevSB.xlsx"),8),6,"TEST PDIV for 44kV Cables",[2.05,2.60]);


%function produces a scatterplot, with metric values divided by the
%operating voltage acting as values in the x axis. all of the datapoints
%are put onto a 0-100th percentile on the y-axis

%parameters
%stats: input of the getReportStats.m file with target file
%stats_index: index number (column wise) of the stat wanted to produce a bar graph of
%metricName: string value of the metric's name is (used for plot axis titles)
%values is an array of value of benchmarks of common ratios
function [totalTests] = produceScatterPlot_fromStatsFunction(stats,index,metricName,values)
    
    ax1 = gca;
    ax1.Box = 'off';
    ax2 = axes(gcf);
    ax2.XAxisLocation = 'top';
    ax2.YAxisLocation = 'right';
    ax2.Color = 'none';
    ax2.Box = 'off';
    hold(ax2,'on')
    metric=str2double(stats(1:size(stats,1),index));
    %removed=zeros((size(metric,1)),1);
    removedCounter=0;

%     for i=1:size(metric,1)
%         %removes values with greaterThanFlags for PDIV calls
%         if strcmp(stats(i,7),"1") && contains(metricName,"PDIV") && ~isnan(metric(i))
%            %removed(i)=metric(i);
%            metric(i)=NaN;
%            removedCounter=removedCounter+1;
%         end
%     end

    %Removes any NaN values
    metric=rmmissing(metric);
    totalTests=size(metric,1);

    %orders from least to greatest values
    metric=sort(metric);
    
    metric_yaxis=linspace(0,100,size(metric,1));

    %create scatter plot
    scatter(ax1,metric(1:size(metric,1)),metric_yaxis,'.')

    %takeLastValueOccurence is a boolean that is true if a specified
    %operating voltage is being plotted, so that it can have the last value
    %of its occurence have a line plotted at it
    takeLastValueOccurence=false;
    if contains(metricName,'13.8') || contains(metricName,'27.6')
        takeLastValueOccurence=true;
    end

    %holds value first occurence index and percentage values
    valueFirstOccurenceIndex=zeros(size(values,2),1);
    valueFirstOccurencePercent=zeros(size(values,2),1);
    
    %holds last occurence index and percentage values
    valueLastOccurenceIndex=zeros(size(values,2),1);
    valueLastOccurencePercent=zeros(size(values,2),1);
    allOccurenceIndex=[];
    for i=1:size(values,2)
        %gets the first index of when the value is found in metric. if
        %value not found, doesnt save. if value is 1, then only checks if
        %rounded to first decimal matches (since value of 1 doesnt always
        %exist in data)
        if ~isempty(find(round(metric,2)==round(values(i),2),1))
            valueFirstOccurenceIndex(i)=find(round(metric,2)==round(values(i),2),1);
            valueFirstOccurencePercent(i)=(valueFirstOccurenceIndex(i)/totalTests)*100;
        elseif ~isempty(find(round(metric,1)==round(values(i),1),1)) && values(i)==1
            valueFirstOccurenceIndex(i)=find(round(metric,1)==round(values(i),1),1);
            valueFirstOccurencePercent(i)=(valueFirstOccurenceIndex(i)/totalTests)*100;
        end

        %if want to make line at last value and value isnt 1

        if ~isempty(find(round(metric,2)==round(values(i),2))) && takeLastValueOccurence && values(i)~=1
            allOccurenceIndex=find(round(metric,2)==round(values(i),2));
            valueLastOccurenceIndex(i)=allOccurenceIndex(size(allOccurenceIndex,1));
            valueLastOccurencePercent(i)=(valueLastOccurenceIndex(i)/totalTests)*100;
        end
    end

    %valueCount holds a matrix of counts, that counts the number of metric
    %values lower,higher, or equal to the specified/inputted values in
    %parameters.
    %Column 1: # that matches value
    %Column 2: # that is below value
    %Column 2: # that is above value
    %Row 1 is for first specific value, row 2 is for 2nd specific value,etc.
    %valueCount=zeros(size(values,2),3);

%     for i=1:size(metric,1)
%         for k=1:size(values,2)
%             %rounds the metric value and specific value to 2 decmials and
%             %checks for same value
%             if round(metric(i),2)==round(values(k),2)
%                 valueCount(k,1)=valueCount(k,1)+1;
%             elseif metric(i)<values(k)
%                 valueCount(k,2)=valueCount(k,2)+1;
%             elseif metric(i)>values(k)
%                 valueCount(k,3)=valueCount(k,3)+1;
%             end
%         end
%     end

    %creates a matrix with rows for lower than first number in 'values',
    %equal to first number in 'values', greater than the first number but
    %lower than the second number in 'values', etc. until last number.
%     valueCount=zeros(size(values,2)*2+1,1);
% 
%     for i=1:size(metric,1)
%         for k=1:size(valueCount,1)
%             %rounds the metric value and specific value to 2 decmials and
%             %checks for same value
%             if round(metric(i),2)<round(values(k),2)
%                 valueCount(k,1)=valueCount(k,1)+1;
%             elseif metric(i)<values(k)
%                 valueCount(k,2)=valueCount(k,2)+1;
%             elseif metric(i)>values(k)
%                 valueCount(k,3)=valueCount(k,3)+1;
%             end
%         end
%     end
%     
%     valueCount;
    
    %valuePercentages is same as valueCount but converts to percentages
%     valuePercentages=zeros(size(values,2),3);
%     for i=1:size(valuePercentages,1)
%         for k=1:3
%             valuePercentages(i,k)=(valueCount(i,k)/totalTests)*100;
%         end
%     end
%     removedPercentage=(removedCounter/totalTests)*100;
% %     valuePercentages;
% 
%     %size of 4 because need a 'removed' as last column
%     displayMatrix=strings(size(values,2),4);
%     for i=1:size(displayMatrix,1)
%         %k is up till 3 because of 3 columns matches, below, above.
%         for k=1:3
%             displayMatrix(i,k)= string(valuePercentages(i,k))+"% ("+string(valueCount(i,k))+")";
%         end
%     end
%     displayMatrix(:,4)=string(removedCounter)+' tests';
%     
%     columnNames={'Matches' 'Below' 'Above' 'Removed'};
%     rowNames=arrayfun(@num2str,values,'un',0);
%     metricTable=array2table(displayMatrix,'VariableNames',columnNames,'RowNames',rowNames);

    %totalCount=['# of Total Tests: '+string(totalCounter) '# of Removed Tests: '+string(totalCounter) '# of Tests After Removing']

    hold(ax1,'on');    
    graphTitle=title(ax2,string(metricName)+ ' Cumulative Distribution');
    xlabel(ax1,string(metricName)+'/Uo')
    ylabel(ax1,'Percentile')
    xAxisMax = get(ax1, 'XLim');

    % Fix the positions of the axes
    ax1.Units = 'pixels';
    ax2.Units = 'pixels';
    ax1.Position = ax2.Position;
    YTicksLeft=[0:20:100];
    YTicksRight=[];
    YTicksRight2=[];
    for i=1:size(values,2)
        plot(ax2,[values(i) values(i)],[0,100],'LineStyle','--','color','k','Marker','none')
        plot(ax2,[xAxisMax(2) values(i)],[valueFirstOccurencePercent(i),valueFirstOccurencePercent(i)],'LineStyle','--','color','k','Marker','none')
        %if want to draw line at last occurence, draw.
        if takeLastValueOccurence && values(i)~=1
            plot(ax2,[xAxisMax(2) values(i)],[valueLastOccurencePercent(i),valueLastOccurencePercent(i)],'LineStyle','--','color','k','Marker','none')
            YTicksRight2=[YTicksRight2,valueLastOccurencePercent(i)];
        end
        YTicksRight=[YTicksRight,valueFirstOccurencePercent(i)];
    end
    YTicksRight=[YTicksRight,YTicksRight2];
    set(ax1,'YTick',YTicksLeft);
    
    ax2.XLim = ax1.XLim;

    %removes any duplicate YTick values (like 0) and sorts them in order
    plot(0,[0 100])
    YTicksRight=sort(unique(YTicksRight));    
    ax2.YTick = YTicksRight;
    ax2.YTickLabels = cellfun(@(x) num2str(x),num2cell(round(YTicksRight)),'uniformOutput',0)';

    ax2.YLim = [0 100];

    % Set the XTick Labels
    ax2.XTick = values;
   

    grid(ax1,'on');
%     hold off;

    graphTitle=strrep(string(metricName),'.','_')+ ' Cumulative Distribution';
    savefig(strrep(string(metricName),'.','_')+ ' Cumulative Distribution');
    fig=gcf;
    print(fig,graphTitle+'.png','-r0','-dpng');

%     directory='\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\MATLAB Scripts\Brandon''s MATLAB Functions\Tables';
%     writetable(metricTable,fullfile(directory,strrep(graphTitle,'.','_')+'.xlsx'),'WriteRowNames',true);

    nothing="";
end