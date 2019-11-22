function [phi, y] = getphi(vecX)

    nonzero = find(vecX ~=0);
    phi = zeros(size(nonzero,1), size(vecX,1));
    for i2=1:size(nonzero,1)
        phi(i2,nonzero(i2)) = 1;       
    end
    y = phi*vecX;
   
    
end