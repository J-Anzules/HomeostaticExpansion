function PlottingResults(pOpt, Genotype)
global tx

ModelData = SimulateGrowth(pOpt, Genotype);
ModelData = array2table(ModelData);

ModelData.Properties.VariableNames = {'NaiveCT' 'ActivCT' 'TregCT' ...
    'ThyDerivedNaive' 'ActivNaive' 'ThyDerivedTregs' 'NaiveDerivedTregs' ...
    'ProlNaive' 'ProlActiv' 'ProlTregs' ...
    'Il2' 'ThyWeight'};

%Selecting the proper files and file names to save figure
%1 = WildType, 2 = Genotype
if Genotype == 1
    CellData = readtable('../RawData/ActivatedWTSpleen.csv');
    ProlData = readtable('../RawData/WTProl.csv');
    Gntype = "WT";
    Order = "1_";
    
elseif Genotype == 2
    CellData = readtable('../RawData/ActivatedKOSpleen.csv');
    ProlData = readtable('../RawData/KOProl.csv');
    Gntype = "KO";
    Order = "2_";
end

%Setting up data for plotting
CellData = CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
    'ThymicNaive', 'ActivatedNaiveCT', ...
    'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
    'hours'});

ProlData = ProlData(:,{ 'NaiveProlCT', 'ActivatedProlCT', 'X4TregProlCT', ...
    'hours'});

%Setting file names
loc = '../Plots/';

plt =  append (loc, Order, Gntype, '_1_pops.png');


%Figure Positioning
left = 0;
bottom = 400;
width = 1800;
height = 1050;

%Begin Plotting
PLT = figure('Visible', 'off');
set(PLT,'Position',[left bottom width height]); %This sents the position of the figure itself

%Naive CT
subplot(3,4,1)
scatter(CellData.hours, CellData.NaiveCT)
ylim([0, 4000000])
hold on 
plot(tx, ModelData.NaiveCT)
title('Naive T Cells')
hold off
%Naive Prol
subplot(3,4,2)
scatter(ProlData.hours, ProlData.NaiveProlCT)
ylim([0, 1000000])
hold on 
plot(tx, ModelData.ProlNaive)
title('Proliferating Naive')
hold off
%Naive Thymic
subplot(3,4,3)
scatter(CellData.hours, CellData.ThymicNaive)
ylim([0, 3500000])
hold on 
plot(tx, ModelData.ThyDerivedNaive)
title('Thymic Naive')
hold off

% %Calculating Treg Frequency
% TregFreq = ModelData.TregCT ./(ModelData.NaiveCT+ModelData.ActivCT);
% %TregFreq (TregFreq > 0.1) = NaN;
% subplot(3,4,4)
% plot(tx, TregFreq)
% title('Treg frequency')

%Activated CT
subplot(3,4,5)
scatter(CellData.hours, CellData.ActivatedCD4CT)
ylim([0, 8000000])
hold on 
plot(tx, ModelData.ActivCT)
title('Activated Counts')
hold off
%Activated Prol
subplot(3,4,6)
scatter(ProlData.hours, ProlData.ActivatedProlCT)
ylim([0, 2000000])
hold on 
plot(tx, ModelData.ProlActiv)
title('Activated Prol')
hold off
%Activated Naive derived
subplot(3,4,7)
scatter(CellData.hours, CellData.ActivatedNaiveCT)
ylim([0, 6000000])
hold on 
plot(tx, ModelData.ActivCT)
title('Activated Naive')
hold off
% %IL-2
% subplot(3,4,8)
% plot(tx, ModelData.Il2)
% title('IL-2')
% hold off
%Treg CT
subplot(3,4,9)
scatter(CellData.hours, CellData.X4TregCT)
ylim([0, 700000])
hold on 
plot(tx, ModelData.TregCT)
title('Treg CT')
hold off
%Treg Prol
subplot(3,4,10)
scatter(ProlData.hours, ProlData.X4TregProlCT)
ylim([0, 600000])
hold on 
plot(tx, ModelData.ProlTregs)
title('Treg Prol')
hold off
%Thymic Tregs
subplot(3,4,11)
scatter(CellData.hours, CellData.ThymicDerivedTregsCT)
ylim([0, 35000])
hold on 
plot(tx, ModelData.ThyDerivedTregs)
title('Thymic Tregs')
hold off
%Naive Derived Tregs
subplot(3,4,12)
scatter(CellData.hours, CellData.NaiveDerivedTregsCT)
ylim([0, 400000])
hold on 
plot(tx, ModelData.NaiveDerivedTregs)
title('Naive Derived Tregs')
hold off

saveas(PLT, sprintf(plt))
end