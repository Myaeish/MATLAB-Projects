clear; clc;

%Read in airfoil data
airfoilcoords = readmatrix("NACA 0015.dat");

%Extract x and y coordinates
dataX = airfoilcoords(:,1);
dataY = airfoilcoords(:,2);

% Airfoil Plot
figure(1); hold on; grid on;
plot(dataX,dataY, 'LineWidth',1)
ylabel('y','FontSize',12)
xlabel('x','FontSize',12)
title('Airfoil: NACA 0015');
axis equal;

%Import airfoil data into a table
airfoilData = readtable("Airfoil_Data.xlsx", "PreserveVariableNames", true);
amb_temp = ((64-32).*(5/9))+273.15; %Ambient temperature in K
amb_density = 1.15; %Ambient Density in kg/m^3
velocity = 12; %Velocity in m/s

%Computational Data
compAirfoilDataZero = readtable("0 Degrees LAB 7.txt", "PreserveVariableNames", true);
compAirfoilDataFive = readtable("5 Degrees LAB 7.txt", "PreserveVariableNames", true);

%Theoretical Data
theoAirfoilData = readtable("Lab 7 Theoretical Cp Data.xlsx", "PreserveVariableNames", true);

%Create pressure arrays in mm Hg for Experimental Data
aFPressZero = (airfoilData{1:height(airfoilData), 3}); %Zero Degrees
aFPressFive = (airfoilData{1:height(airfoilData), 4}); %Five Degrees
aFPressTen = (airfoilData{1:height(airfoilData), 5}); %Ten Degrees
aFPressFifteen = (airfoilData{1:height(airfoilData), 6}); %Fifteen Degrees

%Experimental X/C
expXCt = (airfoilData{1:21,1}); %Upper Surface
expXC = (airfoilData{:,1}); %All

%Experimental Dynamic Pressure Values 
qZero = 0.621607;
qFive = 0.631065;
qTen = 0.625189;
qFifteen = 0.629732;

%Experimental Pressure Coefficient for each measure pressure
cP = @(p, q) (p./q);
cPZero = cP(aFPressZero, qZero);
cPFive = cP(aFPressFive, qFive);
cPTen = cP(aFPressTen, qTen);
cPFifteen = cP(aFPressFifteen, qFifteen);

%Computational pressure coefficients
cPCompDataZero = (compAirfoilDataZero{1:height(compAirfoilDataZero), 3});
cPCompDataFive = (compAirfoilDataFive{1:height(compAirfoilDataFive), 3});

%Computational Upper Surface X/C
xCompDataZero = (compAirfoilDataZero{1:50, 1});
xCompDataFivet = (compAirfoilDataZero{1:50, 1});

%Computational X/C both upper and lower surface
xCompDataFive = (compAirfoilDataZero{:, 1});

%Theoretical Data
theoCP = (theoAirfoilData{:,4}); %Theoretical Pressure Coefficient
theoXC = (theoAirfoilData{:,2}); %Theoretical X/c

%Pressure Coefficient Plot Zero Degrees STEP 5
figure(2)
plot(expXCt, cPZero(1:21), 'LineWidth',1)
hold on;
plot(xCompDataZero,cPCompDataZero(1:50), 'LineWidth',1)
hold on;
plot(theoXC, theoCP, 'LineWidth',1)
title("Upper Surface Pressure Coefficient for NACA 0015")
xlabel("x/c")
ylabel("Pressure Coefficient")
legend("Experimental", "Computational", "Theoretical")
grid on;

%Pressure Coefficient Plot Five Degrees STEP 6
figure(3)
plot(xCompDataFive, cPCompDataFive, 'LineWidth',1)
hold on;
plot(expXC, cPFive, 'LineWidth',1)
title("Upper and Lower Surface Pressure Coefficient for NACA 0015")
xlabel("x/c")
ylabel("Pressure Coefficient")
grid on;
legend("Computational", "Experimental")

aoa = [0,5,10,15]; %Angle of Attack Array

