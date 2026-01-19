clear; clc;

%Constants
r_earth = 6374; %Radius of earth in kilometers
mu = 3.986.*(10.^14)./(1000.^3); %km^3/s^2

%Circular Oribit Altitudes
alt1 = 100+r_earth; %Altitude 1 in kilometers
alt2 = 400+r_earth; %Altitude 2 in kilometers
alt3 = 1000+r_earth; %Altitude 3 in kilometers

%Velocity function
v = @(muc, r) sqrt(muc./r);
%Velocities of altitudes 1,2,3 in km/s
v1 = v(mu, (alt1));
v2 = v(mu, (alt2));
v3 = v(mu, (alt3));

%Period function
period = @(muc,r) sqrt((4.*(pi.^2).*r.^3)./muc)./60;
%Period of atitudes 1,2,3 in minutes
period1 = period(mu, (alt1));
period2 = period(mu, (alt2));
period3 = period(mu, (alt3));

%Hohmann transfer functions
v_apo = @(muc,r2,a) (sqrt(muc.*((2./r2)-(1./a))));
v_peri = @(muc,r1,a) (sqrt(muc.*((2./r1)-(1./a))));
dv1 = @(muc,r1) sqrt(muc./r1);
dv2 = @(muc,r2) sqrt(muc./r2);
v_tot = @(muc,r1,r2,a, v_a, v_p) (abs((v_p-(sqrt(muc./r1)))) + abs(((sqrt(muc./r2))-v_a)));
e = @(a,b) sqrt(1-(b./a).^2);
p = @(a,e) a.*(1-(e.^2));
periodh = @(muc,a) (sqrt((4.*(pi.^2).*a.^3)./muc)./2)./60;

%Hohmann transfer from altitude 1 to 2
a12 = (alt1+alt2)./2;
b12 = sqrt(alt1.*alt2);
v_apo12 = v_apo(mu,alt2,a12);
v_peri12 = v_peri(mu,alt1,a12);
dv1_12 = v_peri12-dv1(mu,alt1);
dv2_12 = dv2(mu,alt2)-v_apo12;
v_tot12 = v_tot(mu, alt1,alt2,a12,v_apo12,v_peri12);
e12 = e(a12,b12);
p12 = p(a12,e12);
period12 = periodh(mu, a12);

%Hohmann transfer from altitude 1 to 3
a13 = (alt1+alt3)./2;
b13 = sqrt(alt1.*alt3);
v_apo13 = v_apo(mu,alt3,a13);
v_peri13 = v_peri(mu,alt1,a13);
dv1_13 = v_peri13-dv1(mu,alt1);
dv2_13 = dv2(mu,alt3)-v_apo13;
v_tot13 = v_tot(mu, alt1,alt3,a13,v_apo13,v_peri13);
e13 = e(a13,b13);
p13 = p(a13,e13);
period13 = periodh(mu, a13);

%Hohmann transfer from altitude 2 to 3
a23 = (alt2+alt3)./2;
b23 = sqrt(alt2.*alt3);
v_apo23 = v_apo(mu,alt3,a23);
v_peri23 = v_peri(mu,alt2,a23);
dv1_23 = v_peri23-dv1(mu,alt2);
dv2_23 = dv2(mu,alt3)-v_apo23;
v_tot23 = v_tot(mu, alt2,alt3,a23,v_apo23,v_peri23);
e23 = e(a23,b23);
p23 = p(a23,e23);
period23 = periodh(mu, a23);

%Finding r(theta) and v(theta)
j = 1;
theta = 0:0.02:2.*pi;

for i = 0:0.02:(2.*pi)
    r(j) = (p12./(1+e12.*cos(i)));
    v_theta(j) = sqrt(mu*((2./r(j)) - (1./a12)));
    j = j +1;
end

%Polar Plots in step 3
figure;
polarplot(theta,r, 'LineWidth', 1.5)
title("Radius versus Angle")

figure;
polarplot(theta,v_theta,'LineWidth', 1.5)
title("Velocity versus Angle")

%Inclination function
delv = @(v, t1,t2) 2.*v.*sind((t2-t1)./2);

%Incltaion for each number asked in km/s
delv_zero = delv(v2, 0, 28.5);
delv_516 = delv(v2, 28.5, 51.6);
delv_90 = delv(v2, 28.5, 90);
delv1_zero = delv(v1, 0, 28.5);
delv_plane_apogee = delv(v_apo12, 0, 28.5);

delv_1 = v_tot12 + delv1_zero;
delv_2 = v_tot12 + delv_zero;
delv_3 = delv_plane_apogee + dv1_12 + dv2_12;
dv4_plane_circ = sqrt(v_apo12^2 + v2^2 - 2*v_apo12*v2*cosd(28.5));
delv_4 = dv1_12 + dv4_plane_circ;
