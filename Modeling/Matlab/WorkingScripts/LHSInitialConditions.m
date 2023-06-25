clc; clear; close all;
%-------------------------------------------------------------------------------------------------------%
%                                       Only make changes here
% Here are the choices {'N', 'T', 'R', 'ThyN', 'ActN', 'ThyR', 'DiffR', 'Nprol', 'Tprol', 'Rprol', 'I'};
CondKeys = {'N', 'T', 'R', 'ThyN', 'ActN', 'ThyR', 'DiffR', 'Nprol', 'Tprol', 'Rprol', 'I'};
SampleSize = 50;
PctChange = 0.55; %What percentage should the initial conditions vary?
EntryNumber = 21;
%--------------------------------------------------------------------------------------------------------%

%Preparing 

FileName = 'Data/ParameterSets.csv';
p = GetParameters(EntryNumber, FileName);

mu= p(1);%Thymic Naive
z = p(2); %Prol Naive
g = p(3); %Naive Death
alpha = p(4); %Thymic Tregs
c = p(5); %Naive Derived Tregs
epsilon = p(6); %Treg Prol
b_R = p(7); %Treg Death
beta =p(8); %Activation Rate
a = p(9); %Activated Prol
b_T = p(10); %ActT Death
e_T = p(11); %ActT Consumption
e_R = p(12); %Treg Consumption
kA = p(13); %Beta Suppression
j = p(14); %Deactivation
kB = p(15); %Treg Death Suppression
n = p(16);
d = p(17); %IL-2 production Rate
nK = p(19); %Naive Carrying Capacity
rK = p(20); %Treg Carrying Capacity
Ki = p(21);%Half rate for activation suppression boost
Kj = p(22);% Half rate for deactivation boost

%{
Keeping this here if I want to replace the top parameter set with normal
values
mu= p(1);%Thymic Naive
z = p(2); %Prol Naive
g = p(3); %Naive Death
alpha = p(4); %Thymic Tregs
c = p(5); %Naive Derived Tregs
epsilon = p(6); %Treg Prol
b_R = p(7); %Treg Death
beta =p(8); %Activation Rate
a = p(9); %Activated Prol
b_T = p(10); %ActT Death
e_T = p(11); %ActT Consumption
e_R = p(12); %Treg Consumption
kA = p(13); %Beta Suppression
j = p(14); %Deactivation
kB = p(15); %Treg Death Suppression
n = p(16);
d = p(17); %IL-2 production Rate
nK = p(19); %Naive Carrying Capacity
rK = p(20); %Treg Carrying Capacity
Ki = p(21);%Half rate for activation suppression boost
Kj = p(22);% Half rate for deactivation boost
%}

%Do not change this order
p = [alpha, a, kA, e_T, e_R, g, b_T, b_R, epsilon, mu, beta, c, kB, j, z, n, d, nK, rK, Ki, Kj];


% Choose a percentage here
% choose witch parameters are going to be changed
% Have the algorithm take care of only the values that you have chosen
% 

%{
    Defining the Initial Conditions
    N - Naive T cells
    T - Activated T Cells
    R - T Regulatory Cells
    
    ThyN - Thymic Derived Naive Cells
    ActN - Activated Naive T Cells
    ThyR - Thymic Derived Tregs
    DiffR - Naive Derived Tregs
    
    Nprol - Self replicating naive T cells
    Tprol - Self replicating activated T cells
    Rprol - Self replicating Tregs
    
    I - IL-2 Cytokine
%}


%Generating map of Initial Conditions
KeySets = {'N', 'T', 'R', 'ThyN', 'ActN', 'ThyR', 'DiffR', 'Nprol', 'Tprol', 'Rprol', 'I'};
Values = {1027, 252, 128, 18, 252, 24, 1, 1008, 10, 510, 0.0001};
InitCond = containers.Map(KeySets, Values);
tx = 0:432; %Maximum amount of time - 18 days

%Generating LHS Samples
par = length(CondKeys); %number of parameters being sampled
LHSVector = lhsdesign(SampleSize,par, 'criterion','maximin','smooth','off');

%Defining the sampling Map
LHSConditions = containers.Map('KeyType', 'char', 'ValueType','any');

%Generating Samples
for sample = 1:par
    
    CurrentKey = CondKeys(sample); 
    CurrentKey = CurrentKey{1}; %Extracting the string key
    value = values(InitCond, CondKeys(sample)); %Extracting the key's value
    
    % calculate the min and max
    minI = value{1}-PctChange*value{1};
    maxI = value{1}+PctChange*value{1};   
    
    % use the inverse CDF to calculate the initial conditions spread
    LHSCDFinv = unifinv(LHSVector(:,sample),minI,maxI);
    
    % save the new array to the map associated with the right key
    LHSConditions(CurrentKey) = LHSCDFinv;
end 


% Generating duplicate values for initial condtions that have not been
% through the LHS sampling. This is to make solving of future iterations
% easier

remove(InitCond , CondKeys); %removes keys that were used for LHS

for static = 1:length(keys(InitCond))
    InitKeys = keys(InitCond);
    
    %Grab keys
    keystring = InitKeys(static);
    keystring = keystring{1}; %Grab just the key string
    value = InitCond (keystring);  %Grabbing the keys value

    a = repelem(value, SampleSize); %duplicating the values
    LHSConditions(keystring) = a';
    
end

%-----------------------------------------------------------------------------------------------%
%                                     Preparing for Simulations
%-----------------------------------------------------------------------------------------------%


