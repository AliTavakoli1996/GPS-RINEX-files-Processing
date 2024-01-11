% network adjustment program
load ION
% syms x y z dTR
% number of satellites
for i=1:6
    m=length(xS);
    n=length(l);
    u=length(x0);
    
    A=zeros(n,u);
    l0=zeros(n,1);
    for i=1:n
        
        l0(i) = ((xS(i)-xR)^2+(yS(i)-yR)^2+(zS(i)-zR)^2)^(1/2)+c*dTR;
        A(i,1) = (2*xR - 2*xS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
        A(i,2) = (2*yR - 2*yS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
        A(i,3) = (2*zR - 2*zS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
        A(i,4) = c;
    end
    
    P=eye(n,n);
    dl=l-l0;
    deltacap=(A'*P*A)\(A'*P*dl);
    
    max(abs(deltacap))
    xcap=x0+deltacap;
    x0=xcap;
    
    xR = xcap(1);
    yR = xcap(2);
    zR = xcap(3);
    dTR = xcap(4);
    coordinate=[xR,yR,zR];
    dist = sqrt((xR-Stcoord(1))^2+(yR-Stcoord(2))^2+(zR-Stcoord(3))^2);
    T = sprintf('positioning error %f ',dist);
    disp(T)
end
% Cartesian2Geodetic function
[phi,lambda,h] = Cartesian2Geodetic (xR,yR,zR);



lat =phi;
lon =lambda;
time_rx =dTR;
% AZandEL_model function
% AZandEL_model function
% AZandEL_model function % % % % % % [Az, El] = AZandEL(xR,yR,zR,coorSP3);
%%%%--------------------------------------------------------------%%%%
X0(:,1) = xR * ones(size(coorSP3,1),1);
X0(:,2) = yR * ones(size(coorSP3,1),1);
X0(:,3) = zR * ones(size(coorSP3,1),1);
Xs=coorSP3(:,1:3);
cl = cos(lambda);
sl = sin(lambda);
cb = cos(phi);
sb = sin(phi);
F = [-sl -sb*cl cb*cl;cl -sb*sl cb*sl;0    cb   sb];
local_vector = F' * (Xs-X0)';
E = local_vector(1,:)';
N = local_vector(2,:)';
U = local_vector(3,:)';
hor_dis = sqrt(E.^2 + N.^2);


if hor_dis < 1.e-20
    %azimuth computation
    Az = 0;
    %elevation computation
    El = 90;
else
    %azimuth computation
    Az = atan2(E,N)/pi*180;
    %elevation computation
    El = atan2(U,hor_dis)/pi*180;
end

i = find(Az < 0);
Az(i) = Az(i)+360;



%%%%--------------------------------------------------------------%%%%
lel =El;
az =Az;
ionoparams =ION;
% klobuchar_model function
[delay] = klobuchar_model(phi, lambda, Az, El, dTR, ION);
%[delay] = klobuchar_model(lat, lon, az, el, time_rx, ionoparams)
delay=delay(1:9,1);
l = l+delay;
l(10:n)=[];
x0=[xR;yR;zR;dTR];
%%%%-------------------------------------------------------------%%%%

m=length(xS);
n=length(l);
u=length(x0);

A=zeros(n,u);
l0=zeros(n,1);
for i=1:n
    
    l0(i) = ((xS(i)-xR)^2+(yS(i)-yR)^2+(zS(i)-zR)^2)^(1/2)+c*dTR;
    A(i,1) = (2*xR - 2*xS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
    A(i,2) = (2*yR - 2*yS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
    A(i,3) = (2*zR - 2*zS(i))/(2*((xR - xS(i))^2 + (yR - yS(i))^2 + (zR - zS(i))^2)^(1/2));
    A(i,4) = c;
end

P=eye(n,n);
dl=l-l0;
deltacap=(A'*P*A)\(A'*P*dl);

max(abs(deltacap))
xcap=x0+deltacap;
x0=xcap;

xR = xcap(1);
yR = xcap(2);
zR = xcap(3);
dTR = xcap(4);
coordinate=[xR,yR,zR];
dist = sqrt((xR-Stcoord(1))^2+(yR-Stcoord(2))^2+(zR-Stcoord(3))^2);
T = sprintf('positioning error %f ',dist);
disp(T)








