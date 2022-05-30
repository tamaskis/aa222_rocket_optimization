%==========================================================================
%
% simulate_trajectory  Simulates a rocket trajectory using 3DOF rocket 
% dynamics.
%
%   [x,y] = simulate_trajectory(theta0,m_ballast,w,rocket,physical)
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
%       • m_prop - (1×1 double) propellant mass [kg]
%       • mdot   - (1×1 double) engine burn rate [kg/s]
%   physical    - (1×1 struct) physical parameters
%       • g   - (1×1 double) gravitational acceleration [m/s^2]
%       • rho - (1×1 double) air density [kg/m^3]
%
% -------
% OUTPUT:
% -------
%   x           - (N×1 double) x-positions [m]
%   y           - (N×1 double) y-positions [m]
%
%==========================================================================
function [x,y] = simulate_trajectory(theta0,m_ballast,w,rocket,physical)
    
    % time step [s]
    dt = 0.01;
    
    % recomputes initial mass including ballast (assumed the rocket is
    % ballasted at the center of mass) [kg]
    rocket.m0 = rocket.m0+m_ballast;
    
    % converts launch angle to radians
    theta0 = theta0*(pi/180);
    
    % -------
    % Ascent.
    % -------
    
    % ascent dynamics
    f = @(t,x) rocket_dynamics(t,x,rocket.m0,rocket.l,rocket.d,rocket.T,...
        rocket.t_burn,rocket.mdot,physical.rho,physical.g,w);
    
    % initial condition
    x0 = zeros(6,1);
    x0(3) = theta0;
    
    % condition function to terminate ascent portion of trajectory (remains
    % true while vertical velocity is greater than 0)
    C = @(t,x) x(5) >= 0;
    
    % solves ascent portion of trajectory
    [t_ascent,x_ascent] = RK4(f,{0,C},x0,dt);
    
    % -------------------------------
    % Descent under drogue parachute.
    % -------------------------------
    
    % initial conditions for drogue descent portion of trajectory [s]
    t0_drogue = t_ascent(end);
    x0_drogue = x_ascent(end,:).';
    
    % descent dynamics under drogue parachute (drifts with wind, descends 
    % at 25 m/s)
    f = @(t,x) [ w;
                -25;
                 zeros(4,1)];
    
    % condition function to terminate drogue descent portion of trajectory 
    % (remains true while altitude is greater than 150 m)
    C = @(t,x) x(2) >= 150;
    
    % solves drogue descent portion of trajectory
    [t_drogue,x_drogue] = RK4(f,{t0_drogue,C},x0_drogue,dt);
    
    % -----------------------------
    % Descent under main parachute.
    % -----------------------------
    
    % initial conditions for main descent portion of trajectory [s]
    t0_main = t_drogue(end);
    x0_main = x_drogue(end,:).';
    
    % descent dynamics under main parachute (drifts with wind, descends 
    % at 3 m/s)
    f = @(t,x) [ w;
                -3;
                 zeros(4,1)];
    
    % condition function to terminate descent portion of trajectory 
    % (remains true while altitude is greater than 0)
    C = @(t,x) x(2) >= 0;
    
    % solves main descent portion of trajectory
    [~,x_main] = RK4(f,{t0_main,C},x0_main,dt);
    
    % concatenates results
    x = [x_ascent;
         x_drogue(2:end,:);
         x_main(2:end,:)];
    
    % extracts horizontal and vertical positions [m]
    y = x(:,2);
    x = x(:,1);
    
end