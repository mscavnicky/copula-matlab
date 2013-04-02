function copulaimg( fun, fname, clines, min, max )

if (nargin < 3)
    clines = 10;
end

if (nargin < 5)
    min = 0;
    max = 1;
end

colormap('default');

fig = figure(1);
set(fig, 'Position', [0, 0, 800, 400]);

sub1 = subplot(1,2,1);
[U1, U2, Y] = ugrid(fun, 20, min, max);
surf(U1, U2, Y);
set(gca, 'FontName', 'NewCenturySchlbk');

sub2 = subplot(1,2,2);
[U1, U2, Y] = ugrid(fun, 100, min, max);
contour(U1, U2, Y, clines);
set(gca, 'FontName', 'NewCenturySchlbk');

set(sub1,'Units','normalized', 'position', [0.05 0.12 0.4 0.8]);
set(sub2,'Units','normalized', 'position', [0.58 0.17 0.35 0.7]);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [13 6.5]);
set(gcf, 'PaperPosition', [0 0 13 6.5]);
print('-dpdf', '-r300', fname);

end

function [ U1, U2, C ] = ugrid( fun, n, min, max )
%UGRID Returns grid useful for graphical display.
u = linspace(min, max, n);
[U1, U2] = meshgrid(u, u);
U = [U1(:) U2(:)];
C = reshape(fun(U), n, n);
end
