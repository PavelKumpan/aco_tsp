function  this = go(this, paths)
% funkce na z�klad� vektoru cest vybere cestu s
% nejsiln�j�� feromonovou stopou a vr�t� jej� index,
% nastav� uzel na dal��

% p�id�me n�hodnou veli�inu, hladinu feromon� zvedeneme o n�hodn� ��slo
% <0 ; max() / 2>
    p = 0.5; % konstanta n�hodnosti;
    routeL = length(this.route);
    [c,i] = max(paths(:));
    if(c == 0)
        c = 1;
    end;
    paths = paths + rand(size(paths)) * p * c;
    if(routeL > 1)
        prevNode = this.route(routeL-1);
    else
        prevNode = 0;
    end;
    
	[c,i] = max(paths(:));   
    this.node = i; % nastaven� nov�ho uzlu
    paths(i) = 0;
    while(this.node == prevNode)
        [c,i] = max(paths(:));
        paths(i) = 0;
        if(sum(paths) == 0)
            this.alive = 0;
            return;
        end;
        this.node = i; % nastaven� nov�ho uzlu
    end;
    
    this.route(routeL + 1) = this.node; % p�id�n� dal��ho uzlu do pro�l� trasy
end

