function HH(amp,dur,stinum,delay)
% Author: (Guray Ozgur)(2167054)(Middle East Technical University)
%
% Description: 
% 	     (Action Potential Generation)
%            A model of the excitable membrane of an axon using the Hudgkin-Huxley (H&H) network model
%            based on the rate constants for ionic channel conductivities determined by H&H
%
% Input:
%      	amp : amplitude of the stimulus current applied to the axon in uA/cm^2
%       dur : duration of the stimulus current applied to the axon in miliseconds
%    stinum : number of consecutive stimuli to be applied (one or two)
%     delay : the time delay between the successive stimuli if more than one stimulus is applied in miliseconds
%
% Output:
%            	     I : applied input current
%                  I_m : total membrane current 
%  I_Na, I_K, I_L, I_C : sodium, potassium, leakage channel and capacitive currents
%       G_Na, G_K, G_L : sodium, potassium, and leakage channel conductances
%                  V_m : transmembrane voltage
% Usage:
%       HH(amp,dur,stinum,delay)  

%% Constants

% the constants of the HH model
C_m = 1;        % in uF/cm^2
V_rest = -90;   % in mV
V_Na = 25;      % in mV
V_K = -102;     % in mV
V_L = -79.387;  % in mV
G_Na = 120;     % in mS/cm^2
G_K = 36;       % in mS/cm^2
G_L = 0.3;      % in mS/cm^2

%% Initials

% creating the timeline
T=30;  		% in ms
dT=1e-4; 	% in ms
t=0:dT:T; 	% in ms

I_m=zeros(size(t)); % in uA/cm^2
% I_m=I, i.e. the value of the total membrane current is equal to the stimulus that is applied
durdT=round(dur/dT);
delaydT=round(delay/dT);
I_m(1,(3/dT):((3/dT)+durdT))=amp;   % the first stimulus current applied to the axon
if stinum == 2
	I_m(1,((3/dT)+durdT+delaydT):(2*durdT+delaydT+(3/dT)))=amp;   % the second stimulus current applied to the axon if any
end

V_m(1)=V_rest;
v_m(1)=V_m(1)-V_rest;

%% Procedure

for i=1:numel(t)-1

% analytic functions used by Hodgkin and Huxley by curve fitting
alpha_n=0.01*(10-v_m(i))/(exp((10-v_m(i))/10)-1); 	% eqn. (5.24) in Plonsey and Barr
beta_n=0.125*exp(-v_m(i)/80);                       % eqn. (5.25) in Plonsey and Barr
alpha_m=0.1*(25-v_m(i))/(exp((25-v_m(i))/10)-1); 	% eqn. (5.36) in Plonsey and Barr
beta_m=4*exp(-v_m(i)/18);                           % eqn. (5.36) in Plonsey and Barr
alpha_h=0.07*exp(-v_m(i)/20);                       % eqn. (5.37) in Plonsey and Barr
beta_h=1/(exp((30-v_m(i))/10)+1);                   % eqn. (5.37) in Plonsey and Barr
if i == 1
	n(1)=alpha_n/(alpha_n+beta_n);
	m(1)=alpha_m/(alpha_m+beta_m);
	h(1)=alpha_h/(alpha_h+beta_h);
end

% estimate dV_m
g_K(i)=G_K*(n(i)^4);
g_Na(i)=G_Na*(m(i)^3)*h(i);
g_L(i)=G_L;
I_K(i)=g_K(i)*(V_m(i)-V_K);
I_Na(i)=g_Na(i)*(V_m(i)-V_Na);
I_L(i)=g_L(i)*(V_m(i)-V_L);
I_ion(i)=I_Na(i)+I_K(i)+I_L(i);
I_C(i)=I_m(i)-I_ion(i);
dV_m=dT*(I_C(i))/C_m;

% estimate dn, dm, and dh
dn=dT*(alpha_n*(1-n(i))-beta_n*n(i));
dm=dT*(alpha_m*(1-m(i))-beta_m*m(i));
dh=dT*(alpha_h*(1-h(i))-beta_h*h(i));

% advance to the next time
V_m(i+1)=V_m(i)+dV_m;
v_m(i+1)=V_m(i+1)-V_rest;
n(i+1)=n(i)+dn;
m(i+1)=m(i)+dm;
h(i+1)=h(i)+dh;
if i == numel(t)-1 
    I_K(i+1)=I_K(i);
    I_Na(i+1)=I_Na(i);
    I_L(i+1)=I_L(i);
    I_ion(i+1)=I_ion(i);
    I_C(i+1)=I_C(i);
    g_K(i+1)=g_K(i);
    g_Na(i+1)=g_Na(i);
    g_L(i+1)=g_L(i);
