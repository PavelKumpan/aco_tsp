function pheromone = getPheromone(this, x, y)
% fce vrací feromon hrany mezi vrcholy s èísly x a y

pheromone = this.matrix(x,y,2);
end

