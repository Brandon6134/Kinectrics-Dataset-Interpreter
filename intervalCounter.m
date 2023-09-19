
%creates a matrix with rows for lower than first number in 'values',
%equal to first number in 'values', greater than the first number but
%lower than the second number in 'values', etc. until last number.

%parameters
%metric is an array of values that will have all of its values compared to
%benchValues to see which are greater, equal, or below
%benchValues is an array of numbers which are benchmarks for the metrics data
%passFlags are the flags if the test passed or not. 1=pass 2=fail.
function [counters,failCounters] = intervalCounter(metric,benchValues,passFlags)
    %first value in counter is for equal to 0, so remove/ignore later
    counters=zeros(size(benchValues,2)*2+1,1);
    failCounters=zeros(size(benchValues,2)*2+1,1);
    numCount=1;
    benchCounter=1;

    for i=1:size(metric,1)
        for j=1:size(benchValues,2)*2+1
            if j==1
                if round(metric(i),2)<round(benchValues(benchCounter),2)
                    counters(j)=counters(j)+1;
                    if passFlags(i)==2
                        failCounters(j)=failCounters(j)+1;
                    end
                end
            elseif j==size(benchValues,2)*2+1
                if round(metric(i),2)>round(benchValues(benchCounter),2)
                    counters(j)=counters(j)+1;
                    if passFlags(i)==2
                        failCounters(j)=failCounters(j)+1;
                    end
                end
            elseif rem(j,2)==0
                if round(metric(i),2)==round(benchValues(benchCounter),2)
                    counters(j)=counters(j)+1;
                    if passFlags(i)==2
                        failCounters(j)=failCounters(j)+1;
                    end
                end
            elseif rem(j,2)==1
                if round(metric(i),2)>round(benchValues(benchCounter),2) && round(metric(i),2)<round(benchValues(benchCounter+1),2)
                    counters(j)=counters(j)+1;
                    if passFlags(i)==2
                        failCounters(j)=failCounters(j)+1;
                    end
                end
                benchCounter=benchCounter+1;
            end
        end
        benchCounter=1;
    end
end

