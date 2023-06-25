% clc; clear variables; close all;
function Latex_table(x)

format long
p = x;

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

KM = 238;
% k_2 = 3.5;
% k_1on = 0.73065; 
% k_1off = k_1on*KM - k_2;
 K1 = k_1off/k_1on;
% 
 %K3 = 520;% KEP = k_off/k_on --- units:nM --- %Fixed Table II-step4- Lu et al 200
% k_3off =483.1722;% value of k_3on that best fits the data
% k_3on = k_3off/K3; %Units:(s)^{-1}---% by definition of KEP
K3 = k_3off/k_3on; 
% 
% k_4on = 0.9*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
% k_4off = 3.6*10^(-4); %Units:(s)^{-1} ----%---% Table II col 3 Baugh 1998
 K4 = k_4off/k_4on;
% 
% k_5on = 7.34*10^(-3);  %Units:---(\nMs)^{-1}---% Table II col 3 Baugh 1998
% k_5off =11*10^(-4) ;  %Units:(s)^{-1}---%% Table II col 3 Baugh 1998
K5 = k_5off/k_5on;
% 
% k_6on = k_4on; 
% k_6off = k_4off;
% 
% % k_6on = 0.00089933;%---Units:---(\nMs)^{-1}--- being sampled
% % k_6off = 0.00036; % ---Units:(s)^{-1}--- being sampled
  K6 = k_6off/k_6on;
% 
% k_7on = 627.3402;% value of k_7on that best fits the data
% k_7off = 0.001033; % value of k_7off that best fits the data
 K7 = k_7off/k_7on;
% 
% 
% % k_8on = k_3on ;  %---Units:---(\nMs)^{-1}--- same as k3on
% % k_8off = k_3off; %---Units:(s)^{-1} same as k3off 
% k_8off = 355.9992; % ---Units:(s)^{-1}--- being sampled
K8 = k_8off/k_8on; 
% k_8on = k_8off/K8;

%Storage vector for kinetic parameters
p = [ k_1on, k_1off, k_2, k_3on, k_3off, k_4on, k_4off, k_5on, k_5off, k_6on, k_6off , k_7on, k_7off, k_8on, k_8off]'

p_name = {'k1\_on', 'k1\_off', 'k\_cat', 'k3\_on', 'k3\_off', 'k4\_on', 'k4\_off', 'k5\_on','k5\_off',...
     'k6\_on', 'k6\_off', 'k7\_on', 'k7\_off', 'k8\_on', 'k8\_off'};
 VarNames = {'Value'};
 T = table(p(:),'RowNames',p_name,'VariableNames',VarNames)

 
FID = fopen('AimII_2w.tex', 'w');
fprintf(FID, '\\begin{tabular}{|r|r|}\\hline \n');
fprintf(FID, 'parameter & value \\\\ \\hline \n');
for k=1:length(p)
    fprintf(FID, '%s & %f \\\\ ', char(p_name(k)) ,p(k));
    %if k==length(p)
        fprintf(FID, '\\hline');
    %end
    fprintf(FID, '\n');
end

fprintf(FID, '\\end{tabular}\n');
fclose(FID);
 

pp = [KM, K1 ,K3, K4, K5, K6, K7, K8]';
pp_name = {'KM', 'K1', 'K3', 'K4', 'K5', 'K6', 'K7', 'K8'};
 VarNames = {'Value'};
 T = table(pp(:),'RowNames',pp_name,'VariableNames',VarNames)

FID = fopen('AimII_2Kw.tex', 'w');
fprintf(FID, '\\begin{tabular}{|r|r|}\\hline \n');
fprintf(FID, 'parameter & value \\\\ \\hline \n');
for k=1:length(pp)
    fprintf(FID, '%s & %f \\\\ ', char(pp_name(k)) ,pp(k));
%     if k==length(pp)
        fprintf(FID, '\\hline ');
%     end
     fprintf(FID, '\n');
end

fprintf(FID, '\\end{tabular}\n');
fclose(FID);
end