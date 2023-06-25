function Res_Main(p0)
global tx
ModelData = SimulateGrowth(p0, 1);
ModelData = array2table(ModelData);

ModelData.Properties.VariableNames = {'NaiveCT' 'ActivCT' 'TregCT' ...
    'ThyDerivedNaive' 'ActivNaive' 'ThyDerivedTregs' 'NaiveDerivedTregs' ...
    'ProlNaive' 'ProlActiv' 'ProlTregs' ...
    'Il2' 'ThyWeight'};



%-------------------------------------------------------------------------------------------%
%                 Preparing the data for residuals
%-------------------------------------------------------------------------------------------%

parameterStruct = {};
parameterStruct.WildType.CellData = readtable('../RawData/ActivatedWTSpleen.csv');
parameterStruct.KnockOut.CellData = readtable('../RawData/ActivatedKOSpleen.csv');
parameterStruct.WildType.ProlData = readtable('../RawData/WTProl.csv');
parameterStruct.KnockOut.ProlData = readtable('../RawData/KOProl.csv');

%Reducing the number of columns and organizing the populations to be
%iterated over
parameterStruct.WildType.CellData = parameterStruct.WildType.CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
    'ThymicNaive', 'ActivatedNaiveCT', ...
    'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
    'hours'});
parameterStruct.KnockOut.CellData = parameterStruct.KnockOut.CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
    'ThymicNaive', 'ActivatedNaiveCT', ...
    'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
    'hours'});
parameterStruct.WildType.ProlData = parameterStruct.WildType.ProlData(:,{ 'NaiveProlCT', 'ActivatedProlCT', 'X4TregProlCT', ...
    'hours'});
parameterStruct.KnockOut.ProlData = parameterStruct.KnockOut.ProlData(:,{ 'NaiveProlCT', 'ActivatedProlCT', 'X4TregProlCT', ...
    'hours'});

%Just grabbing WT data
CellData = parameterStruct.WildType.CellData;

%Setting up the hours
DataHours = unique(CellData.hours);

Residuals = table;
%ModelData = SimulateGrowth(p0);

%Resetting the variables
N_Residuals = 0;
T_Residuals = 0;
R_Residuals = 0; 
%%
for i = 1:length(DataHours)%Cycles through each unique hour

    hour = DataHours(i);%Unique hour
    CellDataIndex = CellData.hours == hour; %all the data for the hour
    CellDataForResid = CellData{CellDataIndex,:};%all the data for the hour
    SimulationValueForResid = ModelData(hour,:); %Row data from that hour   
    
    for DataNumber = DataUsed
        if DataNumber == 1
            N_Residuals = Res_Calculate(SimulationValueForResid, ...
                                        CellDataForResid, DataNumber);
        elseif DataNumber == 2
            T_Residuals = Res_Calculate(SimulationValueForResid, ...
                                        CellDataForResid, DataNumber);
        else 
            R_Residuals = Res_Calculate(SimulationValueForResid, ...
                                        CellDataForResid, DataNumber);
        end        
    end
    %If is here to make sure that there no mistakes in the lengths
    if length(N_Residuals) ~= length(R_Residuals) || ...
                length(N_Residuals) ~= length(T_Residuals)
        error('Lengths Do not match ')
    end
               
    for j = 1:length(N_Residuals)
        %{
        Here all of the residuals are added row by row to the 
        Residuals variable to complete the calculations of residuals
        in one complete variable
        %}
        row = table(N_Residuals(j), T_Residuals(j),...
            R_Residuals(j), hour);
        Residuals = [Residuals; row];
    end
end

Residuals.Properties.VariableNames = {'N', 'T', 'R', 'hour'};
disp('Ready to Plot!')


Plt = figure;

%Simulation and Data

subplot(2,3,1)
scatter(CellData.hours, CellData.NaiveCT)
hold on 
plot(tx, ModelData(:,1))
title('Naive T Cells')
hold off

subplot(2,3,2)
scatter(CellData.hours, CellData.ActivatedCD4CT)
hold on
plot(tx, ModelData(:,2))
title('Activated T cells')

subplot(2,3,3)
scatter(CellData.hours, CellData.AllTregs)
hold on
plot(tx,ModelData(:,3))
title('T Regulatory Cells')

%Residuals

subplot(2,3,4)
scatter(Residuals.hour, Residuals.N)
hold on
yline(0)
title('Residuals Naive T cells')

subplot(2,3,5)
scatter(Residuals.hour, Residuals.T)
hold on
yline(0)
title('Residuals Activated T Cells')

subplot(2,3,6)
scatter(Residuals.hour, Residuals.R)
hold on
yline(0)
title('Residuals Tregs')

sgtitle({['Error = ' num2str(Error)]})

%saveas(Plt,sprintf('../Plots/FIG_%d.png',EntryNumber));
end

