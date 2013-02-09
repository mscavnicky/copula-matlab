%#ok<*DEFNU>
%#ok<*STOUT>
%#ok<*NBRAK>

function test_suite = test_hac_pdf
initTestSuite;

function testHacPdfFlat2D
% Tests 2 dimensional case of hac.fpdf with copulapdf
    U = csvread('data/data2d.csv');
    assertVectorsAlmostEqual(hac.pdf('clayton', U, { 1 2 1.5 }), copulapdf('clayton', U, 1.5));
    assertVectorsAlmostEqual(hac.pdf('frank', U,  { 1 2 1.5 }), copulapdf('frank', U, 1.5));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, { 1 2 1.5 }), copulapdf('gumbel', U, 1.5));
    
function testHacPdfFlat3D
% Tests 2 dimensional case of hac.fpdf with copulapdf
    U = csvread('data/data3d.csv');
    assertVectorsAlmostEqual(hac.pdf('clayton', U, { 1 2 3 1.5 }), archim.pdf('clayton', U, 1.5));
    assertVectorsAlmostEqual(hac.pdf('frank', U,  { 1 2 3 1.5 }), archim.pdf('frank', U, 1.5));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, { 1 2 3 1.5 }), archim.pdf('gumbel', U, 1.5));
    
function testHacFastPdfFlat2D
% Tests 2 dimensional case of hac.fpdf with copulapdf
    U = csvread('data/data2d.csv');
    assertVectorsAlmostEqual(hac.fpdf('clayton', U, { 1 2 1.5 }), copulapdf('clayton', U, 1.5));
    assertVectorsAlmostEqual(hac.fpdf('frank', U,  { 1 2 1.5 }), copulapdf('frank', U, 1.5));
    assertVectorsAlmostEqual(hac.fpdf('gumbel', U, { 1 2 1.5 }), copulapdf('gumbel', U, 1.5));
    
function testHacFastPdfFlat3D
% Tests 2 dimensional case of hac.fpdf with copulapdf
    U = csvread('data/data3d.csv');
    assertVectorsAlmostEqual(hac.fpdf('clayton', U, { 1 2 3 1.5 }), archim.pdf('clayton', U, 1.5));
    assertVectorsAlmostEqual(hac.fpdf('frank', U,  { 1 2 3 1.5 }), archim.pdf('frank', U, 1.5));
    assertVectorsAlmostEqual(hac.fpdf('gumbel', U, { 1 2 3 1.5 }), archim.pdf('gumbel', U, 1.5));
    
function testHacFastPdf3DAgainsHacPdf
    U = csvread('data/data3d.csv');
    tree =  {1 {2 3 0.5} 1.5};
    assertVectorsAlmostEqual(hac.fpdf('clayton', U, tree), hac.pdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.fpdf('gumbel', U, tree), hac.pdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.fpdf('frank', U, tree), hac.pdf('frank', U, tree));