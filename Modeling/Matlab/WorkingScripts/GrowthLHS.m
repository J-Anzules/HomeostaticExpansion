function dTdt = GrowthLHS(t, x, p, i, Genotype)
%global alpha epsilon a c b_R mu beta g b_T d e_T e_R f kA n

alpha   = p(1);
a       = p(2);
%kA      = p(3);
e_T     = p(4);
e_R     = p(5);
g        = p(6);
b_T     = p(7);
%b_R     = p(8);
epsilon = p(9);
mu = p(10);
beta = p(11);
c = p(12);
kB = p(13);
%j = p(14);
z = p(15);
n = p(16);
% d = p(17);

if Genotype == 1
    d = p(17);
    kA      = p(3);
    j = p(14);
    b_R     = p(8);
elseif Genotype == 2
    d = p(22);
    kA = p(23);
    j = p(24);
    b_R     = p(25);
    
end

nK = p(18);
rK = p(19);
Ki = p(20);
Kj = p(21);


n1 = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------Fixed Parameters-------%
% These should never be changed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = 1.38629; %IL-2 degradation Rate

%Initial conditions
N = x(1); %Naive T Cells
T = x(2); %Activated T Cells
R = x(3); %Regulatory T Cells

ThyN = x(4); %Thymic Dervied Naive
ActN =  x(5);  % Activated Naive T Cells
ThyR = x(6); % Thymic Derived Tregs
DiffR = x(7); % Naive Derived Tregs

Nprol = x(8); % Self replicating naive T cells
Tprol = x(9); % Self replicating activated T cells
Rprol = x(10); % Self replicating Tregs

I = x(11); %IL-2 Cytokine
m = x(12); %Mass of Thymus


%Thymus Parameters
K = 0.074896;
lambda = 0.016932;

% Naive and sub populations  
dNdt = (mu*N*(1-(N/nK))) - beta*N*(1/(1+((R*(I/(Ki+I)))/kA)^n)) + z*N - c*N - g*N;
dNproldt = z*N - beta*Nprol*(1/(1+((R*(I/(Ki+I)))/kA)^n)) - c*Nprol - g*Nprol ; %Self replicating naive T cells
dThyNdt = (mu*N*(1-(N/nK))) - beta*ThyN*(1/(1+((R*(I/(Ki+I)))/kA)^n)) - c*ThyN- g*ThyN; %Thymic derived naive T cells

% Activated T Cells and sub populations
dTdt = beta*N*(1/(1+((R*(I/(Ki+I)))/kA)^n)) + a*T - j*R*T*(I/(Kj+I)) - b_T*T;
dActNdt = beta*N*(1/(1+((R*(I/(Ki+I)))/kA)^n)) - j*R*ActN*(I/(Kj+I)) - b_T*ActN; %Activated Naive T cells
dTproldt = a*T - j*R*Tprol*(I/(Kj+I)) - b_T*Tprol; %Self replicating activated T cells

% Treg and Treg sub-populations
dRdt = (alpha*R*(1-(R/rK))) + epsilon*R + c*N - b_R*R*(1/(1+(I/kB)^n1));
dThyRdt = (alpha*R*(1-(R/rK))) - b_R*ThyR*(1/(1+(I/kB)^n1)); %Thymic Dervied Tregs
dRproldt = epsilon*R - b_R*Rprol*(1/(1+(I/kB)^n1)); %Self Replicating Tregs
dDiffRdt = c*N - b_R*DiffR*(1/(1+(I/kB)^n1)); %Naive Derived Tregs

% IL-2
dIdt = d*T - e_T*I*T - e_R*I*R - f*I;
% Thymic Mass
dmdt = lambda * m * (1 - (m/K));


%The apostrophe returns a transposed matrix of [4x1]
%dTdt = [dNdt, dTdt, dRdt, dThyRdt, dRplRdt, dDiffRdt, dIdt, dmdt]';
dTdt = [dNdt, dTdt, dRdt, ... %1, 2, 3,
    dThyNdt, dActNdt, dThyRdt, dDiffRdt, ... %4, 5, 6, 7
    dNproldt, dTproldt, dRproldt, ... %8, 9, 10
    dIdt, dmdt]'; %11, 12



