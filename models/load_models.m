%==========================================================================
%
% load_f_alt  Loads the actual and surrogate models describing the rocket's 
% apogee and drift from the launch pad as functions of launch angle, 
% ballast mass, and wind speed.
%
%   [apogee_act,drift_act,apogee_surr,drift_surr] = load_models
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% -------
% OUTPUT:
% -------
%   apogee_act      - (1×1 function_handle) actual model describing the 
%                     rocket's apogee as a function of launch angle,
%                     ballast mass, and wind speed
%   drift_act       - (1×1 function_handle) actual model describing the 
%                     rocket's drift from the launch pad as a function of 
%                     launch angle, ballast mass, and wind speed
%   apogee_surr     - (1×1 function_handle) surrogate model describing the 
%                     rocket's apogee as a function of launch angle,
%                     ballast mass, and wind speed
%   drift_surr      - (1×1 function_handle) surrogate model describing the 
%                     rocket's drift from the launch pad as a function of 
%                     launch angle, ballast mass, and wind speed
%   
% ------
% NOTE:
% ------
%   --> All functions are defined as functions of z ∈ ℝ³, where
%           • z(1). theta0    - launch angle [deg]
%           • z(2). m_ballast - ballast mass [kg]
%           • z(3). w         - wind speed [m/s]
%
%==========================================================================
function [apogee_act,drift_act,apogee_surr,drift_surr] = load_models
    apogee_act = struct2array(load('apogee_act.mat'));
    drift_act = struct2array(load('drift_act.mat'));
    apogee_surr = struct2array(load('apogee_surr.mat'));
    drift_surr = struct2array(load('drift_surr.mat'));
end