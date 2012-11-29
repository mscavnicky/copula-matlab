%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_archim_rnd
initTestSuite;

function testClaytonRnd
    U = archim.rnd('clayton', 1.5, 100, 5);
    assertEqual(sum(sum(U < 0)), 0);
    assertEqual(sum(sum(U > 1)), 0);

function testGumbelRnd
    U = archim.rnd('clayton', 1.5, 100, 5);
    assertEqual(sum(sum(U < 0)), 0);
    assertEqual(sum(sum(U > 1)), 0);

function testFrankRnd
    U = archim.rnd('frank', 1.5, 100, 5);
    assertEqual(sum(sum(U < 0)), 0);
    assertEqual(sum(sum(U > 1)), 0);

    
    