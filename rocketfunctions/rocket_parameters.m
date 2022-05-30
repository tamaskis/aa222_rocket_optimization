%==========================================================================
%
% rocket_parameters  Rocket parameters.
%
%   rocket = rocket_parameters
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% -------
% OUTPUT:
% -------
%   rocket      - (1×1 struct) rocket parameters
%       • m0     - (1×1 double) initial mass [kg]
%       • l      - (1×1 double) length [m]
%       • d      - (1×1 double) static margin [m]
%       • T      - (1×1 double) engine thrust [N]
%       • t_burn - (1×1 double) burn time [s]
%       • m_prop - (1×1 double) propellant mass [kg]
%       • mdot   - (1×1 double) engine burn rate [kg/s]
%
%==========================================================================
function rocket = rocket_parameters
    rocket.m0 = 22.5;                           % initial mass [kg]
    rocket.l = 3;                               % length [m]
    rocket.d = 2;                               % static margin [m]
    rocket.T = 1720;                            % thrust [N]
    rocket.t_burn = 2;                          % burn time [s]
    rocket.m_prop = 4;                          % propellant mass [kg]
    rocket.mdot = rocket.m_prop/rocket.t_burn;  % burn rate [kg/s]
end