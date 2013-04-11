function  this = go(this, paths)
% funkce na základì vektoru cest vybere cestu s
% nejsilnìjší feromonovou stopou a vrátí její index,
% nastaví uzel na další

% pøidáme náhodnou velièinu, hladinu feromonù zvedeneme o náhodné èíslo
% <0 ; max() / 2>
    p = 0.5; % konstanta náhodnosti;
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
    this.node = i; % nastavení nového uzlu
    paths(i) = 0;
    while(this.node == prevNode)
        [c,i] = max(paths(:));
        paths(i) = 0;
        if(sum(paths) == 0)
            this.alive = 0;
            return;
        end;
        this.node = i; % nastavení nového uzlu
    end;
    
    this.route(routeL + 1) = this.node; % pøidání dalšího uzlu do prošlé trasy
end

