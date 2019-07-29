function param = init_pop(param)
% generate initial population
% 
% param:
% pop_size: the size of the population
% dim: number of decision variables
% upper_bound: upper bound of each decision variable
% lower_bound: lower bound of each decision variable
% encoding: the encoding of population
%
% pop: generated population

    
    if strcmpi(param.encoding, 'binary')
        param.pop = init_bi_pop(param);
    end
    
    if strcmpi(param.encoding, 'real')
        param.pop = init_real_pop(param);
    end
    
    param.velocity = init_velocity(param);
        
end

% -------------------------------------------------------------------------
function pop = init_real_pop(param)
% generate initial decimal coded population
    
    pop_size = param.pop_size;
    dim = param.dim;
    U = param.upper_bound;
    L = param.lower_bound;
    
    pop = L + (U - L) .* rand(pop_size, dim);
end

% -------------------------------------------------------------------------
function pop = init_bi_pop(param)
% generate initial binary coded population
    
    pop_size = param.pop_size;
    dim = param.dim;
    chrom_length = param.chrom_length;
  
    pop = round(rand(pop_size, chrom_length * dim));
    
end

% -------------------------------------------------------------------------
function velocity = init_velocity(param)
    velocity = zeros(param.pop_size, param.dim);
end
