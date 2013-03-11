function fit2bars( folder, dataset, class )
%FIT2BARS
%
%   References:
%       [1] http://alex.bikfalvi.com/research/latex_in_matlab_ticks/
%       [2] http://stats.stackexchange.com/questions/577/is-there-any-reason-to-prefer-the-aic-or-bic-over-the-other

% Load the IFM anc CML fits
filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
data = load(filename, 'cml', 'ifm');
cml = data.cml;
ifm = data.ifm;

% Start the invisible figure
figure('Visible','off')
% Bar figure with AIC data
aic = [cml.AIC; ifm.AIC];
handle = bar(-aic);
% Use other font
set(gca, 'FontName', 'NewCenturySchlbk');
% Set text for the ticks on XLabels
set(gca, 'XTickLabel', {'CML', 'IFM'});
% Set grid color to grey
set(gca, 'XColor', [0.1 0.1 0.1])
set(gca, 'YColor', [0.1 0.1 0.1])
% Show overlay grid
grid on;
set(gca,'XGrid', 'off');
set(gca,'Layer','top');
% Use more appealing colormap
colormap(summer);
% Turn off black borders around graph
set(gca,'box','off')
% Set bar edge color to none
set(handle, 'EdgeColor', 'None');
% Add unboxed legend
families = {'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank',...
    'Clayton HAC', 'Gumbel HAC', 'Frank HAC',...
    'Clayton HAC*', 'Gumbel HAC*', 'Frank HAC*'};
legend(families, 'Location', 'eastoutside');
legend('boxoff');

% Print out the figure
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [14.5 5.0]);
set(gcf, 'PaperPosition', [0 0 14.5 5.0]);
imagename = sprintf('%s/%s-%s-Bar.pdf', folder, dataset, class );
print('-dpdf', '-r300', imagename);

% Also print the latex document for inserting the figure
filename = sprintf('%s/%s-%s-Bar.tex', folder, dataset, class );
fid = fopen(filename, 'w');
fprintf(fid, '\\begin{figure}\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\includegraphics[scale=1.0]{%s}\n', imagename);
fprintf(fid, '\\caption{Fit results (AIC) for the %s dataset for class %s.}\n', dataset, class);
fprintf(fid, '\\end{figure}\n');
fclose(fid);

end

