function pheromone = getPheromone(this)
% funkce vrac� feromon mravence jako fce jeho v�ku
    pheromone = 1 / (this.age + 1)^2;
end

