%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_gof_stat
initTestSuite;

function testSnCGaussian7D
    U = csvread('data/data7d.csv');
    assertVectorsAlmostEqual(copula.snc(U), 0.02247455);
    
function testSnBGaussian7D
    U = csvread('data/data7d.csv');
    assertVectorsAlmostEqual(copula.snb(U), 0.009721139);

    