%calculate the distance (2d) between a line (Q1, Q2) and a point (P)
function d = linedist(Q1, Q2, P)
  Q1(3) = Q2(3) = P(3) = 0;
  d = norm(cross(Q2-Q1,P-Q1))/norm(Q2-Q1);
end