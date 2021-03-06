function createAdjMatrix()
% vytvo�� matici sousednosti ze zadan�ch bod�

global inputPoints;
global adjMatrix;
adjMatrix = [];

[isize c]   = size(inputPoints);

for(j = 1:isize)   
    for(i = 1:isize)
        distance = sqrt(sum((inputPoints(j, :) - inputPoints(i, :)).^2));
        adjMatrix(j, i) = distance;
        adjMatrix(i, j) = distance;
    end;
end;

end

