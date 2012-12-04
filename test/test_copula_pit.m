%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_pit
initTestSuite;

function testGaussianPitIn2D
    X = csvread('data/data2d.csv');
    E = csvread('data/test_copula_pit_gaussian2d.csv');
    copulaparams.rho = covmat(0.57);
    assertVectorsAlmostEqual(E, copula.pit('gaussian', X, copulaparams));
    
function testGaussianPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_gaussian3d.csv');
    copulaparams.rho = covmat([0.18, 0.23, 0.74]);
    assertVectorsAlmostEqual(E, copula.pit('gaussian', X, copulaparams));
    
function testClaytonPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_clayton3d.csv');
    copulaparams.alpha = 0.9912;
    assertVectorsAlmostEqual(E, copula.pit('clayton', X, copulaparams));
    
function testGumbelPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_gumbel3d.csv');
    copulaparams.alpha = 1.4529;
    assertVectorsAlmostEqual(E, copula.pit('gumbel', X, copulaparams));