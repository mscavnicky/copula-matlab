function writefit( filename, type, fit )
%WRITEFIT Write information about copula fit to specified csv file.

cols = {};
cols{1} = sprintf('"%s"', datestr(now, 'yyyy-mm-dd'));
cols{2} = sprintf('"%s"', type);
cols{3} = sprintf('"%s"', fit.copulaparams.family);
cols{4} = sprintf('"%s"', getfield2(fit, 'method', ''));
cols{5} = sprintf('%d', fit.bootstraps);
cols{6} = sprintf('%.1f', fit.ll);
cols{7} = sprintf('%.1f', fit.aic);
cols{8} = sprintf('%.1f', fit.bic);
cols{9} = sprintf('%.3f', getfield2(fit, 'snc', 0.0));
cols{10} = sprintf('%.3f', getfield2(fit, 'snb', 0.0));

% Write line into a file
fid = fopen(filename, 'a');
fprintf(fid, '%s\n', strjoin(cols, ','));
fclose(fid);

end

function [ value ] = getfield2( struct, field, default )
    if isfield(struct, field)
        value = getfield(struct, field);
    else
        value = default;
    end
end

