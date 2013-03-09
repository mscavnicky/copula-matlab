function cm2table( folder, dataset, method, CM )
%CM2TABLE Convert confusion matrix to latex table.

filename = sprintf('%s/%s-%s-CM.tex', folder, dataset, method );
fid = fopen(filename, 'w');
fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\small\n');
fprintf(fid, '\\centering\n');

fprintf(fid, '\\begin{tabular}{lrrrcrrr}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, ' & \\multicolumn{3}{c}{Gaussian} & \\phantom{abc} & \\multicolumn{3}{c}{Student-t} \\\\\n');
fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8} \n');
fprintf(fid, ' & 1 & 2 & 3 && 1 & 2 & 3 \\\\\n');
fprintf(fid, '\\midrule\n');
for i=1:3
    fprintf(fid, '%d & %d & %d & %d &&', i, CM{1}(i, :));
    fprintf(fid, '%d & %d & %d \\\\\n', CM{2}(i, :));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');

fprintf(fid,  '\\vspace{1em} \\vspace{1em}\n');

fprintf(fid, '\\begin{tabular}{lrrrcrrrcrrr}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, ' & \\multicolumn{3}{c}{Clayton} & \\phantom{abc} & \\multicolumn{3}{c}{Gumbel} & \\phantom{abc} & \\multicolumn{3}{c}{Frank} \\\\\n');
fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8} \\cmidrule{10-12}\n');
fprintf(fid, ' & 1 & 2 & 3 && 1 & 2 & 3 && 1 & 2 & 3 \\\\\n');
fprintf(fid, '\\midrule\n');
for i=1:3
    fprintf(fid, '%d & %d & %d & %d &&', i, CM{3}(i, :));
    fprintf(fid, '%d & %d & %d &&', CM{4}(i, :));
    fprintf(fid, '%d & %d & %d \\\\\n', CM{5}(i, :));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n'); 

fprintf(fid,  '\\vspace{1em} \\vspace{1em}\n');

fprintf(fid, '\\begin{tabular}{lrrrcrrrcrrr}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, ' & \\multicolumn{3}{c}{Clayton HAC} & \\phantom{abc} & \\multicolumn{3}{c}{Gumbel HAC} & \\phantom{abc} & \\multicolumn{3}{c}{Frank HAC} \\\\\n');
fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8} \\cmidrule{10-12}\n');
fprintf(fid, ' & 1 & 2 & 3 && 1 & 2 & 3 && 1 & 2 & 3 \\\\\n');
fprintf(fid, '\\midrule\n');
for i=1:3
    fprintf(fid, '%d & %d & %d & %d &&', i, CM{6}(i, :));
    fprintf(fid, '%d & %d & %d &&', CM{7}(i, :));
    fprintf(fid, '%d & %d & %d \\\\\n', CM{8}(i, :));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');

fprintf(fid,  '\\vspace{1em} \\vspace{1em}\n');

fprintf(fid, '\\begin{tabular}{lrrrcrrrcrrr}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, ' & \\multicolumn{3}{c}{Clayton HAC*} & \\phantom{abc} & \\multicolumn{3}{c}{Gumbel HAC*} & \\phantom{abc} & \\multicolumn{3}{c}{Frank HAC*} \\\\\n');
fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8} \\cmidrule{10-12}\n');
fprintf(fid, ' & 1 & 2 & 3 && 1 & 2 & 3 && 1 & 2 & 3 \\\\\n');
fprintf(fid, '\\midrule\n');
for i=1:3
    fprintf(fid, '%d & %d & %d & %d &&', i, CM{9}(i, :));
    fprintf(fid, '%d & %d & %d &&', CM{10}(i, :));
    fprintf(fid, '%d & %d & %d \\\\\n', CM{11}(i, :));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');

fprintf(fid, '\\caption{Confusion matrices for the %s fitted using %s method.}\n', dataset, method);
fprintf(fid, '\\end{table}\n');
fclose(fid);

end

