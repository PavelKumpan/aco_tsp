function bestRoute = tsp(map, params, onIter)
% map (matrix [num, num])   - matice sousednosti reprezentuj�c� mapu sv�ta
% params (struct)           - struktura s parametry
% onIter (function handle)  - funkce volan� p�i ukon�en� iterace
% 
% returns bestRoute (vector [n])  - vektor nejlep�� nalezen� cesty
% 
%                \   /              
%                 \_/
%            __   /^\   __
%           '  `. \_/ ,'  `
%                \/ \/     
%           _,--./| |\.--._  
%        _,'   _.-\_/-._   `._
%             |   / \   |
%             |  /   \  |
%            /   |   |   \
%          -'    \___/    `-
%
%
%% Deklarace parametr�

global phe0;
global ro;
global phi;

colonySize  = params.colonySize;    % velikost kolonie
maxIter     = params.maxIter;       % po�et iterac�
q0          = params.q0;            % parametr definuj�c� pravd�podobnost v�b�ru cesty dle feromon� / n�hodn�ho v�b�ru cesty
beta    	= params.beta;          % parametr relativn� v�hy dohlednosti
alpha       = params.alpha;         % parametr relativn� v�hy feromonov� stopy
ro          = params.ro;            % parametr ��d�c� rozklad feromonu
phi         = params.phi;           % rychlost vypa�ov�n� feromonu 
phe0        = 1;                    % v�choz� hladina feromonu na hran�

%% Vytvo�en� mapy

clear graph;
[mapSize, l] = size(map);
global graph;
graph = World(map);
graph = setGlobalPheromone(graph, phe0);

%% Hlavn� cyklus

clear bestRoute;
bestRoute   = [];
iterCount   = 0;    % po�et iterac�
inIter      = 0;    % ve kter� iteraci byla nalezena nejlep�� cesta

