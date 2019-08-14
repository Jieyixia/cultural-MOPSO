function pop = true_pf(func_name)
switch func_name
    case 'fon'
        t = linspace(-1/sqrt(3), 1/sqrt(3), 100);
        pop = [t; t; t];
        pop = pop';
 
end