end

end

%% Plots

figure
subplot(311)
plot(t, I_m,'r','LineWidth', 2)
hold on
plot(t, I_m,'b','LineWidth', 2)
grid on
legend( 'Applied Input Current', 'Total Membrane Current')
ylabel('Current (uA/cm^2)')
title('Applied Input Current and Total Membrane Current');

subplot(312)
plot(t, V_m,'k','LineWidth', 2)
hold on
grid on
ylabel('Voltage (mV)')
ylim([-110 40])
title('Transmembrane Voltage');

subplot(313)
f1 = plot(t, m,'r','LineWidth', 2);
hold on
f2 = plot(t, h, 'g','LineWidth', 2);
hold on
f3 = plot(t, n, 'b','LineWidth', 2);
grid on
legend([f1, f2, f3], 'm', 'h', 'n')
xlabel('time (ms)')
title('Gating Variables')

% conversion from (uA/cm^2) to (mA/cm^2)
I_K=I_K/1000;
I_Na=I_Na/1000;
I_L=I_L/1000;
I_C=I_C/1000;

figure
subplot(211)
g1 = plot(t, I_K,'r','LineWidth', 2);
hold on
g2 = plot(t, I_Na, 'g','LineWidth', 2);
hold on
g3 = plot(t, I_L, 'b','LineWidth', 2);
hold on
g4 = plot(t, I_C, 'c','LineWidth', 2);
grid on
legend([g1, g2, g3, g4], 'Current for Potassium', 'Current for Sodium', 'Current for Leakage Channel', 'Capacitive Current')
ylabel('Current (mA/cm^2)')
title('Sodium, Potassium, Leakage Channel, and Capacitive Currents')

subplot(212)
h1 = plot(t, g_K,'r','LineWidth', 2);
hold on
h2 = plot(t, g_Na, 'g','LineWidth', 2);
hold on
h3 = plot(t, g_L, 'b','LineWidth', 2);
grid on
legend([h1, h2, h3], 'Conductance for Potassium', 'Conductance for Sodium', 'Conductance for Leakage Channel')
ylabel('Conductance (mS/cm^2)')
xlabel('time (ms)')
title('Sodium, Potassium, and Leakage Channel Conductances')

figure
plot(t, I_m,'r','LineWidth', 2)
hold on
plot(t, I_m,'b','LineWidth', 2)
grid on
legend( 'Applied Input Current', 'Total Membrane Current')
xlabel('time (ms)')
ylabel('Current (uA/cm^2)')
title('Applied Input Current and Total Membrane Current');

figure
plot(t, V_m,'k','LineWidth', 2)
hold on
grid on
xlabel('time (ms)')
ylabel('Voltage (mV)')
ylim([-110 40])
title('Transmembrane Voltage');

figure
f1 = plot(t, m,'r','LineWidth', 2);
hold on
f2 = plot(t, h, 'g','LineWidth', 2);
hold on
f3 = plot(t, n, 'b','LineWidth', 2);
grid on
legend([f1, f2, f3], 'm', 'h', 'n')
xlabel('time (ms)')
title('Gating Variables')

% conversion from (uA/cm^2) to (mA/cm^2)
I_K=I_K/1000;
I_Na=I_Na/1000;
I_L=I_L/1000;
I_C=I_C/1000;

figure
g1 = plot(t, I_K,'r','LineWidth', 2);
hold on
g2 = plot(t, I_Na, 'g','LineWidth', 2);
hold on
g3 = plot(t, I_L, 'b','LineWidth', 2);
hold on
g4 = plot(t, I_C, 'c','LineWidth', 2);
grid on
legend([g1, g2, g3, g4], 'Current for Potassium', 'Current for Sodium', 'Current for Leakage Channel', 'Capacitive Current')
ylabel('Current (mA/cm^2)')
xlabel('time (ms)')
title('Sodium, Potassium, Leakage Channel, and Capacitive Currents')

figure
h1 = plot(t, g_K,'r','LineWidth', 2);
hold on
h2 = plot(t, g_Na, 'g','LineWidth', 2);
hold on
h3 = plot(t, g_L, 'b','LineWidth', 2);
grid on
legend([h1, h2, h3], 'Conductance for Potassium', 'Conductance for Sodium', 'Conductance for Leakage Channel')
ylabel('Conductance (mS/cm^2)')
xlabel('time (ms)')
title('Sodium, Potassium, and Leakage Channel Conductances')

end

