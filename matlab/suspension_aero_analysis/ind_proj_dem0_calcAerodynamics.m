%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: e.g. Spring 2025
%
% Function Call:
%     [lift, drag] = calcAerodynamics(rho, A, Cl, Cd, V)
%
% Input Arguments:
%     rho - Air density in kg/m^3
%     A   - Frontal area of the vehicle in m^2
%     Cl  - Lift coefficient (unitless)
%     Cd  - Drag coefficient (unitless)
%     V   - Vector of speeds in m/s
%
% Output Arguments:
%     lift - Vector of downforce values in N
%     drag - Vector of drag force values in N
%
% Description:
%     This function calculates aerodynamic downforce (lift) and drag 
%     based on dynamic pressure and vehicle characteristics across a range
%     of speeds.
%
% Assignment Information:
%     Assignment:     Individual Project - MATLAB UDF
%     Team ID:        LC1 - 20
%     Author:         Noah Walden, walden28@purdue.edu
%     Date:           04/22/2025
%
% Contributor:
%     Name, login@purdue [repeat for each]
%
%     My contributor(s) helped me:
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%     Note that if you helped somebody else with their code, you
%     have to list that person as a contributor here as well.
%
% Academic Integrity Statement:
%     I have not used source code obtained from any unauthorized
%     source, either modified or unmodified; nor have I provided
%     another student access to my code.  The project I am
%     submitting is my own original work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [lift, drag] = ind_proj_dem0_calcAerodynamics(rho, A, Cl, Cd, V)

%% ____________________
%% CALCULATIONS
q = 0.5 * rho * V.^2;  % Dynamic pressure
lift = q * A * Cl;     % Downforce
drag = q * A * Cd;     % Drag force

end