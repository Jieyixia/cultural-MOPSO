function phi = find_nondominant(param)
% % 判断global_archive中的解是否互相不支配
% % calculate objective function values
f = param.f;
g = param.g;
fn = numel(f);
gn = numel(g);

global_archive = param.global_archive;
ga_size = size(global_archive, 1);
obj_value = zeros(ga_size, fn);
cv = zeros(ga_size, 1);
for i = 1 : fn
    obj_value(:, i) = f{i}(param.global_archive);

end

for i = 1 : gn
    temp = g{i}(param.global_archive);
    cv = cv + temp .* (temp > 0); 
end

n = zeros(ga_size, 1);
phi = zeros(ga_size, 1);

for i = 1 : ga_size
    for j = 1 : ga_size
        if isdominate(obj_value([j, i], :), cv([j, i]), fn)
            % individual j dominates individual i
            n(i) = n(i) + 1;
        end
    end
    if n(i) == 0
        phi(i) = 1;
    end
end
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