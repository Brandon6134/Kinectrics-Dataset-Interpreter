
%compareTestResults([8,97],[23,24],[888,1000],[39,40],"\\atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\KIN_Copy of Overall Cable Data_ALLPLANTS_Final_R3 2015.xlsx","\\atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\BB Historical and Cables Master List DRAFT 20180514-12-Mod.xlsm");

%rows1 is matrix of number row that the same report number begin and end
%(e.g. [145,166]) for first report. rows2 is for second report. columns1
%is number column location of the PDIV and PDEV values of first report,
%columns 2 is same for second report.
function [nothing] = compareTestResults(rows1,columns1,rows2,columns2,filepath1,filepath2)
    clc;
    [num1,text1,raw1]=xlsread(filepath1);
    [num2,text2,raw2]=xlsread(filepath2);
%     reportValues1=zeros(rows1(2)-rows1(1));
%     reportValues2=zeros(rows2(2)-rows2(1));
    sameCounter=0;
    


    ii=(raw1(rows1(1),columns1(1)))
    ii{1}
    rows1(2)-rows1(1)
    for i=0:rows1(2)-rows1(1)
        ii=(raw1(rows1(1)+i,columns1(1)));
        ii=ii{1};
        gg=(raw1(rows1(1)+i,columns1(2)));
        gg=gg{1};
        reportIV1(i+1)=string(ii);
        reportEV1(i+1)=string(gg);
    end

    for i=0:rows2(2)-rows2(1)
        ii=(raw2(rows2(1)+i,columns2(1)));
        if contains(string(ii{1}),'>') || contains(string(ii{1}),'<')
            ii=split(string(ii{1}),'>');
            ii=split(string(ii),'<');
            ii=ii(2)
        end

        gg=(raw2(rows1(1)+i,columns2(2)));
        if contains(string(gg{1}),'>') || contains(string(gg{1}),'<')
            gg=split(string(gg{1}),'>')
            gg=split(string(gg),'<')
            gg=gg(2)
        end
        reportIV2(i+1)=string(ii);
        reportEV2(i+1)=string(gg);
    end

    counter=1;
    for i=1:rows1(2)-rows1(1)
        for k=1:rows2(2)-rows2(1)
            if strcmp(reportIV1(i),reportIV2(k)) && strcmp(reportEV1(i),reportEV2(k)) && ~strcmp(reportIV1(i),'stop')
                sameCounter=sameCounter+1;
                reportIV1(i)="stop";
                reportIV2(i)="stop";
                reportEV1(i)="stop";
                reportEV2(i)="stop";
                list1(counter)=rows1(1)+i-1;
                list2(counter)=rows2(1)+k-1;
                counter=counter+1;
                
            end
        end
    end

    list1=list1
    list2=list2
    sameCounter

    done="Function ran successfully!"
    nothing=raw1;

end