function ModelData = SimulateThymus(p)
%p comes from p0 (located in the main script)
global MaxTime

ModelData = zeros(length(MaxTime), 0); %Empty df for future data

%{
Note: Every row will be that hours entry
i.e. ModelData(40, 1) = hours data of column one
for hour 40

DECIDE LATER: Because matlab starts counting at 1 for row entries
it seems that hour match will be off by one hour. I don't know if this is a
bid deal.

So, ModelData(40, 1) 
%}

%Initial Conditions
m = 0.0023; %The average of the Thymus weight at age 0
T0 = m; %This value will change everytime in the Simulation

ModelData(1,1) = m; %First entry, hour 0. 

disp('Simulating...')

for i = 1:length(MaxTime)-1 %Simulation will not run for the last hour
    %Only for the time step of second to last to last hour
    %disp(['Starting T0: ' num2str(T0)])
    %disp(['Current i:' num2str(i)])
    %disp('Current Time Step:')
    
    ts = [MaxTime(i), MaxTime(i+1)];
    sol = ode15s(@(t,x)ThymusGrowth(t,x,p),ts,T0);
    T0 = sol.y(1,end); %Only saves the last value of the ts
    ModelData(i+1) = T0; %Saves entry for the next time slot
    %disp(['Ending T0' num2str(T0)])
end