% Storage Vectors for all the cellular growths per sample size. Each column
% in these will represent one iteration of the sameple size
NaiveCTWT = zeros(length(tx),SampleSize);
ActTCTWT = zeros(length(tx),SampleSize);
TregCTWT = zeros(length(tx),SampleSize);
ThyNWT = zeros(length(tx),SampleSize);
ActNWT = zeros(length(tx),SampleSize);
ThyRWT = zeros(length(tx),SampleSize);
DiffRWT = zeros(length(tx),SampleSize);
NprolWT = zeros(length(tx),SampleSize);
TprolWT = zeros(length(tx),SampleSize);
RprolWT = zeros(length(tx),SampleSize);
IWT = zeros(length(tx),SampleSize);

%IL-2 KO results
NaiveCTKO = zeros(length(tx),SampleSize);
ActTCTKO = zeros(length(tx),SampleSize);
TregCTKO = zeros(length(tx),SampleSize);
ThyNKO = zeros(length(tx),SampleSize);
ActNKO = zeros(length(tx),SampleSize);
ThyRKO = zeros(length(tx),SampleSize);
DiffRKO = zeros(length(tx),SampleSize);
NprolKO = zeros(length(tx),SampleSize);
TprolKO = zeros(length(tx),SampleSize);
RprolKO = zeros(length(tx),SampleSize);
IKO = zeros(length(tx),SampleSize);

Genotype = [1, 2]; %Will run simulation for both genotypes

%Prepping the Initial conditions
InitNaiveCT = LHSConditions('N');
InitActTCT = LHSConditions('T');
InitTregCT = LHSConditions('R');
InitThyN = LHSConditions('ThyN');
InitActN = LHSConditions('ActN');
InitThyR = LHSConditions('ThyR');
InitDiffR = LHSConditions('DiffR');
InitNprol = LHSConditions('Nprol');
InitTprol = LHSConditions('Tprol');
InitRprol = LHSConditions('Rprol');
InitI = LHSConditions('I');

%Running Simulation
for iter = 1:SampleSize
    N = InitNaiveCT(iter);
    T = InitActTCT(iter);
    R = InitTregCT(iter);
    ThyN = InitThyN(iter);
    ActN = InitActN(iter);
    ThyR = InitThyR(iter);
    DiffR = InitDiffR(iter);
    Nprol = InitNprol(iter);
    Tprol = InitTprol(iter);
    Rprol = InitRprol(iter);
    I = InitI(iter);
    m = 0.0023; %Too lazy to remove this from every where rn
        
    T0 = [N T R ...
    ThyN ActN ThyR DiffR ... 
    Nprol Tprol Rprol ...
    I m ];
    
    for Gene = Genotype
        
        %------------------This is where the solving happens----------------%
        ModelData = SimulateGrowthLHS(T0, tx,p, Gene );
        %------------------------------------------------------------------------------%
        
        if Gene == 1        
            NaiveCTWT(:,iter) = ModelData(:,1);
            ActTCTWT(:,iter) = ModelData(:,2);
            TregCTWT(:,iter)= ModelData(:,3);
            %Non Proliferating Trackers
            ThyNWT(:,iter) = ModelData(:,4);
            ActNWT(:,iter) = ModelData(:,5);
            ThyRWT(:,iter) = ModelData(:,6);
            DiffRWT(:,iter) = ModelData(:,7);
            % Proliferating Cell Trackers
            NprolWT(:,iter) = ModelData(:,8);
            TprolWT(:,iter) = ModelData(:,9);
            RprolWT(:,iter) = ModelData(:,10);
            % Other
            IWT(:,iter) = ModelData(:,11);
            
        elseif Gene ==2
            NaiveCTKO(:,iter) = ModelData(:,1);
            ActTCTKO(:,iter) = ModelData(:,2);
            TregCTKO(:,iter)= ModelData(:,3);
            %Non Proliferating Trackers
            ThyNKO(:,iter) = ModelData(:,4);
            ActNKO(:,iter) = ModelData(:,5);
            ThyRKO(:,iter) = ModelData(:,6);
            DiffRKO(:,iter) = ModelData(:,7);
            % Proliferating Cell Trackers
            NprolKO(:,iter) = ModelData(:,8);
            TprolKO(:,iter) = ModelData(:,9);
            RprolKO(:,iter) = ModelData(:,10);
            % Other
            IKO(:,iter) = ModelData(:,11);
        end
        
    end
    
end

%-----------------------------------------------------------------------------------------------%
%                               Preparing Data for Plotting
%-----------------------------------------------------------------------------------------------%

%Saving WT Data
CellularData(:,:,1,1) = NaiveCTWT;
CellularData(:,:,2,1) = ActTCTWT;
CellularData(:,:,3,1) = TregCTWT;
CellularData(:,:,4,1) = ThyNWT;
CellularData(:,:,5,1) = ActNWT;
CellularData(:,:,6,1) = ThyRWT;
CellularData(:,:,7,1) = DiffRWT;
CellularData(:,:,8,1) = NprolWT;
CellularData(:,:,9,1) = TprolWT;
CellularData(:,:,10,1) = RprolWT;
CellularData(:,:,11,1) = IWT;
%Saving KO Data
CellularData(:,:,1,2) = NaiveCTKO;
CellularData(:,:,2,2) = ActTCTKO;
CellularData(:,:,3,2) = TregCTKO;
CellularData(:,:,4,2) = ThyNKO;
CellularData(:,:,5,2) = ActNKO;
CellularData(:,:,6,2) = ThyRKO;
CellularData(:,:,7,2) = DiffRKO;
CellularData(:,:,8,2) = NprolKO;
CellularData(:,:,9,2) = TprolKO;
CellularData(:,:,10,2) = RprolKO;
CellularData(:,:,11,2) = IKO;

%------------ All Statistical calculations are done here------------------%
StatsOfCells = CalculateTheFillRanges(CellularData);

%----------------------Plotting the LHS Results-----------------------------%
PlottingLHSResults(StatsOfCells, tx)



