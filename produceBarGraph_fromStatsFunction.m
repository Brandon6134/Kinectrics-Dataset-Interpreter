%produceBarGraph_fromStatsFunction(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\TDT Historical MV Cable Data.xlsx"),1)
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,5),3,"achipot withstand 13.8kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[1.88,3.26,3.77])
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,5),3,"achipot withstand 13.8kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[2.38])
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,1),3,"achipot withstand 13.8kV Cables @ 1 Minutes","Withstand Voltage/Uo",1,[2.38]);
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,5),4,"achipot withstand 27.8kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[1.82,2.51,2.64]);
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,5,["Maintenance"]),2,"achipot withstand maintenance+post 6.6kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[3.41]);
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,5),2,"achipot withstand maintenance+post 6.6kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[3.41]);
%produceBarGraph_fromStatsFunction(operatingVoltageSorter(getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx"),4,["Maintenance","Post-Repair","Commissioning"],5),4,"achipot withstand maintenance+post 27.6kV Cables @ 5 Minutes","Withstand Voltage/Uo",1,[1.82,2.51,2.64]);

%function finds unique entries, and counts how many values occur for each
%unique entry. Then produces bar graph off these.

%parameters
%stats: input of the getReportStats.m function call with target file
%stats_index: index number (column wise) of the stat wanted to produce a
%bar graph of (this is the index of the stats matrix returned from
%getReportStats.m, not the xlsx file)
%graphTitle and xaxisTitle are names of respective titles of graph
%type is type of data being graphed. value of 1 is for numbers, 2 is for
%strings

%OPTIONAL parameters
%ratios is an array that holds the numbers (ratios) desired for table

%returns
%ratioStats is an array of arrays, and each array contains a pair of data;
%the first value is # of tests and second value is percentage of tests that
%correspond with that ratio's 'section'. for more explanation see
%intervalCounter.m 
function [ratioStats,failStats,totalCount] = produceBarGraph_fromStatsFunction(stats,stats_index,graphTitle,xaxisTitle,type,ratios)
    
    %if dealing with number data type, do conversions. this is so that when
    %doing rmmissing it sorts by least to greatest number (if string, sorts
    %differently)
    if type==1
        stats=str2double(stats);
    end

    %rmmissing removes NaN values and unique removes duplicate entries plus
    %organizes the data from least to greatest
    metric=unique(rmmissing(stats(1:size(stats,1),stats_index)));

    if type==1
        stats=string(stats);
        metric=string(metric);
    end

    %below line removes any blanks
    metric=metric(metric~="");
    metric_counter=zeros(1,size(metric,1));

    %counts how many cable tests correspond to each unique metric value, and
    %counts how many of each metric occur using a matrix of counters
    for i=1:size(metric,1)
        for k=1:size(stats,1)
            if metric(i)==stats(k,stats_index)
                metric_counter(i)=metric_counter(i)+1;
            end
        end
    end

    %totalCount holds total number of tests
    totalCount=0;
    for i=1:size(metric_counter,2)
        totalCount=metric_counter(i)+totalCount;
    end

    %ratioStats=[];
    %if was given ratios
    if nargin > 5
        [ratioCounters,failCounters]=intervalCounter(str2double(stats(:,stats_index)),ratios,str2double(stats(:,8)));
        ratioPercents=zeros(size(ratioCounters,1),1);
        failPercents=zeros(size(ratioCounters,1),1);
        for i=1:size(ratioCounters,1)
            ratioPercents(i)=round((ratioCounters(i)/totalCount)*100,1);
            failPercents(i)=round((failCounters(i)/totalCount)*100,1);
            ratioStats{i}={ratioCounters(i) ratioPercents(i)};
            failStats{i}={failCounters(i) failPercents(i)};
        end
        jj=graphTitle
        fialll=failCounters
    else
        ratioStats=[];
        failStats=[];
    end
    %ratioStats{2}(1)

    hold on;
    graph=bar(metric_counter);
    set(gca, 'XTickLabel',metric);
    set(gca, 'XTick',1:size(metric,1));%unless you specify x-values in plot and bar
    t=title(string(graphTitle));
    set(t,'position',get(t,'position')+[0 1 0]);
    xlabel(string(xaxisTitle))
    ylabel('# of Tests')
    text(graph.XEndPoints,graph.YEndPoints,string(graph.YData),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',9);
    hold off;

    %saving plot as fig
    savefig(strrep(graphTitle,'.','_'));
    fig=gcf;
    print(fig,strrep(graphTitle,'.','_')+'.png','-r0','-dpng');

%     metricTable=table(metric,metric_counter','VariableNames',[graphTitle 'Number of Occurences']);
% 
%     directory='\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\MATLAB Scripts\Brandon''s MATLAB Functions\Tables';
%     writetable(metricTable,fullfile(directory,strrep(graphTitle,'.','_')+'.xlsx'));

    %--------------------------------------------%


    %unique_entries=metric;
    %counters=metric_counter;
    %counters=ratioCounters;
end