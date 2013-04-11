function this = actualizePheromones(this, route)
% aktualizuje hladinu feromonu na hran�ch cesty
%   this    - objekt grafu
%   route   - cesta pro aktualizaci

global ro;
global phe0;

[l, m]  = size(route);
if(m > 2)
    for(k = 2:length(route(1, :)))
        n = route(1, k-1);
        o = route(1, k);
        s = sum(route);
        if(s == 0)
            s = 10e-15;
        end;
        p = getPheromone(this, n, o) + 1 / s;
        this = setPheromone(this, n, o, p);
    end;
end;
end

