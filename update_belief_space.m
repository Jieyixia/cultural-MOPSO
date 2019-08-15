function param = update_belief_space(param)
grid_num = param.grid_num;
f = param.f;
g = param.g;
fn = numel(f);
gn = numel(g);

phi = param.phi;
obj_value = param.obj_value;
cv = param.cv;
pop = param.pop;
velocity = param.velocity;

% update situational knowledge(for every particle)
for i = 1 : param.pop_size
    x_i = pop(i, :);
    
    arch_size = size(param.situational{i}, 1);
    if arch_size == 0
        param.situational{i} = x_i;
        continue
    end
    
    obj_value_i = obj_value(i, :);
    cv_i = cv(i);
    
    dominated = [];
    for j = 1 : arch_size
        x_j = param.situational{i}(j, :);
        
        obj_value_j = zeros(1, fn);
        for obj_num = 1 : fn
            obj_value_j(obj_num) = f{obj_num}(x_j);
        end
        
        cv_j = 0;
        for cons_num = 1 : gn
            cons = g{cons_num}(x_j);
            cv_j = cv_j + cons * (cons > 0);         
        end
        
        flag_1 = isdominate([obj_value_i; obj_value_j], [cv_i; cv_j], fn);
        if flag_1 == 1 % find solutions dominated by x_i
            dominated = [dominated, j]; %#ok<AGROW>
        end
        
        flag_2 = isdominate([obj_value_j; obj_value_i], [cv_j; cv_i], fn);
        if flag_2 == 1 % find if any solution dominate x_i
            break
        end
    end
%     fprintf('flag_1 = %d, flag_2 = %d, d_num = %d\n', flag_1, flag_2, numel(dominated))
    if flag_2
        continue
    else
        param.situational{i} = [param.situational{i}; x_i];
    end
    
    % delete dominated solutions
    param.situational{i}(dominated, :) = [];
end

% update normative knowledge 设置断点检查下
selected = find(phi == 1);
selected = selected';

upper = max(obj_value(selected, :), [], 1);
lower = min(obj_value(selected, :), [], 1);

% param.normative_range(1, :) =  upper;
% param.normative_range(2, :) =  lower;
% 需要修改的地方
% 可以根据global archive来寻找当前的格子？
% 从global archive中寻找gbest而不是第t代的非支配解？
if sum(sum(param.normative_range)) == 0
    param.normative_range(1, :) =  upper;
    param.normative_range(2, :) =  lower;
else
    param.normative_range(1, :) = max(upper, param.normative_range(1, :));
    param.normative_range(2, :) = min(lower, param.normative_range(2, :));   
end

param.normative_velocity(1, :) = max(velocity(selected, :), [], 1);
param.normative_velocity(2, :) = min(velocity(selected, :), [], 1);

% update topographical knowledge
% fprintf('非支配解的个数%d\n', length(selected))
if length(selected) == 1
    disp('Warning(update belief space.m):only one nondominated solution!')
    param.grid = [];
    param.nondominant = [selected, 0, 0];
    return
end

% 增加判断是否所有的非支配解都一样？使zdt2能顺利运行？
param.grid = zeros(param.grid_num); 
param.gridwidth = (param.normative_range(1, :) - param.normative_range(2, :))./grid_num;
param.nondominant = [];
for i = selected
    obj_value_i = obj_value(i, :);
    grid_index = zeros(1, 2);
    for j = 1 : fn
        grid_index(j) = ceil((obj_value_i(j) -  param.normative_range(2, j)) / param.gridwidth(j));
        if grid_index(j) == 0
            grid_index(j) = 1;
        end
    end
%     grid_index
%     param.noramtive_range
%     param.gridwidth
    param.grid(grid_index(1), grid_index(2)) = param.grid(grid_index(1), grid_index(2)) + 1;
    param.nondominant = [param.nondominant; [i grid_index]];
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

end
