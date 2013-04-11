function plotRoute(this, route)
% fce vykresluje grafickou reprezentaci cesty

[m,n,o] = size(this.matrix);
step  = 10;
x = 0;
y = 0 ;


% zvýraznìné hrany
for(i = 2:length(route))
    x1 = route(i) * step -  floor(route(i)/3) * step;
    x2 = route(i-1) * step -  floor(route(i-1)/3) * step;
    y1 = mod(route(i), 3) * step;
    y2 = mod(route(i-1), 3) * step;
    plot([x1 x2], [y1 y2], 'r', 'LineWidth', 2);
end;


end

