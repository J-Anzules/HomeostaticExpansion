clc; clear variable; close all;
% This file was created by issuing command: 
% 	python make_ode_m_file.py test.csv BaughSchemeII.m

%%%%%%%%%%%%%%%%%%%%
% Real Data for 2A %
%%%%%%%%%%%%%%%%%%%%

clf

[Time_data, Product_data] = realData();

colorE = [[1 0 0]; [0 1 0]; [0 0 1]; [0.2 0 0]; [1 0 1]; [0 1 1]; [1 0.5 0.5]; [0.2 0.5 0.5]];


%-------------------------%
%-- Enzyme Conentration --%
%-------------------------%
 
% Different Enzyme concentration given in baugh 1998 fig 2A
TF_PCPS= 0.001.*[1024, 512, 384, 256, 192,128,64,32]; % converting pM to nM
TF_PCPS = sort(TF_PCPS);  

%-----------------%
%--- Time Step ---%
%-----------------%

t_start = 0; % Default start time is 0
t_final = 900; % Default final time is 1

%--------------------------%
%--- Kinetic Parameters ---%
%--------------------------%

KM = 238;
k_2 = 7;
k_1on = 0.5;
k_1off = k_1on*KM - k_2; % (s)^{-1}

KEP = 520;% KEP = k_off/k_on --- units:nM --- %Fixed Table II-step4- Lu et al 200
k_3off = 350;% value of k_3on that best fits the data
k_3on = k_3off/KEP; %Units:(s)^{-1}---% by definition of KEP

k_4on = 0.9*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
k_4off = 3.6*10^(-4); %Units:(s)^{-1} ----%---% Table II col 3 Baugh 1998

k_5on = 7.34*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
k_5off = 11*10^(-4);  %Units:(s)^{-1}---%% Table II col 3 Baugh 1998

k_6on =  k_4on*10^(3);%.43185;  %---Units:---(\nMs)^{-1}--- being sampled
k_6off = k_4off*10^(3); % ---Units:(s)^{-1}--- being sampled

k_7on = 0;%2*k_3off;% value of k_7on that best fits the data
k_7off = 0;%11*10^(-5); % value of k_7off that best fits the data
K7 = k_7off/k_7on;
%assumed to be same as k3 because it represents the same physical binding

k_8off = k_3off; %---Units:(s)^{-1} same as k3off
k_8on = k_3off/(KEP/2);  %---Units:---(\nMs)^{-1}--- same as k3on
K8 = k_8off/k_8on;

p = [ k_1on, k_1off, k_2, k_3on, k_3off, k_4on, k_4off, k_5on, k_5off, k_6on, k_6off , k_7on, k_7off, k_8on, k_8off];


%---------------------------------%
%----Initial conditions-----------%
%---------------------------------%
S_0 = 170;
I_0 = 2.4;
%----------------------------------%
%--- Generating Sample using LHS---%
%----------------------------------%

%number of samples
SampleSize = 10;

%Storage Vector for all The product Curves
tVals = t_start:1:t_final;
POutputLHS = zeros(length(tVals),SampleSize);

%Generating Samples
par = 3; %number of parameters being sampled
X = lhsdesign(SampleSize,par, 'criterion','maximin','smooth','off');

%Renaming

 S_LHSSamples = X(:,1);
 E_LHSSamples = X(:,2);
 I_LHSSamples = X(:,3);

% using inverse CDF to get the random value.
r = 0.05;
minS = S_0-r*S_0;
maxS = S_0+r*S_0;
S_vec = unifinv(S_LHSSamples,minS,maxS);

minI = I_0-r*I_0;
maxI = I_0+r*I_0;
I_vec = unifinv(I_LHSSamples,minI,maxI);


%--------------------------------------
%-------Experiment Baugh fig (2A)----
%--------------------------------------

