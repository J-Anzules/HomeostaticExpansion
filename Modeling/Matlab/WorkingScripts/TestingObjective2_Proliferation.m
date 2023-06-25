function obj= TestingObjective2_Proliferation(p)
global Objective WhichGenotype
%load data

%1 = WildType, 2 = Genotype
if WhichGenotype == 1
    CellData = readtable('../RawData/ActivatedWTSpleen.csv');
    ProlData = readtable('../RawData/WTProl.csv');
elseif WhichGenotype == 2
    CellData = readtable('../RawData/ActivatedKOSpleen.csv');
    ProlData = readtable('../RawData/KOProl.csv');
end

%CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...                  
%     'ThymicDerivedTregsCT', 'X4TregProlCT', 'NaiveDerivedTregsCT' ... 
%     'hours'}); 

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

ModelData = SimulateGrowth(p);

%Setting up the hours
DataHours = unique(CellData.hours);

Rsquare = 0;
%Calculating R squared from the NON-proliferating populations
for i = DataUsed
    %Calculates each data used at a time
    %Cell data numbers match 
    Cells = CellData(:,[i,8]); %Grabs data and hours
    SimulationData = ModelData(:,i);
    
    
    for j = 1:length(DataHours)
        hour = DataHours(j);      
        CellDataIndex = Cells.hours == hour;
        CellDataForRSqr = Cells{CellDataIndex,1}; %Do not need hours anymore
        SimulationValue = SimulationData(hour);
        
        
        for h = 1:length(CellDataForRSqr)
                         
            CellValue = CellDataForRSqr(h);
            %RSquareValue = (SimulationValue - CellValue).^2;
            RSquareValue = ((SimulationValue - CellValue)/CellValue)^2;
            Rsquare = Rsquare + RSquareValue;
           
        end

    end
    
end

%Calculating R squared from the proliferating populations
ProlDataUsed = [1, 2, 3, 4];
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
            %RSquareValue = (SimulationValue - CellValue).^2;
            RSquareValue = ((SimulationValue - CellValue)/CellValue)^2;
            Rsquare = Rsquare + RSquareValue;
           
        end

    end
    
end

disp(['Objective = ' num2str(Rsquare)])
Objective = Rsquare;
obj = Rsquare;



























    
