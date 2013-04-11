function n = addPoint(x, y)
% pøidá bod do globální matice sousednosti po kliknutí v GUI

global inputPoints;

[isize i] = size(inputPoints);
inputPoints(isize + 1, :) = [x, y];
n = isize + 1;

end

