function copulaimg( fun, fname )

fig = figure(1);
set(fig, 'Position', [0, 0, 800, 400]);

sub1 = subplot(1,2,1);
[U1, U2, Y] = ugrid(fun, 20);
surf(U1, U2, Y);

sub2 = subplot(1,2,2);
[U1, U2, Y] = ugrid(fun, 100);
contour(U1, U2, Y);

set(sub1,'Units','normalized', 'position', [0.05 0.12 0.4 0.8]);
set(sub2,'Units','normalized', 'position', [0.58 0.17 0.35 0.7]);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [13 6.5]);
set(gcf, 'PaperPosition', [0 0 13 6.5]);
print('-dpng', '-r300', fname);

end

function [ U1, U2, C ] = ugrid( fun, n )
%UNIFGRID Returns grid useful for graphical display.
u = linspace(0, 1, n);
[U1, U2] = meshgrid(u, u);
U = [U1(:) U2(:)];
C = reshape(fun(U), n, n);
end
