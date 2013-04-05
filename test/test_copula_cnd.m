%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_cnd
initTestSuite;

function testGaussianIn2D
    U = csvread('data/data3d.csv');
    gaussian3 = struct('family', 'gaussian', 'rho', covmat([0.18, 0.23, 0.74]));
    X = copula.cnd(gaussian3, U, 2);
    Y = csvread('data/test_copulacnd_gaussian2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGaussianIn3D
    U = csvread('data/data3d.csv');
    gaussian3 = struct('family', 'gaussian', 'rho', covmat([0.18, 0.23, 0.74]));
    X = copula.cnd(gaussian3, U, 3);
    Y = csvread('data/test_copulacnd_gaussian3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testStudentIn2D
    U = csvread('data/data3d.csv');
    student3 = struct('family', 't', 'rho', covmat([0.37, 0.52, 0.77]), 'nu', 5);
    X = copula.cnd(student3, U, 2);
    Y = csvread('data/test_copulacnd_t2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testStudentIn3D
    U = csvread('data/data3d.csv');
    student3 = struct('family', 't', 'rho', covmat([0.37, 0.52, 0.77]), 'nu', 5);
    X = copula.cnd(student3, U, 3);
    Y = csvread('data/test_copulacnd_t3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonIn2D
    U = csvread('data/data2d.csv');
    X = archim.cnd('clayton', U, 1.4557, 2);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonIn3D
    U = csvread('data/data3d.csv');
    X = archim.cnd('clayton', U, 0.9912, 3);
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testGumbelIn3D
    U = csvread('data/data3d.csv');
    X = archim.cnd('gumbel', U, 1.4529, 3);
    Y = csvread('data/test_copulacnd_gumbel3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn2D
    U = csvread('data/data2d.csv');
    X = hac.cnd('clayton', U, {1 2 1.4557}, 2);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatHacClaytonIn3D
    U = csvread('data/data3d.csv');
    X = hac.cnd('clayton', U, {1 2 3 0.9912}, 3);
    Y = csvread('data/test_copulacnd_clayton3d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testFlatFastHacClaytonIn2D
    U = csvread('data/data2d.csv');
    X = hac.fastCnd('clayton', U, {1 2 1.4557}, 2);
    Y = csvread('data/test_copulacnd_clayton2d.csv');
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonHacIn3D
    U = csvread('data/data3d.csv');
    X = hac.cnd('clayton', U, {1 { 2 3 2.2 } 0.9912}, 3);
    Y = hac.fastCnd('clayton', U, {1 { 2 3 2.2 } 0.9912}, 3);
    assertVectorsAlmostEqual(X, Y);
    
function testClaytonHacIn4D
    U = csvread('data/data7d.csv');
    X = hac.cnd('clayton', U(:, 1:4), {{1 2 2.2} { 3 4 1.2 } 0.9912}, 3);
    Y = hac.fastCnd('clayton', U(:, 1:4), {{1 2 2.2} { 3 4 1.2 } 0.9912}, 3);
    assertVectorsAlmostEqual(X, Y);
    