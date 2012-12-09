%% Independence copula
copulaimg(@(U) prod(U, 2), '../Images/independence-cdf.png');

%% Comonotonicity copula
copulaimg(@(U) min(U, [], 2), '../Images/comonotonicity-cdf.png');

%% Countermonotonicity copula
copulaimg(@(U) max(sum(U, 2) - 1, 0), '../Images/countermonotonicity-cdf.png');