function StatsOfCells = CalculateTheFillRanges(CellularData, tx)
%{
Defining the Numbers in the multidimensional dataframe
StatsOfCells(A,B,C,D)
StasOfCells(rows,Columns,pages,books)
(A) - 432 rows, each row represents an hour

(B) - 6 - Each column represents a statistic for that hour
    1 - mean
    2 - Standard deviation
    3 - +1 standard deviation
    4 - -1 standard deviation (if less than 0, then 0)
    5 - Lowest 10 percentile
    6 - Highest 90 percentile

(C) - Each page is a different cellular population
    1 - Total Naive T Cells
    2 - Total Activated T Cells
    3 - Total Tregs
    4 - Thymic Naive T Cells
    5 - Naive Derived Activated T Cells
    6 - Thymic Tregs
    7 - Naive Derived Tregs
    8 - Proliferating Naive T Cells
    9 - Proliferating Activated T Cells
    10 - Proliferating Tregs
    11 - IL-2 Cytokine

(D) - Genotypes 'books'

%}


Genotype = [1, 2]; %WT = 1, KO = 2
Pages = 1:11; %Each number is defined above
%rows = 1:433; %432 hours in the simulation

StatsOfCells = zeros(length(tx), 6, 11, 2);

%{
Defining the Numbers
6 stats per cellular population
11 Cellular populations
2  Two Genotypes
%}




for gene = Genotype
    for pg = Pages
        for row = tx
            % (1) - Means
            StatsOfCells(row,1,pg,gene) = mean(CellularData(row, : , pg, gene));
            
            % (2) - Standard Deviation
            StatsOfCells(row,2,pg,gene) = std(CellularData(row, : , pg, gene));
            
            % (3) +1 Standard Deviation
            StatsOfCells(row,3,pg,gene) = StatsOfCells(row,1,pg,gene) + StatsOfCells(row,2,pg,gene);
            
            % (4) -1 Standard Deviation
            StatsOfCells(row,4,pg,gene) = StatsOfCells(row,1,pg,gene) - StatsOfCells(row,2,pg,gene);
            
            if StatsOfCells(row,4,pg,gene) < 0 
                %So that we have no negative values
                StatsOfCells(row,4,pg,gene) = 0;
            end
            
            % (5) -Lowest 10 percentile
            StatsOfCells(row,5,pg,gene) = prctile(CellularData(row, : , pg, gene), 10);
            
            % (6) - Highest 90 percentile
            StatsOfCells(row,6,pg,gene) = prctile(CellularData(row, : , pg, gene), 90);
        end
    end
end