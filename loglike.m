function [ l ] = loglike( x )
%loglike Computes log likelihood of given pdf samples
l = -sum(log(x));
end

