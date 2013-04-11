function this = setGlobalPheromone(this, weight)
% funkce nastavuje feromon na celou mapu

this.matrix(:, :, 2) = weight;
end

