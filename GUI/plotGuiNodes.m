function plotGuiNodes()
% fce vykresluje grafickou reprezentaci grafu na kresl�c� plochu v gui

global inputPoints;
global fig;


[m,n] = size(inputPoints);

for(i = 1:m)
    plot(fig, inputPoints(i, 1), inputPoints(i, 2), 'bo')
end;


end

