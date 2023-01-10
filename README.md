# HodgkinHuxleyModel

This repository is a project, for which an action potential is simulated by using the Hodgkin-Huxley Model in MATLAB. This model is based on the rate constants for ionic channel conductivities determined by Hodgkin and Huxley. In this simulation, for the ordinary differential equations describing the phenomenon, Forward Euler Method is used. User specifies the number of stimulations and delay between them. Moreover, for applied input current, its amplitude and duration are chosen by the user. All the outputs are taken out in a graphical form for a smooth visualization of the data in a certain time interval to observe the effect of the stimulations.

# Usage
```Matlab
Action Potential Generation Simulation using the Hodgkin-Huxley Model
##############################################################################################################################################

This file includes a GUI in "GUI.m" and a function HH(amp,dur,stinum,delay) that GUI uses in "HH.m".

To run the simulation basicly just open GUI.m with MATLAB and run it. 
When the GUI appears, tune with the inputs as you want, however you should be careful about it, inputs given out of range result in an empty plot. TUNE IT CAREFULLY.

To understand the function better, look at below and see the description of the function. OR better just look at the code in "HH.m".
##############################################################################################################################################

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
```
# Example Results

![Membrane Action Potential Using the Hodgkin-Huxley Equations](https://github.com/gurayozgur/HodgkinHuxleyModel/blob/main/images/1-%20Membrane%20Action%20Potential%20Using%20the%20Hodgkin-Huxley%20Equations.jpg?raw=true)
![Sodium, Potassium, and Leakage Conductances, and Corresponding Currents](https://github.com/gurayozgur/HodgkinHuxleyModel/blob/main/images/2-%20Sodium,%20Potassium,%20and%20Leakage%20Conductances,%20and%20Corresponding%20Currents.jpg?raw=true)
