function this = setNode(this, node)
% nastavuje uzel
    this.node = node;
    this.route(length(this.route) + 1) = node;
end

