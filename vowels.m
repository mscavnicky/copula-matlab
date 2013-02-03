%% Read data

speaker1 = dlmread('../Data/Vowels/speaker1.txt', ' ');
% dlm read reads 13 cols instead of 12
speaker1 = speaker1(:, 1:12);

U1 = uniform(speaker1);

%% Fit copulas to data

copula.eval('gaussian', U1, 100);
copula.eval('t', U1, 0); % Infeasible
copula.eval('clayton', U1, 100);
copula.eval('gumbel', U1, 10); % Infeasible
copula.eval('frank', U1, 10);

claytonTree = hac.fit('clayton', U1, 'okhrin');