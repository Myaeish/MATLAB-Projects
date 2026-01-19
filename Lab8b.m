clear; clc;

compAirfoilDataFive = readtable("airfoil8a 5.5 degrees.txt", "PreserveVariableNames", true);
cPCompDataFive = (compAirfoilDataFive{1:height(compAirfoilDataFive), 3});
xCompDataFive = (compAirfoilDataFive{:, 1});

cn0 = trapz(xCompDataFive, cPCompDataFive);
cl0 = cn0.*cosd(5);

cl = [cl0];
for i = 1:1:9
    cl(i + 1) = cl(1)./sqrt(1-((mod(i,10)./10).^2));
end

M = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];

%Different Mach Numbers at aoa of 5 degrees
compAirfoilData1 = readtable("airfoil 8a mach .1.txt", "PreserveVariableNames", true);
compAirfoilData2 = readtable("airfoil 8a mach .2.txt", "PreserveVariableNames", true);
compAirfoilData3 = readtable("airfoil 8a mach .3 5.5 degrees.txt", "PreserveVariableNames", true);
compAirfoilData4 = readtable("airfoil 8a mach .4.txt", "PreserveVariableNames", true);
compAirfoilData5 = readtable("airfoil 8a mach .5.txt", "PreserveVariableNames", true);
compAirfoilData6 = readtable("airfoil 8a mach .6.txt", "PreserveVariableNames", true);
compAirfoilData7 = readtable("airfoil 8a mach .7 4.5 degrees.txt", "PreserveVariableNames", true);

%Different mach numbers pressure coefficients
cPCompData1 = (compAirfoilData1{1:height(compAirfoilData1), 3});
cPCompData2 = (compAirfoilData2{1:height(compAirfoilData2), 3});
cPCompData3 = (compAirfoilData3{1:height(compAirfoilData3), 3});
cPCompData4 = (compAirfoilData4{1:height(compAirfoilData4), 3});
cPCompData5 = (compAirfoilData5{1:height(compAirfoilData5), 3});
cPCompData6 = (compAirfoilData6{1:height(compAirfoilData6), 3});
cPCompData7 = (compAirfoilData7{1:height(compAirfoilData7), 3});

%Computational X/C both upper and lower surface
xCompData1 = (compAirfoilData1{:, 1});
xCompData2 = (compAirfoilData2{:, 1});
xCompData3 = (compAirfoilData3{:, 1});
xCompData4 = (compAirfoilData4{:, 1});
xCompData5 = (compAirfoilData5{:, 1});
xCompData6 = (compAirfoilData6{:, 1});
xCompData7 = (compAirfoilData7{:, 1});

%Normal Coefficient Function
cn = @(XCompData, cPCompData) trapz(XCompData, cPCompData);
%Lift Coefficient Functions
clfunc = @(cn, theta) cn.*cosd(theta);

%Normal Coefficients for mach .1-.7
cndata0 = cn(xCompDataFive, cPCompDataFive);
cndata1 = cn(xCompData1, cPCompData1);
cndata2 = cn(xCompData2, cPCompData2);
cndata3 = cn(xCompData3, cPCompData3);
cndata4 = cn(xCompData4, cPCompData4);
cndata5 = cn(xCompData5, cPCompData5);
cndata6 = cn(xCompData6, cPCompData6);
cndata7 = cn(xCompData7, cPCompData7);

%Lift Coefficients for mach .1-.7
cldata0 = clfunc(cndata0, 5);
cldata1 = clfunc(cndata1, 5);
cldata2 = clfunc(cndata2, 5);
cldata3 = clfunc(cndata3, 5);
cldata4 = clfunc(cndata4, 5);
cldata5 = clfunc(cndata5, 5);
cldata6 = clfunc(cndata6, 5);
cldata7 = clfunc(cndata7, 5);

cl2 = [cldata0, cldata1, cldata2, cldata3, cldata4, cldata5, cldata6, cldata7];
M2 = [0 .1 .2 .3 .4 .5 .6 .7];

figure(1); hold on; grid on;
plot(M,cl, 'LineWidth',1.5)
xlabel("Mach Numbers")
ylabel("Lift Coefficients")
title("Lift Coefficients Versus Mach Number (Prandtl-Glauert)")

figure(2); hold on; grid on;
plot(M2,cl2, 'lineWidth', 1.5)
xlabel("Mach Numbers")
ylabel("Lift Coefficients")
title("Lift Coefficients Versus Mach Number (Computational)")