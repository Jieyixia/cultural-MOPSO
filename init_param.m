function param = init_param(func_name, encoding)

    func_name = lower(func_name);
    encoding = lower(encoding);

    param.pop_size = 200;
    param.func_name = func_name;
    param.encoding = encoding;
    
    param.global_archive = [];
    param.max_global_archive_size = 100;
    
    switch func_name
        case 'sch'
            param.dim = 1;
            param.upper_bound = ones(1, param.dim) * 1000;
            param.lower_bound = -ones(1, param.dim) * 1000;
            param.chrom_length = 30;
            
            
        case 'srn'
            param.dim = 2;
            param.upper_bound = ones(1, param.dim) * 20;
            param.lower_bound = -ones(1, param.dim) * 20;
            param.chrom_length = 30;
            
        
        case 'zdt1'
            param.dim = 30;
            param.upper_bound = ones(1, param.dim);
            param.lower_bound = zeros(1, param.dim);
            param.chrom_length = 30;
            
        case 'zdt2'
            param.dim = 30;
            param.upper_bound = ones(1, param.dim);
            param.lower_bound = zeros(1, param.dim);
            param.chrom_length = 30;
            
        case 'zdt3'
            param.dim = 30;
            param.upper_bound = ones(1, param.dim);
            param.lower_bound = zeros(1, param.dim);
            param.chrom_length = 30;
            
        case 'zdt4'
            param.dim = 10;
            param.upper_bound = ones(1, param.dim) * 5;
            param.lower_bound = ones(1, param.dim) * -5;
            param.upper_bound(1) = 1;
            param.lower_bound(1) = 0;
            param.chrom_length = 30;
            
        case 'zdt6'
            param.dim = 10;
            param.upper_bound = ones(1, param.dim);
            param.lower_bound = zeros(1, param.dim);
            param.chrom_length = 30;
            
        case 'fon'
            param.dim = 3;
            param.upper_bound = ones(1, param.dim) * 4;
            param.lower_bound = ones(1, param.dim) * -4;
            param.chrom_length = 30;
            
        case 'kur'
            param.dim = 3;
            param.upper_bound = ones(1, param.dim) * 5;
            param.lower_bound = ones(1, param.dim) * -5;
            param.chrom_length = 30;
    end

    if strcmpi(encoding, 'real')
        param.pc = 0.9;
        param.pm = 2;
%         param.pm = 1 / param.dim;
%         param.eta_c = 20;
%         param.eta_m = 20;
    end
    
    if strcmpi(encoding, 'binary') 
        param.pc = 0.9;
        param.pm = 1 /  param.chrom_length; 
    end
    
    % cg, cp和w的设置还需要参考文献
    
    param.cg_max = 3;
    param.cg_min = 1;
    param.cg = rand * (param.cg_max - param.cg_min) + param.cg_min;
    param.alpha = 1;
    
    % ???这里的初始值应该怎么设置???
    param.Ng_old = 1;
    param.Ng_new = 1;
    
    param.cp_max = 3;
    param.cp_min = 1;
    param.cp = rand(param.pop_size, 1) * (param.cp_max - param.cp_min) + param.cp_min;
    param.beta = 1;
    
    param.Np_old = ones(param.pop_size, 1);
    param.Np_new = ones(param.pop_size, 1);
    
    param.w_max = 0.9;
    param.w_min = 0.1;
    param.w = rand(param.pop_size, param.dim) * (param.w_max - param.w_min) + param.w_min;
    param.delta_w = 0.1;
    
    param.grid_num = [4, 4]; 
    
end