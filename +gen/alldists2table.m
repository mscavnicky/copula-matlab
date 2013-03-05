function alldists2table( folder, allDists, allPValues, names, dataset, classNames )
    % Number of classes
    numClasses = numel(classNames);
    
    filename = sprintf('%s/%s-dists.tex', folder, dataset );
    fid = fopen(filename, 'w');
    fprintf(fid, '\\begin{sidewaystable}\n');
    fprintf(fid, '\\small\n');
    fprintf(fid, '\\centering\n');
    
    
    fprintf(fid, '\\begin{tabular}{l');
    for i=1:numClasses
        fprintf(fid, 'lr');
        if i ~= numClasses
            fprintf(fid, 'c');
        end
    end    
    
    fprintf(fid, '}\n');
    fprintf(fid, '\\toprule\n');
    
    fprintf(fid, 'Attribute ');
    for i=1:numClasses
        fprintf(fid, ' & \\multicolumn{2}{c}{%s}', classNames{i});
        if i ~= numClasses
            fprintf(fid, ' & \\phantom{abc}');
        end        
    end       
    fprintf(fid, ' \\\\\n');
    
    for i=1:numClasses
        fprintf(fid, '\\cmidrule{%d-%d} ', 3*i-1, 3*i );
    end
    fprintf(fid, '\n');
    
    fprintf(fid, '& ');
    for i=1:numClasses
        fprintf(fid, 'Distribution & p-value');
        if i ~= numClasses
            fprintf(fid, ' && ');
        end
    end
    fprintf(fid, ' \\\\\n');
    
    fprintf(fid, '\\midrule\n');
    for a=1:numel(names)
        fprintf(fid, '%s & ', names{a});    
        for i=1:numClasses
            fprintf(fid, '%s & %.3f', prettyDistName(allDists{i}{a}), allPValues{i}(a));
            if i ~= numClasses
                fprintf(fid, ' && ');
            end
        end
        fprintf(fid, ' \\\\\n');
    end
    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');
    
    fprintf(fid, '\\caption{Fitted margins of the %s dataset.}\n', dataset);
    fprintf(fid, '\\end{sidewaystable}\n');
    fclose(fid);
end

function pretty = prettyDistName( distname )
switch distname
    case 'beta'
        pretty = 'Beta';
    case 'exponential'
        pretty = 'Exponential';
    case 'extreme value'
        pretty = 'Extreme Value';
    case 'gamma'
        pretty = 'Gamma';
    case 'inversegaussian'
        pretty = 'Inverse Gaussian';
    case 'logistic'
        pretty = 'Logistic';
    case 'loglogistic'
        pretty = 'Loglogistic';
    case 'lognormal'
        pretty = 'Lognormal';
    case 'normal'
        pretty = 'Normal';
    case 'tlocationscale'
        pretty = 'Student-t';
    case 'weibull'
        pretty = 'Weibull';
    otherwise
        error('Unknown distribution %s.', distname);
end
end
