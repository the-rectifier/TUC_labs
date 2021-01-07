function num_of_symbol_errors = symbol_errors(est_X, X)
est_X = round(est_X);
X = round(X);
num_of_symbol_errors = sum(sum(X ~= est_X));
end