clear;clc;

BE50 = readtable("BE50_LFT.xls");
E387A = readtable("E387A_LFT.xls");
D = 0.0023769;
V_BE50 = 160;
V_E387A = 100;
WA = 2;

BE50_rows = 7:height(BE50);
E387A_rows = 7:height(E387A);

liftCoef = @(l, dens, veloc, wingA) (2.*l)./(dens.*(veloc).^2.*wingA);

lift_BE50 = BE50{BE50_rows, "Var2"};
lift_E387A = E387A{E387A_rows, "Var2"};

angle_BE50 = BE50{BE50_rows, "Var1"}; 
angle_E387A = E387A{E387A_rows, "Var1"}; 

BE50_liftCoef = liftCoef(lift_BE50,D,V_BE50,WA);
E387A_liftCoef = liftCoef(lift_E387A,D,V_E387A,WA);

plot(angle_BE50,BE50_liftCoef,"r--s",angle_E387A,E387A_liftCoef,"b-o")
title("Lift Coefficient vs Angle of Attack")
xlabel("Angle of Attack (Degrees)")
ylabel("Lift Coefficient")
legend("BE50", "E387A")
grid on;

%At an angle of attack of 5 degrees the lift will be greater for the
%E387A because it has a higher lift coefficient 
