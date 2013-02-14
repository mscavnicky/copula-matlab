function barfit( filename, imagename )

% Red the data
fid = fopen(filename);
C = textscan(fid, '%s %s %s %s %d %f %f %f %f %f', 'delimiter', ',');
fclose(fid);


X = abs([ C{6} C{7} C{8} ])';



fig = figure(1);
set(fig, 'Position', [0, 0, 950, 1410]);


sub1 = subplot(2,1,1);
bar(X(:, 1:8));
legend({'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC'}, 'Location', 'northwest');
set(gca, 'xticklabel', {'LL', 'AIC', 'BIC'});

sub2 = subplot(2,1,2);
bar(X(:, 9:16));
%legend({'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC'});
set(gca, 'xticklabel', {'LL', 'AIC', 'BIC'});


% Get rid of white margins
%set(gca,'LooseInset',get(gca,'TightInset'))

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [19.0 27.0]);
set(gcf, 'PaperPosition', [0 0 19.0 27.0]);
print('-dpdf', '-r300', imagename);

%savefig(fig, imagename);

end

