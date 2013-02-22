function fit2table( folder, cmlfits, ifmfits, dataset, classnum, classname )
    cmlstats = fits2stats( cmlfits );
    ifmstats = fits2stats( ifmfits );
    
    cmlbest = [max(cmlstats(:,1)) min(cmlstats(:,2:4))];
    ifmbest = [max(ifmstats(:,1)) min(ifmstats(:,2:4))];


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
    fprintf(fid, '& LL & AIC & BIC & AKS && LL & AIC & BIC & AKS \\\\\n');
    fprintf(fid, '\\midrule\n');
    for i=1:numel(families)        
        cmlstr = strcat(stat2str('%.1f', cmlstats(i,1), cmlbest(1)),' & ',...
                        stat2str('%.1f', cmlstats(i,2), cmlbest(2)),' & ',...
                        stat2str('%.1f', cmlstats(i,3), cmlbest(3)),' & ',...
                        stat2str('%.3f', cmlstats(i,4), cmlbest(4)));
        ifmstr = strcat(stat2str('%.1f', ifmstats(i,1), ifmbest(1)),' & ',...
                        stat2str('%.1f', ifmstats(i,2), ifmbest(2)),' & ',...
                        stat2str('%.1f', ifmstats(i,3), ifmbest(3)),' & ',...
                        stat2str('%.3f', ifmstats(i,4), ifmbest(4)));        
        fprintf(fid, '%s & %s && %s \\\\\n', families{i}, cmlstr, ifmstr);
    end    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');    
    
    fprintf(fid, '\\caption{Fitted of copulas fits of the %s dataset for class %s.}\n', dataset, classname);
    fprintf(fid, '\\end{table}\n');
    fclose(fid);
end

function stats = fits2stats( fits )
    stats = zeros(numel(fits), 4);
    for i=1:numel(fits)
       stats(i, :) = fits{i}.stats; 
    end        
end

function str = stat2str( fmt, stat, best )  
    str = sprintf(fmt, stat);
    if stat == best
        str = strcat('\textbf{', str, '}'); 
    end
end