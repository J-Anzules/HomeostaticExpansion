    function ModelData = SimulateGrowthLHS(T0, tx, p, Genotype)

ModelData = zeros(length(tx),0);
%%% First Entry of the data frame %%%
%Total Cell Numbers
ModelData(1,1) = T0(1); % Naive T cells
ModelData(1,2) = T0(2); % Activated T Cells
ModelData(1,3) = T0(3); % T Regulatory Cells
%Non Proliferating Trackers
ModelData(1,4) = T0(4); % Thymic Derivied Naive T Cells
ModelData(1,5) = T0(5); % Activated Naive T Cells
ModelData(1,6) = T0(6); % Thymic Derived Tregs
ModelData(1,7) = T0(7); % Naive Derived Tregs
% Proliferating Cell Trackers
ModelData(1,8) = T0(8); % Self replicating naive T cells
ModelData(1,9) = T0(9); % Self replicating activated T cells
ModelData(1,10) = T0(10); % Self replicating Tregs
% Other
ModelData(1,11) = T0(11); % IL-2 Cytokine
ModelData(1,12) = T0(12); % Average of the Thymus weight at day 0

for i = 1:length(tx)-1
    ts = [tx(i),tx(i+1)];
    %options1 = odeset('NonNegative', 1);
    sol = ode15s(@(t,x)GrowthLHS(t,x,p,i, Genotype),ts,T0); %i is passed for the Thymus equation
    T0 = [sol.y(1,end),sol.y(2,end),sol.y(3,end),sol.y(4,end),sol.y(5,end),...
        sol.y(6,end), sol.y(7,end),sol.y(8,end),  sol.y(9,end), sol.y(10,end),...
        sol.y(11,end), sol.y(12,end)];
    
    %%% Adds final result of solving to the end of the data frame %%%
    %Total Cell Numbers
    ModelData(i+1,1) = T0(1); % Naive T cells
    ModelData(i+1,2) = T0(2); % Activated T Cells
    ModelData(i+1,3) = T0(3); % T Regulatory Cells
    %Non Proliferating Trackers
    ModelData(i+1,4) = T0(4); % Thymic Derivied Naive T Cells
    ModelData(i+1,5) = T0(5); % Activated Naive T Cells
    ModelData(i+1,6) = T0(6); % Thymic Derived Tregs
    ModelData(i+1,7) = T0(7); % Naive Derived Tregs
    % Proliferating Cell Trackers
    ModelData(i+1,8) = T0(8); % Self replicating naive T cells
    ModelData(i+1,9) = T0(9); % Self replicating activated T cells
    ModelData(i+1,10) = T0(10); % Self replicating Tregs
    % Other
    ModelData(i+1,11) = T0(11); % IL-2 Cytokine
    ModelData(i+1,12) = T0(12); %Thymus weight at day 0
end

%save('SimmyTest', 'ModelData')
%save('parameters', 'p')