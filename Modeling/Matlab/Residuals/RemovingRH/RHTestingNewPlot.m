%%
%%
close all; clear all; clc
%Getting Data from simulation and for table
Data = readtable('../RawData/ActivatedWTSpleen.csv');
CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'AllTregs', ...                  
     'hours'});

%Hight a: 14
%Best: EntryNumber = 1420;
EntryNumber = 14;
tx = 1:432; %hours where our data belongs

[ModelData, Error] = Plot_Simulation(EntryNumber);%Error value for plotting

p = GetParameters(EntryNumber);

%Parameter Values
mu      = p(1);
beta    = p(2);
c       = p(3);
epsilon = p(4);
n       = p(5);
d       = p(6);
ff       = p(7);
alpha   = p(8);
a       = p(9);
kA      = p(10);
e_T     = p(11);
e_R     = p(12);
g       = p(13);
b_T     = p(14);
b_R     = p(15);



%Simulation results are in the form ModelData = [dNdt, dTdt, dRdt, dIdt, dmdt]';

ModelData(:,6) = c * ModelData(:,1); %Tregs from Naive Differentiation: c*Naive
ModelData(:,7) = epsilon * a .*ModelData(:,4) .*ModelData(:,3); %Treg Self Replication: epsilon*a*I*Tregs
%ModelData(:,8) = ModelData(:,3) - (ModelData(:,6) + ModelData(:,7)); %Tregs from Thymus

%Logistical growth equation for the Thymus
K = 0.074896;
Thy_max = K;
lambda = 0.016932;
Thy = lambda.* ModelData(:,5).* (1 - (ModelData(:,5)./K));
ModelData(:,8) = alpha * (Thy/Thy_max);

ModelData(:,9) =beta.* ModelData(:,1).*(1./(1+(ModelData(:,3)./kA).^n)); %Activation of naive
ModelData(:,10) = a.*ModelData(:,4).*ModelData(:,2); %Activated T Cell Self Replication


%ModelData1 = array2table(ModelData,...
   % 'VariableNames',{'NaiveCT','ActivatedCD4CT','AllTregs', 'IL2', 'ThymusMass'});


%-------------------------------------------------------------------------------%
% ---------------------------Plot Variables --------------------------------%
%-------------------------------------------------------------------------------%

%Labels
xlab = "Hours";
ylab = "Cell Count";
ylab2 = "IL-2 Cytokine Count";

%Figure Positioning
left = 0;
bottom = 400;
width = 1800;
height = 1050;

TitleFontSize = 20;
XFontSize = 20;
YFontSize = 20;
%-------------------------------------------------------------------------------%
% ------------------------------- Plotting -----------------------------------%
%-------------------------------------------------------------------------------%
f = figure(1);
set(f,'Position',[left bottom width height]); %This sents the position of the figure itself

%Place the Error Value on the top of the plot
sgtitle({['Error = ' num2str(Error)]})


