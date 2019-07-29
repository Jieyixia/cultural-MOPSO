function param = select_pbest(param)
% pbest will be seleted as the a member of the archive that has
% the largest distance from all current populations
pop = param.pop;
pop_size = param.pop_size;
dim = param.dim;
f = param.f;
situational = param.situational;

param.pbest = zeros(pop_size, dim);
Np = zeros(pop_size, 1);
for i = 1 : pop_size
    arch_size = size(situational{i}, 1);
    max_dis_sqsum = 0;
    pbest_index = 0;
    for j = 1 : arch_size
        x_j = situational{i}(j, :);
        dis_sqsum = sum(sum((x_j - pop).^2)); 
        if dis_sqsum > max_dis_sqsum
            max_dis_sqsum = dis_sqsum;
            pbest_index = j;
        end
    end
    param.pbest(i, :) = situational{i}(pbest_index, :);
    obj_value = [f{1}(situational{i}), f{2}(situational{i})];
    Np(i) = cal_pbest_grid(obj_value, pbest_index);
end

param.Np_old = param.Np_new;
param.Np_new = Np;

end

% --------------------------------------------------------------
function np = cal_pbest_grid(obj_value, pbest_index)
num = size(obj_value, 1);
if num <= 2
    np = 1;
    return
end

U = max(obj_value, [], 1);
L = min(obj_value, [], 1);
grid_width = (U - L) ./ [3, 3];
grid = zeros(3, 3);

for i = 1 : num
    pos = ceil((obj_value(i, :) - L) ./ grid_width);
    pos = max(pos, 1);
    grid(pos(1), pos(2)) = grid(pos(1), pos(2)) + 1;
    if i == pbest_index
        pbest_pos = pos;
    end
end
np = grid(pbest_pos(1), pbest_pos(2));
end