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

%% Clayton copula
copulaimg(@(U) copulapdf('clayton', U, 0.7), '../Images/clayton-pdf.png', 30, 0.05, 0.95);

%% Gumbel copula
copulaimg(@(U) copulapdf('gumbel', U, 1.3), '../Images/gumbel-pdf.png', 20, 0.05, 0.95);

%% Frank copula
copulaimg(@(U) copulapdf('frank', U, -2), '../Images/frank-pdf.png', 20, 0.05, 0.95);

%% Positive and negative dependency scatter

U = copularnd('gumbel', 2.5, 500);
U1 = 1 - U(:,1);
U2 = U(:,2);

fig = figure(1);
set(fig, 'Position', [0, 0, 1000, 250]);

sub1 = subplot(1,3,1);
scatter(U1, U2, '.');
xlabel(sub1, 'U1');
ylabel(sub1, 'U2');

sub2 = subplot(1,3,2);
scatter(1 - U1, U2, '.');
xlabel('1 - U1');
ylabel('U2');


sub3 = subplot(1,3,3);
scatter(U1, 1 - U2, '.');
xlabel('U1');
ylabel('1 - U2');

%set(sub1,'Units','normalized', 'position', [0.05 0.12 0.4 0.8]);
%set(sub2,'Units','normalized', 'position', [0.58 0.17 0.35 0.7]);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [16 4]);
set(gcf, 'PaperPosition', [0 0 16 4]);
print('-dpng', '-r300', '../Images/rotating-negative-dependence.png');
