% cultural-based multiobjective particle swarm optimization
% 代码还没有调通
% init_param里的参数设置还没有参考文献

param = init_param('kur', 'real');
param = problems('kur', param);

% initialize pop space
param = init_pop_space(param);

% initialize belief space
param = init_belief_space(param);

% iteration times
T = 100;
for t = 1 : T
    t
    % evaluate pop_space
    param = fitness(param);

    % mutate
    param.mp = (1 - t / T)^(5 / param.pm);
    param = mutate(param);
    
    % update belief_space
    param = update_belief_space(param);
    
    % select gbest and pbest
    param = select_gbest(param);
    param = select_pbest(param);
   
    % adapt the accerleration and momentum
    param = influence_functions(param);
    
    % update the global archive
    param = update_global_archive(param);
    
    % update pop_space
    param = update_pop_space(param);
    
   
    % visualize
    if mod(t, 20) == 0
        p_f1 = param.f{1}(param.global_archive);
        p_f2 = param.f{2}(param.global_archive);

        figure
        plot(p_f1, p_f2, '*')
        title(['No.', num2str(t), 'th iteration'])
        
        p_f = [p_f1, p_f2];
        v = hypervolume(p_f);
        fprintf('t = %d, hypervolume = %f\n', t, v)
    end
end