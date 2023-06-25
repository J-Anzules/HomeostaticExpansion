function dTdt = Plot_growth(t, x, p, i)

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
kB      = p(16);

%Initial conditions
N = x(1);
T = x(2);
R = x(3);
I = x(4);
m = x(5);

%Thymus Parameters
K = 0.074896;
lambda = 0.016932;

%Cell  
dNdt = mu*(m/K)-beta*N*(1/(1+(R/kA)^n)) - c*N - g*N;
    
dTdt = beta*N*(1/(1+(R/kA)^n)) + a*T - b_T*T;

dRdt = alpha*(m/K) + epsilon*R + c*N - b_R*R*(1/(1+(I/kB)^n));

dIdt = d*T - e_T*I*T - e_R*I*R - f*I;

dmdt = lambda * m * (1 - (m/K));

%The apostrophe returns a transposed matrix of [4 columns x n rows]
dTdt = [dNdt, dTdt, dRdt, dIdt, dmdt]';



