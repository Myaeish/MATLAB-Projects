clear; clc;

amp = [.39, .51, 1.81, 2.79, 3.24]; %MilliAmpere
velocity = [60, 75, 90, 105, 120]; %Volts
water_mano = [1.138, 1.189, 1.150, 1.842, 1.990]; %inH2O

water_mano_zero = 1.040; %inH2O
p_amb = 1009.*100; %Ambient Pressure in N/m^2
t_amb = ((5/9).*(81-32)) + 273.15; %Ambient temperature in Kelvin

a = sqrt(t_amb .* 1.4 .* 287); %Air speed in m/s
rho_h2o = (1./1000).*(100).^3; % density of water in kg/m^3
h = ((water_mano-water_mano_zero)./12).*.3048; %meters
g = 9.81; %m/s^2
rho_air = p_amb./(t_amb.*287); %kg/m^3

dp_wm = rho_h2o.*h.*g; %Dynamic pressure from manometer N/m^2
dp_cpt = amp.*(1250./16); %Dynamic pressure from commercial pressure transducer N/m^2

v_wm = sqrt((2.*dp_wm)./rho_air); %Velocity from manometer m/s
v_cpt = sqrt((2.*dp_cpt)./rho_air);% Velocity from commercial pressure transducer m/s

M_wm = v_wm./a; %Mach number of manometer
M_cpt = v_cpt./a; %Mach number of commercial pressure transducer

percent_error = ((dp_wm - dp_cpt) ./ dp_cpt).*100; %Percent Error 

V_all   = [v_wm(:); v_cpt(:)];
V_min   = max(0, min(V_all) - 2);
V_max   = max(V_all) + 2;
theo_v  = linspace(V_min, V_max, 200).'; %Smooth x for the line
theo_p  = 0.5 * rho_air * (theo_v.^2); %Theoretical dynamic pressure

var_names = {'Dynamic Pressure of Manometer (N/m^2)', ...
    'Dynamic Pressure of Commercial Pressure Transducer (N/m^2)', ...
    'Velocity of Manometer (m/s)', ...
    'Velocity of Commercial Pressure Transducer (m/s)', ...
    'Mach Number of Manometer', ...
    'Mach Number of Commercial Pressure Transducer', ...
    'Percent Error (%)'};
results = table(dp_wm',dp_cpt',v_wm',v_cpt',M_wm',M_cpt',percent_error', 'VariableNames', var_names)

plot(v_cpt, dp_cpt, 'o', v_wm,dp_wm, 's', theo_v,theo_p, '-k')
grid on;
title('Dynamic Pressure vs Velocity')
legend('Commercial Pressure Transducer','Manometer','Theoretical')
xlabel('Velocity (m/s)')
ylabel('Dynamic Pressure (N/m^2)')
