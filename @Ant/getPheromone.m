function pheromone = getPheromone(this)
% funkce vrací feromon mravence jako fce jeho vìku
    pheromone = 1 / (this.age + 1)^2;
end

