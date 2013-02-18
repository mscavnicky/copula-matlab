function dists2table( folder, fit, names, dataset, classnum, classname )
    n = numel(names);
    n1 = ceil(n / 2);

    filename = sprintf('%s/%s-%d-dists.tex', folder, dataset, classnum );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{table}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    fprintf(fid, '\\begin{tabular}{llr}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Attr. & Dists. & p-value \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:n1
        fprintf(fid, '%s & %s & %.4f \\\\\n', names{i}, fit.dists{i}, fit.pvalues(i));
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');
    
    fprintf(fid, '\\quad\n');
    
    fprintf(fid, '\\begin{tabular}{llr}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Attr. & Dists. & p-value \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=n1+1:n
        fprintf(fid, '%s & %s & %.4f \\\\\n', names{i}, fit.dists{i}, fit.pvalues(i));
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');
    
    fprintf(fid, '\\caption{Fitted margins of the %s dataset for class %s.}\n', dataset, classname);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end
