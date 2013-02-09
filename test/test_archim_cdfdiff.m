%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_cdfdiff
initTestSuite;

function testArchimCdfDiff2D
    U = csvread('data/data2d.csv');
    assertVectorsAlmostEqual(archim.cdfdiff('clayton', U, 1.0, [1 2]), copulapdf('clayton', U, 1.0));
    assertVectorsAlmostEqual(archim.cdfdiff('frank', U, 1.5, [1 2]), copulapdf('frank', U, 1.5));
    assertVectorsAlmostEqual(archim.cdfdiff('gumbel', U, 1.5, [1 2]), copulapdf('gumbel', U, 1.5));
    
function testArchimCdfDiff3D
    U = csvread('data/data3d.csv');
    assertVectorsAlmostEqual(archim.cdfdiff('clayton', U, 1.0, [1 2 3]), archim.pdf('clayton', U, 1.0));
    assertVectorsAlmostEqual(archim.cdfdiff('frank', U, 1.5, [1 2 3]), archim.pdf('frank', U, 1.5));
    assertVectorsAlmostEqual(archim.cdfdiff('gumbel', U, 1.5, [1 2 3]), archim.pdf('gumbel', U, 1.5));
    
