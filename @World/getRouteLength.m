function s = getRouteLength(this, route)
% vrac� d�lku cesty - sou�et vah jednotliv�ch hran

s = 0;
if(length(route) >= 2)
    for(i = 2:length(route))
        s = s + this.matrix(route(i-1), route(i));
    end;
end;

end

