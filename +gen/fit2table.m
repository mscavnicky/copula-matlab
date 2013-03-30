function fit2table( folder, families, dataset, class )
    % Load the IFM anc CML fits
    filename = sprintf('%s/%s-%s.mat', folder, dataset, class);
    data = load(filename, 'cml', 'ifm');
    cml = data.cml(1:8);
    ifm = data.ifm(1:8);

    filename = sprintf('%s/%s-%s-Fits.tex', folder, dataset, class );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{table}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    fprintf(fid, '\\begin{tabular}{lrrrcrrrc}\n');
    fprintf(fid, '\\toprule\n');
    fprintf(fid, 'Family & \\multicolumn{3}{c}{CML} & \\phantom{abc} & \\multicolumn{3}{c}{IFM} \\\\\n');
    fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8}\n');
    fprintf(fid, '& LL & AIC & SnC && LL & AIC & SnC \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:numel(families)        
        cmlstr = strcat(textbf('%.1f', cml(i).LL, max([cml.LL])),' & ',...
                        textbf('%.1f', cml(i).AIC, min([cml.AIC])),' & ',...
                        textbf('%.3f', cml(i).SnC, min([cml.SnC])));
        ifmstr = strcat(textbf('%.1f', ifm(i).LL, max([ifm.LL])),' & ',...
                        textbf('%.1f', ifm(i).AIC, min([ifm.AIC])),' & ',...
                        textbf('%.3f', ifm(i).SnC, min([ifm.SnC])));        
        fprintf(fid, '%s & %s && %s \\\\\n', families{i}, cmlstr, ifmstr);
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');    
    
    fprintf(fid, '\\caption{Measures of fit for different copula families for class %s (%s dataset).}\n', class, dataset);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end

function str = textbf( fmt, stat, best )
    str = sprintf(fmt, stat);
    if stat == best
        str = strcat('\textbf{', str, '}'); 
    end
end