%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_cdf
initTestSuite;

function testArchimCdfAgainstMatlab
% Tests 2 dimensional case of archimcdf with copulacdf
    X = [0.1 0.2; 0.3 0.8; 0.9 0.4; 0.5 0.5];
    assertVectorsAlmostEqual(archim.cdf('clayton', X, 1.5), copulacdf('clayton', X, 1.5));
    assertVectorsAlmostEqual(archim.cdf('frank', X, 1.5), copulacdf('frank', X, 1.5));
    assertVectorsAlmostEqual(archim.cdf('gumbel', X, 1.5), copulacdf('gumbel', X, 1.5));
    
function testArchimCdfAgainstR
    U = csvread('data/data3d.csv');
    X = archim.cdf('joe', U, 1.85);
    Y = csvread('data/test_archim_cdf_joe3d.csv');
    assertVectorsAlmostEqual(X, Y);