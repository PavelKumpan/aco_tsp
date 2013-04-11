function this = World(matrix)

[m, n] = size(matrix);

if(m == 1 && n == 1)
    this.matrix = generate(matrix);
else
    this.matrix = matrix;
    this.matrix(:, :, 2) = 1;
end;

this = class(this, 'World');


    function matrix = generate(n)
        matrix = zeros(n, n, 1);
        for(i = 1:n)
            for(j = i+1:n)
                matrix(i, j, 1) = round(rand(1)*0.7) * (j - i + 1);
            end;
        end;
        matrix = matrix + matrix';
        matrix(:, :, 2) = zeros(n);
    end
end

