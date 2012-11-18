%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copulacnd
initTestSuite;

function testGaussianIn2D
% Tests 2 dimensional conditional distribution against true implementation
    U = [0.1 0.2 0.4; 0.3 0.8 0.1; 0.9 0.4 0.5; 0.5 0.5 0.2];
    rho = copulafit('gaussian', U);
    X = copulacnd('gaussian', U, 2, rho);
    r = rho(1,2);
    Y = normcdf( (norminv(U(:,2)) - r * norminv(U(:,1))) / sqrt(1-r*r) );
    assertVectorsAlmostEqual(X, Y);
    
function testGaussianIn3D
% Tests 3D conditional distribution and verifies it produces valid values
    U = [0.1 0.2 0.4; 0.3 0.8 0.1; 0.9 0.4 0.5; 0.5 0.5 0.2];
    rho = copulafit('gaussian', U);
    X = copulacnd('gaussian', U, 3, rho);
    assertEqual(sum(X<0), 0);
    assertEqual(sum(X>1), 0);
    
