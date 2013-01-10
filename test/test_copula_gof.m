%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_gof
initTestSuite;

function testSnCGaussian2D
    U = uniform(copularnd('gaussian', 0.5, 1000, 2));
    copulaparams = copula.fit('gaussian', U);      
    [~, p] = copula.gof(copulaparams, U, 200, 'snc', 0);
    assertTrue(p > 0.05);
    
function testSnBGaussian2D
    U = uniform(copularnd('gaussian', 0.5, 1000, 2));
    copulaparams = copula.fit('gaussian', U);
    [~, p] = copula.gof(copulaparams, U, 200, 'snb', 0);   
    assertTrue(p > 0.05);
    
function testSnCClayton2D
    clayton2.family = 'clayton';
    clayton2.alpha = 1.5;
    U = uniform(copula.rnd('clayton', 1000, 2, clayton2));
    copulaparams = copula.fit('clayton', U);
    [~, p] = copula.gof(copulaparams, U, 200, 'snc', 0);
    assertTrue(p > 0.05);
    
function testSnBClayton2D
    clayton2.family = 'clayton';
    clayton2.alpha = 1.5;
    U = uniform(copula.rnd('clayton', 1000, 2, clayton2));
    copulaparams = copula.fit('clayton', U);
    [~, p] = copula.gof(copulaparams, U, 200, 'snb', 0);
    assertTrue(p > 0.05);