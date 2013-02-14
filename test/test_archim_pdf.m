%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_pdf
initTestSuite;

function testArchimNDiff
% Test n-th derivative of a function with comparing analytical ndiff with
% normal diff
    X = [0.1 0.2; 0.2 0.8; 1.0 0.4; 0.5 0.4];
    assertElementsAlmostEqual(archim.ndiff('clayton', 1, X, 1.2), archim.diff('clayton', X, 1.2))
    assertElementsAlmostEqual(archim.ndiff('frank', 1, X, 1.2), archim.diff('frank', X, 1.2))
    assertElementsAlmostEqual(archim.ndiff('gumbel', 1, X, 1.2), archim.diff('gumbel', X, 1.2))
    assertElementsAlmostEqual(archim.ndiff('joe', 1, X, 1.2), archim.diff('joe', X, 1.2))
    
function testArchimGenDiff
% Test n-th derivative of a function with comparing analytical ndiff with
% normal diff
    X = [0.1 0.2; 0.2 0.8; 1.0 0.4; 0.5 0.4];
    assertElementsAlmostEqual(archim.gendiff('clayton', 1, X, 1.2), archim.diff('clayton', X, 1.2))
    assertElementsAlmostEqual(archim.gendiff('gumbel', 1, X, 1.2), archim.diff('gumbel', X, 1.2))
    assertElementsAlmostEqual(archim.gendiff('frank', 1, X, 1.2), archim.diff('frank', X, 1.2))
    
function testArchimPdfAgainstMatlab
% Tests 2 dimensional case of archimpdf with copulapdf
    X = [0.1 0.2; 0.3 0.8; 0.9 0.9; 0.5 0.5];
    assertVectorsAlmostEqual(archim.pdf('clayton', X, 1.0), copulapdf('clayton', X, 1.0));
    assertVectorsAlmostEqual(archim.pdf('frank', X, 1.5), copulapdf('frank', X, 1.5));
    assertVectorsAlmostEqual(archim.pdf('gumbel', X, 1.5), copulapdf('gumbel', X, 1.5));
    
function testArchimPdfClaytonAgainstR
% Test 3-dimensional Clayton density against values produced by R
    U = csvread('data/data3d.csv');
    X = archim.pdf('clayton', U, 0.9912);
    Y = csvread('data/test_archimpdf_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function IGNOREtestArchimPdfJoeAgainstR
% Test 3-dimensional Clayton density against values produced by R
    U = csvread('data/data3d.csv');
    X = archim.pdf('joe', U, 1.85);
    Y = csvread('data/test_archim_pdf_joe3d.csv');
    assertVectorsAlmostEqual(X, Y);