function fit2table( folder, cmlfits, ifmfits, dataset, classnum, classname )
    families = {'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC' };

    filename = sprintf('%s/%s-%d-fits.tex', folder, dataset, classnum );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{table}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    fprintf(fid, '\\begin{tabular}{lrrrcrrrcrr}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Family & \\multicolumn{4}{c}{CML} & \\phantom{abc} & \\multicolumn{4}{c}{IFM} \\\\');
    fprintf(fid, '\\cmidrule{2-5} \\cmidrule{7-10}\n');
    fprintf(fid, '& LL & AIC & BIC & KS && LL & AIC & BIC & KS \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:numel(families)
        fprintf(fid, '%s & %.1f & %.1f & %.1f & %.2f && %.1f & %.1f & %.1f & %.2f \\\\\n', families{i}, cmlfits{i}.ll, cmlfits{i}.aic, cmlfits{i}.bic, cmlfits{i}.ks, ifmfits{i}.ll, ifmfits{i}.aic, ifmfits{i}.bic, ifmfits{i}.ks);
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');    
    
    fprintf(fid, '\\caption{Fitted of copulas fits of the %s dataset for class %s.}\n', dataset, classname);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end

