%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_fit 
initTestSuite;

function testArchimfitGumbel
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archim.fit('gumbel', X);
    [ alpha2 ] = copulafit('gumbel', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 1e-6);
    
function testArchimfitFrank
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archim.fit('frank', X);
    [ alpha2 ] = copulafit('frank', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 1e-6);
    
function testArchimfitClayton
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archim.fit('clayton', X);
    [ alpha2 ] = copulafit('clayton', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 1e-6);
    
    