CN0 = trapz(expXC(1:39), cPZero(1:39));
CN5 = trapz(expXC(1:39), cPFive(1:39));
CN10 = trapz(expXC(1:39), cPTen(1:39));
CN15 = trapz(expXC(1:39), cPFifteen(1:39));

cl0 = CN0.*cosd(0);
cl5 = CN5.*cosd(5);
cl10 = CN10.*cosd(10);
cl15 = CN15.*cosd(15);

expCl = [cl0, cl5, cl10,cl15]; %Experimental lift coefficient

cd0 = CN0.*sind(0);
cd5 = CN5.*sind(5);
cd10 = CN10.*sind(10);
cd15 = CN15.*sind(15);

expCd = [cd0, cd5, cd10,cd15]; %Experimental Drag coefficient

%Compuational Parameter for low reynolds number
compPolars1 = readtable("Polars LAB 7.txt", "PreserveVariableNames", true);
aoaComp1 = (compPolars1{:,1}); %Angle of Attack
cLComp1 = (compPolars1{:,2}); %Lift Coefficient
cDComp1 = (compPolars1{:,3}); %Drag Coefficient
cDpComp1 = (compPolars1{:,4}); %Profile Drag Coefficient

CDcomp1 = cDComp1 + cDpComp1; %Total Drag

slope_comp = cLComp1(11)/aoaComp1(11)
slope = expCl(2)/aoa(2)

%Plot STEP 8
figure(4)
plot(aoa, expCl, 'LineWidth',1)
hold on;
plot(aoaComp1, cLComp1, 'LineWidth',1)
grid on;
title("Lift Coefficient vs Angle of Attack")
xlabel("Angle of Attack")
ylabel("Lift Coefficent")
legend("Experimental", "Computational")

figure(5)
plot(expCd, expCl,'LineWidth',1)
hold on;
plot(CDcomp1, cLComp1,'LineWidth',1)
grid on;
title("Lift Coefficient vs Drag Coefficient")
xlabel("Drag Coefficent")
ylabel("Lift Coefficent")
legend("Experimental", "Computational")

%Computational Parameters for 32000000 Reynolds Number
compPolars2 = readtable("3200000 POLARS LAB 7.txt", "PreserveVariableNames", true);
aoaComp2 = (compPolars2{:,1}); %Angle of Attack
cLComp2 = (compPolars2{:,2}); %Lift Coefficient
cDComp2 = (compPolars2{:,3}); %Drag Coefficient
cDpComp2 = (compPolars2{:,4}); %Profile Drag Coefficient

CDcomp2 = cDComp2 + cDpComp2; %Total Drag

%Historical Data
histAoA = [0,2,4,6,8,10,12,14,16,18,20,22,24,26]; %Angle of Attack in Degrees
histcL = [0,.14,.3,.44,.6,.75,.9,1.03,1.18,1.3,1.41,1.51,1.21,1.1];
histcD = [.01,0.012,.018,.02,.031,.04,.059,.077,.095,.115,.14,.17,.256,.328];

%Plot STEP 9
figure(6)
plot(aoaComp2, cLComp2, 'LineWidth',1)
hold on;
plot(histAoA, histcL, 'LineWidth',1)
grid on;
title("Lift Coefficient vs Angle of Attack")
xlabel("Angle of Attack")
ylabel("Lift Coefficent")
legend("Computational", "Historical")

figure(7)
plot(CDcomp2, cLComp2, 'LineWidth',1)
hold on;
plot(histcD, histcL, 'LineWidth',1)
grid on;
title("Lift Coefficient vs Drag Coefficient")
xlabel("Drag Coefficent")
ylabel("Lift Coefficent")
legend("Computational", "Historical")

writetable(compAirfoilDataZero, "Computation Airfoil Data (Zero Degrees).xlsx")
writetable(compAirfoilDataFive, "Computation Airfoil Data (Five Degrees).xlsx")
writetable(compPolars1, "Computational Polars Expiremental Reynolds Number.xlsx")
writetable(compPolars2, "Computational Polars 3200000 Reynolds Number.xlsx")
writematrix(airfoilcoords, "Airfoil Coordinates.xlsx")
