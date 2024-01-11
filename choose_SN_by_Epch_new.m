clc
clear
format long g
%load from SP3
load A
%load from observation
load C_code

% %sp3
%coor all
coor_all(:,:)=A(:,2:5);
Epoch=length(C_code);

% %obs
%p : CA code that is in obs_file
t=1;
for j=1:Epoch
    t=1;
    for i=1:31
        if C_code(i,j)>0
            p_all(t,j)=C_code(i,j);
            num_st_all(t,j)=i;
            t=t+1;
        end
    end
end
%for all Epoch
for j=1:length(num_st_all)    
    for k=1:size(num_st_all(:,1))
        if num_st_all(k,j)>0
            size_num_st_all(1,j)=k;
        end
    end
end
k=0;
for i=1:Epoch
  
    for j=1:size_num_st_all(i)
        
          coorSP3(j+k,:)=coor_all(num_st_all(j,i)+31*(i-1),1:4);
     
    end
    k=k+j;
end

% % % for true test : som=sum(size_num_st_all(1:i))

 save num_st_all  p_all
 save coor_all
%coorSP3 : coordinate of SP3 from satelites that is in your Epoch
%accuracy_coorSP3 : accuracy of coordinate of SP3 from satelites that is in your Epoch

% sat.num, xs,ys,zs, dts, p
k=0;
for i=1:Epoch
 
        p_al(1+k:size_num_st_all(i)+k,1)=p_all(1:size_num_st_all(i),i);
   
    k=k+size_num_st_all(i);
end


k=0;
for i=1:Epoch
 
        num_st_al(1+k:size_num_st_all(i)+k,1)=num_st_all(1:size_num_st_all(i),i);
   
    k=k+size_num_st_all(i);
end
Xcoor=str2num(Xcoordinate);
Ycoor=str2num(Ycoordinate);
Zcoor=str2num(Zcoordinate);

GPSOBS=[num_st_al,coorSP3,p_al];

save coorSP3
Stcoord=[Xcoor,Ycoor,Zcoor];
save gpsdata.mat GPSOBS Stcoord





