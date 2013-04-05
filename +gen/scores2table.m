function scores2table( families, datasets, classes )
%SCORES2TABLE

scores = zeros(8, 6);

for i=1:numel(datasets)
    dataset = datasets{i};
    datasetClasses = classes{i};
   
    for j=1:numel(datasetClasses)
        class = datasetClasses{j};
        filename = sprintf('../Results/%s/%s-%s.mat', dataset, dataset, class);
        data = load(filename, 'cmlFits', 'ifmFits');
        cml = data.cmlFits(1:8);
        ifm = data.ifmFits(1:8);
      
        for k=1:numel(families)
            if cml(k).LL == max([cml.LL])
                scores(k, 1) = scores(k, 1) + 1;
            end            
            if cml(k).AIC == min([cml.AIC])
                scores(k, 2) = scores(k, 2) + 1;
            end            
            if cml(k).SnC == min([cml.SnC])
                scores(k, 3) = scores(k, 3) + 1;
            end
            
            if ifm(k).LL == max([ifm.LL])
                scores(k, 4) = scores(k, 4) + 1;
            end            
            if ifm(k).AIC == min([ifm.AIC])
                scores(k, 5) = scores(k, 5) + 1;
            end            
            if ifm(k).SnC == min([ifm.SnC])
                scores(k, 6) = scores(k, 6) + 1;
            end           
        end             
   end   
end

fid = fopen('../Results/Scores.tex', 'w');
fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\small\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\begin{tabular}{lrrrrcrrrrc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Family & \\multicolumn{3}{c}{CML} & \\phantom{abc} & \\multicolumn{3}{c}{IFM} \\\\\n');
fprintf(fid, '\\cmidrule{2-4} \\cmidrule{6-8}\n');
fprintf(fid, '& LL & AIC & SnC && LL & AIC & SnC \\\\\n');
fprintf(fid, '\\midrule\n');
fprintf(fid, 'Gaussian & %d & %d & %d && %d & %d & %d \\\\\n', scores(1, :));
fprintf(fid, 'Student-t & %d & %d & %d && %d & %d & %d \\\\\n', scores(2, :));
fprintf(fid, 'Clayton & %d & %d & %d && %d & %d & %d \\\\\n', scores(3, :));
fprintf(fid, 'Gumbel & %d & %d & %d && %d & %d & %d \\\\\n', scores(4, :));
fprintf(fid, 'Frank & %d & %d & %d && %d & %d & %d \\\\\n', scores(5, :));
fprintf(fid, 'Clayton HAC & %d & %d & %d && %d & %d & %d \\\\\n', scores(6, :));
fprintf(fid, 'Gumbel HAC & %d & %d & %d && %d & %d & %d \\\\\n', scores(7, :));
fprintf(fid, 'Frank HAC & %d & %d & %d && %d & %d & %d \\\\\n', scores(8, :));
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\caption{Scores for different copula families.}\n');
fprintf(fid, '\\label{tab:results-scores}\n');
fprintf(fid, '\\end{table}\n');
fclose(fid);


end

