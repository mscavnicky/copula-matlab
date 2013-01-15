%% Dependence

U1 = copularnd('clayton', 5.5, 1000);
corr(U1(:,1), U1(:,2))
hf = figure;
hs = scatterhist(U1(:,1), U1(:,2));
hp = get(hs(1), 'children');
set(hp, 'marker', '.');
xlabel('X');
ylabel('Y');


U2 = copularnd('t', 0.91, 5, 1000);
corr(U2(:,1), U2(:,2))
hf = figure;
hs = scatterhist(U2(:,1), U2(:,2));
hp = get(hs(1), 'children');
set(hp, 'marker', '.');
xlabel('X');
ylabel('Y');

%%

Ga = copularnd('gaussian', 0.9, 1000);
scatter(Ga(:,1), Ga(:,2),'.');

t = copularnd('t', 0.9, 4, 1000);
scatter(t(:,1), t(:,2),'.');

Cl = copularnd('clayton', 6.0, 1000);
scatter(Cl(:,1), Cl(:,2),'.');

Gu = copularnd('gumbel', 6.0, 1000);
scatter(Gu(:,1), Gu(:,2),'.');