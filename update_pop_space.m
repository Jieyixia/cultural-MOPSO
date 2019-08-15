function param = update_pop_space(param)
cg = param.cg;
cp = param.cp;
w = param.w;
pbest = param.pbest;
gbest = param.gbest;
pop = param.pop;
velocity = param.velocity;

r1 = rand;
r2 = rand;

param.velocity = w .* velocity + r1 * cp .* (pbest - pop) + r2 * cg * (gbest - pop);
param.pop = pop + param.velocity;
count = 0;
for i = 1 : param.dim
    count = sum(param.pop(:, i) > param.upper_bound(i)) + sum(param.pop(:, i) < param.lower_bound(i));
    
%     % -----------------------------------------------------------
%     param.velocity(:, i) = (2 * (param.pop(:, i) < param.upper_bound(i)) - 1) .* param.velocity(:, i);
%     param.velocity(:, i) = (2 * (param.pop(:, i) > param.lower_bound(i)) - 1) .* param.velocity(:, i);
%     % -----------------------------------------------------------
    
    param.pop(:, i) = max(param.pop(:, i), param.lower_bound(i));
    param.pop(:, i) = min(param.pop(:, i), param.upper_bound(i));
    
    
end
fprintf('¸üÐÂ:%d\n', count)
end