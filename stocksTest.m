% Load Google and Intel Stock Prices
goog = csvread('Data/goog-20070101-20120101');
intc = csvread('Data/intc-20070101-20120101');

% Convert prices to log returns
googReturns = price2ret(goog);
intcReturns = price2ret(intc);

% Scatter
scatterhist(googReturns, intcReturns);

% Copula Summary
copulasummary('Gaussian', [googReturns intcReturns]);
