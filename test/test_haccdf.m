%#ok<*DEFNU>
%#ok<*STOUT>
%#ok<*NBRAK>

function test_suite = test_haccdf
initTestSuite;

function testHacCdf
% Tests 2 dimensional case of haccdf with copulacdf
    X = [0.1 0.2; 0.3 0.8; 1.0 0.4; 0.5 0.5];
    assertVectorsAlmostEqual(haccdf('clayton', X, { 1 2 [1.5] }), copulacdf('clayton', X, 1.5));
    assertVectorsAlmostEqual(haccdf('frank', X,  { 1 2 [1.5] }), copulacdf('frank', X, 1.5));
    assertVectorsAlmostEqual(haccdf('gumbel', X, { 1 2 [1.5] }), copulacdf('gumbel', X, 1.5));