function plotGuiGraph(graph)
% fce vykresluje grafickou reprezentaci grafu na kreslící plochu v gui

global inputPoints;
global fig;
global plotedEdges;

matrix = getMatrix(graph);

[m,n,o] = size(matrix);
p       = 1/5;  % parametr pro sjednocení feromonù pro vykreslení hrany

maxPhe = max(max(matrix(:,:,2).^p));

if(isempty(plotedEdges))
    plotedEdges = zeros(m, n);
end;

for(i = 1:m)
    for(j = i:n)
        if(matrix(i,j,1) > 0)
            x1 = inputPoints(i, 1);
            y1 = inputPoints(i, 2);
            x2 = inputPoints(j, 1);
            y2 = inputPoints(j, 2);         
            CC = (1 - matrix(i,j,2)^p / maxPhe) .* [1, 1, 1];            
            CC(isnan(CC)) = 1;      
            
            if(plotedEdges(i, j) == 0)
                plotedEdges(i, j) = plot(fig, [x1 x2], [y1 y2], 'Color', CC);
            else
                set(plotedEdges(i, j), 'Color', CC);
            end;
        end;
    end;
end;


end

