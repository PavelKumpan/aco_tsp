function bestRoute = tsp(map, params, onIter)
% map (matrix [num, num])   - matice sousednosti reprezentující mapu svìta
% params (struct)           - struktura s parametry
% onIter (function handle)  - funkce volaná pøi ukonèení iterace
% 
% returns bestRoute (vector [n])  - vektor nejlepší nalezené cesty
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
%% Deklarace parametrù

global phe0;
global ro;
global phi;

colonySize  = params.colonySize;    % velikost kolonie
maxIter     = params.maxIter;       % poèet iterací
q0          = params.q0;            % parametr definující pravdìpodobnost výbìru cesty dle feromonù / náhodného výbìru cesty
beta    	= params.beta;          % parametr relativní váhy dohlednosti
alpha       = params.alpha;         % parametr relativní váhy feromonové stopy
ro          = params.ro;            % parametr øídící rozklad feromonu
phi         = params.phi;           % rychlost vypaøování feromonu 
phe0        = 1;                    % výchozí hladina feromonu na hranì

%% Vytvoøení mapy

clear graph;
[mapSize, l] = size(map);
global graph;
graph = World(map);
graph = setGlobalPheromone(graph, phe0);

%% Hlavní cyklus

clear bestRoute;
bestRoute   = [];
iterCount   = 0;    % poèet iterací
inIter      = 0;    % ve které iteraci byla nalezena nejlepší cesta

while(iterCount < maxIter)
    tic
    iterCount = iterCount + 1;
    
    % ---------------------------------------------------------------------
    % Vytvoøení kolonie a náhodné rozmístìní mravencù
    
    clear colony;
    colony = cell(colonySize, 1);
    for(i = 1:colonySize)
        node = randi([1, mapSize], 1);          % vybrání náhodného uzlu
        colony{i} = Ant();                      % narození
        colony{i} = setNode(colony{i}, node);   % umístìní mravence do náhodného uzlu
    end;
    
    % ---------------------------------------------------------------------
    % Cyklus kolonie

    for(k = 1:colonySize)       % pro všechny v kolonii, cyklus probíhá paralelnì
        ant = colony{k};        % lokální kopie mravence
        hasPath = 1;            % definuje zda exituje cesta kterou mravenec mùže použít
        c = 0;                  % poèítadlo iterací cesty mravence
        
        % -----------------------------------------------------------------
        % Cyklus cesty jednoho mravence
        
        while(hasPath && c <= mapSize)
            c = c + 1;
            
            % -------------------------------------------------------------
            % Výbìr cesty
        
            node = getNode(ant);                    % uzel ve kterém je mravenec
            candidates = getPaths(graph, node);     % matice cest [vzdálenost; feromon]
            route = getRoute(ant);                  % mravencova cesta dosud
            for(j = 1:length(route))                % odstranìní už navštívených uzlù z kandidátù
                candidates(1, route(j), :) = [0 0];
            end;
            candidates(1, candidates == inf, 1) = 0;
            candidates(1, isnan(candidates), 1) = 0;
            
            if(sum(candidates(1, :, 1)) <= 0)       % nejsou-li k dispozici žádná mìsta, kam by mohl jít, cyklus konèí
                hasPath = 0;
            else                                    % pokud máme nìjaké kandidáty
                hasPath = 1;
                q = rand(1);                        % náhodné rozhodnutí o zpùsobu rozhodování
                
                visibility = (1./(candidates(1, :, 1)));        % dohlednost, stanoví se jako pøevrácená hodnota vzdálenosti - malé vzdálenosti -> velká dohlednost
                visibility(visibility == inf)   = 0;            % odstranìní nesmyslných hodot
                visibility(isnan(visibility))   = 0;
                
                pheromones = candidates(1, :, 2);               % získání feromonù
                pheromones(pheromones == inf)   = 0;            % odstranìní nesmyslných hodot
                pheromones(isnan(pheromones))   = 0;

                if(q <= q0) 	% volba cesty na základì feromonù
                    [i, node] = max(pheromones.^alpha .* visibility.^beta);  % jako maximum z ohodnocení hran
                    if(i == 0)
                        hasPath = 0; 	% pokud je maximum 0, už není žádná cesta po které by šlo jít
                    end
                else            % náhodnì na základì pøiøazení pravdìpodobností     
                    S = sum(pheromones.^alpha .* visibility.^beta);
                    p =    (pheromones.^alpha .* visibility.^beta) ./ S;   % každé cestì se pøiøadí pravdìpodobnost reflektující sílu feromonu i dohlednost
                    nodes = randperm(length(p));            % vygeneruje náhodné poøadí procházení uzlù
                    i = 0;
                    prob = rand(1);
                    while((prob > 0) && (i < length(p)))   % algoritmus náhodného výbìru se zohledòením pravdìpodobnosti
                        i = i + 1;
                        prob = prob - p(nodes(i));
                    end;
                    node = nodes(i);        % použití vybraného uzlu
                end;  
                ant = setNode(ant, node);	% pøechod mravence do nového uzlu
            end;
        end;
        colony{k} = ant;    % vrácení mravence do kolonie
    end;      
    % / konec cyklu kolonie
    
    % ---------------------------------------------------------------------
    % Globální odpaøení feromonových stop
    
    graph = evaporatePheromone(graph);
    
    % ---------------------------------------------------------------------
    % Vyhodnocení užiteènosti cest
        
    for(k = 1:colonySize)       % pro všechny v kolonii       
        ant = colony{k}; 
        route = getRoute(ant);  % pokud je mravencova cesta neužiteèná - z konce se nedostane na start nebo má-li cesta délku jedna, zatrest zabijeme mravence
        if(getEdge(graph, getNode(ant), route(1)) == 0 || length(route) == 1)
            ant = die(ant);   
        else                    % pokud je užiteèná, aktualizujeme na ní feromonovou stopu
            graph = actualizePheromones(graph, route);
        end;
        colony{k} = ant;        % vrácení mravence do kolonie
    end;
    
    % ---------------------------------------------------------------------
    % Výbìr nejkvalitnìjší prošlé cesty
    
    for(k = 1:colonySize)
        ant = colony{k};
        route = getRoute(ant);
        if(isLive(ant) && length(route) == mapSize)     % je mravenec živý (cesta má smysl) a má správnou délku
            if(isempty(bestRoute) || getRouteLength(graph, route) < getRouteLength(graph, bestRoute))
                bestRoute = route;
                inIter = iterCount;
            end;
        end;        
    end;
        
    % ---------------------------------------------------------------------
    % Porovnání nejlepší mravenèí cesty s nejlepší feromonovou stopou
    
    strongestRoute = getStrongestRoute(graph, mapSize);
    if(getRouteLength(graph, strongestRoute) < getRouteLength(graph, bestRoute))
        bestRoute = strongestRoute;
        inIter = iterCount;
    end;
    
   toc

    % ---------------------------------------------------------------------
    % Vykreslování
    
    onIter(graph, bestRoute);
end;

%% Zobrazení výsledkù

bestRoute
if(length(unique(bestRoute)) == length(bestRoute) && mapSize == length(bestRoute))
    disp('Nalezená cesta øeší TSP');
else
    disp('CESTA NEØEŠÍ TSP!');
end;
routeLength = getRouteLength(graph, bestRoute)
inIter

