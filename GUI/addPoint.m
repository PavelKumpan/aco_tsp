function n = addPoint(x, y)
% p�id� bod do glob�ln� matice sousednosti po kliknut� v GUI

global inputPoints;

[isize i] = size(inputPoints);
inputPoints(isize + 1, :) = [x, y];
n = isize + 1;

end

