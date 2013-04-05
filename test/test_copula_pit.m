%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_pit
initTestSuite;

function testGaussianPitIn2D
    X = csvread('data/data2d.csv');
    E = csvread('data/test_copula_pit_gaussian2d.csv');
    gaussian2 = struct('family', 'gaussian', 'rho', covmat(0.57));
    assertVectorsAlmostEqual(E, copula.rosenblattTransform(gaussian2, X));
    
function testGaussianPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_gaussian3d.csv');
    gaussian3 = struct('family', 'gaussian', 'rho', covmat([0.18, 0.23, 0.74]));
    assertVectorsAlmostEqual(E, copula.rosenblattTransform(gaussian3, X));
    
function testGaussianPitIn7D
    X = csvread('data/data7d.csv');
    E = csvread('data/test_copula_pit_gaussian7d.csv');
    rho = covmat([0.1003, 0.0573, 0.0548,-0.0287, 0.0260, 0.0559, 0.0858, -0.0256, -0.0509, -0.0824, 0.0413, 0.1022, -0.1138, 0.0983, 0.0552, 0.0952, -0.0668, 0.0905, -0.0617, 0.0725, 0.0040]);
    gaussian7 = struct('family', 'gaussian', 'rho', rho);
    assertVectorsAlmostEqual(E, copula.rosenblattTransform(gaussian7, X));
    
function testClaytonPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_clayton3d.csv');
    clayton3 = struct('family', 'clayton', 'alpha', 0.9912);
    assertVectorsAlmostEqual(E, copula.rosenblattTransform(clayton3, X));
    
function testGumbelPitIn3D
    X = csvread('data/data3d.csv');
    E = csvread('data/test_copula_pit_gumbel3d.csv');
    gumbel3 = struct('family', 'gumbel', 'alpha', 1.4529);
    assertVectorsAlmostEqual(E, copula.rosenblattTransform(gumbel3, X));