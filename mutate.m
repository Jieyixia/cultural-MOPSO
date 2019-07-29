function param = mutate(param)
    
    mp = param.mp;
    dim = param.dim;
    phi = param.phi;
    upper_bound = param.upper_bound;
    lower_bound = param.lower_bound;
    
    Nd = param.pop_size - sum(phi); % number of dominated paricles
    
    Nm = round(mp * Nd);  % number of mutated particles
    mdim = round(mp * dim); % number of mutated dimensions
    Rm = mp * (upper_bound - lower_bound); % range of mutation
    
%     fprintf('Nm = %d, mdim = %d\n', Nm, mdim)
  
    if Nm == 0
        return
    end
    
    if mdim == 0
        return
    end
    
    dominant = find(phi == 0);
    dominant = dominant';
    
    count = 0;
    i_count = 0;
    for i = dominant(randperm(Nd))
   
        j_count = 0;
        for j = randperm(dim)    
            delta = Rm(j) * (2 * rand - 1);
            param.pop(i, j) = param.pop(i, j) + delta;
            
            %--------------------------------------------------------------------
            if param.pop(i, j) > upper_bound(j) || param.pop(i, j) < lower_bound(j)
                count = count + 1;
            end
            %--------------------------------------------------------------------
            param.pop(i, j) = min(param.pop(i, j), upper_bound(j));
            param.pop(i, j) = max(param.pop(i, j), lower_bound(j));
            
            j_count = j_count + 1;
            if j_count == mdim
                break
            end
            
        end
        
        i_count = i_count + 1;
        if i == Nm
            break
        end       
    end
    fprintf('±äÒì£º%d\n', count)
end 