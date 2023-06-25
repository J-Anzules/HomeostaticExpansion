function obj= ThymObjective(p)
ThymusData = readtable('../Data/ThymusData.csv');
%disp('Value of p:')
%disp(p)
ModelData = SimulateThymus(p);
%disp('End Simulation')
%Setting up the hours
DataHours = unique(ThymusData.Hours);

Rsquare = 0;
%ModelData = SimulateGrowth(p0);

for j = 1:length(DataHours)
    %disp(j)
       
    %{ 
    colnm = ThymusData.Properties.VariableNames;
    disp(' ')
    disp(' ')
    disp(['Population = ', colnm{i}])
    disp(['Working on hour: ', num2str(DataHours(j))])
    %}
    hour = DataHours(j);
    ThymusDataIndex = ThymusData.Hours == hour;
    ThymusDataForRSqr = ThymusData{ThymusDataIndex,2}; %Do not need hours anymore
    %CellDataForRSqr has all the data for the current hour iteration
    SimulationValue = ModelData(hour); %Pull simulation value for that hour

        
    for h = 1:length(ThymusDataForRSqr)
        %disp(['Simulation Data: ', num2str(SimulationValue)])
        %disp(['Hour: ', num2str(hour), ' Data: ', ...
        %    num2str(CellDataForRSqr(h))])
        %disp(' ')

        CellValue = ThymusDataForRSqr(h);
        RSquareValue = (SimulationValue - CellValue).^2;
        %RSquareValue = ((SimulationValue - CellValue)./CellValue).^2;
        Rsquare = Rsquare + RSquareValue;

    end

end

disp(['Objective = ' num2str(Rsquare)])
obj = Rsquare;