%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_dprint
initTestSuite;

function testPrintInt
    assertEqual('1', dprint(1));
    
function testPrintFloat
    assertEqual('2.123', dprint(2.123));
    
function testPrintLongPrecisionFloat
    assertEqual('2.1235', dprint(2.123456789));
    
function testPrintRowVector
    assertEqual('[1 2 3]', dprint([1 2 3]));
    
function testPrintColumnVector
    assertEqual('[1;2;3]', dprint([1; 2; 3]));
    
function testPrintMatrix
    assertEqual('[1 2 3;4 5 6]', dprint([1 2 3;4 5 6]));
    
function testPrintCellArray
    assertEqual('{1, 2, 3}', dprint({1, 2, 3}));
    
function testPrintMap
    m = containers.Map({'a', 'b', 'c'}, {1, 2, 3});
    assertEqual('#{''a'':1, ''b'':2, ''c'':3}', dprint(m));