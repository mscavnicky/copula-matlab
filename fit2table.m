function fit2table( folder, cmlfits, ifmfits, dataset, classnum, classname )
    families = {'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC' };

    filename = sprintf('%s/%s-%d-fits.tex', folder, dataset, classnum );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{table}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    fprintf(fid, '\\begin{tabular}{lrrrcrrrcrr}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Family & \\multicolumn{3}{c}{CML} & \\phantom{abc} & \\multicolumn{3}{c}{IFM} \\\\');
    fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8}\n');
    fprintf(fid, '& LL & AIC & BIC && LL & AIC & BIC \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:numel(families)
        fprintf(fid, '%s & %.1f & %.1f & %.1f && %.1f & %.1f & %.1f \\\\\n', families{i}, cmlfits{i}.ll, cmlfits{i}.aic, cmlfits{i}.bic, ifmfits{i}.ll, ifmfits{i}.aic, ifmfits{i}.bic);
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');    
    
    fprintf(fid, '\\caption{Fitted of copulas fits of the %s dataset for class %s.}\n', dataset, classname);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end

