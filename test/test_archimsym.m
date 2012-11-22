%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archimsym
initTestSuite;

function test_sym_archimcdf_gumbel
% Test generating and evaluating symbolic expression of Gumbel copula    
    syms u1 u2 a;
    f = archim.sym.cdf('gumbel', {u1 u2}, a);
    g = matlabFunction(f, 'vars', [u1 u2 a]);
    
    X = [0.5 0.4; 0.7 0.2; 0.4 0.1];
    assertVectorsAlmostEqual(g(X(:,1), X(:,2), 1.5), copulacdf('gumbel', X, 1.5));