function PlottingFillPrm_Fig4_color(ModelRates, StatsOfCells, tx, PlotType,CondKeys, PctChange)

%{
The order of the plots 
subplot(3,4, n)

1) NaiveCT -           StatsOfCells(:,:,1,1) = NaiveCTWT;
2) Prol Naive -        StatsOfCells(:,:,8,1) = NprolWT;
3) ThyNaive -          StatsOfCells(:,:,4,1) = ThyNWT;
4) EMPTY
5) ActivatedCT -     StatsOfCells(:,:,2,1) = ActTCTWT;
6) ActTProl -           StatsOfCells(:,:,9,1) = TprolWT;
7) ActN -                StatsOfCells(:,:,5,1) = ActNWT;
8) IL-2 -                  StatsOfCells(:,:,11,1) = IWT;
9) TregCT -             StatsOfCells(:,:,3,1) = TregCTWT;
10)  TregProl -        StatsOfCells(:,:,9,1) = TprolWT;
11) ThyTregs -        StatsOfCells(:,:,6,1) = ThyRWT;
12) NaiveTregs -     StatsOfCells(:,:,7,1) = DiffRWT;

Location of the Stats StatsOfCells(:,x,-,-)
1 - Means
2 - Standard Deviation
3 - +1 std
4 - -1 std
5 - Lowest 10%ile
6 - Highes 90%ile
%}

%Choosing the plot type
tx = tx / 24;

%-----------------Setting up variables for plotting-----------------------%

if PlotType == "Percentile"
    UpperLimits = 6;
    LowerLimits = 5;
elseif PlotType == "Std"
    UpperLimits = 3;
    LowerLimits = 4;
end

% Genotype = [1,2];
tx2 = [tx, fliplr(tx)]; %Used for the fill in ranges

%Saving the hex colors that I chose
strWT = '#09E600';
strKO = '#9B13A2';
strLineColorWT = '#098027';
strLineColorKO = '#9B13A2';

%Converting the hex to the RGB that matlab uses
colorWT = sscanf(strWT(2:end),'%2x%2x%2x',[1 3])/255;
colorKO = sscanf(strKO(2:end),'%2x%2x%2x',[1 3])/255;
LineColorWT = sscanf(strLineColorWT(2:end),'%2x%2x%2x',[1 3])/255;
LineColorKO = sscanf(strLineColorKO(2:end),'%2x%2x%2x',[1 3])/255;

%The opacity of the fill
FaceAlpha = 0.25;
%LineWidth
LineWidth = 2.5;

%Setting up variables for saving the figure    
loc1 = '../Plots/LHS_Parameters/Figure4/';
plt1 = append(loc1, 'Figure_4_Color_log.pdf');

PLT1 = figure('Visible', 'off');
%set(PLT1,'Position', [left bottom width height]); %This sents the position of the figure itself

%------------------End of variables-------------------------------------------------%



%%%%%%%%%%%%%%
%Treg Death Rate
%%%%%%%%%%%%%%
subplot(2,4,2)

