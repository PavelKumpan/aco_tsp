function this = evaporatePheromone(this)
% odpa�� feromon na hran�ch

global phi;

this.matrix(:, :, 2) = this.matrix(:, :, 2) .* (1 - phi);
end

