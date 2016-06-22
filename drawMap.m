function drawMap(lines)

%figure 1;
hold on;
%Configuracao do grafico
d = 50;
axis([0-d 4680+d 0-d 3200+d], "equal");

for i = 1:size(lines, 1)
  plot([lines(i, 1) lines(i, 3)], [lines(i, 2) lines(i, 4)], '-r');
end

end