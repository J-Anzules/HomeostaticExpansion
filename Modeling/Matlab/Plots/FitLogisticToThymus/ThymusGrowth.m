function dmdt= ThymusGrowth(t, x, p)

%Initial Growth
m = x;

K = p(1);
lambda = p(2);

%Equation

dmdt = lambda * m * (1 - m/K);





