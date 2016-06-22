%Given any real number in (-inf, inf) corresponding to an angle
%This returns an equivalent angle in the interval (-pi pi]
function result = angleNormalize(x)
  result = mod(x + pi, 2*pi) - pi;
end