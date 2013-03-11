function alldists2table( folder, dataset, attributes, classes )
    numClasses = numel(classes);
    
    % Read margins from MAT files
    margins = {};    
    for i=1:numClasses
        filename = sprintf('%s/%s-%s.mat', folder, dataset, classes{i});
        data = load(filename, 'margins');
        margins{i} = data.margins;
    end
    
    % Open latex file for reading
    filename = sprintf('%s/%s-Margins.tex', folder, dataset );
    fid = fopen(filename, 'w');
    
    % Print the header of the tables
    fprintf(fid, '\\begin{tabular}{l');
    for i=1:numClasses
        fprintf(fid, 'lr');
        if i ~= numClasses
            fprintf(fid, 'c');
        end
    end    
    fprintf(fid, '}\n');
    
    % Print the header with class names
    fprintf(fid, '\\toprule\n');    
    fprintf(fid, 'Attribute ');
    for i=1:numClasses
        fprintf(fid, ' & \\multicolumn{2}{c}{%s}', classes{i});
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
    
    % Print the actual data
    fprintf(fid, '\\midrule\n');
    for attr=1:numel(attributes)
        fprintf(fid, '%s & ', attributes{attr});    
        for i=1:numClasses
            m = margins{i}(attr);
            fprintf(fid, '%s & %.3f', prettyDistName(m.DistName), m.PValue);
            if i ~= numClasses
                fprintf(fid, ' && ');
            end
        end
        fprintf(fid, ' \\\\\n');
    end
    
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');
    % Fixed bug in spacing
    fprintf(fid, '\\vspace{0em}\n');

    fclose(fid);
end


%TODO Replace this with container map
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