%------------ Naive T Cells ------------%
subplot(3,3,1) % Top left
scatter(CellData.hours, CellData.NaiveCT)
hold on 
plot(tx, ModelData(:,1))
title('Naive T Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
hold off

%---------- T Regulatory Cells ----------%
subplot(3,3,2) % Top left
scatter(CellData.hours, CellData.AllTregs)
hold on 
plot(tx, ModelData(:,3))
title('T Regulatory Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
hold off          

%---------- Activated T Cells ------------%
subplot(3,3,3) % Top left
scatter(CellData.hours, CellData.ActivatedCD4CT)
hold on 
plot(tx, ModelData(:,2))
title('Activated T Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
hold off

%----------- IL-2 Cytokine ----------------%
subplot(3,3,4)
plot(tx,ModelData(:,4))
title('IL-2 Cytokine', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab2, 'Fontsize', YFontSize)

%---------- Other Treg growths ---------%
subplot(3,3,5)
%scatter(CellData.hours, CellData.AllTregs)
plot(tx, ModelData(:,6), 'DisplayName', 'From Naive')
hold on
plot(tx, ModelData(:,7), 'DisplayName', 'Self Replication')
plot(tx, ModelData(:,8), 'DisplayName', 'Thymus')
legend('Location','northwest')
title('Other Treg Growths', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
hold off

%---------- Other Activated T Cell Growths ------------%
subplot(3,3,6) % Top left
%scatter(CellData.hours, CellData.ActivatedCD4CT)
plot(tx, ModelData(:,9), 'DisplayName', 'From Naive')
hold on
plot(tx, ModelData(:,10), 'DisplayName', 'Self Replication')
title('Other Activated T Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
legend('Location','northwest')
hold off        


Changing = {'alpha',     alpha,     '   cells*hr−1';...
                    'a',           a,            '   cells*hr−1';...
                    'kA',         kA,          '   cells';...
                    'e_T',       e_T,         '   molecules*hr−1';...
                    'e_R',       e_R,         '   molecules*hr−1';...
                    'g',          g,             '   cells*hr−1';...
                    'b_T',       b_T,         '   cells*hr−1';...
                    'b_R',      b_R,          '   cells*hr−1';};

columnname =   {'Parameters', '     Value          ', '           Units           '};
columnformat = {'char', 'numeric', 'char'}; 
uitable('Units','normalized',...
                 'Position', [0.12 0.04 0.3466 0.3],... % [ Horizontal Location, Verticle location,Right Line, Bottom Line]
                 'Data', Changing,...
                 'ColumnName', columnname,...
                 'ColumnFormat', columnformat,...
                 'RowName',[],...
                 'FontSize', 20,...
                 'ColumnWidth', {150 200 270});
             
             
Fixed =  {'mu',       mu,         '   cells*hr−1';...
                'beta',      beta,      '   cells*hr−1';...   
                'c',           c,           '   cells*hr−1';...
                'epsilon',  epsilon,   '              -        ';...
                'n',           n,           '              -        ';...
                'd',           d,           '   molecules*hr−1';...
                'f',            ff,           '   cells*hr−1';};
            
columnname =   {'Fixed Parameter', '     Value          ', '           Units           '};
columnformat = {'char', 'numeric', 'char'}; 
uitable('Units','normalized',...
                 'Position', [0.57 0.04 0.3466 0.3],... % [ Horizontal Location, Verticle location,Right Line, Bottom Line]
                 'Data', Fixed,...
                 'ColumnName', columnname,...
                 'ColumnFormat', columnformat,...
                 'RowName',[],...
                  'FontSize', 20,...
                 'ColumnWidth', {150 200 270});

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%              Practicing Section             %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Data = readtable('../RawData/ActivatedWTSpleen.csv');
CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'AllTregs', ...                  
     'hours'});

tx = 1:432; %hours where our data belongs
DataUsed = [1, 2, 3]; %Naive = 1, Activ = 2, Treg = 3, hours = 4


[ModelData, Error] = Plot_Simulation(EntryNumber);%Error value for plotting

p = GetParameters(EntryNumber);

%Parameter Values
mu      = p(1);
beta    = p(2);
c       = p(3);
epsilon = p(4);
n       = p(5);
d       = p(6);
f       = p(7);
alpha   = p(8);
a       = p(9);
kA      = p(10);
e_T     = p(11);
e_R     = p(12);
g       = p(13);
b_T     = p(14);
b_R     = p(15);

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

%%
saveas(Plt,sprintf('../Plots/FIG_%d.png',EntryNumber));

%% Working Table
Data = readtable('../RawData/ActivatedWTSpleen.csv');
CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'AllTregs', ...                  
     'hours'});

EntryNumber = 43;
tx = 1:432; %hours where our data belongs
DataUsed = [1, 2, 3]; %Naive = 1, Activ = 2, Treg = 3, hours = 4


[ModelData, Error] = Plot_Simulation(EntryNumber);%Error value for plotting

p = GetParameters(EntryNumber);


f = figure(1);
%Position is: [ Horizontal Location, Verticle location,Right Line, Bottom Line]
set(f,'Position',[1400 600 330 400]); %This sents the position of the figure itself


dat =  {'mu',       p(1),     '   cells*hr−1';...
            'beta',      p(2),     '   cells*hr−1';...   
            'c',           p(3),     '   cells*hr−1';...
            'epsilon',  p(4),      '               -';...
            'n',           p(5),     '               -';...
            'd',           p(6),     '   molecules*hr−1';...
            'f',            p(7),     '   cells*hr−1';...
            'alpha',     p(8),     '   cells*hr−1';...
            'a',           p(9),     '   cells*hr−1';...
            'kA',         p(10),   '   cells';...
            'e_T',       p(11),    '   molecules*hr−1';...
            'e_R',       p(12),    '   molecules*hr−1';...
            'g',          p(13),    '   cells*hr−1';...
            'b_T',       p(14),    '   cells*hr−1';...
            'b_R',      p(15),     '   cells*hr−1';};
columnname =   {'Parameter', '     Value          ', '           Units           '};
columnformat = {'char', 'numeric', 'char'}; 
uitable('Units','normalized',...
                 'Position', [0.05 0.1 0.9 0.9],... 
                 'Data', dat,...
                 'ColumnName', columnname,...
                 'ColumnFormat', columnformat,...
                 'RowName',[]);
%%
scatter(CellData.hours, CellData.NaiveCT)
hold on 
plot(tx, ModelData(:,1))
title('Naive T Cells')
hold off
             
%%
subplot(2,1,1);
plot(1:10);
uitable('Data', [1 2 3], 'ColumnName', {'A', 'B', 'C'}, 'Position', [20 20 500 150]);
        
        
        
        %%
%f = figure(1);
%set(f,'Position',[500 500 330 400]);
subplot(2,1,1)
dat =  {'mu',       p(1),     '   cells*hr−1';...
            'beta',      p(2),     '   cells*hr−1';...   
            'c',           p(3),     '   cells*hr−1';...
            'epsilon',  p(4),      '               -';...
            'n',           p(5),     '               -';...
            'd',           p(6),     '   molecules*hr−1';...
            'f',            p(7),     '   cells*hr−1';...
            'alpha',     p(8),     '   cells*hr−1';...
            'a',           p(9),     '   cells*hr−1';...
            'kA',         p(10),   '   cells';...
            'e_T',       p(11),    '   molecules*hr−1';...
            'e_R',       p(12),    '   molecules*hr−1';...
            'g',          p(13),    '   cells*hr−1';...
            'b_T',       p(14),    '   cells*hr−1';...
            'b_R',      p(15),     '   cells*hr−1';};
columnname =   {'Parameter', '     Value          ', '           Units           '};
columnformat = {'char', 'numeric', 'char'}; 
uitable('Position', [0.05 0.1 0.9 0.9],... 
                 'Data', dat,...
                 'ColumnName', columnname,...
                 'ColumnFormat', columnformat,...
                 'RowName',[]);
             
subplot(2,1,2)
scatter(CellData.hours, CellData.NaiveCT)
hold on 
plot(tx, ModelData(:,1))
title('Naive T Cells')
hold off
             
        
%% - Simple working figure and uitable
% Create table


LastName = {'Sanchez','Johnson','Danz'}; 
Age = [38,43,40]; 
Height = [71, 69, 71]; 
T = table(LastName',Age',Height','VariableNames',{'LastName','Age','Height'}); 
% plot some data in the main axes
%Plt = figure();
figure()
axes('position',[.1,0.45,0.8,0.5]) %[,Horizontal Location,Verticle Location, Right line,top line]
plot(Age,Height,'o')
xlabel('Age')
ylabel('Height'); 

uit = uitable('Data', table2cell(T),'ColumnName',T.Properties.VariableNames,...
    'Units', 'Normalized', 'Position',[0.2,0.05,0.6,0.25]);


%saveas(Plt,sprintf('../Plots/Test.png'));





%% a
        
        
        
        