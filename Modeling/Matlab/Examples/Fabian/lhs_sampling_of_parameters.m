function PRMS = lhs_sampling_of_parameters(prms_info,N)
% % FUNCTION: SAMPLE_PRMS
% % AUTHOR: Fabian Santiago
% % EMAIL: fsantiago3@ucmerced.edu
% % DATE: 11/13/2020
% %     Returns parameter N values for each parameter specified by the
% %     prms_info vector. Each parameter is sampled from a uniform 
% %     distribution within a range specified in the input prms_info.
% % INPUTS 
% %     prms_info: [SA_Bool a b DaysBool]
% %         rows -> a different parameter in the model
% %         column1 -> boolean (0 no SA or 1 yes SA)
% %         column2 and column2 -> range (a,b) for parameter. Note that if
% %                                the sensitivity of that parameter is not
% %                                of interest, then a==b, and the column1 
% %                                entry is zero.
% %         column4 -> boolean (1 range in days 0 not in days)
% %         EXAMPLE: 
% %         prms_info = [1 0.0 0.40 0;  % par 1: range = (0,0.4)
% %                      0 1.0 7.00 1;  % par 2: range = (1/(7*24),1/(1*24) 
% %                      1 0.1 0.50 0;  % par 3: range = (0.1,0.5)
% %                      1 1.0 20.0 0;  % par 4: range = (1,20)
% %                      0 0.4 0.40 0]; % par 5: constant = 0.4
% % OUTPUT
% %     PRMS:
% %         Random parameter values for each parameter unless
% %         there is no interest in the sensitivity of that parameter.
% %         There are N samples for each parameter.
% %
% % NOTE: SIGMA and ALPHA are modified at the end to be the same for 
% %       U, D, G and F. Comment those lines if this is no longer needed. 

% Determine the number of parameters in the model
numPRMS = size(prms_info,1);
gsaPRMS = sum(prms_info(:,1));

% LHS parameters
LHS_PRMS = lhsdesign(N,gsaPRMS);

% Pre-allocate space for all of the paramters that will be sampled. 
PRMS = zeros(N,numPRMS);

% Sample parameter values from a uniform distribution in the specified
% range.
prm_lhs = 1;
for param = 1:numPRMS   
    % Determine range (a,b)
    [a,b] = deal(prms_info(param,2),prms_info(param,3));
    
    % Determine if parameter is in days or not, and if we are assesing the
    % sensitivity of that parameter.
    if logical(prms_info(param,4))
        if logical(prms_info(param,1))
            PRMS(:,param) = 1./(24*((b-a)*LHS_PRMS(:,prm_lhs)+a));
            prm_lhs = prm_lhs + 1;
        else
            PRMS(:,param) = 1./(24*(a*ones(N,1)));
        end
    else
        if logical(prms_info(param,1))
            PRMS(:,param) = (b-a)*LHS_PRMS(:,prm_lhs)+a;
            prm_lhs = prm_lhs + 1;
        else
            PRMS(:,param) = a*ones(N,1);
        end
    end
end

% Make SIGMA the same for all U, D, G, and F (prms 16:19)
PRMS(:,17:19) = repmat(PRMS(:,16),[1 3]);

% Make PHI the same for all U, D, G, and F (prms 20:23)
PRMS(:,21:23) = repmat(PRMS(:,20),[1 3]);

% Make ALPHA the same for all U, D, G, and F (prms 28:31)
PRMS(:,29:31) = repmat(PRMS(:,28),[1 3]);