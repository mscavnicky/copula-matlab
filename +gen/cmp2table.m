function cmp2table( datasets, families )
%CMP2TABLE

correct = zeros(24, numel(datasets));
for i=1:numel(datasets)
    dataset = datasets{i};  
    filename = sprintf('../Results/%s/%s-Confus.mat', dataset, dataset);
    data = load(filename, 'results');       
    correct(:, i) = [data.results.Correct]';
end

cmpimage(families, cmp(correct(1:12, :)), '../Results/CMLComp.pdf');
cmpimage(families, cmp(correct(13:24, :)), '../Results/IFMComp.pdf');

% fid = fopen('../Results/ClassificationComparison.tex', 'w');
% fprintf(fid, '\\begin{table}\n');
% fprintf(fid, '\\small\n');
% fprintf(fid, '\\centering\n');
% fprintf(fid, '\\begin{tabular}{lrrrrrrrrrrrr}\n');
% fprintf(fid, '\\toprule\n');
% fprintf(fid, 'Family & Ind & Ga & t & Cl & Gu & Fr & ClH & GuH & FrH & ClH* & GuH* & FrH* \\\\\n');
% fprintf(fid, '\\midrule\n');
% fprintf(fid, 'Independent & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(1, :));
% fprintf(fid, 'Gaussian & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(2, :));
% fprintf(fid, 'Student-t & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(3, :));
% fprintf(fid, 'Clayton & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(4, :));
% fprintf(fid, 'Gumbel & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(5, :));
% fprintf(fid, 'Frank & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(6, :));
% fprintf(fid, 'Clayton HAC & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(7, :));
% fprintf(fid, 'Gumbel HAC & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(8, :));
% fprintf(fid, 'Frank HAC & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(9, :));
% fprintf(fid, 'Clayton HAC* & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(10, :));
% fprintf(fid, 'Gumbel HAC* & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(11, :));
% fprintf(fid, 'Frank HAC* & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d & %d \\\\\n', M(12, :));
% fprintf(fid, '\\bottomrule\n');
% fprintf(fid, '\\end{tabular}\n');
% fprintf(fid, '\\caption{Scores for different copula families.}\n');
% fprintf(fid, '\\label{tab:results-scores}\n');
% fprintf(fid, '\\end{table}\n');
% fclose(fid);

end

function cmpimage( families, M, imagename )

% Start the invisible figure
figure('Visible','off')
imagesc(M); % plot the matrix
axis('square');
set(gca, 'FontName', 'NewCenturySchlbk');
set(gca, 'XTick', 1:12); 
set(gca, 'YTick', 1:12); 
set(gca, 'XTickLabel', families); 
gen.rotateticklabel(gca, 90); 
set(gca, 'YTickLabel', families);
colormap([1.0 1.0 1.0; 0.75 0.75 0.75; 0.5 0.5 0.5; 0.25 0.25 0.25; 0.0 0.0 0.0]);

hcb = colorbar;
set(hcb, 'YTick', [0,1,2,3,4]);
set(hcb, 'FontName', 'NewCenturySchlbk');

pos = get(gca, 'OuterPosition');
pos(2) = pos(2) + 0.1;
set(gca,'OuterPosition',pos);

% Print out the figure
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [12.0 10.0]);
set(gcf, 'PaperPosition', [0 0.0 12.0 10.0]);
print('-dpdf', '-r300', imagename);

end

function [ M ] = cmp( X )
%CMP

[n, d] = size(X);
M = zeros(n, n);

for j=1:d
    for i=1:n
       M(i, :) = M(i, :) + (X(i,j) > X(:,j))';
    end
end

end

