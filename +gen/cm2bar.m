function cm2bar( folder, dataset )
%CM2TABLE Convert confusion matrix to latex table.

filename = sprintf('%s/%s-Confus.mat', folder, dataset);
workspace = load(filename, 'matrices');
matrices = cell2mat(workspace.matrices);
misclassified = reshape([matrices.misclassified], 2, 11);

% Start the invisible figure
figure('Visible','off')
handle = bar(misclassified);
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
colormap(autumn);
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
imagename = sprintf('%s/%s-Confus-Bar.pdf', folder, dataset );
print('-dpdf', '-r300', imagename);

% Also print the latex document for inserting the figure
filename = sprintf('%s/%s-Confus-Bar.tex', folder, dataset );
fid = fopen(filename, 'w');
fprintf(fid, '\\begin{figure}\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\includegraphics[scale=1.0]{%s}\n', imagename);
fprintf(fid, '\\caption{Number of misclassified elements for different copula families for %s dataset.}\n', dataset);
fprintf(fid, '\\end{figure}\n');
fclose(fid);

end

