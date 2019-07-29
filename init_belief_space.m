function param = init_belief_space(param)
% initialize belief space

    param.situational = cell(param.pop_size, 1);
%     for i = 1 : param.pop_size
%         param.situational{i} = param.pop(i, :);
%     end
    param.normative_range = zeros(2, numel(param.f));
    param.normative_velocity = zeros(2, param.dim);
    
end
