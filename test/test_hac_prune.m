%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_hac_prune
initTestSuite;

function testHacPruneDoesNotWorkForMultivariateHAC
    assertExceptionThrown(@() hac.prune({1 2 3 4 0.5}, 2), '');

function testHacPrune2D
    assertEqual({1 2 0.5}, hac.prune({1 2 0.5}, 2));
    assertEqual(1, hac.prune({1 2 0.5}, 1));
    assertEqual(0, hac.prune({1 2 0.5}, 0));
    
function testHacPrune3D
    assertEqual({1 {2 3 0.7} 0.5}, hac.prune({1 {2 3 0.7} 0.5}, 3));
    assertEqual({1 2 0.5}, hac.prune({1 {2 3 0.7} 0.5}, 2));
    assertEqual(1, hac.prune({1 {2 3 0.7} 0.5}, 1));
    assertEqual(0, hac.prune({1 {2 3 0.7} 0.5}, 0));
    
function testHacPrune4DFullyNested
    assertEqual({1 {2 {3 4 0.9} 0.7} 0.5}, hac.prune({1 {2 {3 4 0.9} 0.7} 0.5}, 4));
    assertEqual({1 {2 3 0.7} 0.5}, hac.prune({1 {2 {3 4 0.9} 0.7} 0.5}, 3));
    assertEqual({1 2 0.5}, hac.prune({1 {2 {3 4 0.9} 0.7} 0.5}, 2));
    assertEqual(1, hac.prune({1 {2 {3 4 0.9} 0.7} 0.5}, 1));
    assertEqual(0, hac.prune({1 {2 {3 4 0.9} 0.7} 0.5}, 0));
    
function testHacPrune4DPartiallyNested
    assertEqual({{1 2 0.8} {3 4 0.9} 0.5}, hac.prune({{1 2 0.8} {3 4 0.9} 0.5}, 4));
    assertEqual({{1 2 0.8} 3 0.5}, hac.prune({{1 2 0.8} {3 4 0.9} 0.5}, 3));
    assertEqual({1 2 0.8}, hac.prune({{1 2 0.8} {3 4 0.9} 0.5}, 2));
    assertEqual(1, hac.prune({{1 2 0.8} {3 4 0.9} 0.5}, 1));
    assertEqual(0, hac.prune({{1 2 0.8} {3 4 0.9} 0.5}, 0));