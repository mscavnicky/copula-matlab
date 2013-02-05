%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_copula_gof
initTestSuite;

function testSnCGaussian2D
    U = uniform(copularnd('gaussian', 0.5, 1000));
    copulaparams = copula.fit('gaussian', U);      
    [~, p] = copula.gof(copulaparams, U, 100, 'snc', 0);
    assertTrue(p > 0.05);
    
function testSnCGaussian10D
    U = uniform(copularnd('gaussian', corrrnd(10), 1000));
    copulaparams = copula.fit('gaussian', U);      
    [~, p] = copula.gof(copulaparams, U, 100, 'snc', 0);
    assertTrue(p > 0.05);
    
function testSnBGaussian2D
    U = uniform(copularnd('gaussian', 0.5, 1000, 2));
    copulaparams = copula.fit('gaussian', U);
    [~, p] = copula.gof(copulaparams, U, 100, 'snb', 0);  
    assertTrue(p > 0.05);
    
function testSnBGaussian10D
    U = uniform(copularnd('gaussian', corrrnd(10), 1000));
    copulaparams = copula.fit('gaussian', U);      
    [~, p] = copula.gof(copulaparams, U, 100, 'snb', 0);
    assertTrue(p > 0.05);
    
function testSnCClayton2D
    clayton2.family = 'clayton';
    clayton2.alpha = 1.5;
    U = uniform(copula.rnd('clayton', 1000, 2, clayton2));
    copulaparams = copula.fit('clayton', U);
    [~, p] = copula.gof(copulaparams, U, 100, 'snc', 0);
    assertTrue(p > 0.05);
    
function testSnBClayton2D
    clayton2.family = 'clayton';
    clayton2.alpha = 1.5;
    U = uniform(copula.rnd('clayton', 1000, 2, clayton2));
    copulaparams = copula.fit('clayton', U);
    [~, p] = copula.gof(copulaparams, U, 100, 'snb', 0);
    assertTrue(p > 0.05);
    
function [ S ] = corrrnd( d )
% http://stackoverflow.com/questions/1037340/
    S = rand(d);
    S = S' * S;
    s = sqrt(diag(S));
    S = diag(1./s) * S * diag(1./s);
    S(logical(eye(d))) = 1;
    