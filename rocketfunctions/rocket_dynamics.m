%==========================================================================
%
% rocket_dynamics  Continuous-time 3DOF rocket dynamics.
%
%   dxdt = rocket_dynamics(t,x,m0,l,d,T,t_burn,mdot,rho,g,w)
%
% Author: Tamas Kis
% Last Update: 2022-05-30
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   t       - (1×1 double) time [s]
%   x       - (6×1 double) state vector
%               1. x      - x-position [m]
%               2. y      - y-position [m]
%               2. theta  - pitch angle [rad]
%               1. vx     - x-velocity[m/s]
%               2. vy     - y-velocity [m/s]
%               2. dtheta - pitch rate [rad/s]
%   m0      - (1×1 double) initial mass [kg]
%   l       - length [m]
%   d       - static margin [m]
%   T       - engine thrust [N]
%   t_burn  - burn time [s]
%   mdot    - engine burn rate [kg/s]
%   rho     - air density [kg/m^3]
%   g       - gravitational acceleration [m/s^2]
%   w       - wind speed [m/s]
%
% -------
% OUTPUT:
% -------
%   dxdt    - (6×1 double) state vector derivative
%
%==========================================================================
function dxdt = rocket_dynamics(t,x,m0,l,d,T,t_burn,mdot,rho,g,w)
    
    % unpacks state vector
    y = x(2);
    theta = x(3);
    vx = x(4);
    vy = x(5);
    dtheta = x(6);
    
    % freestream velocity [m/s]
    v_inf = sqrt((w-vx)^2+vy^2);
    
    % angle of attack [rad]
    beta = atan2(w-vx,vy);
    alpha = beta-theta;
    
    % lift force (assumed to be 0 while on launch rail) [N]
    if y > 5
        L = (0.3*rho*v_inf^2*alpha/cos(alpha));
    else
        L = 0;
    end
    Lx = L*cos(beta);
    Ly = L*sin(beta);
    
    % sets thrust to 0 if engine has completed burn
    if t > t_burn
        T = 0;
    end
    
    % thrust [N]
    Tx = T*sin(theta);
    Ty = T*cos(theta);
    
    % mass [kg]
    if t < t_burn
        m = m0-mdot*t;
    else
        m = m0-mdot*t_burn;
    end
    
    % moment of inertia [kg.m^2]
    I = m*l^2/12;
    
    % gravitational force [N]
    Fg = m*g;
    
    % linear accelerations [m/s^2]
    ax = (Lx-Tx)/m;
    ay = (Ty+Ly-Fg)/m;
    
    % angular acceleration (assumed to be 0 while on launch rail) [rad/s^2]
    if y < 5
        ddtheta = 0;
    else
        ddtheta = (L*cos(alpha))*d/I;
    end
    
    % assembles state vector derivative
    dxdt = [vx;
            vy;
            dtheta;
            ax;
            ay;
            ddtheta];
    
end