%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: e.g. Spring 2025
%
% Function Call:
%     travel = calcSuspensionTravel(bump_height, damping_ratio)
%
% Input Arguments:
%     bump_height    - Height of the road input/bump in meters
%     damping_ratio  - Damping ratio of the suspension system (unitless)
%
% Output Arguments:
%     travel         - Estimated peak suspension travel in meters
%
% Description:
%     This function estimates the peak suspension travel of a simplified 
%     vehicle system in response to a step bump input, based on the 
%     damping ratio and bump height.
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
function travel = ind_proj_demo_calcSuspensionTravel(bump_height, damping_ratio)
%% ____________________
%% CALCULATIONS
if damping_ratio < 1
    % Underdamped system approximation
    travel = bump_height * (1 + exp(-damping_ratio * pi / sqrt(1 - damping_ratio^2)));
else
    % Critically damped or overdamped
    travel = bump_height * 1.1;
end

end