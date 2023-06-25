function PlottingLHSResults(StatsOfCells, tx, PlotType)

%{
The order of the plots 
subplot(3,4, n)
1 = NaiveCT -           StatsOfCells(:,:,1,1) = NaiveCTWT;
2 = Prol Naive -        StatsOfCells(:,:,8,1) = NprolWT;
3 = ThyNaive -          StatsOfCells(:,:,4,1) = ThyNWT;
4 = EMPTY
5 = ActivatedCT -     StatsOfCells(:,:,2,1) = ActTCTWT;
6 = ActTProl -           StatsOfCells(:,:,9,1) = TprolWT;
7 = ActN -                StatsOfCells(:,:,5,1) = ActNWT;
8 = IL-2 -                  StatsOfCells(:,:,11,1) = IWT;
9 = TregCT -             StatsOfCells(:,:,3,1) = TregCTWT;
10 =  TregProl -        StatsOfCells(:,:,9,1) = TprolWT;
11 = ThyTregs -        StatsOfCells(:,:,6,1) = ThyRWT;
12 = NaiveTregs -     StatsOfCells(:,:,7,1) = DiffRWT;

Location of the Stats StatsOfCells(:,x,-,-)
1 - Means
2 - Standard Deviation
3 - +1 std
4 - -1 std
5 - Lowest 10%ile
6 - Highes 90%ile
%}


%Choosing the plot type

if PlotType == "Percentile"
    UpperLimits = 6;
    LowerLimits = 5;
elseif PlotType == "Std"
    UpperLimits = 3;
    LowerLimits = 4;
end


