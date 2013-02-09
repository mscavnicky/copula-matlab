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
    tree =  {{1 2 2.0} 3 1.5};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, tree), hac.fpdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.pdf('frank', U, tree), hac.fpdf('frank', U, tree));
   
function testHacFastPdf3DAgainsHacPdfWithMixedArguments
    U = csvread('data/data3d.csv');
    tree =  {{3 2 2.0} 1 1.5};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, tree), hac.fpdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.pdf('frank', U, tree), hac.fpdf('frank', U, tree));

function testHacFastPdfPartiallyNested4DAgainsHacPdf
    U = csvread('data/data7d.csv');
    U = U(1:10,1:4);
    tree =  {{1 2 2.0} {3 4 1.5} 1.2};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, tree), hac.fpdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.pdf('frank', U, tree), hac.fpdf('frank', U, tree));
    
function testHacFastPdfPartiallyNested4DAgainsHacPdfWithMixedArguments
    U = csvread('data/data7d.csv');
    U = U(1:10,1:4);
    tree =  {{3 2 2.0} {4 1 1.5} 1.2};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, tree), hac.fpdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.pdf('frank', U, tree), hac.fpdf('frank', U, tree));
    
function testHacFastPdfFullyNestedNested4DAgainsHacPdf
    U = csvread('data/data7d.csv');
    U = U(1:10,1:4);
    tree =  {{{1 2 2.0} 3 1.5} 4 1.2};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));
    assertVectorsAlmostEqual(hac.pdf('gumbel', U, tree), hac.fpdf('gumbel', U, tree));
    assertVectorsAlmostEqual(hac.pdf('frank', U, tree), hac.fpdf('frank', U, tree));
    
function testHacFastPdf7DAgainstHacPdf
    U = csvread('data/data7d.csv');
    U = U(1:10,:);
    tree =  {{{1 7 3.0} {2 6 3.0} 2.0} {3 {4 5 3.0} 1.5} 1.2};    
    assertVectorsAlmostEqual(hac.pdf('clayton', U, tree), hac.fpdf('clayton', U, tree));