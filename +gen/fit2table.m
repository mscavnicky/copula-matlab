function fit2table( folder, dataset, class )
    % Load the IFM anc CML fits
    filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
    data = load(filename, 'cml', 'ifm');
    cml = data.cml;
    ifm = data.ifm;

    families = {'Gaussian', 'Student-t', 'Clayton', 'Gumbel', 'Frank', 'Clayton HAC', 'Gumbel HAC', 'Frank HAC', 'Clayton HAC*', 'Gumbel HAC*', 'Frank HAC*' };

    filename = sprintf('%s/%s-%s-Fits.tex', folder, dataset, class );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{table}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    fprintf(fid, '\\begin{tabular}{lrrrcrrrc}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Family & \\multicolumn{3}{c}{CML} & \\phantom{abc} & \\multicolumn{3}{c}{IFM} \\\\\n');
    fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8}\n');
    fprintf(fid, '& AIC & BIC & AKS && AIC & BIC & AKS \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:numel(families)        
        cmlstr = strcat(textbf('%.1f', cml(i).AIC, min([cml.AIC])),' & ',...
                        textbf('%.1f', cml(i).BIC, min([cml.BIC])),' & ',...
                        textbf('%.3f', cml(i).AKS, min([cml.AKS])));
        ifmstr = strcat(textbf('%.1f', ifm(i).AIC, min([ifm.AIC])),' & ',...
                        textbf('%.1f', ifm(i).BIC, min([ifm.BIC])),' & ',...
                        textbf('%.3f', ifm(i).AKS, min([ifm.AKS])));        
        fprintf(fid, '%s & %s && %s \\\\\n', families{i}, cmlstr, ifmstr);
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');    
    
    fprintf(fid, '\\caption{Fitted of copulas fits of the %s dataset for class %s.}\n', dataset, class);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end

function str = textbf( fmt, stat, best )
    str = sprintf(fmt, stat);
    if stat == best
        str = strcat('\textbf{', str, '}'); 
    end
end