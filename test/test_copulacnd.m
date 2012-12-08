%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copulacnd
initTestSuite;

function testGaussianIn2D
    U = csvread('data/data3d.csv');
    copulaparams.rho = covmat([0.18, 0.23, 0.74]);
    X = copula.cnd('gaussian', U, 2, copulaparams);
    Y = csvread('data/test_copulacnd_gaussian2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGaussianIn3D
    U = csvread('data/data3d.csv');
    copulaparams.rho = covmat([0.18, 0.23, 0.74]);
    X = copula.cnd('gaussian', U, 3, copulaparams);
    Y = csvread('data/test_copulacnd_gaussian3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testStudentIn2D
    U = csvread('data/data3d.csv');
    copulaparams.rho = covmat([0.37, 0.52, 0.77]);
    copulaparams.nu = 5;    
    X = copula.cnd('t', U, 2, copulaparams);
    Y = csvread('data/test_copulacnd_t2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testStudentIn3D
    U = csvread('data/data3d.csv');
    copulaparams.rho = covmat([0.37, 0.52, 0.77]);
    copulaparams.nu = 5; 
    X = copula.cnd('t', U, 3, copulaparams);
    Y = csvread('data/test_copulacnd_t3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonIn2D
    U = csvread('data/data2d.csv');
    copulaparams.alpha = 1.4557;
    X = copula.cnd('clayton', U, 2, copulaparams);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonIn3D
    U = csvread('data/data3d.csv');
    copulaparams.alpha = 0.9912;
    X = copula.cnd('clayton', U, 3, copulaparams);
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGumbelIn3D
    U = csvread('data/data3d.csv');
    copulaparams.alpha = 1.4529;
    X = copula.cnd('gumbel', U, 3, copulaparams);
    Y = csvread('data/test_copulacnd_gumbel3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn2D
    U = csvread('data/data2d.csv');
    copulaparams.tree = {1 2 1.4557};
    X = copula.cnd('claytonhac', U, 2, copulaparams);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn3D
    U = csvread('data/data3d.csv');
    copulaparams.tree = {1 2 3 0.9912};
    X = copula.cnd('claytonhac', U, 3, copulaparams);
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y); 
    
    