% This function is used to generate the coordinates of the panel end points
% including the wake panel
%
% Outputs
% x_UL - real number - x coordinate of the points on the airfoil surface
% z_UL - real number - z coordinate of the points on the airfoil surface
%
% Inputs
% code  - string - the NACA code used for specifying the shape of airfoil
% N - real number - the number of panels
% AoA - real number - the angle of attack in degrees

function [x_UL,z_UL] = panelgen(code, N, AoA)

m = str2double(code(1))/100; %maximum camber in percent
p = str2double(code(2))/10; %location of max camber in tenths of chord
t = str2double(code(3:4))/100; %max airfoil thickness in percent

%panel endpoint x
x = 1 - 0.5*(1 - cos(2*pi.*((1:N+1) - 1)/N));

%mean camber line y_c
y_c = zeros(length(x),1)';

for i = 1:length(x)
    if 0 <= x(i) && x(i) < p
        y_c(i) = (m/p^2)*(2*p*x(i) - x(i)^2);
    else
        y_c(i) = (m/(1-p)^2)*((1-2*p) + 2*p*x(i) - x(i)^2);
    end
end

%thickness function y_t 0.1036
y_t = 5*t*(0.2969.*sqrt(x) - 0.126.*x - 0.3516.*x.^2 + 0.2843.*x.^3 - 0.1015.*x.^4);
y_t(1) = 0;
y_t(end) = 0;

%derivative of function y_c
dy_c = zeros(length(x),1)';

for i = 1:length(x)
    if 0 <= x(i) && x(i) < p
        dy_c(i) = ((2*m)/p^2)*(p-x(i));
    else
        dy_c(i) = (((2*m)/(1-p)^2)*(p-x(i)));
    end
end

%theta of each panel
theta = zeros(length(x),1)';

for i = 1:length(x)
    theta = atan(dy_c);
end

%each panel end point stored in an array
x_UL = zeros(length(x),1)'; 
z_UL = zeros(length(x),1)'; 

for i = 1:length(x)
    if i < (N/2 + 1)
        x_UL(i) = x(i) + y_t(i).*sind(theta(i));
        z_UL(i) = y_c(i) - y_t(i).*cos(theta(i));
    else
        x_UL(i) = x(i) - y_t(i).*sind(theta(i));
        z_UL(i) = y_c(i) + y_t(i).*cos(theta(i));
    end
end

%creating the wake panel
x_UL(N+2) = 10^300 * cosd(AoA);
z_UL(N+2) = 10^300 * sind(AoA);

end