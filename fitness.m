function param = fitness(param)
% fitness assignment(based on nondominated level)
% 
% param:
% pop:  population
% phi: non-dominant level of each candidate solution
% obj_value: objective function value for each individual
    
    pop = param.pop;
    pop_size = param.pop_size;
    
    % calculate objective function values
    f = param.f;
    g = param.g;
    fn = numel(f);
    gn = numel(g);
    obj_value = zeros(pop_size, fn);
    cv = zeros(pop_size, 1);
    for i = 1 : fn
        obj_value(:, i) = f{i}(pop);
        
    end
    for i = 1 : gn
        temp = g{i}(pop);
        cv = cv + temp .* (temp > 0); 
    end
    
    % find the individuals in the first non-dominant level
    S = cell(pop_size, 1);
    n = zeros(pop_size, 1);
    phi = zeros(pop_size, 1);
    
    for i = 1 : pop_size
        S{i} = [];
        for j = 1 : pop_size
            if isdominate(obj_value([i, j], :), cv([i, j]), fn) 
                % individual i dominates individual j
                S{i} = [S{i}; j];
            else
                if isdominate(obj_value([j, i], :), cv([j, i]), fn)
                    % individual j dominates individual i
                    n(i) = n(i) + 1;
                end
            end
        end
        if n(i) == 0
            phi(i) = 1;
        end
    end
    
    param.phi = phi;
    param.obj_value = obj_value;
    param.cv = cv;

end

% -------------------------------------------------------------------------
function flag = isdominate(obj_value, cv, fn)
    
    flag = 0; 
    if cv(1) == 0 && cv(2) == 0     
        % if both solutions are feasible
        diff = obj_value(1, :) - obj_value(2, :);    
        if  length(find(diff <= 0)) == fn 
            if length(find(diff < 0)) >= 1
                flag = 1;
                return
            end
        end
    end

    if cv(1) == 0 && cv(2) > 0
        % if one is feasible, the other is not
        flag = 1;
        return
    end

    if cv(1) > 0 && cv(2) > 0
        % if both are infeasible
        if cv(1) < cv(2)
            flag = 1;
            return
        end
    end
end