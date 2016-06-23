clear; clc; close all;

% constroi um mapa de grade a partir de um mapa de retas

% cada linha do mapa contem 4 parametros
% - pontos x,y de inicio da reta
% - pontos x,y de fim da reta

mapa = [];
mapa = [mapa; 0	0	4680	0]; 
mapa = [mapa; 0	0	0	3200];
mapa = [mapa; 0	3200	4680	3200];
mapa = [mapa; 4680	0	4680	3200];
mapa = [mapa; 0	2280	2000	2280];
mapa = [mapa; 920	2280	920	3200];
mapa = [mapa; 4190	2365	4680	2365];
mapa = [mapa; 4190	2365	4190	3200];
mapa = [mapa; 4030	0	4680	650];
mapa = [mapa; 2000    920     2000    2280];
mapa = [mapa; 2000    2280    2400    2280];
mapa = [mapa; 2400    2280    2400    920];
mapa = [mapa; 2000    920     2400    920];

mapa = [];
mapa = [mapa;  0    0    4680    0];
mapa = [mapa; 0    0    0    3200];
mapa = [mapa; 0    3200    4680    3200];
mapa = [mapa; 4680    0    4680    3200];
mapa = [mapa; 0    2280    920    2280];
mapa = [mapa; 920    2280    920    3200];
mapa = [mapa; 4190    2365    4680    2365];
mapa = [mapa; 4190    2365    4190    3200];
mapa = [mapa; 4030    0    4680    650];
mapa = [mapa; 920    2280    920    2080];
mapa = [mapa; 920    2080    1840    2080];
mapa = [mapa; 1840    2080    2330    1355];
mapa = [mapa; 2330    1355    3020    1835];
mapa = [mapa; 3020    1835    2690    2315];
mapa = [mapa; 2690    2315    2195    1975];
mapa = [mapa; 2195    1975    2025    2210];
mapa = [mapa; 2025    2210    1840    2080];

%mapa = [mapa; 0    0    0    2280];
%mapa = [mapa; 0    2280 920  2280];
%mapa = [mapa; 920  2280 920  3200];
%mapa = [mapa; 920  3200 4190 3200];
%mapa = [mapa; 4190 3200 4190 2850];
%mapa = [mapa; 4190 2850 4680 2850];
%mapa = [mapa; 4680 2850 4680 650];
%mapa = [mapa; 4680 650  4030 0];
%mapa = [mapa; 4030  0    0  0];
% obstaculos
%mapa = [mapa; 2340  900    2340  2700];
%mapa = [mapa; 2340  2700  3500 2700];
%mapa = [mapa; 2340 900   1000 900];

% limites do mapa
MinX = 0;
MaxX = 4680;
MinY = 0;
MaxY = 3200;

% define tamanho da celula
CellSize = 100;   % mm

% array contendo o mapa
MaxCellX = ceil(MaxX/CellSize);
MaxCellY = ceil(MaxY/CellSize);

% plota o mapa
ocupadas = buildgrid(mapa, CellSize, MaxCellX, MaxCellY);

% plota grade
hold on
cx = [];
cy = [];
for i=1:MaxCellX+1
  cx = [cx i  i                     i+1];
  cy = [cy 1 MaxCellY+2  MaxCellY+2];
endfor
plot(cx, cy, 'k' , 'LineWidth' , 1);
cx = [];
cy = [];
 for j=1:MaxCellY+1
     cx = [cx 1 MaxCellX+2 MaxCellX+2];
     cy = [cy  j  j                   j+1];
endfor
plot(cx, cy, 'k' , 'LineWidth' , 1);


%plota posiçao inicial do robo
PoseXIni = 500;
PoseYIni = 1800;
RoboXIni = ceil(PoseXIni/CellSize);
RoboYIni = ceil(PoseYIni/CellSize);
cx = [RoboXIni RoboXIni RoboXIni+1 RoboXIni+1 RoboXIni];
cy = [RoboYIni RoboYIni+1 RoboYIni+1 RoboYIni RoboYIni];
plot(cx, cy, 'b' , 'LineWidth' , 5);


