clear; clc;

%Constants
amb_p = (29.26./29.92).*101325; %Ambient Pressure in N/m^2
amb_t = ((5/9).*(71-32)) + 273.15; %Ambient temperature in kelvin
g0 = 9.81; %Gravity
a1 = -6.5*10^-3;
R1 = 287; %Nm/kgK

%AD4GN-11 constants
d11 = (48./12).*.3048; %initial diameter in meters
b11_weight = (89./1000).*9.8; %Balloon weight in kilograms
p11_weight = (65./1000).*9.8; %payload weight in kilograms
b11 = readtable("AD4GN-11.xlsx", "PreserveVariableNames", true);
b11_temp = b11.temperature + 273.15;
b11_alt = b11.altitude;
b11_p = b11.pressure;
b11_v = (b11.speed./3600).*1000;
b11_d = b11_p./(R1.*b11_temp);

%AD4GN-12 constants
d12 = (36./12).*.3048; %initial diameter in meters
b12_weight = (88./1000).*9.8; %Balloon weight in kilograms
p12_weight = (68./1000).*9.8; %payload weight in kilograms
b12 = readtable("AD4GN-12.xlsx", "PreserveVariableNames", true);
b12_temp = b12.temperature + 273.15;
b12_alt = b12.altitude;
b12_p = b12.pressure;
b12_v = (b12.speed./3600).*1000;
b12_d = b12_p./(R1.*b12_temp);

t11 = datetime(b11.time,'InputFormat',"MM/dd/yyyy HH:mm");
t12 = datetime(b12.time,'InputFormat',"MM/dd/yyyy HH:mm");

dt1 = seconds(diff(t11));
b11_v = [NaN; diff(b11.altitude)./dt1]; 
dt2 = seconds(diff(t12));
b12_v = [NaN; diff(b12.altitude)./dt2];

rho0 = amb_p/(R1.*amb_t);  

%Tempertaure function for gradient region
temp = @(t1,a,h,h1) (t1 + a.*(h-h1));
%Pressure function for gradient region
p = @(p1, t, t1, g, a, R) (p1.*(t./t1).^(-g/(a.*R)));
%Pressure for isothermal region
p_iso = @(p, g, R, t, h, h1) (p.*exp((-g./(R.*t)).*(h-h1)));
%Tempertaure for isothermal region
t_iso = amb_t + a1.*11000;
%Pressure for isothermal at 11000 meters
p_anchor = amb_p.*(t_iso./amb_t).^(-g0/(a1.*R1));

i = 1;
h1 = linspace(0, 25000, 236);

for h = linspace(0, 25000, 236)
    if h<11000
        theo_temp(i) = temp(amb_t, a1, h, 0);
        theo_p(i) = p(amb_p, theo_temp(i), amb_t, g0, a1, R1);
    elseif h>=11000
        theo_temp(i) = t_iso;
        theo_p(i) = p_iso(p_anchor, g0, R1, t_iso,h, 11000);
    end
    i = i + 1;
end

rho_th = theo_p ./ (R1 .* theo_temp); % theoretical air density along h1


d11_series = d11 .* (rho0 ./ rho_th).^(1/3);
d12_series = d12 .* (rho0 ./ rho_th).^(1/3);

CD1=0.8;  % guess and check for best fit
CD2=2.8;  % guess and check for best fit
lift = @(rho, g, d, pw, bw) (rho.*(6.2/7.2).*g.*(pi/6).*d.^3 - pw - bw);
lift_11 = lift(rho_th,g0,d11_series,b11_weight,p11_weight);
lift_11 = max(lift_11,0);
%Ascent Rate function
AR = @(rho, d, CD, lift) (sqrt( (8 ./ (rho .* pi .* d.^2 .* CD)) .* lift));
b11_AR = AR(rho_th,d11_series,CD1,lift_11);
lift_12 = lift(rho_th,g0,d12_series,b12_weight,p12_weight);
lift_12 = max(lift_12,0);
b12_AR = AR(rho_th,d12_series,CD2,lift_12);

figure(1);
plot(theo_temp, h1./1000, 'k','LineWidth', 1.5)
hold on;
plot(b12_temp, b12_alt./1000, 'ob')
hold on;
plot(b11_temp, b11_alt./1000, '+r')
xlabel('Temperature (Kelvin)')
ylabel('Altitude')
ylim([0,25])
xlim([200,320])
grid on;
legend("Theoretical Temperature", "Balloon 12 Temperature", "Balloon 11 Temperature")
title("Altitude vs Temperature")

figure(2);
plot(theo_p, h1./1000, 'k')
hold on;
plot(b12_p, b12_alt./1000, 'ob')
hold on;
plot(b11_p, b11_alt./1000, '+r')
xlabel('Pressure (N/m^2)')
ylabel('Altitude')
ylim([0,25])
xlim([1e3,1e5])
grid on;
legend("Theoretical Pressure", "Balloon 12 Pressure", "Balloon 11 Pressure")
title("Altitude vs Pressure")

figure(3);
plot(b11_AR, h1./1000, 'k', 'LineWidth', 1.5)
hold on;
plot(b12_AR, h1./1000, 'g','LineWidth', 1.5)
hold on;
plot(b12_v, b12_alt./1000, 'ob')
hold on;
plot(b11_v, b11_alt./1000, '+r')
xlabel('Ascent Rate(m/s)')
ylabel('Altitude')
ylim([0,25])
xlim([0,10])
grid on;
legend("Balloon 11 Theoretical Ascent Rate", "Balloon 12 Theoretical Ascent Rate", "Balloon 12 Ascent Rate", "Balloon 11 Ascent Rate")
title("Altitude vs Ascent Rate")
