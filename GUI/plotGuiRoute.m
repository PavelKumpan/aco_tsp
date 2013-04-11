function plotGuiRoute( graph, route )

% fce vykresluje grafickou reprezentaci grafu na kreslící plochu v gui

global inputPoints;
global fig;
global plotedRoute;

matrix = getMatrix(graph);

[m,n,o] = size(matrix);

% zvýraznìné hrany
for(i = 2:length(route))
    x1 = inputPoints(route(i), 1);
    y1 = inputPoints(route(i), 2);
    x2 = inputPoints(route(i-1), 1);
    y2 = inputPoints(route(i-1), 2);
    if(length(plotedRoute) >= i)
        delete(plotedRoute(i));
    end;
    plotedRoute(i) = plot(fig, [x1 x2], [y1 y2], 'r');
end;



end

