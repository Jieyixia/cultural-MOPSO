function param = problems(func_name, param)
% f: a cell array storing objective functions
% g: a cell array storing constraints

    func_name = lower(func_name);
    switch func_name
        case 'srn'
            f = cell(2, 1);
            f{1} = @(x)(x(:, 1) - 2).^2 + (x(:, 2) - 1).^2 + 2;
            f{2} = @(x)9 * x(:, 1) - (x(:, 2) - 1).^2;
            
            g = cell(2, 1);
            g{1} = @(x)x(:, 1).^2 + x(:, 2).^2 - 225;
            g{2} = @(x)x(:, 1) - 3 * x(:, 2) + 10;  
            
        case 'sch'
            f =  cell(2, 1);
            f{1} = @(x)(x - 2).^2;
            f{2} = @(x)x.^2;
            
            g = [];
        
        case 'zdt1'
            f = cell(2, 1);
            f{1} = @(x)x(:, 1);
            
            p = @(x)(1 + 9 * sum(x(:, 2 : end), 2) / 29);
            f{2} = @(x)p(x) .* (1 - sqrt(x(:, 1) ./ p(x)));
            
            g = [];
        
        case 'zdt2'
            f = cell(2, 1);
            f{1} = @(x)x(:, 1);
            
            p = @(x)(1 + 9 * sum(x(:, 2 : end), 2) / 29);
            f{2} = @(x)p(x) .* (1 - (x(:, 1)./ p(x)).^2);
            
            g = [];
            
        case 'zdt3'
            f = cell(2, 1);
            f{1} = @(x)x(:, 1);
            
            p = @(x)(1 + 9 * sum(x(:, 2 : end), 2) / 29);
            f{2} = @(x)p(x) .* (1 - sqrt(x(:, 1) ./ p(x)) - x(:, 1)./ p(x) .* sin(10 * pi * x(:, 1)));
            
            g = [];
            
        case 'zdt4'
            f = cell(2, 1);
            f{1} = @(x)x(:, 1);
            
            p = @(x)(1 + 90 + sum(x(:, 2 : end).^2 - 10 * cos(4 * pi * x(:, 2 : end)), 2));
            f{2} = @(x)p(x) .* (1 - sqrt(x(:, 1) ./ p(x)));
            
            g = [];
            
        case 'zdt6'
            f = cell(2, 1);
            f{1} = @(x)1 - exp(-4 * x(:, 1)) .* sin(6 * pi * x(:, 1)).^6;
            
            p = @(x)1 + 9 * (sum(x(:, 2 : end), 2) / 9).^0.25;
            f{2} = @(x)p(x).* (1 - (f{1}(x)./ p(x)).^2);
            
            g = [];
            
        case 'fon'
            f = cell(2, 1);
            f{1} = @(x)1 - exp(-sum((x - 1/sqrt(3)).^2, 2));
            f{2} = @(x)1 - exp(-sum((x + 1/sqrt(3)).^2, 2));
            
            g = [];
            
        case 'kur'
            f = cell(2, 1);
            f{1} = @(x)-10 * (exp(-0.2 * sqrt(x(:, 1).^2 + x(:, 2).^2)) + exp(-0.2 * sqrt(x(:, 2).^2 + x(:, 3).^2)));
            f{2} = @(x)sum(abs(x).^0.8 + 5 * sin(x.^3), 2);
            
            g = [];
    end
    param.f = f;
    param.g = g;
    
end