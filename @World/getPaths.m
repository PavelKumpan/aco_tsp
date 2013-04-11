function paths = getPaths(this, node)
% vrací vektor cest z vrcholu node [váha, feromon]

paths = this.matrix(node, :, :);
end

