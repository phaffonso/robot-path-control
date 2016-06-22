%Given that your environment has all the variables created by the path control
%algorithm, this file plots the planned & real path and displays the parameters used
%Useful to visualize data from a saved session

close all

%loads 'mapa' and 'straj' variables
load smoothtraj.mat

CellSize = 100;   % mm

straj = straj * CellSize;

drawMap(mapa);

plot(straj(:, 1), straj(:, 2), '-*b');

plot(PoseXIni, PoseYIni, 'ok');

%parameters
Kp
Kd
Ki
v
goalRadius 

dt

plot(rpath(:, 1), rpath(:, 2), '-k');

AvgAngleErr = J1 / steps
AvgPositionErr = J2 / steps
