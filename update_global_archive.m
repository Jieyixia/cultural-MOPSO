function param = update_global_archive(param)
phi = param.phi;
pop = param.pop;
nondominant = find(phi == 1);
nondominant = nondominant';

if isempty(param.global_archive)
    param.global_archive = [param.global_archive; pop(nondominant, :)];
    return
end

obj_value = param.obj_value;
cv = param.cv;
f = param.f;
g = param.g;
fn = length(f);
gn = length(g);

global_archive_size = size(param.global_archive, 1);
obj_value_ga = zeros(global_archive_size, fn);
cv_ga = zeros(global_archive_size, 1);
for i = 1 : fn
    obj_value_ga(:, i) = f{i}(param.global_archive);
end

for i = 1 : gn
    temp = g{i}(param.global_archive);
    cv_ga(:, i) = cv_ga(:, i) + temp .* (temp > 0);
end

add = [];
delete = [];
for i = nondominant
    
    obj_value_i = obj_value(i, :);
    cv_i = cv(i, :);
    
    dominated = [];
    for j = 1 : global_archive_size
        
        obj_value_j = obj_value_ga(j, :);
        cv_j = cv_ga(j);
        
        flag_1 = is_weak_dominate([obj_value_i; obj_value_j], [cv_i; cv_j], fn);
        if flag_1 == 1 % find solutions dominated by x_i
            dominated = [dominated, j]; %#ok<AGROW>
        end
        
        flag_2 = is_weak_dominate([obj_value_j; obj_value_i], [cv_j; cv_i], fn);
        if flag_2 == 1 % find if any solution week dominate x_i
            break
        end
        
    end
    
    if flag_2
        continue
    else
        add = [add, i];
        delete = [delete, dominated];
    end
    
    
end

delete = unique(delete);
param.global_archive(delete, :) = [];
param.global_archive = [param.global_archive; pop(add, :)];

ga_size = size(param.global_archive, 1);
fprintf('size of global archive:%d\n', ga_size)

end

function flag = is_weak_dominate(obj_value, cv, fn)
    
    flag = 0; 
    if cv(1) == 0 && cv(2) == 0     
        % if both solutions are feasible
        diff = obj_value(1, :) - obj_value(2, :);    
        if  length(find(diff <= 0)) == fn 
            flag = 1;
            return
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
