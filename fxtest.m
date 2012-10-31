fxPrices = csvread('../Data/fxdata-final.txt');
fxReturns = price2ret(fxPrices);

uniformFxReturns = uniform(fxReturns);

[ fits ] = hacfit( 'clayton', uniformFxReturns );