%writeMatToXls("\\atlas\data$\TDT\422 EST\322 Sub Equipment\322 Sub Eq. NPD, R&D\EST Co-Op Student\Brandon K Files\Historical PD Test Data\Existing Data\STPData.mat");

%reads a .mat file then writes it to an xlsx sheet
%filepath is filepath of desired .mat file holding STP data
function [newMatrix] = writeMatToXls(filePath)
     clc
       
     data=load(filePath);
     dataArray=struct2cell(data.outputData);
     counter=2;%keeps track of which line saving to
     
     %a loop is for looping the total # of circuits in .mat file
     for a=1:size(dataArray,3)
         %i loop is for looping the # of phases the circuit has
         for i=1:size(data.outputData(a).data,2)
             %k loop is for saving the 16 values for each circuit
             for k=1:16
                %first 4 values are regular, 5th value is a nested struct
                if k<=4
                    newMatrix(counter,k)=dataArray(k,a);
                %in nested struct, are 6 values. 11th value is nested struct.
                elseif k<=10
                    d=struct2cell(data.outputData(a).data);
                    newMatrix(counter,k)=d(k-4,i);
                %below line enters the nested nested struct and grabs data
                else
                    f=struct2cell(data.outputData(a).data(i).testResults);
                    newMatrix(counter,k)=f(k-10,1);
                end
             end
             counter=counter+1;
         end
     end
  
     writecell(newMatrix,'newSTPData.xlsx');
end