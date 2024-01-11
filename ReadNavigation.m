clc
close all
clear all
format long g
fileNV = fopen('C:\Users\Active\Desktop\proje\files\clar0440.18n');

foundendtime=0;
foundIONALPHA=0;
foundIONBETA=0;
foundheaderend=0;
foundDELTAUTC=0;
a=[];

result=[];
i=1;

while ~feof(fileNV)
    
    line = fgetl(fileNV);
    line = strtrim(line);%remove of empty spac
    
    if foundendtime==0
        k=strfind(line,'UTCPGM');
        if isempty(k)
            continue
        else
            C = strsplit(line);
            
            endofdate =char(C(6));
            kl =char(C(7));
            endoftime =kl(1:5);
            
            foundendtime = 1;
            continue
        end
    end
    %ALPHA
    if foundIONALPHA==0
        k=strfind(line,'ION ALPHA');
        if isempty(k)
            continue
        else
            C = strsplit(line);
            
            a0 =str2num(char(C(1)));
            a1 =str2num(char(C(2)));
            a2 =str2num(char(C(3)));
            a3 =str2num(char(C(4)));
            ALPHA=[a0,a1,a2,a3];
            foundIONALPHA = 1;
            continue
        end
    end
    %BETA
    if foundIONBETA==0
        k=strfind(line,'ION BETA');
        if isempty(k)
            continue
        else
            C = strsplit(line);
            
            b0 =str2num(char(C(1)));
            b1 =str2num(char(C(2)));
            b2 =str2num(char(C(3)));
            b3 =str2num(char(C(4)));
            BETA=[b0,b1,b2,b3];
            foundIONBETA = 1;
            continue
        end
    end
    
    %DETA
    if foundDELTAUTC==0
        k=strfind(line,'DELTA-UTC');
        if isempty(k)
            continue
        else
            C = strsplit(line);
            zz=strfind(line,'D');
            A0 =str2num(line(1:zz(1,1)+3));
            A1 =str2num(line(zz(1,1)+4:zz(1,2)+3));
            T =str2num(char(C(2)));
            W =str2num(char(C(3)));
            DELTA=[A0,A1,T,W];
            foundDELTAUTC = 1;
            continue
        end
    end

    i=i+1;
    
end
ION=[ALPHA,BETA];
save ION