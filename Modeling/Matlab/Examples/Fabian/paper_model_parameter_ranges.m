function [prms_info,prms_str,prms_str2] = paper_model_parameter_ranges
% % FUNCTION: MODEL_PARAMETER_RANGES
% % AUTHOR: Fabian Santiago
% % EMAIL: fsantiago3@ucmerced.edu
% % DATE: 12/4/2020
% %     Creates a matrix of information for each parameter in the COV-19
% %     model. Each ROW represents ONE parameter and includes: 
% %        (i) if sensitivity is to be determined: true/false (index 1)
% %       (ii) the range of of the parameter values (index 2 and index 3)
% %      (iii) if the parameter is in days: true/false (index 4)

prms_info = [... % [SA_Bool a  b Days_Bool]
% CONTACT MULTIPLIERS   
   false 1.00  1.00   false;... % (1) livingM: multiplies living contacts matrix 
   false 1.00  1.00   false;... % (2) dormM: multiplies dorm undergrad students to dorm undergrad students living contacts (just the (2,2) entry of the living matrix) 
   true  1.00  10.00   false;... % (3) communityM: multiplies contacts between (U,D,G,F) and the community
% CONDITIONS FOR THE MERCED COMMUNITY : Force of Infection for Merced Area:   
   true  0.00  0.10   false;... % (4) pM = fraction with COV in Merced (default has been 0.03)
   false 0.20  0.20   false;... % (5) pA = fraction Asymptomatic in Merced (default has been 0.20)
% SOCIAL CONTACT PARAMETERS
   false  0.75  0.75   false;... % (6) frac_social: the fraction of the time you socialize with your same students
   true  1.00  10.00   false;... % (7) partysize [0,10,20]
   true  1.00  10.00   false;... % (8) weekend_multiplier [1,10,20,50]
% INITIAL CONDITIONS
   true  1.00  50.00   false;... % (9) symptomatic infected Us
   true  1.00  50.00   false;... % (10) asymptomatic infected Ua (up to 10)
   true  1.00  50.00   false;... % (11) symptomatic infected Ds
   true  1.00  50.00   false;... % (12) asymptomatic infected Da
%%%%%% INFECTION PARAMETERS 
   true  1.50  4.50   false;... % (13) R0: beta -> 2614.552209348986*beta = R0
   true  0.40  1.00   false;... % (14) maskeffect: percent of beta modified by wearing masks
% PARAMS STRUCT PARAMETERS
   false  1.00  1.00   false;... % (15) params.aS = [0.5] asymptomatics infect with probability
% SIGMA  = 1/(Expected Time in Exposed State)
   true  2.50  7.50   true;... % (16) params.sigmau %(SHOULD BE THE SAME FOR ALL 4 CASES)
   false  2.50  7.50   true;... % (17) params.sigmad
   false  2.50  7.50   true;... % (18) params.sigmag
   false  2.50  7.50   true;... % (19) params.sigmaf
% PHI = PROB of BECOMING ASYMPTIOMATIC
   true  0.20  0.80   false;... % (20) params.phiu NOTE: change to(.2 - .8)
   false  0.50  0.50   false;... % (21) params.phid
   false  0.50  0.50   false;... % (22) params.phig
   false  0.50  0.50   false;... % (23) params.phif
% GAMMA = 1/(Expected Duration in Asymptomatic Infectious State)
   false  14.00 14.00  true;... % (24) params.gammaau
   false  14.00 14.00  true;... % (25) params.gammaad
   false  14.00 14.00  true;... % (26) params.gammaag
   false  14.00 14.00  true;... % (27) params.gammaaf
% ALPHA: Prob of symptomatic who go to Hospital HS  %(SHOULD BE THE SAME FOR ALL 4 CASES)
   true  0.50  1.00   false;... % (28) params.alphau
   false  0.50  1.00   false;... % (29) params.alphad
   false  0.50  1.00   false;... % (30) params.alphag
   false  0.50  1.00   false;... % (31) params.alphaf
% GAMMA:  1/(Expected Time in Symptomatic State BEFORE you go to health services)
   false  2.00  2.00   true;...  % (32) params.gammasu
   false  2.00  2.00   true;...  % (33) params.gammasd
   false  2.00  2.00   true;...  % (34) params.gammasg
   false  2.00  2.00   true];... % (35) params.gammasf

%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER NAMES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prms_str = {'$l_m$','$d_m$','$c$','$M$','$m$',... % CONTACT MULTIPLIERS 
             '$f_s$','$p$','$w$',... % SOCIAL CONTACT PARAMETERS
             '$I_{0u}^s$','$I_{0u}^a$','$I_{0d}^s$','$I_{0d}^a$',... % Initial conditions
             '$\beta$','$m$',... % INFECTION PARAMETERS 
             '$aS$',...% ASYMPTOMATIC INFECTED
             '$\sigma$','$\sigma$','$\sigma$','$\sigma$',... % SIGMA  = 1/(Expected Time in Exposed State)
             '$\phi$','$\phi$','$\phi$','$\phi$',... % PROB of BECOMING ASYMPTIOMATIC
             '$\gamma_{au}$','$\gamma_{ad}$','$\gamma_{ag}$','$\gamma_{af}$',... % GAMMA = 1/(Expected Duration in Asymptomatic Infectious State)
             '$\alpha$','$\alpha$','$\alpha$','$\alpha$',... % ALPHA: Prob of symptomatic who go to Hospital HS
             '$\gamma_{su}$','$\gamma_{sd}$','$\gamma_{sg}$','$\gamma_{sf}$',... % GAMMA:  1/(Expected Time in Symptomatic State BEFORE you go to health services)
             '$h$','$h$','$h$','$h$',... % h -> 1/Expected Time in the health services/Quarantine
             '$\delta$','$\delta$','$\delta$','$\delta$'}; % delta -> 1/(Expected Time in Symptomatic State IF you do NOT go to health services)
         
%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER NAMES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prms_str2 = {'$l_m$','$d_m$','Community Contact','Merced Infected','$m$',... % CONTACT MULTIPLIERS 
             '$f_s$','Party Size','Weekend Contact',... % SOCIAL CONTACT PARAMETERS
             'Off-Campus Sym','Off-Campus Asym','Dorms Sym','Dorms Asym',... % Initial conditions
             'Transmission Rate','Mask Usage',... % INFECTION PARAMETERS 
             '$aS$',...% ASYMPTOMATIC INFECTED
             'Time Exposed','$\sigma$','$\sigma$','$\sigma$',... % SIGMA  = 1/(Expected Time in Exposed State)
             'Pr(Asymptomatic)','$\phi$','$\phi$','$\phi$',... % PROB of BECOMING ASYMPTIOMATIC
             '$\gamma_{au}$','$\gamma_{ad}$','$\gamma_{ag}$','$\gamma_{af}$',... % GAMMA = 1/(Expected Duration in Asymptomatic Infectious State)
             'Self-Isolation','$\alpha$','$\alpha$','$\alpha$',... % ALPHA: Prob of symptomatic who go to Hospital HS
             '$\gamma_{su}$','$\gamma_{sd}$','$\gamma_{sg}$','$\gamma_{sf}$',... % GAMMA:  1/(Expected Time in Symptomatic State BEFORE you go to health services)
             '$h$','$h$','$h$','$h$',... % h -> 1/Expected Time in the health services/Quarantine
             '$\delta$','$\delta$','$\delta$','$\delta$'}; % delta -> 1/(Expected Time in Symptomatic State