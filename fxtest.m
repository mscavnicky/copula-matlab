%% FX Rates 
% Dataset consists of 4 columns: CAD, EUR, GBP, JPY

d = 4;
names = {'CAD', 'EUR', 'GBP', 'JPY'};

%% Read prices data and create returns

fxPrices = csvread('../Data/fxdata-final.txt');
fxReturns = price2ret(fxPrices);

%% Plot prices

figure
for i=1:d
    subplot(2,2,i);
    plot(fxPrices(:,i));
    title(names{i});
end

%% Plot returns

figure
for i=1:d
    subplot(2,2,i);
    plot(fxReturns(:,i));
    ylim([-0.05, 0.05]);
    title(names{i});
end


%% Other stuff

mean(fxReturns)
std(fxReturns)
kurtosis(fxReturns)
skewness(fxReturns)

[h1, p1] = jbtest(fxReturns(:,1))
[h2, p2] = jbtest(fxReturns(:,2))
[h3, p3] = jbtest(fxReturns(:,3))
[h4, p4] = jbtest(fxReturns(:,4))

uniformFxReturns = uniform(fxReturns);

[ fits ] = hacfit( 'clayton', uniformFxReturns, 'full' );