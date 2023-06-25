function Residuals = Res_Calculate(SimulationValueForResid,... 
    CellDataForResid, DataNumber)

%{
    This is how the residuals will be calculated.
    It takes the bulk values from the data
    and subtracts from each of those values the simulation
    value for each specific hour  
  
    SimulationValueForResid - Row of values from simulation
    CellDataForResid - Row values for Cell data
    
    The population values will be chosen by 'DataNumber'
    
%}
    

CellData = CellDataForResid(:,DataNumber); %1:N 2:T 3:R
SimData = SimulationValueForResid(DataNumber);
Res = []; %Setting it up 
%disp('Cycle Begins') - DELETE?
%count = 1; - DELETE?
for h = 1:length(CellData)
    %disp(['Cycle number: ', num2str(h) ]) - DELETE?
    CellValue = CellData(h);
    Residual = (SimData - CellValue);
    
    Res = [Res Residual]; % Will consider changing if needs to be scaled up
    %Every Cycle of look 
end
Residuals = Res; % Array of values is returned here