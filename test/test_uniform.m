%#ok<*DEFNU>
%#ok<*STOUT>

% Test was also compared with R implementation. R implementation uses
% different treating of ties.

function test_suite = test_uniform
initTestSuite;

function testUniformRowVector
    x = [1 2 3 3 4 5 1];
    expected = [0.25 0.375 0.625 0.625 0.75 0.875 0.25];
    assertVectorsAlmostEqual(expected, uniform(x, 2));
    
function testUniformColumnVector
    x = [1; 2; 3; 3; 4; 5; 5];
    expected = [0.125; 0.25; 0.5; 0.5; 0.625; 0.875; 0.875];
    assertVectorsAlmostEqual(expected, uniform(x, 1));
    
function testUniformMatrix
    X = [1 2 3; 4 5 6];
    expected = [0.3333 0.3333 0.3333; 0.6666 0.6666 0.6666];
    assertVectorsAlmostEqual(expected, uniform(X), 'absolute', 0.001);

