function path = getStrongestRoute(this, l)
% vrací nejsilnìjší cestu podle feromonù
[c start] = max(max(this.matrix(:, :, 2)));
path(1) = start;
k = 1;
i = start;
while(k < l)
    edges   = this.matrix(path(k), :, 2);   % hodnoty feromonù na hranách z uzlu vycházejících
    edges(edges == inf) = 0;
    edges(isnan(edges)) = 0;
    k       = k + 1;                        % counter proti zacyklení a k poèítání indexu
    [c, i]  = max(edges);
    
    while(ismember(i, path))                % dokud vede nejsilnìjší cesta do navštíveného mìsta
        edges(i) = 0;
        [c, i] = max(edges);
    end;
    
    path(k) = i;
end;

end

