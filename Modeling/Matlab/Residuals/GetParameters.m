function Parameters = GetParameters(EntryNmbr)
%Gets parameter from the Parameters.csv file that is in the same folder as
%this function
%Pulls only the row given in EntryNmber. Further manipulation will occur in
%the future

%Order of Parameters
% 1_alpha 2_Thy 3_Thy_max 4_epsilon 5_a 6_c 7_b_R 8_mu 9_beta 10_g 11_b_T 
% 12_d 13_e_T 14_e_R 15_f 16_kA 17_n 18_EntryNumber 19_Notes 20_Naive
% 21_Activated 22_Treg 23_IL2 24_PreviousPset

ParameterData = readtable('../Data/ParameterRanges27.csv');
PrmtIndex = ParameterData.EntryNumber == EntryNmbr;
Parameters = ParameterData{PrmtIndex,:}; % {} - Returns an array somehow

