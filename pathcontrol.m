% Robot Path Control
% Author: Pedro Affonso
% Loads a planned path, then uses a simple PID controller
% to make a robot follow that path

close all

%loads 'mapa' and 'straj' variables
load smoothtraj.mat

PoseXIni = 500;
PoseYIni = 1800;

%0 for simulator on localhost, 1 for real robot on 10.1.3.130
realrob = 0;

if(realrob)
  disp('using real robot');
  baseurl = 'http://10.1.3.130:4950/';
else
  disp('using simulator');
  baseurl = 'http://127.0.0.1:4950/';
end
fflush(stdout);

ResPose = [baseurl 'motion/pose'];
ResVel = [baseurl 'motion/vel'];
ResRotVel = [baseurl 'motion/rotvel'];

CellSize = 100;   % mm

straj = straj * CellSize;
%plot the map for the envorinment
drawMap(mapa);

%plot the desired path
plot(straj(:, 1), straj(:, 2), '-*b');
%plot the initial pose
plot(PoseXIni, PoseYIni, 'ok');

%parameters
Kp = 0.6;
Kd = 0.4;
Ki = 0;
v = 100;
goalRadius = 70;

dt = 0.3;

%initialization
integral = 0;
last_err = 0;
J1 = J2 = 0;
last_target = straj(1, :);
k = 2;
target = straj(k, :);
p = [PoseXIni PoseYIni 0]';
http_init;
pose.x = PoseXIni;
pose.y = PoseYIni;
pose.th = 0;
http_put(ResPose, pose);
http_put(ResVel, v);
tic;
steps = 0;
rpath = [];
while 1
  steps = steps + 1;
  pose = http_get(ResPose)
  p = [pose.x pose.y pose.th*pi/180]';
  rpath = [rpath; p'];
  plot(p(1), p(2), 'xk');
  %Calculates angular error and distance to goal by means of a coordinate transformation
  polar = w2r(target, p);
  r = polar(1);
  err = polar(2) / pi * 180
  %calculate partial costs (squared errors) and sum them to the total cost
  J1 = J1 + err^2;
  J2 = J2 + linedist(target, last_target, p(1:2)')^2;
  if(r < goalRadius)
    k = k + 1
    if(k > size(straj, 1))
      stop;
      disp fim
      break;
    end
    last_target = target;
    target = straj(k, :);
    %Plot new target
    plot(target(1), target(2), '-*c');
    polar = w2r(target, p);
    r = polar(1);
    err = polar(2) / pi * 180;
  end
  
  %Calculate integral and derivative
  integral = integral + dt * err;
  deriv = (err - last_err)/dt;
  %Calculate PID controller output
  out = Kp * err + Ki * integral + Kd * deriv;
  http_put(ResRotVel, out);
  
  fflush(stdout);
  elapsedTime = toc;
  sleep(dt - elapsedTime);
  tic;
  
end 

AvgAngleErr = J1 / steps
AvgPositionErr = J2 / steps

fn = input('save results for this run as: ', 's');
save([fn '.mat'], 'J1', 'J2', 'steps', 'AvgAngleErr', 'AvgPositionErr', 'rpath', 'v', 'Kp', 'Ki', 'Kd', 'goalRadius');

