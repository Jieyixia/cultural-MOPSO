function param = influence_functions(param)
% update global accerleration
delta_Ng = param.Ng_old - param.Ng_new;
param.cg = param.cg + param.alpha * delta_Ng;
param.cg = max(param.cg, param.cg_min);
param.cg = min(param.cg, param.cg_max);

% update personal accerleration
delta_Np = param.Np_old - param.Np_new;
param.cp = param.cp + param.beta * delta_Np;
param.cp = max(param.cp, param.cp_min);
param.cp = min(param.cp, param.cp_max);

% update momentum
for i = 1 : param.pop_size
    t = param.velocity(i, :) < param.normative_velocity(2, :);
    param.w(i, :) = param.w(i, :) + t * param.delta_w;
    
    t = param.velocity(i, :) > param.normative_velocity(1, :);
    param.w(i, :) = param.w(i, :) - t * param.delta_w;
    
    param.w(i, :) = max(param.w(i, :), param.w_min);
    param.w(i, :) = min(param.w(i, :), param.w_max);
    
end

end