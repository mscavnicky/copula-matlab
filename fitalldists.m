function [ dist,  dists ] = fitalldists(X)
%FITALLDISTS Fit all valid parametric probability distributions to data.
%   [dist dists] = FITALLDISTS(X) fits all valid parametric probability
%   distributions to the data in vector X, and returns a struct dists of
%   fitted distributions and parameters and distribution with highest BIC
%   value in the dist variable.
%
%   List of distributions it will try to fit
%     Continuous (default)
%       Beta
%       Exponential
%       Extreme value
%       Gamma
%       Inverse Gaussian
%       Logistic
%       Log-logistic
%       Lognormal
%       Normal
%       t location-scale
%       Weibull

distnames={...
    'beta',...    
    'exponential',...
    'extreme value',...
    'gamma',...    
    'inversegaussian',...
    'logistic',...
    'loglogistic',...
    'lognormal',...
    'normal',...
    'tlocationscale',...
    'weibull'};


n=size(X, 1);

warning('off','all');
dists = [];
for i=1:numel(distnames)
    try
        % Obtain ProbDist object from MATLAB's 
        PD = fitdist(X, distnames{i});
        
        % Ignore distributions with infinite log likelihood
        if ~isfinite(PD.NLogL)
            error('Negative log-likelihood not-finite.');
        end
        
        % Ignore distributions that produce Inf or NaN values
        Y = PD.cdf(X);
        if isnan(Y) | isinf(Y) %#ok<OR2>
            error('Distribution not numerically stable.');           
        end        
        Y = PD.pdf(X);
        if isnan(Y) | isinf(Y) %#ok<OR2>
            error('Distribution not numerically stable.');           
        end 
        
        % Keep the fitted distribution
        num=numel(dists)+1;
        k=numel(PD.Params); %Number of parameters
        [~, p] = kstest(X, PD);
        
        dists(num).DistName=PD.DistName; %#ok<*AGROW>
        dists(num).NLogL=PD.NLogL;
        dists(num).BIC=-2*(-PD.NLogL)+k*log(n);        
        dists(num).PValue=p;
        dists(num).ProbDist = PD;
        
    catch err %#ok<NASGU>
        %Ignore distribution
    end
end
warning('on','all');

if numel(dists)==0
    error('ALLFITDIST:NoDist','No distributions were found');
end

% Sort fitted distributions
[~, idx]=sort([dists.BIC]);
dists = dists(idx);
% Return the best distribution
dist = dists(1);

end