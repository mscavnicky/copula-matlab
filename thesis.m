%% Independence copula
copulaimg(@(U) prod(U, 2), '../Images/independence-cdf.png');

%% Comonotonicity copula
copulaimg(@(U) min(U, [], 2), '../Images/comonotonicity-cdf.png');

%% Countermonotonicity copula
copulaimg(@(U) max(sum(U, 2) - 1, 0), '../Images/countermonotonicity-cdf.png');

%% Guassian copula
copulaimg(@(U) copulapdf('gaussian', U, 0.3), '../Images/gaussian-pdf.png', 20, 0.05, 0.95);

%% Student-t copula
copulaimg(@(U) copulapdf('t', U, 0.3, 3), '../Images/student-pdf.png', 20, 0.05, 0.95);