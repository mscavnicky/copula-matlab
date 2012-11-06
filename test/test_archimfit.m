%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archimfit 
initTestSuite;

function testArchimfitGumbel
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archimfit('gumbel', X);
    [ alpha2 ] = copulafit('gumbel', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 0.0001);    
    
function testArchimfitFrank
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archimfit('frank', X);
    [ alpha2 ] = copulafit('frank', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 0.0001);
    
function testArchimfitClayton
% Tests 2 dimensional case of archimfit on copulafit
    X = uniform(normrnd(0, 1, 10000, 2));
    [ alpha1 ] = archimfit('clayton', X);
    [ alpha2 ] = copulafit('clayton', X);
    assertVectorsAlmostEqual(alpha1, alpha2, 'absolute', 0.0001);


