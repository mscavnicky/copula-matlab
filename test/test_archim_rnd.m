%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_rnd
initTestSuite;

function testClaytonRnd
    U = archim.rnd('clayton', 1.5, 1000, 5);
    assertInRange(U, 0, 1);
    X = csvread('data/test_copula_rnd_clayton.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);    

function IGNORE_testGumbelRnd    
    U = archim.rnd('gumbel', 1.5, 1000, 5);
    assertInRange(U, 0, 1);
    X = csvread('data/test_copula_rnd_gumbel.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);
    
function testGumbelRndAgainstMatlab
    U = archim.rnd('gumbel', 1.5, 1000, 2);
    assertInRange(U, 0, 1);
    X = copularnd('gumbel', 1.5, 1000);
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);

function testFrankRnd
    U = archim.rnd('frank', 1.5, 1000, 5);
    assertInRange(U, 0, 1);
    X = csvread('data/test_copula_rnd_frank.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0); 
    
function assertInRange( X, x1, x2 )
    assertEqual(sum(sum(X < x1)), 0);
    assertEqual(sum(sum(X > x2)), 0);

function [ H ] = mvkstest2(X, Y)    
    assert(size(X, 2) == size(Y, 2), 'Dimensions do not match.');
    
    d = size(X, 2);
    H = zeros(d, 2);
    for i=1:d
        [h p] = kstest2(X(:,i), Y(:,i), 0.01);
        H(i,:) = [h p];
    end
    
    