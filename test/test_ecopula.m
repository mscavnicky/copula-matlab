%#ok<*DEFNU>
%#ok<*STOUT>

function test_suite = test_ecopula
initTestSuite;

function testEmpiricalCopulaIn2D_1
    X = [1, 2; 3, 4; 5, 6; 7, 8];
    C = [0.25; 0.5; 0.75; 1.0];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));

function testEmpiricalCopulaIn2D_2
    X = [0.1 0.2; 0.9 0.4; 0.5 0.5; 0.2 0.4; 0.9, 0.9];
    C = [0.2; 0.6; 0.6; 0.4; 1.0];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));
    
function testEmpiricalCopulaIn2DWithEqualElements
    X = [1, 1; 2, 2; 1, 1; 2, 2; 3, 3];
    C = [0.4; 0.8; 0.4; 0.8; 1.0];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));    
    
function testEmpiricalCopulaIn3D
    X = [0.1 0.2 0.3; 0.9 0.4 0.5; 0.5 0.5 0.8; 0.2 0.4 0.7; 0.9 0.9 0.9];
    C = [0.2; 0.4; 0.6; 0.4; 1.0];
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));
    
function testEmpiricalCopulaIn3DAgainstR
    X = csvread('data/data3d.csv');
    C = csvread('data/test_ecopula_3d.csv');
    assertVectorsAlmostEqual(C, ecopula(uniform(X)));
        