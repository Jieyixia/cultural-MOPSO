function param = select_gbest(param)
grid = param.grid;
nondominant = param.nondominant;

if isempty(grid)
    disp('Warning(select_gbest.m):only one nondominated solution!')
    param.gbest = param.pop(nondominant(1), :);
    param.Ng_old = param.Ng_new;
    param.Ng_new = 1;
    return
end

% find cells containing nondominant solutions
[m, n] = find(grid > 0);
fit_value = zeros(length(m), 1);
for i = 1 : length(m)
    fit_value(i) = 10 / grid(m(i), n(i));
end

% roullete strategy to select a cell
cum_fit = cumsum(fit_value) / sum(fit_value);

p = rand;
selected_cell = find(p < cum_fit, 1);

% find nondominant solutions in the selected cell
t1 = nondominant(:, 2) == m(selected_cell);
t2 = nondominant(:, 3) == n(selected_cell);
t = t1 .* t2;
nd_in_cell = nondominant(t == 1, 1);
ndnum_in_cell = length(nd_in_cell);

% choose one nondominant solution as gbest
selected = nd_in_cell(ceil(rand * ndnum_in_cell));
param.gbest = param.pop(selected, :);

param.Ng_old = param.Ng_new;
param.Ng_new = ndnum_in_cell;

end