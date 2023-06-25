%Making an empty dataframe, where everything is going to appended to
VarNames = {'Population', 'Hour', 'SimulationValue', 'CellValue', 'RsquareValue' };


ObjectiveData = array2table(zeros(0,5)); %Non Proliferating cellular population
% ObjectiveDataProl = array2table(zeros(0,5)); %Proliferating cellular population

ObjectiveData.Properties.VariableNames = VarNames;
% ObjectiveDataProl.Properties.VariableNames = VarNames;



%Setting up a small hash for the variable names. To be used when making a
%table
keys = {1, 2, 3, 4, 5, 6, 7};
Values = {'NaiveTCT', 'ActTCT', 'TregCT', 'ThyNaive', 'ActivatedNaive', 'ThyTregs', 'NaiveTregs'};
CellValues = containers.Map(keys, Values);

%Setting up the hash for Proliferating cell population
keysProl = {1, 2, 3};
ValuesProl = {'NaiveProl', 'ActTProl', 'TregProl'};
ProlValues = containers.Map(keysProl, ValuesProl);


%%
% - Adding to the normal cellular population
Population =  CellValues(7);
Hour = 9;
SimulationValue = 400;
CellValue = 200;
RsquareValue = ((SimulationValue - CellValue)/CellValue).^2;
row = {Population, Hour, SimulationValue, CellValue, RsquareValue};

%Saving all the variables for this row of information
ObjectiveData = [ObjectiveData; row ];

%%
% Adding to the proliferating data
Population =  ProlValues(3);
Hour = 510;
SimulationValue = 10600;
CellValue = 7500;
RsquareValue = ((SimulationValue - CellValue)/CellValue).^2;
rowProl = {Population, Hour, SimulationValue, CellValue, RsquareValue};

ObjectiveData = [ObjectiveData; rowProl];
%%
SumOfRsquare = sum(ObjectiveData.RsquareValue);

ObjectiveData.PctContribution = ObjectiveData.RsquareValue / SumOfRsquare;

writetable(ObjectiveData, './Data/ObjectiveData.csv')


