function dTdt = RHPlot_growth(t, x, p, i)

%Order of Parameters
% 1_alpha 2_Thy 3_Thy_max 4_epsilon 5_a 6_c 7_b_R 8_mu 9_beta 10_g 11_b_T 
% 12_d 13_e_T 14_e_R 15_f 16_kA 17_n 18_EntryNumber 19_Notes 20_Naive
% 21_Activated 22_Treg 23_IL2 24_PreviousPset

%Thymus Parameters
K = 0.074896;
lambda = 0.016932;


%Change parameters that will be fitted accordingly using the p parameter
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
Thy_max = K; %The maximum value

%Initial conditions
N = x(1);
T = x(2);
R = x(3);
I = x(4);
m = x(5);

%Thy = lambda * m * (1 - (m/K));

%Cell  
dNdt = mu*(m/Thy_max)-beta*N - c*N - g*N;
    
dTdt = beta*N + a*I*T - b_T*T;

dRdt = alpha*(m/Thy_max) + epsilon*I*R + c*N - b_R*R;

dIdt = d*T - e_T*I*T - e_R*I*R - f*I;

dmdt = lambda * m * (1 - (m/K));
%dmdt = Thy;
%The apostrophe returns a transposed matrix of [4 columns x n rows]
dTdt = [dNdt, dTdt, dRdt, dIdt, dmdt]';



