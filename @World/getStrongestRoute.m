function path = getStrongestRoute(this, l)
% vrac� nejsiln�j�� cestu podle feromon�
[c start] = max(max(this.matrix(:, :, 2)));
path(1) = start;
k = 1;
i = start;
while(k < l)
    edges   = this.matrix(path(k), :, 2);   % hodnoty feromon� na hran�ch z uzlu vych�zej�c�ch
    edges(edges == inf) = 0;
    edges(isnan(edges)) = 0;
    k       = k + 1;                        % counter proti zacyklen� a k po��t�n� indexu
    [c, i]  = max(edges);
    
    while(ismember(i, path))                % dokud vede nejsiln�j�� cesta do nav�t�ven�ho m�sta
        edges(i) = 0;
        [c, i] = max(edges);
    end;
    
    path(k) = i;
end;

end

