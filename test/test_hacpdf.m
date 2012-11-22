%#ok<*DEFNU>
%#ok<*STOUT>
%#ok<*NBRAK>

function test_suite = test_hacpdf
initTestSuite;

function testHacPdf
% Tests 2 dimensional case of hacpdf with copulapdf
    X = [0.1 0.2; 0.3 0.8; 0.9 0.4; 0.5 0.5];
    assertVectorsAlmostEqual(hac.pdf('clayton', X, { 1 2 [1.5] }), copulapdf('clayton', X, 1.5));
    assertVectorsAlmostEqual(hac.pdf('frank', X,  { 1 2 [1.5] }), copulapdf('frank', X, 1.5));
    assertVectorsAlmostEqual(hac.pdf('gumbel', X, { 1 2 [1.5] }), copulapdf('gumbel', X, 1.5));