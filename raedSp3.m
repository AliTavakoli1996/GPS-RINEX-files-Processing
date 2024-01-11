clc
clear
close all

fid=fopen('C:\Users\Active\Desktop\proje\files\igs19882.sp3');
headerlength = 22;
i = 0;
j = 0;
k = 0;
counter=-1;
m=20000;
A=zeros(20000,6);
while ~feof(fid)
    line = fgets(fid);
    i = i+1;
    if i <= headerlength
        continue;
    end
    C = strsplit(line);
    
    if strcmp(C(1),'*')==1
        
        if length(C)>5
            currentdate = strcat( C(2) , C(3) , C(4));
            currenttime = str2double(C(5)) * 60 + str2double(C(6));
            %dataline = str2double(line(2:end));
        end
        counter=counter+1;
    elseif strcmp(line(1),'P')==1
        
        if k>=m-20
            A=[A;zeros(20000,6)];
            m=m+20000;
        end
        
        C = strsplit(line);
        
        if length(C)>4
            k=32*counter+str2double(line(3:4));
            numberST=str2num(line(3:4));
            A(k,:) = [currenttime str2double(C(2)) str2double(C(3)) str2double(C(4)) str2double(C(5)) numberST];
            
            if A(k,5)>750
                A(k,5)=A(k-1,5);
                
            end
            
        end
    end
    j=j+1;
    
end
A(k+1:end,:)=[];
fclose(fid);

save A

       
   



