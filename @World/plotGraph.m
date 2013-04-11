function plotGraph(this)
% fce vykresluje grafickou reprezentaci grafu

[m,n,o] = size(this.matrix);
step    = 10;
x       = 0;
y       = 0;
p       = 1/5;  % parametr pro sjednocení feromonù pro vykreslení
% hrany

maxPhe = max(max(this.matrix(:,:,2).^p));

for(i = 1:m)
    for(j = i:n)
        if(this.matrix(i,j,1) > 0)
            x1 = i * step -  floor(i/3) * step;
            x2 = j * step -  floor(j/3) * step;
            y1 = mod(i, 3) * step;
            y2 = mod(j, 3) * step;
            
            color = (1 - this.matrix(i,j,2)^p / maxPhe) .* [1, 1, 1]; 
           
            color(isnan(color)) = 1;
            
            plot([x1 x2], [y1 y2], 'Color', color)
        end;
    end;
end;

% vrcholy
for(i = 1:m)
    
    if(mod(i,3) ~= 0)
        x = x + step;
    end;
    
    y = y + step;
    
    if(mod(i,3) == 0)
        y = 0;
    end;
    
    plot(x, y, 'bo');
    text(x + 1, y, int2str(i), 'Color', 'k');
end;




axis([0 x+10 -10 30]);

end

