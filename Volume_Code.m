%%CALCULO DEL VOLUMEN DE EDIFICIOS VOLCÃ?NICOS
% LECTURA DEL ARCHIVO DEM - EN FORMATO TIFF.
[A,R]= geotiffread('LosLagosDEM.tiff');
%valores que limitan al DEM en x,y
R.XLimWorld(1,1)=695606.4375;
R.YLimWorld(1,2)=5503703.75;
% NUMERO DE DOMOS A CALCULAR
Vol=zeros(3,1);
Area=zeros(3,1);
for i=1:3
 nameV=['DomosCVP',num2str(i),'.txt'];
 V=load(nameV);
 x=V(:,1);
 y=V(:,2);
 z=V(:,3);
 clear V;
 Area(i) = polyarea(x,y);
 xmin=min(x);
 xmax=max(x);
 ymin=min(y);
 ymax=max(y);
 [X,Y] = meshgrid(xmin:20*R.DeltaX:xmax, ymax:20*R.DeltaY:ymin);
 In=inpolygon(X,Y,x,y);
 Z = griddata(x,y,z,X,Y,'linear');
 Z(In==0) = NaN;
 [r,c,v]= find(Z>1);
 XX=X(r,c);
 YY=Y(r,c);
 ZZ=Z(r,c);
 xx=[x;XX(:)];
 yy=[y;YY(:)];
 zz=[z;ZZ(:)];
 [X,Y] = meshgrid(xmin:R.DeltaX:xmax, ymax:R.DeltaY:ymin);
 Z = griddata(xx,yy,zz,X,Y,'linear');
 Z(In==0) = NaN;
 [m,n]=size(Z);
 [r,c,v]= find(Z>1);
 Ix=round((xmin-R.XLimWorld(1,1))/R.DeltaX);
 Iy=round((ymax-R.YLimWorld(1,2))/R.DeltaY);
 DemV=double(A(Iy:Iy+ m -1,Ix:Ix+n-1));
 h=(DemV-Z);
 ih=h>0;
 Vol(i)=nansum(nansum(h(ih)*R.DeltaX^2))/1000^3; % Volumen en Km3
 figure;
 subplot(2,2,1)
 plot(x,y); axis equal
134
 subplot(2,2,2)
 plot3(xx,yy,zz,'.');
 subplot(2,2,3); imshow(Z); 
 subplot(2,2,4); mesh(DemV); 
end