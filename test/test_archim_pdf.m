%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_pdf
initTestSuite;

function testArchimGenDiff
% normal diff
    X = [0.1 0.2; 0.2 0.8; 1.0 0.4; 0.5 0.4];
    assertElementsAlmostEqual(archim.gdiff('clayton', X, 1.2, 1), archim.ndiff('clayton', X, 1.2, 1))
    assertElementsAlmostEqual(archim.gdiff('gumbel', X, 1.2, 1), archim.ndiff('gumbel', X, 1.2, 1))
    assertElementsAlmostEqual(archim.gdiff('frank', X, 1.2, 1), archim.ndiff('frank', X, 1.2, 1))
    
function testArchimPdfAgainstMatlab
    X = [0.1 0.2; 0.3 0.8; 0.9 0.9; 0.5 0.5];
    assertVectorsAlmostEqual(archim.pdf('clayton', X, 1.0), copulapdf('clayton', X, 1.0));
    assertVectorsAlmostEqual(archim.pdf('frank', X, 1.5), copulapdf('frank', X, 1.5));
    assertVectorsAlmostEqual(archim.pdf('gumbel', X, 1.5), copulapdf('gumbel', X, 1.5));
    
function testArchimPdfClaytonAgainstR
    U = csvread('data/data3d.csv');
    X = archim.pdf('clayton', U, 0.9912);
    Y = csvread('data/test_archimpdf_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testArchimPdfFrankWithHighAlpha
    U = csvread('data/data2d.csv');
    assertVectorsAlmostEqual(archim.pdf('frank', U, 50.0), copulapdf('frank', U, 50));
    
function testArchimPdf7DWithHighAlpha
    U = csvread('data/data7d.csv');
    assertVectorsAlmostEqual(archim.pdf('clayton', U, 5.0), csvread('data/test_archim_pdf_clayton7d.csv'));
    assertVectorsAlmostEqual(archim.pdf('gumbel', U, 5.0), csvread('data/test_archim_pdf_gumbel7d.csv'));
    assertVectorsAlmostEqual(archim.pdf('frank', U, 5.0), csvread('data/test_archim_pdf_frank7d.csv'));