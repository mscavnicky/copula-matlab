function modified2table( folder, dataset, classes )
    numClasses = numel(classes);
    
    % Read likelihoods from MAT files
    ll = {};
    for i=1:numClasses
        filename = sprintf('%s/%s-%s.mat', folder, dataset, classes{i});
        data = load(filename, 'cml', 'ifm');
        ll{i,1} = [data.cml(6:8).LL; data.cml(9:11).LL]';
        ll{i,2} = [data.ifm(6:8).LL; data.ifm(9:11).LL]';
    end
    
    % Open latex file for reading
    filename = sprintf('%s/%s-Modified.tex', folder, dataset );
    fid = fopen(filename, 'w');
    
    % Print the header of the tables
    fprintf(fid, '\\begin{tabular}{llrrcrrcrr}\n');
    
    % Print the header with class names
    fprintf(fid, '\\toprule\n');    
    fprintf(fid, 'Method & Class');
    
    families = {'Clayton HAC', 'Gumbel HAC', 'Frank HAC'};
    for i=1:3
        fprintf(fid, ' & \\multicolumn{2}{c}{%s}', families{i});
        if i ~= numClasses
            fprintf(fid, ' & \\phantom{abc}');
        end        
    end       
    fprintf(fid, ' \\\\\n');
    
    for i=1:numClasses
        fprintf(fid, '\\cmidrule{%d-%d} ', 3*i, 3*i+1 );
    end
    fprintf(fid, '\n');
    
    fprintf(fid, '& & ');
    for i=1:numClasses
        fprintf(fid, 'O & O*');
        if i ~= numClasses
            fprintf(fid, ' && ');
        end
    end
    fprintf(fid, ' \\\\\n');
    
    % Print the actual data
    fprintf(fid, '\\midrule\n');
    for c=1:numel(classes)
        if c == 1
            fprintf(fid, 'CML');
        end
        fprintf(fid, '& %s & ', classes{c});
        for i=1:3            
            fprintf(fid, '%.1f & %.1f', ll{c, 1}(i,:));
            if i ~= 3
                fprintf(fid, ' && ');
            end
        end
        fprintf(fid, ' \\\\\n');
    end
    
    % Print the actual data
    fprintf(fid, '\\cmidrule{2-10}\n');
    for c=1:numel(classes)
        if c == 1
            fprintf(fid, 'IFM');
        end
        fprintf(fid, '& %s & ', classes{c});
        for i=1:3            
            fprintf(fid, '%.1f & %.1f', ll{c, 2}(i,:));
            if i ~= 3
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