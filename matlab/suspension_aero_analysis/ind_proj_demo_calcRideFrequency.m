%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: e.g. Spring 2025
%
% Function Call:
%     freq = calcRideFrequency(spring_rate, mass)
%
% Input Arguments:
%     spring_rate - Suspension spring stiffness in N/m
%     mass - Sprung mass of the vehicle in kg
%
% Output Arguments:
%     freq - Ride frequency in Hz
%
% Description:
%     Replace this line with a description of your program.
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
function freq = ind_proj_demo_calcRideFrequency(spring_rate, mass)
%% ____________________
%% CALCULATIONS
freq = (1/(2*pi)) * sqrt(spring_rate / mass);

end