semilogy(tx, ModelRates(2).TregDeath(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
semilogy(tx, ModelRates(2).TregDeath(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).TregDeath(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).TregDeath(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).TregDeath(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).TregDeath(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Treg Death Rates')
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
xlim([0 18])
%legend('WT', 'IL-2 KO', 'WT', 'IL-2 KO')
hold off

%%%%%%%%%%%%%%%%%%%
%Zoomed in Treg Death Rate
%%%%%%%%%%%%%%%%%%%
subplot(2,4,6)

semilogy(tx, ModelRates(2).TregDeath(:,1,1),'color', LineColorWT, 'LineWidth',  LineWidth)%Plotting the means
hold on
semilogy(tx, ModelRates(2).TregDeath(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means
%WT fill
inBetweenWT = [ModelRates(2).TregDeath(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).TregDeath(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).TregDeath(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).TregDeath(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Zoomed in Treg Death Rates')
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
%legend('WT', 'IL-2 KO', 'WT', 'IL-2 KO')
xlim([0 5])
ylim([0 30])
hold off

%%%%%%%%
%Prol Tregs
%%%%%%%%
subplot(2,4,3)

semilogy(tx, ModelRates(2).ProlTregs(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)
hold on
semilogy(tx, ModelRates(2).ProlTregs(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)
% plot(tx, ModelRates(2).ProlTregs(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
% hold on
% plot(tx, ModelRates(2).ProlTregs(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).ProlTregs(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).ProlTregs(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).ProlTregs(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).ProlTregs(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Treg Proliferating Rates')
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
%legend('WT', 'IL-2 KO', 'WT', 'IL-2 KO')
xlim([0 18])
hold off

%%%%%%%%%%%%%
%Zoomed in Prol Tregs
%%%%%%%%%%%%%
subplot(2,4,7)

semilogy(tx, ModelRates(2).ProlTregs(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)
hold on
semilogy(tx, ModelRates(2).ProlTregs(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)
% plot(tx, ModelRates(2).ProlTregs(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
% hold on
% plot(tx, ModelRates(2).ProlTregs(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).ProlTregs(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).ProlTregs(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).ProlTregs(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).ProlTregs(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Zoomed in Proliferating Tregs')
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
%legend('WT', 'IL-2 KO', 'WT', 'IL-2 KO')
xlim([0 5])
%ylim([1.5 7])
hold off


%%%%%%%%%%%%
%Treg Hill Results
%%%%%%%%%%%%
subplot(2,4,5)

plot(tx, ModelRates(2).TregDeathHill(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
plot(tx, ModelRates(2).TregDeathHill(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).TregDeathHill(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).TregDeathHill(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).TregDeathHill(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).TregDeathHill(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Treg Death Suppression Strength')
ylabel('Percentage')
xlabel('Age in Days')
xlim([0 18])
hold off

%-----------------Plotting from StatsOfCells DF------------------------%
% Here are what each of the multidimensional slots represents
% (A, B, C, D)
% A - Each row represents an hour
% B - The different stats are here
% C - The cellular populations
% D - Genotypes

% Note: I didn't learn how to properly use data structs at the time when I
% was coding the function that calculates StatsOfCells.If I have time, I'll change
% the structure.

%%%%%
% IL-2
%%%%%
subplot(2,4,1)

plot(tx, StatsOfCells(:,1,11,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means WT
hold on
plot(tx, StatsOfCells(:,1,11,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means KO
%WT Fill
inBetweenWT = [StatsOfCells(:,UpperLimits,11,1)', fliplr(StatsOfCells(:,LowerLimits,11,1)')];
fill(tx2, inBetweenWT , colorWT, 'FaceAlpha',FaceAlpha);
%KO Fill
inBetweenKO = [StatsOfCells(:,UpperLimits,11,2)', fliplr(StatsOfCells(:,LowerLimits,11,2)')]; % KO
fill(tx2, inBetweenKO , colorKO, 'FaceAlpha',FaceAlpha);

title('Available IL-2 Cytokine')
ylabel('IL-2 Cytokine')
xlabel('Age in Days')
xlim([0 18])
hold off

%%%%%%%%
% Total Tregs
%%%%%%%%
subplot(2,4,4)

semilogy(tx, StatsOfCells(:,1,3,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
semilogy(tx, StatsOfCells(:,1,3,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT Fill
inBetweenWT = [StatsOfCells(:,UpperLimits,3,1)', fliplr(StatsOfCells(:,LowerLimits,3,1)')];
fill(tx2, inBetweenWT , colorWT, 'FaceAlpha',FaceAlpha);

%KO FIll
inBetweenKO = [StatsOfCells(:,UpperLimits,3,2)', fliplr(StatsOfCells(:,LowerLimits,3,2)')];
fill(tx2, inBetweenKO , colorKO, 'FaceAlpha',FaceAlpha);

title('Total Tregs');
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
%xlim([0 18])
legend('WT', 'IL-2 KO', 'WT', 'IL-2 KO', 'Location','northwest')
hold off

%%%%%%%%%%%%%%
% zoomed in Total Tregs
%%%%%%%%%%%%%%
subplot(2,4,8)

semilogy(tx, StatsOfCells(:,1,3,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
semilogy(tx, StatsOfCells(:,1,3,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT Fill
inBetweenWT = [StatsOfCells(:,UpperLimits,3,1)', fliplr(StatsOfCells(:,LowerLimits,3,1)')];
fill(tx2, inBetweenWT , colorWT, 'FaceAlpha',FaceAlpha);

%KO FIll
inBetweenKO = [StatsOfCells(:,UpperLimits,3,2)', fliplr(StatsOfCells(:,LowerLimits,3,2)')];
fill(tx2, inBetweenKO , colorKO, 'FaceAlpha',FaceAlpha);

title('Zoomed in Total Tregs')
ylabel('Cell Numbers (log)')
xlabel('Age in Days')
xlim([0 5])
%ylim([130 400])
hold off

clear figure_property;
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';
figure_property.Width= '21'; % Figure width on canvas
figure_property.Height= '8'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '18'; %Changing the font size from 9
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '18'; %Changing the font size from 9
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=PLT1;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(PLT1,plt1,figure_property); %Set desired file name


%saveas(PLT1, sprintf(plt1))
end