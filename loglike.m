function [ l ] = loglike( x )
%LOGLIKE Computes negative log likelihood of given pdf samples
l = -sum(log(x));
end

