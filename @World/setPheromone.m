function this = setPheromone(this, x, y, weight)
% funkce nastavuje sílu feromonu na hranì

this.matrix(x, y, 2) = this.matrix(x, y, 2) + weight;
this.matrix(y, x, 2) = this.matrix(y, x, 2) + weight;
end

