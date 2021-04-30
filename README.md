# Engine-Tune
Fill in fuel table values not able to be tested on the Dyno

Use the input for the function to input the excel spreadsheet name to use it, have it in the same folder/workspace in matlab. 
Have excel spreadsheet in the following format:
  First row is just a label (RPM)
  Second row are the values for label (RPM)
  First column is label2 (Manifold Pressure)
  Second column are label2 (Manifold Pressure) values.
  Have values wanted to calculate be a repeat of the lowest manifold pressure value able to be tested on the dyno
  
Change the output filename to whatever you want to excel sheet to be named.

Note: 
  This is for finding the low manifold pressure values and only uses a highest of a second order polynomial.
    This is so that it does not over fit the line.
    It also uses first order if the second order polynomial used creates values that increase in value because this does not fit the needed trend of the fuel map