Genotype = [1,2];
tx = tx /24;
for gene = Genotype
    %Selecting the proper files and file names to save figure
    %1 = WildType, 2 = Genotype
    
    if gene == 1
        CellData = readtable('../RawData/ActivatedWTSpleen.csv');
        ProlData = readtable('../RawData/WTProl.csv');
        Gntype = "WT";

    elseif gene == 2
        CellData = readtable('../RawData/ActivatedKOSpleen.csv');
        ProlData = readtable('../RawData/KOProl.csv');
        Gntype = "KO";
    end

    %Setting up data for plotting
    CellData = CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
        'ThymicNaive', 'ActivatedNaiveCT', ...
        'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
        'hours'});

    ProlData = ProlData(:,{ 'NaiveProlCT', 'ActivatedProlCT', 'X4TregProlCT', ...
        'hours'});
    
    %Setting up variables for saving the figure    
    loc = '../Plots/LHS_Parameters/';
    plt = append(loc, Gntype, '_LHSinit.png');
    
    %Figure Positioning
    left = 0;
    bottom = 400;
    width = 1800;
    height = 1050;
    
    PLT = figure('Visible', 'off');
    set(PLT,'Position',[left bottom width height]); %This sents the position of the figure itself
    
    %Changing hours to days
    %tx = tx /24;
    CellData.hours = CellData.hours / 24;
    ProlData.hours = ProlData.hours / 24;
    
   
    %----------------------------------------------------------------------------------------------%
    %                                     Plot Variables

    TitleSize = 18;
    XSize = 22;
    YSize = 22;
    TickSize = 13;
    DotSize = 50;


    %----------------------------------------------------------------------------------------------%
    %                                           Naive T Cells
    %----------------------------------------------------------------------------------------------%
    
    
    %Total Naive T Cells
    subplot(3,4,1)
    scatter(CellData.hours, CellData.NaiveCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 4000000])
    hold on
    plot(tx, StatsOfCells(:,1,1,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,1,gene)', fliplr(StatsOfCells(:,LowerLimits,1,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Total','naive T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %Proliferating Naive
    subplot(3,4,2)
    scatter(ProlData.hours, ProlData.NaiveProlCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 4000000])
    hold on
    plot(tx, StatsOfCells(:,1,8,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,8,gene)', fliplr(StatsOfCells(:,LowerLimits,8,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Proliferating', 'naive T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %Thymic Derived Naive T Cells
    subplot(3,4,3)
    scatter(CellData.hours, CellData.ThymicNaive, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 4000000])
    hold on
    plot(tx, StatsOfCells(:,1,4,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,4,gene)', fliplr(StatsOfCells(:,LowerLimits,4,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Thymic derived', 'naive T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %----------------------------------------------------------------------------------------------%
    %                                       Activated T Cells
    %----------------------------------------------------------------------------------------------%
    
    %Total Activated T Cells
    subplot(3,4,5)
    scatter(CellData.hours, CellData.ActivatedCD4CT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 8000000])
    hold on
    plot(tx, StatsOfCells(:,1,2,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,2,gene)', fliplr(StatsOfCells(:,LowerLimits,2,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Total', 'activated T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %Prol ActT
    subplot(3,4,6)
    scatter(ProlData.hours, ProlData.ActivatedProlCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 8000000])
    hold on
    plot(tx, StatsOfCells(:,1,9,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,9,gene)', fliplr(StatsOfCells(:,LowerLimits,9,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Proliferating', 'activated T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    % Naive Derived Activated T
    subplot(3,4,7)
    scatter(CellData.hours, CellData.ActivatedNaiveCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 8000000])
    hold on
    plot(tx, StatsOfCells(:,1,5,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,5,gene)', fliplr(StatsOfCells(:,LowerLimits,5,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Naive derived', 'activated T cells'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    % IL-2
    subplot(3,4,8)
    plot(tx, StatsOfCells(:,1,11,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    ax = gca;   
    ax.FontSize = TickSize;
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,11,gene)', fliplr(StatsOfCells(:,LowerLimits,11,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title('IL-2 Cytokine', 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %----------------------------------------------------------------------------------------------%
    %                                       Regulatory T Cells
    %----------------------------------------------------------------------------------------------%
    
    % Total Tregs
    subplot(3,4,9)
    scatter(CellData.hours, CellData.X4TregCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 820000])
    hold on
    plot(tx, StatsOfCells(:,1,3,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,3,gene)', fliplr(StatsOfCells(:,LowerLimits,3,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title('Total Tregs', 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('Age in days', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    %Prol Treg
    subplot(3,4,10)
    scatter(ProlData.hours, ProlData.X4TregProlCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 820000])
    hold on
    plot(tx, StatsOfCells(:,1,10,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,10,gene)', fliplr(StatsOfCells(:,LowerLimits,10,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title('Proliferating Tregs', 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('Age in days', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    
    % ThymicDerivedTregsCT
    subplot(3,4,11)
    scatter(CellData.hours, CellData.ThymicDerivedTregsCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 820000])
    hold on
    plot(tx, StatsOfCells(:,1,6,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,6,gene)', fliplr(StatsOfCells(:,LowerLimits,6,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Thymic Derived', 'Tregs'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('Age in days', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    
    % NaiveDerivedTregsCT
    subplot(3,4,12)
    scatter(CellData.hours, CellData.NaiveDerivedTregsCT, DotSize, 'o', 'MarkerFaceColor', 'blue')
    ax = gca;   
    ax.FontSize = TickSize;
    ylim([0, 820000])
    hold on
    plot(tx, StatsOfCells(:,1,7,gene),'b-', 'LineWidth', 1.5)%Plotting the means
    tx2 = [tx, fliplr(tx)];
    inBetween = [StatsOfCells(:,UpperLimits,7,gene)', fliplr(StatsOfCells(:,LowerLimits,7,gene)')];
    fill(tx2, inBetween, [0.6 0.1 1.0], 'FaceAlpha',0.2);
    title({'Naive Derived', 'Tregs'}, 'FontName', 'Arial', 'FontSize', TitleSize)
    ylabel('Cell numbers','FontName', 'Arial', 'FontSize',XSize)
    xlabel('Age in days', 'FontName', 'Arial', 'FontSize', YSize)
    hold off
    

    
    saveas(PLT, sprintf(plt))
end