figure(1)
 for z = 1:length(TF_PCPS)
     E_0 = TF_PCPS(z);
     minE = E_0-r*E_0;
     maxE = E_0+r*E_0;
     E_vec = unifinv(E_LHSSamples,minE,maxE);

%compute sample outputs
    for j = 1:SampleSize
        %--------------------------%
        %--- Initial Conditions ---%
        %--------------------------%

        E_IC = E_vec(j); 
        S_IC = S_vec(j);
        ES_IC = 0; 
        EP_IC = 0; 
        P_IC = 0; 
        I_IC = I_vec(j);
        PI_IC = 0; 
        PIE_IC = 0; 
        EPI_IC = 0; 

        init_cond = [ E_IC, S_IC, ES_IC, EP_IC, P_IC, I_IC, PI_IC, PIE_IC, EPI_IC];


        options = odeset('RelTol',1e-12,'AbsTol',1e-23);


        %------------------------------ Main Solve ---------------------------------%
        [time,y] = ode15s(@(t,y)RHS(t,y,p), [t_start:1:t_final], init_cond, options);
        %---------------------------------------------------------------------------%

        % Rename solution components
        E = y(:,1); 
        S = y(:,2); 
        ES = y(:,3); 
        EP = y(:,4); 
        P = y(:,5); 
        I = y(:,6); 
        PI = y(:,7); 
        PIE = y(:,8); 
        EPI = y(:,9); 

        POutputLHS(:,j) = P;

    end
 
    %--------------
    %----Error-----
    %--------------


    %%%%%%%%%%%%%%%%%%%%%%%%
    % Solve for LHS Sample %
    %%%%%%%%%%%%%%%%%%%%%%%%

    %Note: There are different ways to select min/max
    %      Here we will select the top 90 and bottom 10 pct

    meanValLHS  = zeros(length(tVals),1);
    minCurveLHS = zeros(1,length(tVals));
    maxCurveLHS = zeros(1,length(tVals));
    stdDevLHS  = zeros(length(tVals),1);

    for iter = 1:length(tVals)
        meanValLHS(iter)  = mean(POutputLHS(iter,:));
        minCurveLHS(iter) = prctile(POutputLHS(iter,:),10);
        maxCurveLHS(iter) = prctile(POutputLHS(iter,:),90);
        stdDevLHS(iter)   = std(POutputLHS(iter,:));
    end

    %------------------
    %------Plotting-----
    %-------------------

    subplot(4,2,z)
    plo2 = plot(Time_data, Product_data(z,:),'o', 'MarkerSize',3); 
    plo2.Color = colorE(z,:);
    plo2.MarkerFaceColor = colorE(z,:);
    hold on
    % plotting max, min and mean of product curve
    plot(tVals,meanValLHS,'b--', 'LineWidth', 1.5)
    tVal2     = [tVals, fliplr(tVals)];
    inBetween = [minCurveLHS,fliplr(maxCurveLHS)];
    fill(tVal2, inBetween, [0.6 0.8 1.0],'FaceAlpha', 0.2);
    %legend('Extracted Data','mean','Range', 'location','best');
    title([num2str(minE) '\leq E \leq' num2str(maxE) ' nm'],'Fontsize',8);
    ylabel('Xa (nM)','FontSize',8)
    xlabel('Time(s)','FontSize',8)
    xlim([t_start,t_final]);
    hold on
end

sgtitle({['Product Concentration(Xa) vs time(t) with Preincubation for n = ' num2str(SampleSize) ' with 10 and 90 percentile'],...
    [num2str(minS) '\leq S \leq' num2str(maxS)],...
   [num2str(minI) '\leq I \leq' num2str(maxI)]}, 'Fontsize' ,10);

%-----------------------
%-----Experiment 3B-----
%-----------------------
%-------------------------%
%----- Preincubation -----%
%-------------------------%

POutputLHS_II = zeros(length(tVals),SampleSize);
[Time_data3B, Product_data3B] = realDataB();
colorVar = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 0 1] ];
 
