function PlotAvg(data)
CellData = readtable('../../RawData/ActivatedWTSpleen.csv');

CellData = CellData(:,{'NaiveCT', 'ActivatedCD4CT', 'X4TregCT', ...
    'ThymicNaive', 'ActivatedNaiveCT', ...
    'ThymicDerivedTregsCT', 'NaiveDerivedTregsCT' ... 
    'hours'});

DataHours = unique(CellData.hours);

for hours = DataHours
    
end
