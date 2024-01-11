clear 
clc
load coorSP3
load gpsdata % GPSOBS
% sat.num, xs,ys, zs, dts, p

psedorange = GPSOBS(:,6);
% derived from SP3 file, precise ephemeris
% unit change: from km to meter
xS = GPSOBS(:,2)*1000;
yS = GPSOBS(:,3)*1000;
zS = GPSOBS(:,4)*1000;
% unit change: from microseconds to seconds 
dTS = GPSOBS(:,5)*10^(-6);
% removing outliers
% xS(226)=[];
% yS(226)=[];
% zS(226)=[];
% dTS(226)=[];
% psedorange(226)=[];
% xS(217)=[];
% yS(217)=[];
% zS(217)=[];
% dTS(217)=[];
% psedorange(217)=[];

% dtS in nano-seconds
c=299792458;
% c in meter
n=length(dTS);
dion=0;
dtrop=0;

l = psedorange+c*dTS+dion+dtrop;

l(10:n)=[];

 % starting values of station coordinates and receiver clock error

xR=1000000;
yR=1000000;
zR=1000000;
dTR=1*10^(-5);
x0=[xR;yR;zR;dTR];