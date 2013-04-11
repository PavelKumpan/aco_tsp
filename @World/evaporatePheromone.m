function this = evaporatePheromone(this)
% odpaøí feromon na hranách

global phi;

this.matrix(:, :, 2) = this.matrix(:, :, 2) .* (1 - phi);
end

