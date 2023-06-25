Genotype = 2;

ModelData = SimulateGrowth(pOpt, Genotype);
ModelData = array2table(ModelData);

ModelData.Properties.VariableNames = {'NaiveCT' 'ActivCT' 'TregCT' ...
    'ThyDerivedNaive' 'ActivNaive' 'ThyDerivedTregs' 'NaiveDerivedTregs' ...
    'ProlNaive' 'ProlActiv' 'ProlTregs' ...
    'Il2' 'ThyWeight'};
tx = 0:432; %Maximum amount of time - 18 days

animatedline(tx, ModelData.ActivCT)
%%
x = [1 2];
y = [1 2];
h = animatedline(x,y,'Color','r','LineWidth',3);

%%
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = '../Plots/testAnimated.gif';
for n = 1:0.5:5
    % Draw plot for y = x.^n
    x = 0:0.01:1;
    y = x.^n;
    plot(x,y) 
    drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
end
  
%%
close all; clc
EX =@(t,L,n0) n0*exp(L*t); % I(a;theta) = L*a
% LD =@(t,L,D) 5*exp(-D*t)+L/D; % I(a;theta) = L-D*a
% LG =@(t,L,K) K./(1+(K-1)*exp(-L*t)); % I(a;theta) = a*L*(1-a/K)
tf = 6;
t_vec = linspace(0,tf);
%%%%%%%%%%%%%%%%%%%%%%%% PLOT EXPONENTIAL GROWTH %%%%%%%%%%%%%%%%%%%%%%%%%%
N0 = [nan 1 3];
% figure('InvertHardcopy','on')
for n0 = 1:3
    if n0==2
        col = [9,47,68]/255;
    else
        col = [1,0,0];
    end
    h(n0) = plot(t_vec,EX(t_vec,0.5,N0(n0)),'LineWidth',2.5,'Color',col); hold on
    plot(0,EX(0,0.5,N0(n0)),'ko','MarkerFaceColor',col,...
                        'MarkerEdgeColor',.5*[1,1,1]);
    grid on
    set(gca,'TickLabelInterpreter','latex','FontSize',20)
    xlabel('Time (hrs)','Interpreter','latex','FontSize',22,'Color',0*[1,1,1]) 
    ylabel('Number of Aggregates','Interpreter','latex','FontSize',25,'Color',0*[1,1,1])
    set(gca,'XColor',0*[1,1,1]);set(gca,'YColor',0*[1,1,1])
    xticks(0:1:tf); xlim([0 tf])
    yticks(0:5:65); ylim([0 65])
    set(gcf, 'Position', [100, 100, 400, 500])
    grid on
    shg
    print(['LinearGrowthN0',num2str(n0),'.png'],'-dpng')
end
hold off

%%
% Script: Makes exponential growth model movie with 

% Parameters
Na    = 2*10^3; % Da = 0.01
K     = 700; dK = 100;
a_vec = linspace(0,K,Na); % Spatial grid in a with Da = 0.01
mu = 5; sig = 1; lam = 0.7; rho = 0.5; Tf = 6;
Yn =@(t,a,lam) exp(-lam*t)*normpdf(a.*exp(-lam*t),mu,sig);
a =@(t,lam,a0) a0*exp(lam*t);
A1 = 2; A2 = 8; 
h = figure;   
maxGen = 0;%floor(Tf*60/90);
filename = ['ExpGrowthAggModel','T0-T',num2str(Tf),'Lam',num2str(lam)];
filename(filename=='.')='p';
filename = [filename '.png'];
times_vec = [linspace(0,Tf,10^2) Tf*ones(1,50)];
maxY = 700;

for Tidx = 1:numel(times_vec)
    T = times_vec(Tidx);
    
   plot(times_vec(1:Tidx),a(times_vec(1:Tidx),lam,A1),'-','LineWidth',2.5,'Color',[1,0,0],...
                        'MarkerEdgeColor',.5*[1,1,1]); hold on
   plot(times_vec(1:Tidx),a(times_vec(1:Tidx),lam,A2),'-','LineWidth',2.5,'Color',[9,47,68]/255,...
                        'MarkerEdgeColor',.5*[1,1,1]);       
   H = plot(T,a(T,lam,A2),'ko','MarkerFaceColor',[9,47,68]/255,...
                        'MarkerEdgeColor',.5*[1,1,1]);
   H(2) = plot(T,a(T,lam,A1),'ko','MarkerFaceColor',[1,0,0],...
                        'MarkerEdgeColor',.5*[1,1,1]);
    grid on
    ylim([0 maxY])
    hold off
    ylabel('Number of Aggregates $(a)$','Interpreter','latex','FontSize',25)
    xlabel('Time (hrs)','Interpreter','latex','FontSize',20)
    leg = legend(H,{['$a(0)=',num2str(A1),'$'],['$a(0)=',num2str(A2),'$']});
    title(leg,'Initial Conditions')
    set(leg,'Interpreter','latex','FontSize',20,'Location','northwest','Orientation','vertical');
    set(gca,'FontSize',20,'TickLabelInterpreter','latex')
    set(gcf, 'Position', [100, 100, 435, 800])
    xticks(0:Tf); xticklabels(compose('%0.0f',(0:Tf)')'); 
    ytickformat('%0.0f'); % Add precision to y-ticks
    yticks(0:dK:K);
    xlim([0 6])
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    if Tidx == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        imwrite(imind,cm,[filename(1:end-3),'T_init.gif']);
    else 
        imwrite(imind,cm,filename,'gif','DelayTime',0.001,'WriteMode','append'); 
    end 
end