clear; clc;

x = readtable("Lab 6 Data.xlsx", "PreserveVariableNames", true);

%Dynamic pressure from commercial pressure transducer N/m^2
q = (x{1:height(x),4} .* (1250./16)); 
%Angle for smooth sphere in degrees
B_s = (x{1:height(x),2});
%Angle for dimpled sphere in degrees
B_d = (x{1:height(x),3});
%Voltage in volts
Volt = (x{1:height(x),1});
%Diameters in m
d_s = (1.6./12).*0.3048; %smooth
d_d = (1.5./12).*0.3048; %dimpled
%Areas in m^2
a_s = pi.*((d_s./2).^2); %smooth
a_d = pi.*((d_d./2).^2); %dimpled
%Weights in N
w_s = 47./1000.*9.81; %smooth
w_d = 47./1000.*9.81; %dimpled
%Ambient conditions
p_amb = 1012.*100; %Ambient Pressure in N/m^2
t_amb = (5/9.*(81-32)) + 273.15; %Ambient temperature in k
R = 287; %Gas constant in N-m/kg-K
rho_amb = p_amb./(t_amb.*R); %Ambient density in kg/m^3
visc = 1.458.*((t_amb.^1.5)./(t_amb+110.4)).*(10.^-6); %Dynamic viscocity in kg/m-s

%Velocity in m/s
v = sqrt((2.*q)./rho_amb);
%Drag coefficient
cd_s = (w_s.*tand(B_s))./(.5.*rho_amb.*(v.^2).*a_s); %smooth
cd_d = (w_d.*tand(B_d))./(.5.*rho_amb.*(v.^2).*a_d); %dimpled
%Drag
drag_s = .5.*rho_amb.*a_s.*(v.^2).*cd_s; %smooth
drag_d = .5.*rho_amb.*a_d.*(v.^2).*cd_d; %dimpled
%Reynolds number
re_s = (rho_amb.*v.*d_s)./visc; %smooth
re_d = (rho_amb.*v.*d_d)./visc; %dimpled

var_names = {'Velocity (m/s)', ...
    'Smooth Sphere Drag (N)', ...
    'Dimpled Sphere Drag (N)', ...
    'Smooth Reynolds Number', ...
    'Dimpled Reynolds Number'};
results = table(v,drag_s,drag_d,re_s,re_d,'VariableNames', var_names)

figure(1)
hold on
scatter(v, drag_s, 36, 'o', 'filled')
scatter(v, drag_d, 36, '^', 'filled')
title('Drag Versus Velocity')
xlabel('Velocity (m/s)')
ylabel('Drag (N)')
legend('Smooth','Dimpled')
grid on;

figure(2)
hold on
scatter(re_s, cd_s, 36, 'o', 'filled')
scatter(re_d, cd_d, 36, '^', 'filled')
title('Drag Coefficient Versus Reynolds Number ')
xlabel('Reynolds Number')
ylabel('Drag Coefficient')
legend('Smooth','Dimpled')
grid on;

writetable(results, 'Lab 6 Calculations.xlsx');