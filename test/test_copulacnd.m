%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copulacnd
initTestSuite;

function testGaussianIn2D
    U = csvread('data/data3d.csv');
    rho = [1, 0.18, 0.23; 0.18, 1, 0.74; 0.23 0.74, 1];
    X = copula.cnd('gaussian', U, 2, rho);
    Y = csvread('data/test_copulacnd_gaussian2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGaussianIn3D
    U = csvread('data/data3d.csv');
    rho = [1, 0.18, 0.23; 0.18, 1, 0.74; 0.23 0.74, 1];
    X = copula.cnd('gaussian', U, 3, rho);
    Y = csvread('data/test_copulacnd_gaussian3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testStudentIn2D
    U = csvread('data/data3d.csv');
    rho = [1, 0.37, 0.52; 0.37, 1, 0.77; 0.52, 0.77 1];
    df = 5;
    X = copula.cnd('t', U, 2, rho, df);
    Y = csvread('data/test_copulacnd_t2d.csv');
    assertVectorsAlmostEqual(X, Y, 'absolute', 0.05);
    
function testStudentIn3D
    U = csvread('data/data3d.csv');
    rho = [1, 0.37, 0.52; 0.37, 1, 0.77; 0.52, 0.77 1];
    df = 5;
    X = copula.cnd('t', U, 3, rho, df);
    Y = csvread('data/test_copulacnd_t3d.csv');
    assertVectorsAlmostEqual(X, Y, 'absolute', 0.07);
    
function testClaytonIn2D
    U = csvread('data/data2d.csv');
    X = copula.cnd('clayton', U, 2, 1.4557);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonIn3D
    U = csvread('data/data3d.csv');
    X = copula.cnd('clayton', U, 3, 0.9912);
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGumbelIn3D
    U = csvread('data/data3d.csv');
    X = copula.cnd('gumbel', U, 3, 1.4529);
    Y = csvread('data/test_copulacnd_gumbel3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn2D
    U = csvread('data/data2d.csv');
    X = copula.cnd('clayton', U, 2, {1 2 1.4557});
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn3D
    U = csvread('data/data3d.csv');
    X = copula.cnd('clayton', U, 3, {1 2 3 0.9912});
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y); 
    
    