%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_ecopula
initTestSuite;

function testEmpiricalCopulaIn2D_1
    X = [1, 2; 3, 4; 5, 6];
    C = [0.25; 0.5; 0.75];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));

function testEmpiricalCopulaIn2D_2
    X = [0.1 0.2; 0.9 0.4; 0.5 0.5; 0.2 0.4];
    C = [0.2; 0.6; 0.6; 0.4];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));
    
function testEmpiricalCopulaIn2DWithEqualElements
    X = [1, 1; 2, 2; 1, 1; 2, 2];
    C = [0.4; 0.8; 0.4; 0.8];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));    
    
function testEmpiricalCopulaIn3D
    X = [0.1 0.2 0.3; 0.9 0.4 0.5; 0.5 0.5 0.8; 0.2 0.4 0.7];
    C = [0.2; 0.4; 0.6; 0.4];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));