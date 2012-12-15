%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_hac_rnd
initTestSuite;

function testFlatHacClaytonRnd
    U = hac.rnd('clayton', {1, 2, 3, 4, 5 1.5}, 1000);
    assertInRange(U, 0, 1);
    X = csvread('data/test_copula_rnd_clayton.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);
   
function testFlatHacGumbelRndAgainstMatlab
    U = hac.rnd('gumbel', {1 2 1.5}, 1000);
    assertInRange(U, 0, 1);
    X = copularnd('gumbel', 1.5, 1000);
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);

function testFlatHacFrankRnd
    U = hac.rnd('frank', {1 2 3 4 5 1.5}, 1000);
    assertInRange(U, 0, 1);
    X = csvread('data/test_copula_rnd_frank.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0); 
    
function testHacGumbelRnd
    U = hac.rnd('gumbel', {1, {2, 3, 2.0}  1.25}, 1000);
    assertInRange(U, 0, 1);
    X = csvread('data/test_hac_rnd_gumbel3d.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);
    
function testHacFrankRnd
    U = hac.rnd('frank', {1, {2, 3, 2.0}  1.25}, 1000);
    assertInRange(U, 0, 1);
    X = csvread('data/test_hac_rnd_frank3d.csv');    
    H = mvkstest2(U, X);
    assertEqual(sum(H(:,1)), 0);
  
function testHacClaytonRnd
    U = hac.rnd('clayton', {1, {2, 3, 2.0}  1.25}, 1000);
    assertInRange(U, 0, 1);
    X = csvread('data/test_hac_rnd_clayton3d.csv');    
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
    
    