function obj= GrowthObjective(p, parameterStruct)
global Objective WTerror KOerror
%load data
Gntype = [1, 2];

Rsquare = 0;
nWT = 0;
nKO = 0;

for Genotype = Gntype
    %1 = WildType, 2 = IL-2 KO
    
    %Making an empty dataframe, where everything is going to appended to
    VarNames = {'Population', 'Hour', 'SimulationValue', 'CellValue', 'RsquareValue' };
    ObjectiveData = array2table(zeros(0,5));
    ObjectiveData.Properties.VariableNames = VarNames;

    %Setting up a small hash for the variable names. To be used when making a
    %table
    keys = {1, 2, 3, 4, 5, 6, 7};
    Values = {'NaiveTCT', 'ActTCT', 'TregCT', 'ThyNaive', 'ActivatedNaive', 'ThyTregs', 'NaiveTregs'};
    CellMap = containers.Map(keys, Values);

    %Setting up the hash for Proliferating cell population
    keysProl = {1, 2, 3};
    ValuesProl = {'NaiveProl', 'ActTProl', 'TregProl'};
    ProlMap= containers.Map(keysProl, ValuesProl);
    
    
    if Genotype == 1
        CellData = parameterStruct.WildType.CellData;
        ProlData = parameterStruct.WildType.ProlData;
    elseif Genotype == 2
        CellData = parameterStruct.KnockOut.CellData;
        ProlData = parameterStruct.KnockOut.ProlData;
    end

    CellData = CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
        'ThymicNaive', 'ActivatedNaiveCT', ...
        'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
        'hours'});

    ProlData = ProlData(:,{ 'NaiveProlCT', 'ActivatedProlCT', 'X4TregProlCT', ...
        'hours'});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Numbers for the loop will choose the right data
    % The order of which the data/model is set up is critically important
    %                                                               
    DataUsed = [1, 2, 3, 4, 5, 6, 7]; 
    % 1 = Naive T cells
    % 2 = Activated CD4 cells
    % 3 = All Tregs
    % 4 = Thymic Derivied Naive T Cells
    % 5 = Activated Naive T Cells
    % 6 = Thymic Derived Tregs
    % 7 = Naive Derived Tregs
    % 8 = Hours
    %The data location is equivalent in the ModelData df            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ModelData = SimulateGrowth(p, Genotype);

    %Setting up the hours
    DataHours = unique(CellData.hours);
    
    
    %---------------------------------------------------------------------------------%
    %Calculating R squared from the NON-proliferating populations 
    %---------------------------------------------------------------------------------%    
    for i = DataUsed
        %Calculates each data used at a time
        %Cell data numbers match 
        Cells = CellData(:,[i,8]); %Grabs data and hours
        SimulationData = ModelData(:,i);
        

        for j = 1:length(DataHours)
            %Pull out all of the data needed; condition is hour match
            hour = DataHours(j);      
            CellDataIndex = Cells.hours == hour;
            CellDataForRSqr = Cells{CellDataIndex,1}; %Do not need hours anymore
            SimulationValue = SimulationData(hour);


            for h = 1:length(CellDataForRSqr)

                CellValue = CellDataForRSqr(h);
%                 RSquareValue = (SimulationValue - CellValue).^2;
%                 RSquareValue = ((SimulationValue - CellValue)/CellValue).^2;
                RSquareValue = ((SimulationValue - CellValue)/SimulationValue).^2;
                Rsquare = Rsquare + RSquareValue;
                
               
                             
%                 Just to see how many data points there are between the
%                 genotypes
                if Genotype == 1
                    nWT = nWT +1;
                elseif Genotype == 2
                    nKO = nKO + 1;
                end
              
                
                % Preparing name of the population for the df
                Population =  CellMap(i);
                row = {Population, hour, SimulationValue, CellValue, RSquareValue};
                ObjectiveData = [ObjectiveData; row ]; %Appending the data
                
                
              

            end

        end

    end
    
%     disp('**************START OF PROL CALCULATIONS****************')
%     disp(['Genotype = ', num2str(Genotype)])
%     disp(['Rsquare = ' num2str(Rsquare)])
%     disp(' ')
%     disp('***********************************************************')
    
    
    %Calculating R squared from the proliferating populations
    ProlDataUsed = [1, 2, 3];
    % 1 = Self replicating naive T cells
    % 2 = Self replicating activated T cells
    % 3 = Self replicating Tregs
    % 4 = Hours
    
   
    
    for i = ProlDataUsed
        %Calculates each data used at a time
        %Cell data numbers match 
        Cells = ProlData(:,[i,4]); %Grabs data and hours
        SimulationData = ModelData(:,i+7); %The +7 makes sure that the right data in the ModelData is chosen


        for j = 1:length(DataHours)
            hour = DataHours(j);      
            CellDataIndex = Cells.hours == hour;
            CellDataForRSqr = Cells{CellDataIndex,1}; %Do not need hours anymore
            SimulationValue = SimulationData(hour);
            
            


            for h = 1:length(CellDataForRSqr)

                CellValue = CellDataForRSqr(h);
                
                if (CellValue ~= 1)
                    %RSquareValue = (SimulationValue - CellValue).^2;
                    RSquareValue = ((SimulationValue - CellValue)/CellValue).^2;
                    Rsquare = Rsquare + RSquareValue;
                     
                    % Preparing name of the population for the df
                    Population =  ProlMap(i);
                    row = {Population, hour, SimulationValue, CellValue, RSquareValue};
                    ObjectiveData = [ObjectiveData; row ]; %Appending the data
                   
                    if Genotype == 1
                        nWT = nWT +1;
                    elseif Genotype == 2
                        nKO = nKO + 1;
                    end
                   
                end
                
            end

        end
        
    end
    

    
    %Here is where I should save the csv fiile
    % Doing the final calculations of the Objective Table
    SumOfRsquare = sum(ObjectiveData.RsquareValue);
    ObjectiveData.PctContribution = ObjectiveData.RsquareValue / SumOfRsquare;
    
    
    %Removing heavy weights from being considered
    % ObjectiveRemoval will be refreshed for every Genotype loop
    Contributions = ObjectiveData.PctContribution;
    NewData = ObjectiveData(Contributions > 0.1, :);
    ObjectiveRemoval = sum(NewData.RsquareValue);
    
    Rsquare = Rsquare - ObjectiveRemoval;
    if Genotype == 1
        WTerror = Rsquare;
        writetable(ObjectiveData, '../Data/ObjectiveDataWT.csv')
    elseif Genotype == 2
        KOerror = Rsquare - WTerror ;
        writetable(ObjectiveData, '../Data/ObjectiveDataKO.csv')
    end
    
    
    
end



disp(['Total Objective = ' num2str(Rsquare)])
disp(['WT Objective = ' num2str(WTerror)])
disp(['KO Objective = ' num2str(KOerror)])
%disp(['WT n = ' num2str(nWT)])
%disp(['KO n = ' num2str(nKO)])
disp(' ')

Objective = Rsquare;
obj = Rsquare;
    
