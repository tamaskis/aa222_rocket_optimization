%==========================================================================
%
% physical_parameters  Physical parameters.
%
%   physical = physical_parameters
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% -------
% OUTPUT:
% -------
%   physical    - (1×1 struct) physical parameters
%       • g   - (1×1 double) gravitational acceleration [m/s^2]
%       • rho - (1×1 double) air density [kg/m^3]
%
%==========================================================================
function physical = physical_parameters
    physical.g = 9.80665;   % gravitational acceleration [m/s^2]
    physical.rho = 1.225;   % air density [kg/m^3]
end