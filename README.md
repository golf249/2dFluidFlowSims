%
# 2dFluidFlowSims

Computationally calculated the flow field around a NACA 4-digit series using a simple Panel Code in MATLAB. The focus is on potential flow, assuming the fluid is incompressible, inviscid, and irrotational. The simulation aims to model the flow field by discretizing the airfoil surface into multiple panels, each affecting the surrounding flow.

## Project Description
The simulation uses doublet elements to represent the airfoil surface and computes the resulting velocity field using a system of linear equations. The project also calculates and plots key aerodynamic properties such as velocity vectors, streamlines, and the lift coefficient (CL) for various airfoils under different conditions.

Key features of this project include:

- Discretization of a NACA 4-series airfoil surface into panels using cosine spacing.
- Implementation of the potential flow equations, including:
  - Mean camber line (Equation 1)
  - Thickness distribution (Equation 2)
  - Velocity components based on panel geometry (Equations 8 and 9).
- Solving the system of linear equations to determine the strengths of the doublet elements on each panel.
- Implementation of the Kutta condition to ensure smooth airflow at the trailing edge (Equation 13).
- Plotting velocity field vectors and streamlines around the airfoil.

## Implementation Details
1. Airfoil Geometry and Discretization:

- Airfoils are generated using the NACA 4-series method, which involves computing the camber line and thickness distribution over the chord length.
- Panel endpoints are computed using a cosine distribution:

$$
x_i = 1 - 0.5(1 - \cos(2\pi \frac{i - 1}{N}))
$$

where 𝑁is the number of panels.

2. Velocity Calculations:

- The horizontal and vertical velocities ($U_i, V_i$) at the center of each panel are calculated based on the contribution of the freestream velocity and all other panels:

$$
U_i = U_\infty \cos(\alpha) + \sum_{j=1}^{N+1} \mu_j u_{ij}
$$

$$
V_i = U_\infty \sin(\alpha) + \sum_{j=1}^{N+1} \mu_j v_{ij}
$$
 
3. Lift Coefficient Calculation:

- The lift coefficient is estimated using the strength of the wake panel doublet:

$$
C_L = -\frac{2\mu_{N+1}}{U_\infty}
$$

4. Kutta Condition:

- Ensuring smooth flow at the trailing edge by enforcing:

$$
\mu_{N+1} + \mu_1 - \mu_N = 0
$$

## Simulation Results
- Velocity fields and streamlines are visualized for different airfoils and angles of attack. The results include:
  - Flow around a NACA 2412 airfoil at various angles of attack (α).
  - Comparison of lift coefficients (CL) for various panel numbers (N) and angles of attack, plotted against XFOIL data.

## Plots and Analysis
- Lift coefficient vs. Angle of Attack (CL vs. α):
  - Comparison of MATLAB simulation with XFOIL data over a range of angles of attack (0°–10°).
  - Influence of panel count on accuracy (N = 50, 100, 200).
- Streamlines and Velocity Fields:
  - Detailed visualizations of the flow field around various airfoils, showcasing the effect of increasing panel numbers and changing angles of attack.

## How to Use
 - The code includes a function `panelgen()` that generates and discretizes the airfoil surface.
 - The user can input:
    - Airfoil code (e.g., `2412`)
    - Freestream velocity
    - Angle of attack (α)
    - Number of panels (N)
- The script solves for the panel strengths and generates plots of:
    - Lift coefficient CL vs. Angle of attack
    - Velocity field and streamlines around the airfoil

## Files Included
- MATLAB `.m` files for panel generation, solving the system of equations, and plotting the results.
- Figures showing velocity fields, streamlines, and CL vs. alpha plots.
