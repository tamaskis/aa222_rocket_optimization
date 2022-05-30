%==========================================================================
%
% optimize_config  Optimizes the launch configuration.
%
%   [theta0,m_ballast] = optimize_config(w,target_apogee)
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   w               - (1×1 double) wind speed [m/s]
%   target_apogee   - (1×1 double) target apogee [m]
%
% -------
% OUTPUT:
% -------
%   theta0          - (1×1 double) launch angle [°]
%   m_ballast       - (1×1 double) ballast mass [kg]
%
%==========================================================================
function [theta0,m_ballast] = optimize_config(w,target_apogee)
    
    % ----------------------
    % Parameters and models.
    % ----------------------
    
    % loads surrogate models describing the rocket's apogee and drift from
    % the launch pad as functions of launch angle, ballast mass, and wind 
    % speed
    [~,~,apogee_surr,drift_surr] = load_models;
    
    % -----------------------
    % Optimization of apogee.
    % -----------------------
    
    % inequality constraints
    g1 = @(x) [ x(1)-20;                    % launch angle ≤ 20°
               -x(1);                       % launch angle ≥ 0°
                x(2)-2;                     % ballast mass ≤ 2 kg
               -x(2);                       % ballast mass ≥ 0 kg
               -apogee_surr([x;w])+1000;    % apogee ≥ 1000 m
                drift_surr([x;w])-200];     % drift ≤ 200 m
    
    % quadratic penalty function
    p_quadratic = penalty_quadratic([],g1);
    
    % 1st objective function
    f1 = @(x) (apogee_surr([x;w])-target_apogee)^2+1e10*p_quadratic(x);
    
    % initial guess
    x0 = [1;
          1];
    
    % optimization
    opts.sigma0 = 0.5;
    [x1_min,y1_min] = minimize_nelder_mead(f1,x0,opts);
    
    % ----------------------
    % Optimization of drift.
    % ----------------------
    
    % inequality constraints
    g2 = @(x) [g1(x);           % feasibility
               f1(x)-y1_min];   % preservation of optimality
    
    % quadratic penalty function
    p_quadratic = penalty_quadratic([],g2);
    
    % objective function
    f1 = @(x) drift_surr([x;w])^2+1e10*p_quadratic(x);
    
    % optimization
    opts.sigma0 = 0.5;
    x2_min = minimize_nelder_mead(f1,x1_min,opts);
    
    % -----------------------------
    % Optimal launch configuration.
    % -----------------------------
    
    % launch angle [°]
    theta0 = x2_min(1);
    
    % ballast mass [kg]
    m_ballast = x2_min(2);
    
end