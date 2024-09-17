% This function is used to generate the matrix A and B that will be used to
% solve for the doublet strength and lift coefficient values.
%
% Outputs
% A - N+1 x N+1 array - The A matrix on the left side of the equation
% B - N+1 x 1 array - The B matrix on the right side of the equation
%
% Inputs
% N - real number - the number of panels
% AoA - real number - the angle of attack in degrees
% U_inf - real number - the free stream velocity
% x - 1 x N+2 array - the x coordinates of the surface of airfoil
% z - 1 x N+2 array - the z coordinates of the surface of airfoil

function [A,B] = finding_A_B(N, AoA, U_inf,x,z)
    
    %initialises A & B
    A = zeros(N + 1,N + 1);
    B = zeros(N + 1, 1);

    for i = 1:N
        %finding beta for each panel end point using 'atan2' function
        dz = z(i+1) - z(i); 
        dx = x(i+1) - x(i);
        %use mod to shift the range of angle_b to between 0 to 2pi        
        angle_b = mod(atan2(dz,dx),2*pi);

        %finding mid-point of i th panel using 'mean' function
        cx = mean([x(i), x(i+1)]);
        cz = mean([z(i), z(i+1)]);

        for j = 1:(N+1)
            %finding the velocity at i th panel imparted by j the panel
            [u_ij, v_ij] = cdoublet([cx,cz], [x(j),z(j)], [x(j+1),z(j+1)]);
            A(i, j) = v_ij*cos(angle_b) - u_ij*sin(angle_b);
        end
        B(i) = (-U_inf) * sin( (pi*AoA)/180 - angle_b );
    end
    
    %applying Kutta condition
    A(N+1, 1) = 1;
    A(N+1, N) = -1;
    A(N+1, N+1) = 1;
end