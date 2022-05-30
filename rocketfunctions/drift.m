%==========================================================================
%
% drift  Determines the rocket's drift from the launch pad.
%
%   x_drift = drift(theta0,m_ballast,w,rocket,physical)
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   theta0      - (1×1 double) launch angle [deg]
%   m_ballast   - (1×1 double) ballast mass [kg]
%   w           - (1×1 double) wind speed [m/s]
%   rocket      - (1×1 struct) rocket parameters
%       • m0     - (1×1 double) initial mass [kg]
%       • l      - (1×1 double) length [m]
%       • d      - (1×1 double) static margin [m]
%       • T      - (1×1 double) engine thrust [N]
%       • t_burn - (1×1 double) burn time [s]
%       • mdot   - (1×1 double) engine burn rate [kg/s]
%   physical    - (1×1 struct) physical parameters
%       • g   - (1×1 double) gravitational acceleration [m/s^2]
%       • rho - (1×1 double) air density [kg/m^3]
%
% -------
% OUTPUT:
% -------
%   x_drift     - (1×1 double) drift from launch pad [m]
%
%==========================================================================
function x_drift = drift(theta0,m_ballast,w,rocket,physical)
    
    % simulates trajectory
    x = simulate_trajectory(theta0,m_ballast,w,rocket,physical);
    
    % extracts drift from launch pad [m]
    x_drift = iabs(x(end));
    
end