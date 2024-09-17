% This function is used to generate the velocity field for U, V and the
% grid field x, y
%
% Inputs
% N - real number - the number of panels
% AoA - real number - the angle of attack in degrees
% U_inf - real number - the free stream velocity
% x - 1 x N+2 array - the x coordinates of the surface of airfoil
% z - 1 x N+2 array - the z coordinates of the surface of airfoil
% mu_n - real number - doublet strength
% res - real number - it defines the resolution of the points on the grid
%
% Outputs
% U_field - res x res array - the velocity field in the horizontal direction
% V_field - res x res array - the velocity field in the vertical direction
% x_field - res x res array - the x grid field
% y_field - res x res array - the y grid field


function [U_field, V_field, x_field, y_field] = U_V_field(N, AoA, U_inf, x, z, mu_n, res)

    %generating mesh grid for the velocity field
    [x_field, y_field] = meshgrid(linspace(-0.2,1.2,res),linspace(-0.7,0.7,res));

    %initialise the flow field velocity
    U_field(1:res, 1:res) = 0;
    V_field(1:res, 1:res) = 0;
    
    %loop for all the points on the grid of res x res points 
    for i = 1:res
        for j = 1:res
            %initialise the doublet strength
            strength_sum_u = 0;
            strength_sum_v = 0;
            for k = 1:N+1
                %calculate the velocity imparted by the jth panel 
                [u_ij, v_ij] = cdoublet([x_field(i,j), y_field(i,j)], [x(k),z(k)], [x(k+1),z(k+1)]);
                %calculate the doublet strength
                strength_sum_u = strength_sum_u + mu_n(k)*u_ij;
                strength_sum_v = strength_sum_v + mu_n(k)*v_ij;
            end
            %the total velocity of every point on the grid
            U_field(i,j) = (U_inf * cosd(AoA)) +  strength_sum_u;
            V_field(i,j) = (U_inf * sind(AoA)) +  strength_sum_v;
        end
    end
    
    %set the flow inside the airfoil to be zero
    in = inpolygon(x_field, y_field, x(1:N),z(1:N));
    U_field(in) = 0;
    V_field(in) = 0;
end