%Preincubation step
Pvecs = [0 0.25 0.5 1];

E_0 = 128*10^(-3);
minE = E_0-r*E_0;
maxE = E_0+r*E_0;
E_vec = unifinv(E_LHSSamples,minE,maxE);

figure(2)
for i = 1:length(Pvecs)
for j = 1:SampleSize
E_IC = 0; 
S_IC = 0; 
ES_IC = 0; 
EP_IC = 0; 
P_IC = Pvecs(i); 
I_IC = I_vec(j);%I_0;
PI_IC = 0; 
PIE_IC = 0; 
EPI_IC = 0; 

%vector of initial conditions
init_cond = [ E_IC, S_IC, ES_IC, EP_IC, P_IC, I_IC, PI_IC, PIE_IC, EPI_IC];

%options = odeset('RelTol',1e-12,'AbsTol',1e-23);

[time,x] = ode15s(@(t,y)RHS(t,y,p), time, init_cond);

% Rename solution components
Pnew = x(end,5);
PInew = x(end,7); 
Inew = x(end,6);

%initial conditions
E_IC = E_vec(j); 
S_IC =  S_vec(j);
ES_IC = 0; 
EP_IC = 0; 
P_IC = Pnew; 
I_IC = Inew; 
PI_IC = PInew; 
PIE_IC = 0; 
EPI_IC = 0; 

%vector of initial conditions
init_cond = [ E_IC, S_IC, ES_IC, EP_IC, P_IC, I_IC, PI_IC, PIE_IC, EPI_IC];

%options = odeset('RelTol',1e-12,'AbsTol',1e-23);

[time,x] = ode15s(@(t,y)RHS(t,y,p), time, init_cond);

% Rename solution components
P = x(:,5);
POutputLHS_II(:,j) = P; 

end

%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for LHS Sample %
%%%%%%%%%%%%%%%%%%%%%%%%

%Note: There are different ways to select min/max
%      Here we will select the top 90 and bottom 10 pct

meanValLHS_II  = zeros(length(tVals),1);
minCurveLHS_II = zeros(1,length(tVals));
maxCurveLHS_II = zeros(1,length(tVals));
stdDevLHS_II  = zeros(length(tVals),1);

for iter = 1:length(tVals)
    meanValLHS_II(iter)  = mean(POutputLHS_II(iter,:));
    minCurveLHS_II(iter) = prctile(POutputLHS_II(iter,:),10);
    maxCurveLHS_II(iter) = prctile(POutputLHS_II(iter,:),90);
    stdDevLHS_II(iter)   = std(POutputLHS_II(iter,:));
end

subplot(4,1,i)
plo2 = plot(Time_data3B, Product_data3B(i,:),'o', 'MarkerSize',3); 
plo2.Color = colorVar(i,:);
plo2.MarkerFaceColor = colorVar(i,:);
hold on
% plotting max, min and mean of product curve
plot(tVals,meanValLHS_II,'b--', 'LineWidth', 1.5)
tVal2     = [tVals, fliplr(tVals)];
inBetween = [minCurveLHS_II,fliplr(maxCurveLHS_II)];
fill(tVal2, inBetween, [0.6 0.8 1.0],'FaceAlpha', 0.2);
%legend('Extracted Data','mean','Range', 'location','best');
title(['P = ' num2str(Pvecs(i)) 'nm'],'Fontsize',8);
ylabel('Xa (nM)','FontSize',8)
xlabel('Time(s)','FontSize',8)
xlim([t_start,t_final]);
hold on
end
sgtitle({['Product Concentration(Xa) vs time(t) with Preincubation for n = ' num2str(SampleSize) ' with 10 and 90 percentile'],...
    [num2str(minI) '\leq I \leq' num2str(maxI)]},'Fontsize',10);

% ...
%     [num2str(minI) '\leq I \leq' num2str(maxI)]}