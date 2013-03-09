%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_cdf
initTestSuite;

function testArchimCdfAgainstMatlab
% Tests 2 dimensional case of archimcdf with copulacdf
    X = [0.1 0.2; 0.3 0.8; 0.9 0.4; 0.5 0.5; 0.98 0.92];
    assertVectorsAlmostEqual(archim.cdf('clayton', X, 1.5), copulacdf('clayton', X, 1.5));
    assertVectorsAlmostEqual(archim.cdf('frank', X, 1.5), copulacdf('frank', X, 1.5));
    assertVectorsAlmostEqual(archim.cdf('gumbel', X, 1.5), copulacdf('gumbel', X, 1.5));

function testArchimCdfAgainstMatlabForHighAlpha
% Tests 2 dimensional case of archimcdf with copulacdf
    X = [0.1 0.2; 0.3 0.8; 0.9 0.4; 0.5 0.5; 0.9 0.8];
    assertVectorsAlmostEqual(archim.cdf('clayton', X, 50), copulacdf('clayton', X, 50));
    assertVectorsAlmostEqual(archim.cdf('gumbel', X, 50), copulacdf('gumbel', X, 50));
    assertVectorsAlmostEqual(archim.cdf('frank', X, 50), copulacdf('frank', X, 50), 'absolute', 1e-3);