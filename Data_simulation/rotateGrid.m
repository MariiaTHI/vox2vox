% Function to perform grid rotation
function [Xr, Yr, Zr] = rotateGrid(X, Y, Z, alpha, beta)
    rad_alpha = alpha * pi/180;
    rad_beta = beta * pi/180;
    Xr = (X*cos(rad_alpha) + Y*sin(rad_alpha))*cos(rad_beta) + Z*sin(rad_beta);
    Yr = (Y*cos(rad_alpha) - X*sin(rad_alpha))*cos(rad_beta);
    Zr = Z*cos(rad_beta) - (X*cos(rad_alpha) + Y*sin(rad_alpha))*sin(rad_beta);
end
