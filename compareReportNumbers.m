%compareReportNumbers("C:\Users\KONGB\Downloads\KIN_Copy of Overall Cable Data_ALLPLANTS_Final_R3 2015.xlsx",2,"\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\BA Historical and Cables Master List DRAFT 20180511-5.xlsm",26)
%compareReportNumbers("C:\Users\KONGB\Downloads\KIN_Copy of Overall Cable Data_ALLPLANTS_Final_R3 2015.xlsx",2,"\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\BB Historical and Cables Master List DRAFT 20180514-12-Mod.xlsm",26)
%compareReportNumbers("\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\BA Historical and Cables Master List DRAFT 20180511-5.xlsm",26,"\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\BB Historical and Cables Master List DRAFT 20180514-12-Mod.xlsm",26)
%compareReportNumbers("C:\Users\KONGB\Downloads\KIN_Copy of Overall Cable Data_ALLPLANTS_Final_R3 2015.xlsx",2,"\\Atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\Hydro One - Historical MV Cable Data.xlsx",1)

%column_index1 and column_index2 are the numbered locations of the report numbers
%in each xls file (e.g. column D is 4)
function [results] = compareReportNumbers(filepath1,column_index1,filepath2,column_index2)
    clc;

    repeatRepNums=[""];
    counter=1;

    [num,text,raw]=xlsread(filepath1);
    nums1=text(3:size(text,1),column_index1);
    nums1=unique(nums1(~cellfun('isempty',nums1)));%removes empty cells and repeating report numbers

    [num,text,raw]=xlsread(filepath2);
    nums2=text(2:size(text,1),column_index2);
    nums2=unique(nums2(~cellfun('isempty',nums2)));
    
    
    %nums2{1}="THROWAWAYTEXT"

    %A = A(find(~isspace(A)))
    %nums2=unique(nums2(~cellfun('isempty',nums2)));
    %nums2=unique(nums2(find(~isspace(nums2(~cellfun('isempty',nums2))))));

    %checks for matching report numbers between the reports
    for i=1:size(nums1,1)
        for k=1:size(nums2,1)
            if contains(nums1{i},nums2{k}) || contains(nums2{k},nums1{i})
                repeatRepNums(counter)=nums1{i};
                counter=counter+1;
            end
        end
    end

    results=repeatRepNums;
    
end