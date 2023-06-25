clc; clear; close all;
%-------------------------------------------------------------------------------------------------------%
%                                       Only make changes here
% Here are the choices {'mu', 'z', 'g', 'alpha', 'c', 'epsilon', 'b_R', 'beta', 'a', 'b_T', 'e_T', 'e_R', 'kA',...
%    'j', 'kB', 'n', 'd', 'nK', 'rK', 'Ki', 'Kj', 'dKO', 'koKA', 'koj', 'kob_R'};
CondKeys = {'kA', 'koKA', 'j', 'koj', 'b_R', 'kob_R'};
SampleSize = 3000;
PctChange = 0.6; %What percentage should the initial conditions vary?
% EntryNumber = 31;%89;%57;
EntryNumber = 563;
PlotType = "Percentile"; % "Percentile" (10 and 90) or "Std" (1 std above and below the mean)
tx = 1:600; %Model is set up for per hour
%--------------------------------------------------------------------------------------------------------%

%Preparing 
FileName = '../Data/ParameterSearch_opnall5.csv';
% FileName = '../Data/ParameterSearch_opnall4.csv';
% FileName = '../Data/ParameterSearch_opnall2.csv';
% FileName = '../Data/ParameterSets.csv';
p = GetParameters(EntryNumber, FileName);

mu=         p(1);%Thymic Naive
z =         p(2); %Prol Naive
g =         p(3); %Naive Death
alpha =     p(4);  %Thymic Tregs
c =         p(5); %Naive Derived Tregs
epsilon =   p(6); %Treg Prol
b_R =       p(7); %Treg Death
beta =      p(8); %Activation Rate
a =         p(9); %Activated Prol
b_T =       p(10); %ActT Death
e_T =       p(11); %ActT Consumption
e_R =       p(12); %Treg Consumption
kA =        p(13); %Beta Suppression
j =         p(14); %Deactivation 
kB =        p(15); %Treg Death Suppression
n =         p(16);
d =         p(17); %IL-2 production Rate
nK =        p(19); %Naive Carrying Capacity
rK =        p(20); %Treg Carrying Capacity
Ki =        p(21);%Half rate for activation suppression boost
Kj =        p(22);% Half rate for deactivation boost
dKO =       p(23); %Production rate of IL-2 KO 

% Trying to prevent autoimmune disease with the parameters below:
koj =       p(14);% * 3; %4.8234e-07;% 150%Original value (27) 3.2156e-07;
koKA =      p(13) * 0.17; %214120;%64236;% - 70% or 30% Original value (27) 214120;
kob_R =     p(7);% * 0.9; %0.0100; % %0.0100

%Do not change this order


%Generating map of Initial Conditions
KeySets = {'mu', 'z', 'g', 'alpha', 'c', 'epsilon', 'b_R', 'beta', 'a', 'b_T', 'e_T', 'e_R', 'kA',...
    'j', 'kB', 'n', 'd', 'nK', 'rK', 'Ki', 'Kj', 'dKO', 'koKA', 'koj', 'kob_R'};
Values = {mu, z, g, alpha, c, epsilon, b_R, beta, a, b_T, e_T, e_R, kA, ...
    j, kB, n, d, nK, rK, Ki, Kj, dKO, koKA, koj, kob_R};
% Values = {p(1), p(2), p(3), p(4), p(5), p(6), p(7), p(8), p(9), p(10), p(11), p(12), p(13),...
%     p(14), p(15), p(16), p(17), p(19), p(20), p(21), p(22), p(23)};
ParamValues = containers.Map(KeySets, Values);


%Generating LHS Samples
par = length(CondKeys); %number of parameters being sampled
LHSVector = lhsdesign(SampleSize,par, 'criterion','maximin','smooth','off');

%Defining the sampling Map
LHSParaSamples = containers.Map('KeyType', 'char', 'ValueType','any');

%Generating Samples
for sample = 1:par
    
    CurrentKey = CondKeys(sample); 
    CurrentKey = CurrentKey{1}; %Extracting the string key
    value = values(ParamValues, CondKeys(sample)); %Extracting the key's value
    
    % calculate the min and max
    minI = value{1}-PctChange*value{1};
    maxI = value{1}+PctChange*value{1};   
    
    % use the inverse CDF to calculate the initial conditions spread
    LHSCDFinv = unifinv(LHSVector(:,sample),minI,maxI);
    
    % save the new array to the map associated with the right key
    LHSParaSamples(CurrentKey) = LHSCDFinv;
end 

% Generating duplicate values for parameters that have not been
% through the LHS sampling. This is to make solving of future iterations
% easier

remove(ParamValues , CondKeys); %removes keys that were used for LHS

for static = 1:length(keys(ParamValues))
    ParamKeys = keys(ParamValues);
    
    %Grab keys
    keystring = ParamKeys(static);
    keystring = keystring{1}; %Grab just the key string
    value = ParamValues (keystring);  %Grabbing the keys value

    a = repelem(value, SampleSize); %duplicating the values
    LHSParaSamples(keystring) = a';
    
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

