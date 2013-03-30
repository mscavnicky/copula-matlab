function modified2table( folder, dataset, classes )
    numClasses = numel(classes);
    
    % Read likelihoods from MAT files
    ifm = {};
    cml = {};
    
    for i=1:numClasses
        filename = sprintf('%s/%s-%s.mat', folder, dataset, classes{i});
        data = load(filename, 'cml', 'ifm');
        cml{i} = [data.cml(6:8).LL; data.cml(9:11).LL]';
        ifm{i} = [data.ifm(6:8).LL; data.ifm(9:11).LL]';
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
        fprintf(fid, 'Okhrin & Okhrin*');
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
            ll1 = cml{c}(i, 1);
            ll2 = cml{c}(i, 2);
            
            s1 = sprintf('%.1f', ll1);
            s2 = sprintf('%.1f', ll2);                             
            
            fprintf(fid, '%s & %s', bold(s1, ll1 > ll2), bold(s2, ll2 > ll1));
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
            ll1 = ifm{c}(i, 1);
            ll2 = ifm{c}(i, 2);
            
            s1 = sprintf('%.1f', ll1);
            s2 = sprintf('%.1f', ll2);                             
            
            fprintf(fid, '%s & %s', bold(s1, ll1 > ll2), bold(s2, ll2 > ll1));
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

function str = bold( str, flag )
    if flag
        str = strcat('\textbf{', str, '}');
    end
end