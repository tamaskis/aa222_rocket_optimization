%==========================================================================
%
% apogee  Determines the apogee achieved by a rocket.
%
%   y_max = apogee(theta0,m_ballast,w,rocket,physical)
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
%   y_max       - (1×1 double) apogee [m]
%
%==========================================================================
function y_max = apogee(theta0,m_ballast,w,rocket,physical)
    
    % simulates trajectory
    [~,y] = simulate_trajectory(theta0,m_ballast,w,rocket,physical);
    
    % extracts apogee [m]
    y_max = max(y);
    
end