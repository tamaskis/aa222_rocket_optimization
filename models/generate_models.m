%% generate_models.m
% AA 222 - Engineering Design Optimization
%
% Generates the actual and surrogate models needed for the rocket launch
% configuration optimization.
%
% Author: Tamas Kis
% Last Update: 2022-05-30



%% SCRIPT SETUP

% clears Workspace and Command Window, closes all figures
clear; clc; close all;

% adds path to all necessary folders/libraries
addpath(genpath("../../../../../MATLAB/toolboxes/Optimization_Toolbox-"+...
    "MATLAB"));
addpath(genpath('..'));



%% PARAMETERS

% loads rocket parameters
rocket = rocket_parameters;

% loads physical parameters
physical = physical_parameters;



%% GENERATE SURROGATE MODELS

% apogee as a function of launch angle, ballast mass, and wind
apogee_act = @(z) apogee(z(1),z(2),z(3),rocket,physical);

% drift as a function of launch angle, ballast mass, and wind
drift_act = @(z) drift(z(1),z(2),z(3),rocket,physical);

% minimum values of each variable to sample
z_min = [0;     % launch angle [°]
         0;     % ballast mass [kg]
         0];    % wind speed [m/s]

% maximum values of each variable to sample
z_max = [20;    % launch angle [°]
         2;     % ballast mass [kg]
         10];   % wind speed [m/s]

% number of samples per variable
m = [5;         % number of samples for launch angle
     5;         % number of samples for ballast mass
     5];        % number of samples for wind speed

% design point samples
z = samples_full_factorial(z_min,z_max,m);

% generates surrogate models
apogee_surr = get_surrogate(apogee_act,z);
drift_surr = get_surrogate(drift_act,z);

% saves actual models to .mat files
save('apogee_act.mat','apogee_act');
save('drift_act.mat','drift_act');

% saves surrogate models to .mat files
save('apogee_surr.mat','apogee_surr');
save('drift_surr.mat','drift_surr');