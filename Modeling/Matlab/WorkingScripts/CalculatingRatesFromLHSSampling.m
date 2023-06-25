function ModelRates = CalculatingRatesFromLHSSampling(DataForRates, SampleSize, p, tx)

%{
Calculates the ranges for all of the rates that are possible in my model.
The final data frame ModelRates will contain two structs (ModelRates(1) and
ModelRates(2). 1, contains the rates, 2, contains the stats summarizing all
of the rates.

Input: DataForRates
       This is a compilation of the model results (main populations & sub-populations)
        from each LHS sampling of whatever criteria that I chose

Output: ModelRates
        This is the stats summarizing the results of the instantaneous
        rates of interest

For each field in ModelRates(2) (e.g. ModelRates(2).NaiveProl(A,B,C)) will have a summary 
from the LHS sampling. Each row (A) represents the hour of the simulation,
while the columns (B) represents the value explained below, and (C)
represents each Genotype (WT and KO)

(B) - 6 - Each column represents a statistic for that hour
    1 - mean
    2 - Standard deviation
    3 - +1 standard deviation
    4 - -1 standard deviation (if less than 0, then 0)
    5 - Lowest 10 percentile
    6 - Highest 90 percentile


%}

%Parameter Values used to calculate all of the rates
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
dKO = p(23); %Production rate of IL-2 KO 


Genotype = [1, 2];%wt =1 ko = 2
%rows = 1:433; %432 hours in the simulation
% Below I will loop over each genotype and iteration and calculate the
% rates for each of those iterations. The results are saved in a data
% struct for whatever rate I am intersted it.
for gene = Genotype
    for iter = 1:SampleSize
        
        %-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
        %                   Naive T cells
        %-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
        
        %Proliferating naive T cells
        ModelRates.NaiveProl(:, iter, gene) = z .* DataForRates.NaiveCT(:, iter, gene);
        
        %-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
        %            Regulatory T Cells
        %-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
        
        % Treg Death Rate
        ModelRates.TregDeath(:,iter,gene) = b_R .* DataForRates.TregCT(:, iter, gene)...
            .* (1 ./ (1 + (DataForRates.I(:, iter, gene) ./ kB).^ n ));
        
        % Thymic production rate
        ModelRates.ThyTreg(:, iter,gene)= (alpha .* DataForRates.TregCT(:, iter, gene) ...
            .* (1 - (DataForRates.TregCT(:, iter, gene) ./ rK)));
        
        %Hill suppression Treg death rate
        ModelRates.TregDeathHill(:, iter, gene) = 1 - (1 ./ (1 + (DataForRates.I(:, iter, gene) ./ kB).^ n ));
        
        %Proliferating Tregs
        ModelRates.ProlTregs(:, iter, gene) = epsilon .* DataForRates.TregCT(:, iter, gene);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%Figure 5%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Suppression strength on Beta
        ModelRates.BetaSuppressionStrength(:, iter, gene) = 1 - (1 ./ (1 + ((DataForRates.TregCT(:, iter, gene) .*...
            (DataForRates.I(:, iter, gene) ./ (Ki + DataForRates.I(:, iter, gene) )))./kA).^n));
        
        % Removed Activated T Cells
        ModelRates.RemovedActT(:, iter, gene) = (j .* DataForRates.TregCT(:, iter, gene) .* DataForRates.ActTCT(:, iter, gene)) .*...
            (DataForRates.I(:, iter, gene) ./ (Ki + (DataForRates.I(:, iter, gene)))); 
        
        
        
    end
end

%Grabs all of the field names so I can loop over them below. Without this I
% will have to repeat the calculations for all 30 rate calculations.
% That would mean coding up 240 lines of code, at least.
fn = fieldnames(ModelRates);

% Calculates the std, mean, 90/10 percentile for each rate calculation. 
% Calculations is saved in the second array of the struct that I have made
% Original values saved in the first struct (ModelRates(1)), while the
% stats are saved on the second (ModelRates(2))
for gene = Genotype
    for k = 1:numel(fn)
        for row = tx
            % (1) - Means
            ModelRates(2).(fn{k})(row, 1, gene) = mean(ModelRates(1).(fn{k})(row,:,gene));
            
            % (2) - Standard Deviation
            ModelRates(2).(fn{k})(row,2,gene) = std(ModelRates(1).(fn{k})(row, : , gene));
            
            % (3) +1 Standard Deviation
            ModelRates(2).(fn{k})(row,3,gene) = ModelRates(2).(fn{k})(row,1,gene)...
                + ModelRates(2).(fn{k})(row,2,gene);
            
            % (4) -1 Standard Deviation
            ModelRates(2).(fn{k})(row,4,gene) = ModelRates(2).(fn{k})(row,1,gene)...
                - ModelRates(2).(fn{k})(row,2,gene);
            
            if ModelRates(2).(fn{k})(row,4,gene) < 0 
                %So that we have no negative values
                ModelRates(2).(fn{k})(row,4,gene) = 0;
            end
            
            % (5) -Lowest 10 percentile
            ModelRates(2).(fn{k})(row,5,gene) = prctile(ModelRates(1).(fn{k})(row, :, gene), 10);
            
            % (6) - Highest 90 percentile
            ModelRates(2).(fn{k})(row,6,gene) = prctile(ModelRates(1).(fn{k})(row, :, gene), 90);
        end
    end
end
        














































%{

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------Calculating---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-=-=-=-=-=-=-=-=-=-=-=%
%               Naive
%-=-=-=-=-=-=-=-=-=-=-=%

%---Gains---%
ModelDataWT.NaiveGain = (mu.*ModelDataWT.NaiveCT.*(1-(ModelDataWT.NaiveCT./nK))) + (z.*ModelDataWT.NaiveCT);
ModelDataKO.NaiveGain = (mu.*ModelDataKO.NaiveCT.*(1-(ModelDataKO.NaiveCT./nK))) + (z.*ModelDataKO.NaiveCT);

%---Loss---%
ModelDataWT.NaiveLoss =  ((beta.*ModelDataWT.NaiveCT).*(1./(1+((ModelDataWT.TregCT.*(ModelDataWT.Il2./(Ki + ModelDataWT.Il2)))./kA).^n))) + ...
    + (c.*ModelDataWT.NaiveCT) + (g.*ModelDataWT.NaiveCT); 
ModelDataKO.NaiveLoss =  ((beta.*ModelDataKO.NaiveCT).*(1./(1+((ModelDataKO.TregCT.*(ModelDataKO.Il2./(Ki + ModelDataKO.Il2)))./kA).^n))) + ...
    + (c.*ModelDataKO.NaiveCT) + (g.*ModelDataKO.NaiveCT); 

%---Thymic Production---%
ModelDataWT.ThymicProductionIR = (mu.*ModelDataWT.NaiveCT.*(1-(ModelDataWT.NaiveCT./nK)));
ModelDataKO.ThymicProductionIR = (mu.*ModelDataKO.NaiveCT.*(1-(ModelDataKO.NaiveCT./nK)));

%---Naive Self Replication---%
ModelDataWT.NaiveProlIR = (z.*ModelDataWT.NaiveCT);
ModelDataKO.NaiveProlIR = (z.*ModelDataKO.NaiveCT);

%---Activated Naive T Cells---%
ModelDataWT.ActivatedNaiveIR = ((beta.*ModelDataWT.NaiveCT).*(1./(1+((ModelDataWT.TregCT.*(ModelDataWT.Il2./(Ki + ModelDataWT.Il2)))./kA).^n)));
ModelDataKO.ActivatedNaiveIR = ((beta.*ModelDataKO.NaiveCT).*(1./(1+((ModelDataKO.TregCT.*(ModelDataKO.Il2./(Ki + ModelDataKO.Il2)))./kA).^n)));

%---Differentiating Naive to Tregs---%
ModelDataWT.NaiveToTregIR = c.*ModelDataWT.NaiveCT;
ModelDataKO.NaiveToTregIR = c.*ModelDataKO.NaiveCT;

%---Death Rate---%
ModelDataWT.NaiveDeathIR = g.*ModelDataWT.NaiveCT;
ModelDataKO.NaiveDeathIR = g.*ModelDataKO.NaiveCT;

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
%            Regulatory T Cells
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

%---Gains---%
ModelDataWT.TregGain = (alpha.*ModelDataWT.TregCT.*(1-(ModelDataWT.TregCT./rK))) ...
    + (epsilon.*ModelDataWT.TregCT) + c.*(ModelDataWT.NaiveCT);
ModelDataKO.TregGain = (alpha.*ModelDataKO.TregCT.*(1-(ModelDataKO.TregCT./rK)))...
    + (epsilon.*ModelDataKO.TregCT) + c.*(ModelDataKO.NaiveCT);

%---Loss---%
ModelDataWT.TregLoss = b_R.*ModelDataWT.TregCT.*(1./(1+(ModelDataWT.Il2./kB).^n1));
ModelDataKO.TregLoss = b_R.*ModelDataKO.TregCT.*(1./(1+(ModelDataKO.Il2./kB).^n1));

%---Thymic Production---%
ModelDataWT.TregThymicProductionIR = (alpha.*ModelDataWT.TregCT.*(1-(ModelDataWT.TregCT./rK)));
ModelDataKO.TregThymicProductionIR = (alpha.*ModelDataWT.TregCT.*(1-(ModelDataWT.TregCT./rK)));

%---Treg Self Replication---%
ModelDataWT.TregProlIR = epsilon.*ModelDataWT.TregCT;
ModelDataKO.TregProlIR = epsilon.*ModelDataKO.TregCT;

%---Naive to Treg---%
ModelDataWT.NaiveToTregIR = c.*ModelDataWT.NaiveCT;
ModelDataKO.NaiveToTregIR = c.*ModelDataKO.NaiveCT;

%---Death Rate---%
ModelDataWT.TregLoss = b_R.*ModelDataWT.TregCT.*(1./(1+(ModelDataWT.Il2./kB).^n1));
ModelDataKO.TregLoss = b_R.*ModelDataKO.TregCT.*(1./(1+(ModelDataKO.Il2./kB).^n1));

%---Calculating Treg Frequency---%
TregFreqWT = ModelDataWT.TregCT ./(ModelDataWT.NaiveCT+ModelDataWT.ActivCT);
TregFreqKO = ModelDataKO.TregCT ./(ModelDataKO.NaiveCT+ModelDataKO.ActivCT);

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
%            Activated T Cells
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

%---Gains---%
ModelDataWT.TGains =  ((beta.*ModelDataWT.NaiveCT).*(1./(1+((ModelDataWT.TregCT.*(ModelDataWT.Il2./(Ki + ModelDataWT.Il2)))./kA).^n))) +...
    (a.*ModelDataWT.ActivCT);
ModelDataKO.TGains =  ((beta.*ModelDataKO.NaiveCT).*(1./(1+((ModelDataKO.TregCT.*(ModelDataKO.Il2./(Ki + ModelDataKO.Il2)))./kA).^n))) +...
    (a.*ModelDataKO.ActivCT);

%---Loss---%
ModelDataWT.TLoss = (j.*ModelDataWT.TregCT.*ModelDataWT.ActivCT)+(b_T.*ModelDataWT.ActivCT);
ModelDataKO.TLoss = (j.*ModelDataKO.TregCT.*ModelDataKO.ActivCT)+(b_T.*ModelDataKO.ActivCT);

%---Activation of Naive T Cells ---%
ModelDataWT.ActivatedNaiveIR = ((beta.*ModelDataWT.NaiveCT).*(1./(1+((ModelDataWT.TregCT.*(ModelDataWT.Il2./(Ki + ModelDataWT.Il2)))./kA).^n)));
ModelDataKO.ActivatedNaiveIR = ((beta.*ModelDataKO.NaiveCT).*(1./(1+((ModelDataKO.TregCT.*(ModelDataKO.Il2./(Ki + ModelDataKO.Il2)))./kA).^n)));

%---Self Replicating---%
ModelDataWT.TProlIR = a.*ModelDataWT.ActivCT;
ModelDataKO.TProlIR = a.*ModelDataKO.ActivCT;

%---Death---%
ModelDataWT.TDeathIR = b_T.*ModelDataWT.ActivCT;
ModelDataKO.TDeathIR = b_T.*ModelDataKO.ActivCT;

%-=-=-=-=-=-=-=-=-=-=-=%
%          Fig 2 Things
%-=-=-=-=-=-=-=-=-=-=-=%

%---Hill suppression naive---%
ModelDataWT.ActivationSuppression = (1./(1+((ModelDataWT.TregCT.*(ModelDataWT.Il2./(Ki + ModelDataWT.Il2)))./kA).^n));
ModelDataKO.ActivationSuppression = (1./(1+((ModelDataKO.TregCT.*(ModelDataKO.Il2./(Ki + ModelDataKO.Il2)))./kA).^n));

%Hill suppression Treg death rate
ModelDataWT.TregDeathSuppression = (1./(1+(ModelDataWT.Il2./kB).^n1));
ModelDataKO.TregDeathSuppression = (1./(1+(ModelDataKO.Il2./kB).^n1));

%How many Activated T's are being destroyed
ModelDataWT.ActiveDestruction = (j.*ModelDataWT.TregCT.*ModelDataWT.ActivCT) ...
    .* (ModelDataWT.Il2./(Ki + ModelDataWT.Il2));
ModelDataKO.ActiveDestruction = (j.*ModelDataKO.TregCT.*ModelDataKO.ActivCT) ...
    .* (ModelDataKO.Il2./(Ki + ModelDataKO.Il2));

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
%                   Interleukin - 2
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

%---Gain---%
ModelDataWT.ILGain = d.*ModelDataWT.ActivCT;
ModelDataKO.ILGain = d.*ModelDataKO.ActivCT;

%---Loss---%
ModelDataWT.ILLoss = e_T.*ModelDataWT.Il2.*ModelDataWT.ActivCT...
    + e_R.*ModelDataWT.Il2.*ModelDataWT.TregCT + f.*ModelDataWT.Il2;
ModelDataKO.ILLoss = e_T.*ModelDataKO.Il2.*ModelDataKO.ActivCT...
    + e_R.*ModelDataKO.Il2.*ModelDataKO.TregCT + f.*ModelDataKO.Il2;

%---ActT Consumption---%
ModelDataWT.AcTConsumption = e_T.*ModelDataWT.Il2.*ModelDataWT.ActivCT;
ModelDataKO.AcTConsumption = e_T.*ModelDataKO.Il2.*ModelDataKO.ActivCT;

%---Treg Consumption
ModelDataWT.TregConsumption = e_R.*ModelDataWT.Il2.*ModelDataWT.TregCT;
ModelDataKO.TregConsumption = e_R.*ModelDataKO.Il2.*ModelDataKO.TregCT;

%---Death of IL-2---%
ModelDataWT.IL2Death = f.*ModelDataWT.Il2;
ModelDataKO.IL2Death = f.*ModelDataKO.Il2;

%---Activation Suppression Bosst---%
ModelDataWT.ActivationSuprBoost = (ModelDataWT.Il2./(Ki + ModelDataWT.Il2));
ModelDataKO.ActivationSuprBoost = (ModelDataKO.Il2./(Ki + ModelDataKO.Il2));

%---Deactivation Boost---%
ModelDataWT.DeactivationBoost = (ModelDataWT.Il2./(Kj + ModelDataWT.Il2));
ModelDataKO.DeactivationBoost = (ModelDataKO.Il2./(Kj + ModelDataKO.Il2));
%}
end