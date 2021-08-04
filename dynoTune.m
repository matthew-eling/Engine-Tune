%%Instructions%%

%Dyno function to take in the fuel table that was tuned and gain general
%values for the rest of the table that was not able to be reached by the
%dyno.

%INPUTS: the excel filename with the data from the dyno

%OUTPUTS: excel filename with the adjusted fuel table. Has the tuned data
%and the estimated data.

%create excel sheet where first row of it is label RPM, first column is
%label for Manifold Pressure, second row is RPM values, second column is
%Manifold Pressure values. The rest inside are the fuel table values from the
%dyno. For all values not able to be found, replace
%with the same value as the last possible value you were able to find.
%Example column: 70 63 58 56 55 54 54 54 54 54
%The first 54 was tested and found and the others put in as a placeholder

%The first data point for the fuel table should start at B3 in the excel
%document.
function[fileName] = dynoTune(filename)
    cellArray = readcell(filename);
    [r, c] = size(cellArray);
    valuesArray = cellArray(3:r, 2:c);
    manifoldP = cellArray(3:r, 1);
    adjustedValues = [];
    for x = 1:c-1
        for y = 2:r
            if valuesArray{y-1, x} == valuesArray{y, x}
                repeatLocation = y;
                break
            end
        end
        actualValues = valuesArray(1:repeatLocation-1, x);
        manifoldUse = cell2mat(manifoldP(1:repeatLocation-1));
        manifoldRepeat = cell2mat(manifoldP(repeatLocation:(length(valuesArray(:,x)))));
        actualValues = cell2mat(actualValues);
        [coefficients, ~] = polyfit(manifoldUse, actualValues, 1);
        [coefficients2nd, ~] = polyfit(manifoldUse, actualValues, 2);
        fullTable = [actualValues];
        calculated = polyval(coefficients, manifoldRepeat);
        calculated2nd = polyval(coefficients2nd, manifoldRepeat);
        newY = polyval(coefficients, manifoldUse);
        average = mean(actualValues);
        rValue = 1 - ((sum((actualValues-newY).^2))./(sum((actualValues-average).^2)));
        newY2nd = polyval(coefficients2nd, manifoldUse);
        rValue2nd = 1 - ((sum((actualValues-newY2nd).^2))./(sum((actualValues-average).^2)));
        if rValue2nd >= rValue && calculated2nd(end) < calculated2nd(end-1)
            calculatedValues = calculated2nd;
        else
            calculatedValues = calculated;
        end
        fullTable = [fullTable; calculatedValues];
        adjustedValues = [adjustedValues fullTable];
    end
%change (outputFilename) to whatever you want the excel sheet to read
    fileName = '(outputFileName).xlsm';
    adjustedValueCell = num2cell(adjustedValues);
    header = cellArray(2,:);
    sidePiece = cellArray(3:r,1);
    adjustedValueCell = [sidePiece adjustedValueCell];
    adjustedValueCell = [header; adjustedValueCell];
    writecell(adjustedValueCell, fileName);  
    fclose('all');
end
