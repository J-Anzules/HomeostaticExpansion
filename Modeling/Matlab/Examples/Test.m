clc; clear variables; close all;

%--------------------------%
%--- Kinetic Parameters ---%
%--------------------------%

%-----Parameter definition-----
%k_2 = 3.5; % Units:(s^-1)--- %Fixed Table II- fig 1a- step3- Lu et al 2004
KM = 238;  % KM = (k_off+k_cat)/ k_on--- Units: nM--- %Fixed Table II step 2 - Lu et al 2004 
%-------Allowable Range of Parameters/Constaints------
k_2_min = 1;
k_2_max = 10;

k_2 = k_2_min+rand(1,1)*(k_2_max - k_2_min);

k_1on_min = k_2/KM;
k_1on_max = 1;

k_3off_min = 100;
k_3off_max =500;

k_7on_min = 100;
k_7on_max = 1000;

% k_7off_min = 0.0005;
% k_7off_max = 0.005;


%-------------------------------------------
%----- Optimization of k_1on and k_3on -----
%-------------------------------------------

%------------randomly picks an initial guess--------
k_1on = k_1on_min+rand(1,1)*(k_1on_max - k_1on_min);
k_3off = k_3off_min+rand(1,1)*(k_3off_max - k_3off_min);
k_7on = k_7on_min+rand(1,1)*(k_7on_max - k_7on_min);
% k_7off = k_7off_min+rand(1,1)*(k_7off_max - k_7off_min);



%------fmincon function arguments definitions-------
x0 = [k_1on; k_3off; k_7on; k_2]; %vector of initial guess parameters
lb = [k_1on_min, k_3off_min, k_7on_min, k_2_min]; %minimum values for each parameter
ub = [k_1on_max, k_3off_max, k_7on_max, k_2_max]; %maximum values for each parameter

A = [];
b = [];
Aeq = [];
beq = [];
%-----------------------------------------------------------
%------- This code enforces the constraints A*x0 <= b-------
%--------- This is the constraint part of fmincons ---------
%-----------------------------------------------------------
%sol = All_con_error_Proj_II_Exp_II(x)

fun = @(x)combined_expertiment_kcat(x); %function that computes error

[par_fit,error] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub); %computes error and gives vector of...
                  ...best fit param value to the data
                    
%----------------------------%
%---- kinetic parameters ----%
%----------------------------%

k_1on = par_fit(1); % value of k_1on that best fits the data
k_2 = par_fit(4);
k_1off = k_1on*KM - k_2; % (s)^{-1}

KEP = 520;% KEP = k_off/k_on --- units:nM --- %Fixed Table II-step4- Lu et al 200
k_3off = par_fit(2);% value of k_3on that best fits the data
k_3on = k_3off/KEP; %Units:(s)^{-1}---% by definition of KEP

k_4on = 0.9*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
k_4off = 3.6*10^(-4); %Units:(s)^{-1} ----%---% Table II col 3 Baugh 1998


k_5on = 7.34*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
k_5off =11*10^(-4) ;  %Units:(s)^{-1}---%% Table II col 3 Baugh 1998

k_6on = k_4on;  %---Units:---(\nMs)^{-1}--- being sampled
k_6off = k_4off; % ---Units:(s)^{-1}--- being sampled

k_7on = par_fit(3);% value of k_7on that best fits the data
k_7off = 0.001; % value of k_7off that best fits the data

%assumed to be same as k3 because it represents the same physical binding
k_8on = k_3on ;  %---Units:---(\nMs)^{-1}--- same as k3on
k_8off = k_3off; %---Units:(s)^{-1} same as k3off 
              
 
%Storage vector for kinetic parameters
p = [ k_1on, k_1off, k_2, k_3on, k_3off, k_4on, k_4off, k_5on, k_5off,...
    k_6on, k_6off , k_7on, k_7off, k_8on, k_8off];

%convert the table of parameters into Latex
% Latex_table(p) 

%-----------------------------
%---- Experiment Baugh 2A ----
%-----------------------------

[time, data2A] = realData();

colorE = [[1 0 0]; [0 1 0]; [0 0 1]; [0.2 0 0]; [1 0 1]; [0 1 1]; [1 0.5 0.5]; [0.2 0.5 0.5]];


model2A = zeros(size(data2A));

%-------------------------%
%-- Enzyme Conentration --%
%-------------------------%
 
% Different Enzyme concentration given in baugh 1998 fig 2A
TF_PCPS= 0.001.*[1024, 512, 384, 256, 192,128,64,32]; % converting pM to nM
TF_PCPS = sort(TF_PCPS);  

for i = 1:length(TF_PCPS)
E_IC = TF_PCPS(i); 
S_IC = 170; 
ES_IC = 0; 
EP_IC = 0; 
P_IC = 0; 
I_IC = 2.4; 
PI_IC = 0; 
PIE_IC = 0; 
EPI_IC = 0; 

%vector of initial conditions
init_cond = [ E_IC, S_IC, ES_IC, EP_IC, P_IC, I_IC, PI_IC, PIE_IC, EPI_IC];

%options = odeset('RelTol',1e-12,'AbsTol',1e-23);

[time,y] = ode15s(@(t,y)RHS(t,y,p), time, init_cond);

model2A(i,:) = y(:,5);

