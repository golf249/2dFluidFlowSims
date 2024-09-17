%--------------------------------------------------------------------------
%----------------------AIRFOIL CODE MAIN SCRIPT----------------------------
%--------------------------------------------------------------------------

%housekeeping
clear,clc,close all

%user inputs
code = input('Enter the NACA airfoil code: ', 's');

%case of if it is the NACA 2412 airfoil
if isequal(code, '2412')
    %angles, free stream velocity and N given
    AoA = (0:10); % angle of attack
    N = [50 100 200]; %number of panel
    U_inf = 15; %free stream velocity
    
    %initialises lift coefficient
    C_l = zeros(length(N), length(AoA));

    %calculate lift coefficient for every N panel and every angle of attack
    for i = 1:length(N)
        for j = 1:length(AoA)
            
            %end points panel coordinates generated from function panelgen()
            [x,z] = panelgen(code, N(i), AoA(j));

            %function to find A and B values
            [A, B] = finding_A_B(N(i),AoA(j),U_inf, x, z);
            
            %finding the mu value
            mu_n = A\B;
    
            %lift coefficient
            C_l(i,j) = -(2*mu_n(N(i)+1))/U_inf; %stored in C_l matrix

        end
    end
    
    %read XFOIL data as a table, then turning it into an array
    XFOIL = table2array(readtable('xf-naca2412-il-1000000.txt'));
    
    %finding the index at which the angle of attack is between 0 and 10
    indices = find(XFOIL(:,1) >= 0 & XFOIL(:,1) <= 10);
    
    %Cl vs AoA plot for NACA 2412
    figure(3)
    plot(XFOIL(indices,1), XFOIL(indices, 2), 'k', 'Linewidth', 1.5)
    hold on
    plot(AoA, C_l(1,:), 'Linewidth', 1.5)
    plot(AoA, C_l(2,:), 'Linewidth', 1.5)
    plot(AoA, C_l(3,:), 'Linewidth', 1.5)
    title('Cl vs $\alpha ^\circ$ plot for NACA 2412', 'Interpreter','latex' ...
        , 'FontSize', 16)
    xlabel('$\alpha ^\circ$', 'Interpreter','latex', 'FontSize', 16)
    ylabel('Lift Coefficient $C_l$', 'Interpreter','latex', 'FontSize', 16)
    legend('XFOIL','N = 50', 'N = 100', 'N = 200', 'Fontsize', 14 , ...
        'Interpreter','latex','Location', 'northwest')
    grid minor
    hold off

    %saving the figure programmatically as a jpeg file
    saveas(gcf, 'Cl vs AoA NACA2412.jpg')

    %this is for setting the conditions for the streamline plot of the last
    %case
    N = 200;
    AoA = 10;

%normal case of any NACA airfoil series
else
    %rest of the user input
    U_inf = input('Enter the freestream velocity: ');
    AoA = input('Enter the angle of attack: ');
    N = input('Enter the number of panels to be used: ');

    %end points panel coordinates generated from function panelgen()
    [x,z] = panelgen(code, N, AoA);
    
    %function to find the A and B matrix
    [A, B] = finding_A_B(N, AoA, U_inf,x,z);

    %finding the mu value
    mu_n = A\B;
    
    %lift coefficient
    C_l = -(2*mu_n(N+1))/U_inf;

    %displaying the lift coefficient using text formatting
    fprintf(['The Lift Coefficient at angle of attack of %.1f is %.4f using ' ...
        '%d panels. \n'],AoA, C_l, N)
end

%--------------------------------------------------------------------------
%--------------------------streamline plotting-----------------------------
%--------------------------------------------------------------------------

%plotting the streamline and the airfoil using streamslice
res = 200; %setting the resolution of the grid for streamslice plot

%funciton U_V_field returns the u & v velocity field as well as the x & y
%grid.
[U_field, V_field, x_field, y_field] = U_V_field(N, AoA, U_inf, x, z, mu_n, ...
    res);

figure(1)
%plotting the shape of airfoil
plot(x(1:N+1),z(1:N+1), '-k', LineWidth=2); %setting the line thickness to 2

hold on

%plotting the streamline onto the airfoil plot using streamslice
streamplot = streamslice(x_field,y_field,U_field,V_field); %plotting streamline
set(streamplot, 'LineWidth', 1); %setting linewidth of the airfoil to 1
%limiting the figure frame in the given interval below
xlim([-0.2, 1.2]) %for x axes
ylim([-0.7,0.7]) %for y axes
xlabel('x','Fontsize', 14, 'Interpreter','latex')
ylabel('z','Fontsize', 14, 'Interpreter','latex')
title_text = 'NACA %4d Streamline plot'; %variable to store the title of figure
title_subtext = ['at $\\alpha ^\\circ$ of %2.1f, using N = %d with' ...
    ' $U_{\\infty}$ of %.2f m/s']; %variable to store the subtitle of figure
title(sprintf(title_text, str2double(code)), ...
    sprintf(title_subtext,AoA, N, U_inf), 'Fontsize', ...
    14 ,'Interpreter','latex') %adding title to the figure
hold off

%saving the figure programmatically as a jpeg file using 'saveas' function       
filename = sprintf('arrow_NACA%s.jpg', code);
saveas(gcf, filename)

%plotting the arrow and the airfoil using quiver
figure(2)

%plotting the shape of airfoil
plot(x(1:N+1),z(1:N+1), '-k', LineWidth=2);

hold on 

%plotting the quiver onto the same airfoil plot
res = 1:8:200; %resolution of the arrow plot, plotting every 8th arrow on the grid
quiverplot = quiver(x_field(res,res), y_field(res,res), ...
    U_field(res,res), V_field(res,res), 'b'); %plotting arrow plot using quiver
set(quiverplot, 'AutoScale', 'on', 'AutoScaleFactor', 1.3); %setting the arrow to be bigger
%limiting the figure frame in the given interval below
xlim([-0.2, 1.2]) %for x axes
ylim([-0.7,0.7]) %for y axes
xlabel('x','Fontsize', 14, 'Interpreter','latex')
ylabel('z','Fontsize', 14, 'Interpreter','latex')
title_text = 'NACA %4d Arrow'; %variable to store the title of figure
title_subtext = ['at $\\alpha ^\\circ$ of %2.1f, using N = %d with' ...
    ' $U_{\\infty}$ of %.2f m/s']; %variable to store the subtitle of figure
title(sprintf(title_text, str2double(code)), ...
    sprintf(title_subtext,AoA, N, U_inf), 'Fontsize', ...
    14 ,'Interpreter','latex') %adding title to the figure
hold off

%saving the figure programmatically as a jpeg file        
filename = sprintf('streamline_NACA%s.jpg', code);
saveas(gcf, filename)