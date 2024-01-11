clc
close all
clear all
format long
fileID = fopen('C:\Users\Active\Desktop\proje\files\clar0440.18o');

L1=[];
L2=[];
C1=[];
P2=[];

z=[];
t=1;

foundfirstcoordinate=0;
foundfirsttime=0;
foundheaderend=0;
foundANTENNA=0;

while ~feof(fileID)
    line = fgetl(fileID);
    line = strtrim(line);
    
    if foundfirstcoordinate==0;
        F=strfind(line,'XYZ');
        if isempty(F)
            continue
        else
            c=strsplit(line);
            Xcoordinate=char(c(1));
            Ycoordinate=char(c(2));
            Zcoordinate=char(c(3));
            foundfirstcoordinate=1;
            continue
        end
    end
    
       %ANTENNA
    if foundANTENNA==0
        Q=strfind(line,'DELTA');
        if isempty(Q)
            continue
        else
            C = strsplit(line);
            h_Antenna = str2num(char(C(1)));
            
            foundANTENNA = 1;
            continue
        end
    end
    
    
    if foundfirsttime==0
        k=strfind(line,'TIME OF FIRST OBS');
        if isempty(k)
            continue
        else
            C = strsplit(line);
            firstday = str2num(char(C(3)));
            firsthour = str2num(char(C(4)));
            firstminute = str2num(char(C(5)));
            firstsecond = str2num(char(C(6)));
            foundfirsttime = 1;
            continue
        end
    end
 
    
    if foundheaderend==0
        k=strfind(line,'END OF HEADER');
        if isempty(k)
            continue
        else
            foundheaderend = 1;
            continue
        end
    end
    
    C = strsplit(line);
    day = str2num(char(C(3)));
    hour = str2num(char(C(4)));
    minute = str2num(char(C(5)));
    second = str2num(char(C(6)));
    
    %timediff = 0;
    
    if day>=firstday
        timediff= (day-firstday) * 86400 + (hour-firsthour) * 3600 + (minute-firstminute) * 60 + (second-firstsecond);
    else
        timediff= 1 * 86400 + (hour-firsthour) * 3600 + (minute-firstminute) * 60 + (second-firstsecond);
    end
    
    z(t) = timediff;
    
    C(1:7)=[];
    
    st = strtrim(strjoin(C));
    
    
    n = str2num(char(strsplit(st,'G')));
    
    for i=1:n(1)
        sn = n(i+1);
        line1 = strtrim(fgetl(fileID));
        line2 = strtrim(fgetl(fileID));
        
        data = str2double(strsplit(line1));
        if length(data) >= 6
            L1(sn,t) = data(1);  % sotoone 1
            L2(sn,t) = data(3);  % sotoone 3
            C1(sn,t) = data(5);  % sotoone 5
            P2(sn,t) = data(6);  % sotoone 6
            
        end
    end
    t = t + 1;
    second1=second;
end

t = t -  1;
%C_code:C1 Pseudorange for 15 minute
i=1;
for n=1:30:length(C1)
    C_code(:,i)=C1(:,n);
    i=i+1;
    
end
fclose(fileID)

contT=1;
contS=1;
counter=1;
P=[];
for contT=1:96
    for contS=1:31
        P(counter,1)=C_code(contS,contT);
        
        counter=counter+1;
    end
end
save C_code 
save h_Antenna
clear c C contS contT counter data def dlg_title fileID firstday firsthour firstminute firstsecond foundfirsttime foundheaderend hour minute n prompt second second1 sn timediff