end
%  model2A(1:2,:) = 0.50*model2A(1:2,:); 
figure(1)
subplot(1,2,1)
for i = 1:length(TF_PCPS)
plot(time, model2A(i,:), 'color',colorE(i,:),'LineWidth', 1.5);
hold on
plo2 = plot(time, data2A(i,:),'o', 'MarkerSize',3);
plo2.Color = colorE(i, :);
plo2.MarkerFaceColor = colorE(i, :);
end  
ylabel('Product Concentration (nM)','FontSize',10)
xlabel('Time in Seconds (s)','FontSize',10)
title({['[Product concentration as time changes'],...
 ['for various enzyme concentration'],['Baugh 1998 fig 2a']},'Fontsize',8) 
 hold on    
 
%-----------------------------
%---- Experiment Baugh 3B ----
%----------------------------- 

[time, data] = realDataB();

colorVar = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 0 1] ];


model = zeros(size(data));

%-------------------------%
%----- Preincubation -----%
%-------------------------%
 
%Preincubation step
Pvecs = [0 0.25 0.5 1];

for i = 1:length(Pvecs)
E_IC = 0; 
S_IC = 0; 
ES_IC = 0; 
EP_IC = 0; 
P_IC = Pvecs(i); 
I_IC = 2.4; 
PI_IC = 0; 
PIE_IC = 0; 
EPI_IC = 0; 

%vector of initial conditions
init_cond = [ E_IC, S_IC, ES_IC, EP_IC, P_IC, I_IC, PI_IC, PIE_IC, EPI_IC];

%options = odeset('RelTol',1e-12,'AbsTol',1e-23);

[ttime,x] = ode15s(@(t,y)RHS(t,y,p), [1:120*60], init_cond);

% Rename solution components
Pnew = x(end,5);
PInew = x(end,7); 
Inew = x(end,6);

%initial conditions
E_IC = 128*10^(-3); 
S_IC = 170; 
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
model(i,:) = x(:,5);

end 
%model(1,:) = (0.75)*model(1,:);
%figure(2)
subplot(1,2,2)
for i = 1:length(Pvecs)
plot(time, model(i,:), 'color',colorVar(i,:),'LineWidth', 1.5);
hold on
plo2 = plot(time, data(i,:),'o', 'MarkerSize',3);
plo2.Color = colorVar(i, :);
plo2.MarkerFaceColor = colorVar(i, :);
end
ylabel('Product Concentration (nM)','FontSize',10)
xlabel('Time in Seconds (s)','FontSize',10)
title({['Product concentration as time changes'],['with preincubation of product'],['Baugh 1998 fig 3B']},'Fontsize',8)
sgtitle({['Error = ' num2str(error)],...
    ['k_{1}^{on} = ' num2str(k_1on), '  [' num2str(k_1on_min) ',' num2str(k_1on_max)...
    '] and k_3^{off} = ' num2str(k_3off) '  [' num2str(k_3off_min) ',' num2str(k_3off_max) ']' ]...
    ['k_{7}^{on} = ' num2str(k_7on),'  [' num2str(k_7on_min) ',' num2str(k_7on_max)...
    '] and k_2 = ' num2str(k_2) '  [' num2str(k_2_min) ',' num2str(k_2_max) ']']},'Fontsize',11)
hold off

%-----------------------------------------------------%
%-------------------- RHS Function -------------------%
%-----------------------------------------------------%



function dy = RHS(t,y,p)

dy = zeros(9,1);


% Rename Variables 

E   = y(1); 
S   = y(2); 
ES   = y(3); 
EP   = y(4); 
P   = y(5); 
I   = y(6); 
PI   = y(7); 
PIE   = y(8); 
EPI   = y(9); 


% Rename Kinetic Parameters 
k_1on = p(1);  
k_1off = p(2);  
k_2 = p(3);  
k_3on = p(4);  
k_3off = p(5);  
k_4on = p(6);  
k_4off = p(7);  
k_5on = p(8);  
k_5off = p(9);  
k_6on = p(10);  
k_6off = p(11);  
k_7on = p(12);  
k_7off = p(13);  
k_8on = p(14);  
k_8off = p(15);  


%------------------------------------%
%--- ODEs from reaction equations ---%
%------------------------------------%

% E
 dy(1)  =  -  k_1on * E * S  +  k_1off * ES  -  k_3on * E * P  +  k_3off * EP  -  k_5on * E * PI  +  k_5off * PIE  -  k_8on * E * PI  +  k_8off * EPI;

% S
 dy(2)  =  -  k_1on * E * S  +  k_1off * ES;

% ES
 dy(3)  =  +  k_1on * E * S  -  k_1off * ES  -  k_2 * ES;

% EP
 dy(4)  =  +  k_2 * ES  +  k_3on * E * P  -  k_3off * EP  -  k_6on * EP * I  +  k_6off * EPI;

% P
 dy(5)  =  -  k_3on * E * P  +  k_3off * EP  -  k_4on * P * I  +  k_4off * PI;

% I
 dy(6)  =  -  k_4on * P * I  +  k_4off * PI  -  k_6on * EP * I  +  k_6off * EPI;

% PI
 dy(7)  =  +  k_4on * P * I  -  k_4off * PI  -  k_5on * E * PI  +  k_5off * PIE  -  k_8on * E * PI  +  k_8off * EPI;

% PIE
 dy(8)  =  +  k_5on * E * PI  -  k_5off * PIE  +  k_7on * EPI  -  k_7off * PIE;

% EPI
 dy(9)  =  +  k_6on * EP * I  -  k_6off * EPI  -  k_7on * EPI  +  k_7off * PIE  +  k_8on * E * PI  -  k_8off * EPI;

end
