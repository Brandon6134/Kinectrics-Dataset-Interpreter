
%getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\TDT Historical MV Cable Data.xlsx");
%getReportStats("C:\Users\KONGB\Downloads\TDT Historical MV Cable Data-duplicateNew.xlsx","\\atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\STPData.mat");
%getReportStats("C:\Users\KONGB\Downloads\TDT Historical MV Cable Data-duplicateNew.xlsx");
%getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx");
%getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data.xlsx");

%getReportStats("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\NEW - Compiled TDT Historical MV Cable Data - FOR TESTING.xlsx");

%2/27/2023 note: implement a check for if hipot or PD tests are done, if
%yes for either then include in statistics (cause there r tests that say
%no for each (meaning no tests done) so should not count that test/cable
%toward statistics)

%parameters
%filepath is xlsx file kongbpath, matFilePath is the .mat filepath that it also
%takes data from

%outputs a double matrix 'results', which contains test stats of metrics:
%Column 1: Test Dates
%Column 2: Rated Voltage
%Column 3: Operating Voltage
%Column 4: Hi-Pot Withstand Voltage
%Column 5: Time Duration of Hi-Pot (Unfiltered, no AC-Hipot test check)
%Column 6: PD Test Acceptance Voltage
%Column 7: Hi-Pot Withstand Results (Pass/Fail/NA)
%Column 8: PDIV Values
%Column 9: PDEV Values
%Column 10: Insulation Type
%Column 11: Test Type
%Column 12: Flag for greater thans (contains '>') in PDIV, true or false
%Column 13: Time Durations (Filtered if AC-Hipot test was conducted or not)
%NaN Values mean test was missing the data or it wasn't tested/collected
function [results] = getReportStats(filepath,matFilePath)
    clc;
    [num,text,raw]=xlsread(filepath);
    %matData=load(matFilePath);

    %****************************************%
    %Test Dates
    %Contains NaN values where there are empty dates

    string_dates=string(text(3:size(text,1),8));
    %dates=dates(~cellfun('isempty',dates));%removes tests with no date

    for i=1:size(string_dates,1)
        if strlength(string_dates(i))~=0
            %below lines erase '.' and empty spaces. also checks for
            %brackets or 're-test' in the date then splits string as
            %neccessary. then extracts the year (last 4 characters of string)

            string_dates(i)=erase(string_dates(i),'.');
            string_dates(i)=strtrim(string_dates(i));
            if contains(string_dates(i),'(')
                jj=strsplit(string_dates(i),'(');
                jj=jj(1);
                string_dates(i)=strtrim(ww);
            elseif contains(string_dates(i),'re-test','IgnoreCase',true)
                ww=strsplit(string_dates(i),'r');
                ww=strsplit(string_dates(i),'R');
                ww=ww(1);
                string_dates(i)=strtrim(ww);
            end
            
            string_dates(i)=extractAfter(string_dates(i),strlength(string_dates(i))-4);
    
            %some dates are entered as e.g. '31-may-06', so below if statement
            %checks for this to take string on right hand side of '-' and
            %add a '20' before it
            if contains(string_dates(i),'-')
                c=strsplit(string_dates(i),'-');
                string_dates(i)=append('20',c(2));
            end
            dates(i,1)=str2double(string_dates(i));
        %checks if date is number (usually just a year like 2005) since if
        %its a number, the string matrix will have an empty value
        elseif ~isnan(num(i,1))
            dates(i,1)=num(i,1);
        else
            dates(i,1)=NaN;
        end
        
    end

    %sizeStats is size(# of rows) currently in excel data, and is 
    %used across all metric coding for the .mat parts
    sizeStats=size(dates,1);

%     %append .mat data to end of data vector. will append all metric data from .mat
%     %to end of each vector.
%     counter=1;
%     for i=1:size(matData.outputData,2)
%         %append the year the # of times that there are # of tests 
%         %(e.g. 1x5 struct means 5 tests were conducted on that circuit, 
%         %and they all share the same test year thus that year is appended
%         % 5 times in the dates vector)
%         for k=1:size(matData.outputData(i).data,2)
%             dates(counter+sizeStats,1)=matData.outputData(i).year;
%             counter=counter+1;
%         end
%     end

    %****************************************%
    %Rated/Operating Voltages
    
    ratedVolts=num(1:size(num,1),9);
    operateVolts=num(1:size(num,1),10); 

    for i=1:size(ratedVolts,1)
        %checks if rated volts cell contains a string and isnt blank(length==0)
        if isnan(ratedVolts(i)) && strlength(text(i+2,16))~=0

            %below process takes string from that rated volts, takes the characters
            %before 'kV' or 'Kv', and cuts string if neccessary (if greater than 2
            %characters are left). then deletes spaces and converts to num.
            dd=text(i+2,16);
            if contains(dd{1},'kV')
                dd=strsplit(dd{1},'kV');
            else
                dd=strsplit(dd{1},'Kv');
            end
            dd=dd{1};
            if strlength(dd)>2
                dd=extractAfter(dd,strlength(dd)-2);
                dd=dd(find(~isspace(dd)));
            end
            ratedVolts(i)=str2num(dd);
        end
    end

    %need seperate loop for operateVolts because of different sizes and one
    %may be nan, other may be not
    for i=1:size(operateVolts,1)
        if isnan(operateVolts(i)) && strlength(text(i+2,17))~=0
            qq=text(i+2,17);
            qq=strsplit(qq{1},'kV');
            qq=strsplit(qq{1},'KV');
            qq=qq{1};
            qq=qq(find(~isspace(qq)));
            operateVolts(i)=str2num(qq);
        end

        %can insert standard operating voltage logic here
    end

    %****************************************%
    %Hi-Pot Test Withstand Voltage
    %NaN values present in hipotVolts don't always mean a hi-pot test
    %wasn't conducted, as some tests dont list their withstand voltage but
    %still conductd hipot tests.

    hipotVolts=num(1:size(num,1),25);

    for i=1:size(hipotVolts,1)
        %checks if AC hi-pot was perfomed, hipotVolts cell contains a string and either isnt
        %blank(length==0) and filled as only 'N/A','NA', or 'Pass'

        

        if strcmp(text(i+2,28),"Yes") && isnan(hipotVolts(i)) && strlength(text(i+2,32))~=0 ...
                && ~contains(string(text(i+2,32)),'N/A') && ~contains(string(text(i+2,32)),'NA')
            %below process is same logic as ratedVolts,but also cuts at '@'

            if i==1317
                aa=text(i+2,28)
                bb=text(i+2,29)
                cc=text(i+2,30)
                num(i,29)
            end
            
            rr=text(i+2,32);
            rr=strsplit(rr{1},'kV');
            rr=strsplit(rr{1},'Kv');
            rr=rr{1};
            rr=strsplit(rr,'@');
            rr=rr(2);
            if strlength(rr)>2
                rr=extractAfter(rr,strlength(rr)-2);
                rr=rr(find(~isspace(rr)));
            end
            hipotVolts(i)=str2num(string(rr));
        elseif strcmp(text(i+2,28),"No") || strcmp(text(i+2,28),"N/A")
            hipotVolts(i)=NaN;
        end
        %a='-------------'
    end

    %****************************************%
    %Time Duration of Hi-Pot
    for i=1:size(num,1)
        %timesHipotUnfiltered contains time duration, regardless of hipot
        %was conducted or not
        timeHipotUnfiltered(i,1)=num(i,27);

        %timesHipotFiltered contains time duration ONLY if hipot was
        %conducted
        if strcmp(text(i+2,28),"Yes")
            timeHipotFiltered(i,1)=num(i,27);
        else
            timeHipotFiltered(i,1)=NaN;
        end
    end

    %NaN values are still in timeHipot, meaning that a Hipot test wasn't
    %conducted. Make sure to not include these in graph.

    %****************************************%
    %PD Test Acceptance Voltage
    for i=1:size(num,1)
        %checks if hi-pot test was performed
        if strcmp(text(i+2,29),"Yes")
            PDvolts(i,1)=num(i,29);
        else
            PDvolts(i,1)=NaN;
        end
    end

    %NaN values are still present in PDvolts. However it doesn't mean the
    %PD test wasn't done value, it is just missing the data.

    %****************************************%
    %Hi-Pot Withstand Test Results (Pass/Fail)
    %passes are given 1 values, fails are given 2 values,
    %NA are given NaN values

    hipotResults_strings=string(text(3:size(text,1),39));
    hipotResults_ints=zeros(size(hipotResults_strings,1),1);
    
    for i=1:size(hipotResults_strings,1)
        if strcmp(text(i+2,28),"Yes")
            if contains(hipotResults_strings(i),"Pass")
                hipotResults_ints(i)=1;
            elseif contains(hipotResults_strings(i),'Fail')
                hipotResults_ints(i)=2;
            else
                hipotResults_ints(i)=NaN;
            end
        else
            hipotResults_ints(i)=NaN;
        end
    end

    %****************************************%
    %PDEV and PDIV Values
    %NaN values means no PD test conducted

    PDIV=num(1:size(num,1),33);
    PDEV=num(1:size(num,1),34);
    %greaterThanFlags contains a true or false value, to whether or not the
    %PDIV value has a "<" or ">"
    greaterThanFlags=zeros(size(PDIV,1),1);


    for i=1:size(PDIV,1)
        %checks if PD test was conucted, PDIV cell contains a string and either isnt
        %blank(length==0) and filled as only 'N/A' or 'NA'
        if strcmp(text(i+2,29),"Yes") && isnan(PDIV(i)) && strlength(text(i+2,40))~=0 && ~contains(string(text(i+2,40)),'N/A','IgnoreCase',true) && ~contains(string(text(i+2,40)),'NA') && ~contains(string(text(i+2,40)),'x')
            
            %below process has same key logic as ratedVolts, but cuts at
            %'>' or '<'
            yy=text(i+2,40);
            if contains(string(yy),'>');
                yy=strsplit(string(yy),'>');
                yy=yy(2);
                greaterThanFlags(i)=true;
            elseif contains(string(yy),'<');
                yy=strsplit(string(yy),'<');
                yy=yy(2);
                greaterThanFlags(i)=true;
            else
                greaterThanFlags(i)=false;
            end
            PDIV(i)=str2num(string(yy));
        end
    end
    

    for i=1:size(PDEV,1)
        %exact same logic as PDIV
        if strcmp(text(i+2,29),"Yes") && isnan(PDEV(i)) && strlength(text(i+2,41))~=0 && ~contains(string(text(i+2,41)),'N/A','IgnoreCase',true) && ~contains(string(text(i+2,41)),'NA') && ~contains(string(text(i+2,41)),'x')
            
            zz=text(i+2,41);
            if contains(string(zz),'>');
                zz=strsplit(string(zz),'>');
                zz=zz(2);
            elseif contains(string(zz),'<');
                zz=strsplit(string(zz),'<');
                zz=zz(2);
            end
            PDEV(i)=str2num(string(zz));
        end
    end

    %****************************************%
    %Insulation Type
    insulation=string(text(3:size(text,1),22));
    insulation_filtered=strings(size(insulation,1),1);
    
    for i=1:size(insulation,1)
        if contains(insulation(i),"EPR")
            if contains(insulation(i),"100")
                insulation_filtered(i)="EPR 100%";
            elseif contains(insulation(i),"133")
                insulation_filtered(i)="EPR 133%";
            elseif contains(insulation(i),"BLACK")
                insulation_filtered(i)="Black EPR";
            elseif contains(insulation(i),"PINK");
                insulation_filtered(i)="Pink EPR";
            else
                insulation_filtered(i)="EPR 100%";
            end
        elseif contains(insulation(i),"XLPE")
            if contains(insulation(i),"100")
                insulation_filtered(i)="XLPE 100%";
            elseif contains(insulation(i),"133")
                insulation_filtered(i)="XLPE 133%";
            elseif contains(insulation(i),"TR")
                insulation_filtered(i)="TR-XLPE";
            else
                insulation_filtered(i)="XLPE 100%";
            end
        elseif contains(insulation(i),"paper")
            insulation_filtered(i)="Impregnated Paper";
        elseif contains(insulation(i),"MUS")
            insulation_filtered(i)="MUS";
        else
            insulation_filtered(i)=NaN;
        end
    end

    %****************************************%
    %Test Type
    type=string(text(3:size(text,1),6));


    done="Done Running Function"
    results=[dates,ratedVolts,operateVolts,hipotVolts,timeHipotUnfiltered,PDvolts,hipotResults_ints,PDIV,PDEV,insulation_filtered,type,greaterThanFlags,timeHipotFiltered];
    
end