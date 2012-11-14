function copulaexplore

[U1, U2, C] = sampleCopula('Gaussian', 0.0);


figure('Name', 'Copula explorer', 'Toolbar', 'figure', 'NumberTitle', 'off');
surfHandle = surf(U1, U2, C);
xlabel('u1'); 
ylabel('u2');

familyHandle = uicontrol('Style', 'popup', 'Position', [20, 20, 100, 20]);
set(familyHandle, 'String', 'Gaussian|t|Frank|Clayton|Gumbel');

alphaHandle = uicontrol('Style', 'slider', 'String', 'Alpha', 'Position', [20, 50, 100, 20]);
set(alphaHandle, 'Min', 0);
set(alphaHandle, 'Max', 100);
set(alphaHandle, 'Value', 0.0);
set(alphaHandle, 'SliderStep', [0.001, 0.001]);

set(familyHandle, 'Callback', {@setFamily, surfHandle, alphaHandle, familyHandle});
set(alphaHandle, 'Callback', {@setAlpha, surfHandle, alphaHandle, familyHandle});

end

function setFamily( ~, ~, surfHandle, alphaHandle, familyHandle )
    families = containers.Map({ 1, 2, 3, 4, 5 }, {'Gaussian', 't', 'Frank', 'Clayton', 'Gumbel'});
    bounds = containers.Map({ 1, 2, 3, 4, 5 }, { [-1,1], [-1,1], [-10,10], [0,10], [1,10] });
    alpha = get(alphaHandle, 'Value');
    family = get(familyHandle, 'Value');
    
    b = bounds(family);
    set(alphaHandle, 'Min', b(1));
    set(alphaHandle, 'Max', b(2));
    set(alphaHandle, 'Value', 0);
    
    [~, ~, C] = sampleCopula(families(family), alpha);    
    set(surfHandle, 'ZData', C);
end
    
function setAlpha( ~, ~, surfHandle, alphaHandle, familyHandle )
    families = containers.Map({ 1, 2, 3, 4, 5 }, {'Gaussian', 't', 'Frank', 'Clayton', 'Gumbel'});
    family = get(familyHandle, 'Value');
    alpha = get(alphaHandle, 'Value');
    [~, ~, C] = sampleCopula(families(family), alpha);    
    set(surfHandle, 'ZData', C);
end

function [ U1, U2, C ] = sampleCopula( family, alpha )
    n = 20;
    u = linspace(0, 1, n);
    [U1, U2] = meshgrid(u, u);
    U = [U1(:) U2(:)];
    
    switch family 
        case 'Gaussian'
            rho = [1 alpha; alpha 1];
            C = copulapdf(family, U, rho);        
        case 't'
            rho = [1 alpha; alpha 1];
            C = copulapdf(family, U, rho, 2); 
        otherwise
            C = copulapdf(family, U, alpha);        
    end
    C = reshape(C, n, n);
end