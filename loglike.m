function [ l ] = loglike( x )
%LOGLIKE Computes log likelihood of given pdf samples
l = -sum(log(x));
end

