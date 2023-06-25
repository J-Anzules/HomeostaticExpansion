close all; clear all; clc
%Getting Data from simulation and for table
Data = readtable('../RawData/ActivatedWTSpleen.csv');
CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'AllTregs', ...                  
     'hours'});
 
% - Selecting the Data that I want to visualize
EntryNumber = 1;
%hours where our data belongs
tx = 1:432; 

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
kB      = p(16);



%Simulation results are in the form ModelData = [dNdt, dTdt, dRdt, dIdt, dmdt]';

%Tregs from Naive Differentiation: c*Naive
ModelData(:,6) = c.* ModelData(:,1); 
%Treg Self Replication: epsilon*Tregs
ModelData(:,7) = epsilon.*ModelData(:,3); 
%Logistical growth equation for the Thymus
K = 0.074896;
Thy_max = K;
Thy=ModelData(:,5);
%Thymic Tregs
ModelData(:,8) = alpha.*(Thy/Thy_max); 
%Activation of naive
ModelData(:,9) =beta.* ModelData(:,1).*(1./(1+(ModelData(:,3)./kA).^n)); 
%Activated T Cell Self Replication
ModelData(:,10) = a.*ModelData(:,2); 
%Hill suppression naive
ModelData(:,11) = (1./(1+(ModelData(:,3)./kA).^n));
%Hill suppression Treg death rate
ModelData(:,12) = (1./(1+(ModelData(:,4)./kB).^n));


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
PLT = figure(1);
%PLT = figure('visible','off');
set(PLT,'Position',[left bottom width height]); %This sents the position of the figure itself

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
ylim([0, 8000000])
hold off

%---------- T Regulatory Cells ----------%
subplot(3,3,2) % Top left
scatter(CellData.hours, CellData.AllTregs)
hold on 
plot(tx, ModelData(:,3))
title('T Regulatory Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'FModelData(:,1)ontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
ylim([0, 1500000])
hold off          

%---------- Activated T Cells ------------%
subplot(3,3,3) % Top left
scatter(CellData.hours, CellData.ActivatedCD4CT)
hold on 
plot(tx, ModelData(:,2))
title('Activated T Cells', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel(ylab, 'Fontsize', YFontSize)
ylim([0, 1500000])
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


Changing = {'*alpha',     alpha,     '   cells*hr−1';...
                    'a',           a,             '   hr−1';...
                    'kA',         kA,           '   cells';...
                    '*e_T',       e_T,         '   cells-1*hr−1';...
                    'e_R',       e_R,          '   cells-1*hr−1';...
                    '*g',          g,             '   hr−1';...
                    'b_T',       b_T,           '   hr−1';...
                    '*b_R',      b_R,          '   hr−1';};


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
             
             
Fixed =  {'*mu',       mu,         '   cells*hr−1';...
                '*beta',      beta,      '   hr−1';...   
                '*c',           c,           '   hr−1';...
                'epsilon',  epsilon,   '  hr−1';...
                '*n',           n,           '              -        ';...
                '*d',           d,           '   Molecules*cells-1*hr−1';...
                '*f',            ff,           '   hr−1';...
                'kB'          kB           '   cells'};
            
columnname =   {'Fixed Parameter', '     Value          ', '           Units           '};
columnformat = {'char', 'numeric', 'char'}; 
uitable('Units','normalized',...
                 'Position', [0.57 0.04 0.394 0.3],... % [ Horizontal Location, Verticle location,Right Line, Bottom Line]
                 'Data', Fixed,...
                 'ColumnName', columnname,...
                 'ColumnFormat', columnformat,...
                 'RowName',[],...
                  'FontSize', 20,...
                 'ColumnWidth', {150 200 360});
             
PLT2 = figure(2);

subplot(2,1,1)
plot(tx, ModelData(:,11))
title('Hill Value', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', XFontSize)
ylabel('Hill Value', 'Fontsize', YFontSize)

subplot(2,1,2)
plot(tx, ModelData(:,12))
title('Treg Death Suppression', 'Fontsize', TitleFontSize)
xlabel(xlab, 'Fontsize', TitleFontSize)
ylabel('Death Rate Suppression', 'Fontsize', YFontSize)
