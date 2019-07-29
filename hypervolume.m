function v = hypervolume(p_f)
    % calculate hypervolume of a pareto front
    
    func_num = size(p_f, 2);
    n = length(p_f);
    r = max(p_f) + 1; % reference point
    
    diff = r - p_f;
    v = diff(:, 1);
    for i = 2 : func_num
        v = v .* diff(:, i);
    end
    v = sum(v) / n;
    
end