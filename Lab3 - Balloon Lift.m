clear; clc;

x = readtable("Lab 3 class data.xlsx");

%Volume in m^3
V = (x{1:height(x),2}.*(0.0254.^3)); 
%Balloon mass in kg
m_balloon = (x{1:height(x),3})./1000;
%Payload mass in kg
m_payload = (x{1:height(x),4})./1000;

avg_balloons = mean(m_balloon);

%Constants
%Pressure in N/m^2
p = 102600;
%Temperature in kelvin
t = 294.15;
%Gas constant for helium in (N*m)/(kg*k)
r_gas = 2077;
%Gas constant for air in (N*m)/(kg*k)
r_air = 287;
%gravity in m/s^2
g = 9.8;

%density of air in kg/m^3
d_air = p./(r_air.*t);
%density of gas in kg/m^3
d_gas = p./(r_gas.*t);

%Weight of air, gas, payload, and balloon, all in Newtons
w_air = d_air.*g.*V;
w_gas = d_gas.*g.*V;
w_payload = g.*m_payload;
w_balloon = g.*avg_balloons;

%Lift calculations in Newtons
theo_lift = w_air-w_gas-w_balloon;
measured_lift = w_payload;

%Percent Error
p_error = ((theo_lift-measured_lift)./theo_lift).*100;

sort_theo = sort(theo_lift);
sort_v = sort(V);

plot(sort_v, sort_theo, "-b")
hold on; grid on;
scatter(V, measured_lift, 36, 'filled')
title("Theoretical and Measured Lift vs Volume")
xlabel("Volume (m^3)")
ylabel("Lift (Newtons)")
legend("Theoretical", "Measured")