%Prepping the Parameter values for interation
mu_LHS = LHSParaSamples('mu'); %Thymic Naive
z_LHS = LHSParaSamples('z'); %Prol Naive
g_LHS = LHSParaSamples('g'); %Naive Death
alpha_LHS = LHSParaSamples('alpha'); %Thymic Tregs
c_LHS = LHSParaSamples('c'); %Naive Derived Tregs
epsilon_LHS = LHSParaSamples('epsilon'); %Treg Prol
b_R_LHS = LHSParaSamples('b_R'); %Treg Death
beta_LHS = LHSParaSamples('beta'); %Activation Rate
a_LHS = LHSParaSamples('a'); %Activated Prol
b_T_LHS = LHSParaSamples('b_T'); %ActT Death
e_T_LHS = LHSParaSamples('e_T'); %ActT Consumption
e_R_LHS = LHSParaSamples('e_R'); %Treg Consumption
kA_LHS = LHSParaSamples('kA'); %Beta Suppression
j_LHS = LHSParaSamples('j'); %Deactivation
kB_LHS = LHSParaSamples('kB'); %Treg Death Suppression
n_LHS = LHSParaSamples('n');
d_LHS = LHSParaSamples('d'); %IL-2 production Rate
nK_LHS = LHSParaSamples('nK'); %Naive Carrying Capacity
rK_LHS = LHSParaSamples('rK'); %Treg Carrying Capacity
Ki_LHS = LHSParaSamples('Ki');%Half rate for activation suppression boost
Kj_LHS = LHSParaSamples('Kj');% Half rate for deactivation boost
dKO_LHS = LHSParaSamples('dKO'); %Production rate of IL-2 KO 
koKA_LHS = LHSParaSamples('koKA');
koj_LHS = LHSParaSamples('koj');
kob_R_LHS = LHSParaSamples('kob_R');


IterationNumber = 0;

%Running Simulation
for iter = 1:SampleSize
    % Setting up the Init Conditions
    N = 1027;
    T = 252;
    R = 128;
    ThyN = 18;
    ActN = 252;
    ThyR = 24;
    DiffR = 1;
    Nprol = 1008;
    Tprol = 0;
    Rprol = 510;
    I = 0.0001;
    m = 0.0023; %Too lazy to remove this from every where rn
        
    T0 = [N T R ...
    ThyN ActN ThyR DiffR ... 
    Nprol Tprol Rprol ...
    I m ];
    
    %Setting up Parameters
    mu = mu_LHS(iter);
    z = z_LHS(iter);
    g = g_LHS(iter);
    alpha = alpha_LHS(iter);
    c = c_LHS(iter);
    epsilon = epsilon_LHS(iter);
    b_R = b_R_LHS(iter);
    beta = beta_LHS(iter);
    a = a_LHS(iter);
    b_T = b_T_LHS(iter);
    e_T = e_T_LHS(iter);
    e_R = e_R_LHS(iter);
    kA = kA_LHS(iter);
    j = j_LHS(iter);
    kB = kB_LHS(iter);
    n = n_LHS(iter);
    d = d_LHS(iter);
    nK = nK_LHS(iter);
    rK = rK_LHS(iter);
    Ki = Ki_LHS(iter);
    Kj = Kj_LHS(iter);
    dKO = dKO_LHS(iter);
    koKA = koKA_LHS(iter);
    koj = koj_LHS(iter);
    kob_R = kob_R_LHS(iter);
    
    %22, 23, 24
    %dKO, koKA, koj
    
    p0 = [alpha, a, kA, e_T, e_R, g, b_T, b_R, epsilon, mu, beta, c, kB, j, z, n, d, nK, rK, Ki, Kj, dKO, koKA, koj, kob_R];
    
    IterationNumber = IterationNumber + 1;
    disp(['Iteration Number: ', num2str(IterationNumber)])
    for Gene = Genotype
        
        %------------------This is where the solving happens----------------%
        ModelData = SimulateGrowthLHS(T0, tx,p0, Gene );
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

%-----------------------------------------------------------------------------------------------%
%                               Preparing to calculate rates
%-----------------------------------------------------------------------------------------------%
%Saving WT Data
DataForRates.NaiveCT(:,:,1) = NaiveCTWT;
DataForRates.ActTCT(:,:,1) = ActTCTWT;
DataForRates.TregCT(:,:,1) = TregCTWT;
DataForRates.ThyN(:,:,1) = ThyNWT;
DataForRates.ActN(:,:,1) = ActNWT;
DataForRates.ThyR(:,:,1) = ThyRWT;
DataForRates.DiffR(:,:,1) = DiffRWT;
DataForRates.Nprol(:,:,1) = NprolWT;
DataForRates.Tprol(:,:,1) = TprolWT;
DataForRates.Rprol(:,:,1) = RprolWT;
DataForRates.I(:,:,1) = IWT;
%Saving KO Data
DataForRates.NaiveCT(:,:,2) = NaiveCTKO;
DataForRates.ActTCT(:,:,2) = ActTCTKO;
DataForRates.TregCT(:,:,2) = TregCTKO;
DataForRates.ThyN(:,:,2) = ThyNKO;
DataForRates.ActN(:,:,2) = ActNKO;
DataForRates.ThyR(:,:,2) = ThyRKO;
DataForRates.DiffR(:,:,2) = DiffRKO;
DataForRates.Nprol(:,:,2) = NprolKO;
DataForRates.Tprol(:,:,2) = TprolKO;
DataForRates.Rprol(:,:,2) = RprolKO;
DataForRates.I(:,:,2) = IKO;



%------------ All Statistical calculations from the model are done here------------------%
StatsOfCells = CalculateTheFillRanges(CellularData, tx);

%------------ Rates calculated and stats for those rates------------------%
ModelRates = CalculatingRatesFromLHSSampling(DataForRates, SampleSize, p, tx);

%------------ Plotting lhs rates results--------Activation Suppression Strength----------%
PlottingFillPrm_Fig5(ModelRates, StatsOfCells, tx, PlotType, CondKeys, PctChange)