while(iterCount < maxIter)
    tic
    iterCount = iterCount + 1;
    
    % ---------------------------------------------------------------------
    % Vytvo�en� kolonie a n�hodn� rozm�st�n� mravenc�
    
    clear colony;
    colony = cell(colonySize, 1);
    for(i = 1:colonySize)
        node = randi([1, mapSize], 1);          % vybr�n� n�hodn�ho uzlu
        colony{i} = Ant();                      % narozen�
        colony{i} = setNode(colony{i}, node);   % um�st�n� mravence do n�hodn�ho uzlu
    end;
    
    % ---------------------------------------------------------------------
    % Cyklus kolonie

    for(k = 1:colonySize)       % pro v�echny v kolonii, cyklus prob�h� paraleln�
        ant = colony{k};        % lok�ln� kopie mravence
        hasPath = 1;            % definuje zda exituje cesta kterou mravenec m��e pou��t
        c = 0;                  % po��tadlo iterac� cesty mravence
        
        % -----------------------------------------------------------------
        % Cyklus cesty jednoho mravence
        
        while(hasPath && c <= mapSize)
            c = c + 1;
            
            % -------------------------------------------------------------
            % V�b�r cesty
        
            node = getNode(ant);                    % uzel ve kter�m je mravenec
            candidates = getPaths(graph, node);     % matice cest [vzd�lenost; feromon]
            route = getRoute(ant);                  % mravencova cesta dosud
            for(j = 1:length(route))                % odstran�n� u� nav�t�ven�ch uzl� z kandid�t�
                candidates(1, route(j), :) = [0 0];
            end;
            candidates(1, candidates == inf, 1) = 0;
            candidates(1, isnan(candidates), 1) = 0;
            
            if(sum(candidates(1, :, 1)) <= 0)       % nejsou-li k dispozici ��dn� m�sta, kam by mohl j�t, cyklus kon��
                hasPath = 0;
            else                                    % pokud m�me n�jak� kandid�ty
                hasPath = 1;
                q = rand(1);                        % n�hodn� rozhodnut� o zp�sobu rozhodov�n�
                
                visibility = (1./(candidates(1, :, 1)));        % dohlednost, stanov� se jako p�evr�cen� hodnota vzd�lenosti - mal� vzd�lenosti -> velk� dohlednost
                visibility(visibility == inf)   = 0;            % odstran�n� nesmysln�ch hodot
                visibility(isnan(visibility))   = 0;
                
                pheromones = candidates(1, :, 2);               % z�sk�n� feromon�
                pheromones(pheromones == inf)   = 0;            % odstran�n� nesmysln�ch hodot
                pheromones(isnan(pheromones))   = 0;

                if(q <= q0) 	% volba cesty na z�klad� feromon�
                    [i, node] = max(pheromones.^alpha .* visibility.^beta);  % jako maximum z ohodnocen� hran
                    if(i == 0)
                        hasPath = 0; 	% pokud je maximum 0, u� nen� ��dn� cesta po kter� by �lo j�t
                    end
                else            % n�hodn� na z�klad� p�i�azen� pravd�podobnost�     
                    S = sum(pheromones.^alpha .* visibility.^beta);
                    p =    (pheromones.^alpha .* visibility.^beta) ./ S;   % ka�d� cest� se p�i�ad� pravd�podobnost reflektuj�c� s�lu feromonu i dohlednost
                    nodes = randperm(length(p));            % vygeneruje n�hodn� po�ad� proch�zen� uzl�
                    i = 0;
                    prob = rand(1);
                    while((prob > 0) && (i < length(p)))   % algoritmus n�hodn�ho v�b�ru se zohled�en�m pravd�podobnosti
                        i = i + 1;
                        prob = prob - p(nodes(i));
                    end;
                    node = nodes(i);        % pou�it� vybran�ho uzlu
                end;  
                ant = setNode(ant, node);	% p�echod mravence do nov�ho uzlu
            end;
        end;
        colony{k} = ant;    % vr�cen� mravence do kolonie
    end;      
    % / konec cyklu kolonie
    
    % ---------------------------------------------------------------------
    % Glob�ln� odpa�en� feromonov�ch stop
    
    graph = evaporatePheromone(graph);
    
    % ---------------------------------------------------------------------
    % Vyhodnocen� u�ite�nosti cest
        
    for(k = 1:colonySize)       % pro v�echny v kolonii       
        ant = colony{k}; 
        route = getRoute(ant);  % pokud je mravencova cesta neu�ite�n� - z konce se nedostane na start nebo m�-li cesta d�lku jedna, zatrest zabijeme mravence
        if(getEdge(graph, getNode(ant), route(1)) == 0 || length(route) == 1)
            ant = die(ant);   
        else                    % pokud je u�ite�n�, aktualizujeme na n� feromonovou stopu
            graph = actualizePheromones(graph, route);
        end;
        colony{k} = ant;        % vr�cen� mravence do kolonie
    end;
    
    % ---------------------------------------------------------------------
    % V�b�r nejkvalitn�j�� pro�l� cesty
    
    for(k = 1:colonySize)
        ant = colony{k};
        route = getRoute(ant);
        if(isLive(ant) && length(route) == mapSize)     % je mravenec �iv� (cesta m� smysl) a m� spr�vnou d�lku
            if(isempty(bestRoute) || getRouteLength(graph, route) < getRouteLength(graph, bestRoute))
                bestRoute = route;
                inIter = iterCount;
            end;
        end;        
    end;
        
    % ---------------------------------------------------------------------
    % Porovn�n� nejlep�� mraven�� cesty s nejlep�� feromonovou stopou
    
    strongestRoute = getStrongestRoute(graph, mapSize);
    if(getRouteLength(graph, strongestRoute) < getRouteLength(graph, bestRoute))
        bestRoute = strongestRoute;
        inIter = iterCount;
    end;
    
   toc

    % ---------------------------------------------------------------------
    % Vykreslov�n�
    
    onIter(graph, bestRoute);
end;

%% Zobrazen� v�sledk�

bestRoute
if(length(unique(bestRoute)) == length(bestRoute) && mapSize == length(bestRoute))
    disp('Nalezen� cesta �e�� TSP');
else
    disp('CESTA NE�E�� TSP!');
end;
routeLength = getRouteLength(graph, bestRoute)
inIter

