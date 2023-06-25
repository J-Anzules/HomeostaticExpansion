function Parameters = GetParameters(EntryNmbr, File)
%Pulls only the row given in EntryNmber. Further manipulation will occur in
%the future

ParameterData = readtable(File);
PrmtIndex = ParameterData.EntryNumber == EntryNmbr;
Parameters = ParameterData{PrmtIndex,:}; % {} - Returns an array somehow