% posicao final do robo
%PoseXObj = 4000;
%PoseYObj = 1600;
PoseXObj = 2400;
PoseYObj = 2800;
RoboXObj = ceil(PoseXObj/CellSize);
RoboYObj = ceil(PoseYObj/CellSize);
cx = [RoboXObj RoboXObj RoboXObj+1 RoboXObj+1 RoboXObj];
cy = [RoboYObj RoboYObj+1 RoboYObj+1 RoboYObj RoboYObj];
plot(cx, cy, 'g' , 'LineWidth' , 5);


% Estruturas requeridas pelo A*
% Mapa inicial completamente limpo
MapaLocal = ones(MaxCellY+1 , MaxCellX+1);

% Posicao inicial
xIni = RoboXIni;
yIni = RoboYIni;
% Setando a posicao de inicio no mapa local
MapaLocal(yIni , xIni) = 2;

% No local do Ponto Objetivo coloca o valor desta celula
xObj = RoboXObj;
yObj = RoboYObj;
MapaLocal(yObj , xObj) = 0;

% cresce obstaculos
cresceObst = 2;    % altere para 1 para crescer obstaculos em um nivel
custoCresc = 50;   % custo da celula adjacente aos obstaculos
if cresceObst == 1
  for k=1:length(ocupadas)
     xc = ocupadas(k,1);
     yc = ocupadas(k,2);
     try MapaLocal(yc+1,xc) = custoCresc; catch end;
     try MapaLocal(yc,xc+1) = custoCresc; catch end;
     try MapaLocal(yc-1,xc) = custoCresc; catch end;
     try MapaLocal(yc,xc-1) = custoCresc; catch end;
     try MapaLocal(yc+1,xc+1) = custoCresc; catch end;
     try MapaLocal(yc-1,xc+1) = custoCresc; catch end;
     try MapaLocal(yc+1,xc-1) = custoCresc; catch end;
     try MapaLocal(yc-1,xc-1) = custoCresc; catch end;
   end
end
if cresceObst > 1
  for k = 1:length(ocupadas)
    for dx = -cresceObst:cresceObst
      for dy = -cresceObst:cresceObst
        xc = ocupadas(k,1);
        yc = ocupadas(k,2);
        dist = max(abs(dx), abs(dy));
        if(dist > 0)
          try MapaLocal(yc+dy,xc+dx) = custoCresc; catch end;
        end
      end
    end
  end
end

for i = 1:MaxCellX
    for j = 1:MaxCellY
        if MapaLocal(j,i) == custoCresc
           vertices = [i j; i+1 j; i+1 j+1; i j+1]; 
           patch(vertices(:,1), vertices(:,2), 'c');
        end
    end
end

% marca ocupadas com custo infinito (-1)
for k=1:length(ocupadas)
   i = ocupadas(k,1);
   j = ocupadas(k,2);
   MapaLocal(j,i) = -1;
   vertices = [i j; i+1 j; i+1 j+1; i j+1]; 
   patch(vertices(:,1), vertices(:,2), 'r');
end

NL = MaxCellY+1;
NC = MaxCellX+1;

trajetoria = AEstrela(NC, NL, xIni, yIni, xObj, yObj, MapaLocal);

% printf("Trajetoria Otima:\n")
% trajetoria

printf("Pressione uma tecla para suavizar a trajetoria\n");
fflush(stdout);
kbhit();

% Suaviza trajetoria
% alfa = 0.0;  % RETA !!!
alfa = 0.5;
beta = 0.2;
eps = 0.0001;
newtraj = trajetoria;

straj = pathsmooth(alfa, beta,eps,trajetoria);

% plota trajetoria suavizada
hold on;
plot(straj(: , 1)+0.5 , straj(: , 2)+0.5 , 'k' , 'LineWidth' , 4);

save smoothtraj.mat straj mapa
