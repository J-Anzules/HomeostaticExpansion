%{
dTdt = [dNdt, dTdt, dRdt, ... %1, 2, 3,
    dThyNdt, dActNdt, dThyRdt, dDiffRdt, ... %4, 5, 6, 7
    dNproldt, dTproldt, dRproldt, ... %8, 9, 10
    dIdt, dmdt]'; %11, 12
%}

T = load('parameters.mat');
S = load('SimmyTest.mat');

%%

N = S.ModelData(200,1);
T = S.ModelData(200,2);
R = S.ModelData(200,3);

disp(N)
disp(T)
disp(R)

%%
%Checking out the individual Treg populations

ThyR = S.ModelData(200,6);
DiffR = S.ModelData(200,7);
Rprol = S.ModelData(200,10);

disp(ThyR)
disp(DiffR)
disp(Rprol)











