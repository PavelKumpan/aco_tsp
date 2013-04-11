function this = setEdge(this, x, y, weight)
% funkce nastavuje váhu hrany

this.matrix(x, y, 1) = weight;
this.matrix(y, x, 1) = weight;
end

