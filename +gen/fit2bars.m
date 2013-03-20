function fit2bars( folder, families, dataset, class, stat )
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
values = [cml.(stat); ifm.(stat)];
handle = bar(values);
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

% Use more appealing colormap and reverse bar
if strcmp(stat, 'AIC')
    colormap(summer);
    set(gca, 'YDir', 'reverse');
elseif strcmp(stat, 'SnC')
    colormap(cool);
end    
% Turn off black borders around graph
set(gca,'box','off')
% Set bar edge color to none
set(handle, 'EdgeColor', 'None');
% Add unboxed legend
legend(families, 'Location', 'eastoutside');
legend('boxoff');

% Print out the figure
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [14.5 4.0]);
set(gcf, 'PaperPosition', [0 0 14.5 4.0]);
imagename = sprintf('%s/%s-%s-%s.pdf', folder, dataset, class, stat );
print('-dpdf', '-r300', imagename);

% Also print the latex document for inserting the figure
filename = sprintf('%s/%s-%s-%s.tex', folder, dataset, class, stat );
fid = fopen(filename, 'w');
fprintf(fid, '\\begin{figure}\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\includegraphics[scale=1.0]{%s}\n', imagename);
fprintf(fid, '\\caption{Fit results (%s) for the %s dataset for class %s.}\n', dataset, class, stat);
fprintf(fid, '\\end{figure}\n');
fclose(fid);

end

