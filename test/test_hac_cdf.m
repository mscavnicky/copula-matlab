%#ok<*DEFNU>
%#ok<*STOUT>
%#ok<*NBRAK>

function test_suite = test_hac_cdf
initTestSuite;

function testHacCdf
% Tests 2 dimensional case of haccdf with copulacdf
    X = [0.1 0.2; 0.3 0.8; 1.0 0.4; 0.5 0.5];
    assertVectorsAlmostEqual(hac.cdf('clayton', X, { 1 2 [1.5] }), copulacdf('clayton', X, 1.5));
    assertVectorsAlmostEqual(hac.cdf('frank', X,  { 1 2 [1.5] }), copulacdf('frank', X, 1.5));
    assertVectorsAlmostEqual(hac.cdf('gumbel', X, { 1 2 [1.5] }), copulacdf('gumbel', X, 1.5));