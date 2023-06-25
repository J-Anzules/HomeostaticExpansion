function PlottingFillPrm_Fig5(ModelRates, StatsOfCells, tx, PlotType,CondKeys, PctChange)

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
strKO = '#9B13A2';
strWT = '#09E600';
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
LineWidth = 1;

%Setting up variables for saving the figure    
loc2 = '../Plots/LHS_Parameters/Figure5Testing/';
plt2 = append(loc2, CondKeys{:,:},'_', num2str(PctChange), '_koKA_koj.pdf');

%Figure Positioning
left = 0;
bottom = 400;
width = 1800;
height = 1050;


%PctChange = PctChange * 100;


%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%

%                                   Figure 5                                          %      

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%



PLT2 = figure('Visible', 'off');
set(PLT2,'Position',[left bottom width height]); %This sents the position of the figure itself

%sgtitle({['Parameters Changed:', [CondKeys{:,:}]],...
 %   ['Percent Chagne = ', num2str(PctChange), '%']}, 'Fontsize' ,40);

% Activating Naive T cells
subplot(3,1,1)

plot(tx, StatsOfCells(:,1,5,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
plot(tx, StatsOfCells(:,1,5,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT Fill
inBetweenWT = [StatsOfCells(:,UpperLimits,5,1)', fliplr(StatsOfCells(:,LowerLimits,5,1)')];
fill(tx2, inBetweenWT , colorWT, 'FaceAlpha',FaceAlpha);

%KO FIll
inBetweenKO = [StatsOfCells(:,UpperLimits,5,2)', fliplr(StatsOfCells(:,LowerLimits,5,2)')];
fill(tx2, inBetweenKO , colorKO, 'FaceAlpha',FaceAlpha);

title('Activating naive T cells');
ylabel('Cell numbers')
%xlabel('Age in Days')
% xlim([0 45])
ylim([0 2500000])
yticks([0 1000000 2000000 2500000])
yticklabels([0 1 2 ])
hold off

% Hill equation suppressing beta
subplot(3,1,2)

plot(tx, ModelRates(2).BetaSuppressionStrength(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
plot(tx, ModelRates(2).BetaSuppressionStrength(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).BetaSuppressionStrength(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).BetaSuppressionStrength(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).BetaSuppressionStrength(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).BetaSuppressionStrength(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Activation suppression strength')
%xlabel('Age in Days')
ylabel('Hill value')
% xlim([0 45])
hold off

% Removed Effector Cells

subplot(3,1,3)

plot(tx, ModelRates(2).RemovedActT(:,1,1),'color', LineColorWT, 'LineWidth', LineWidth)%Plotting the means
hold on
plot(tx, ModelRates(2).RemovedActT(:,1,2),'color', LineColorKO, 'LineWidth', LineWidth)%Plotting the means

%WT fill
inBetweenWT = [ModelRates(2).RemovedActT(:,UpperLimits,1)', ...
    fliplr(ModelRates(2).RemovedActT(:,LowerLimits,1)')];
fill(tx2, inBetweenWT, colorWT, 'FaceAlpha',FaceAlpha);
%KO fill
inBetweenKO = [ModelRates(2).RemovedActT(:,UpperLimits,2)', ...
    fliplr(ModelRates(2).RemovedActT(:,LowerLimits,2)')];
fill(tx2, inBetweenKO, colorKO, 'FaceAlpha',FaceAlpha);

title('Removed activated T cells')
ylabel('Cell numbers')
xlabel('Age in days')
% xlim([0 45])
ylim([0 550000])
yticks([0 250000 500000])
yticklabels([0 2.5 5])
hold off


clear figure_property;
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';
figure_property.Width= '4'; % Figure width on canvas
figure_property.Height= '5'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '10';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '10';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Arial';% Might want to change this to something that is available
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
chosen_figure=PLT2;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(PLT2,plt2,figure_property); %Set desired file name


%saveas(PLT2, sprintf(plt2))


















































end