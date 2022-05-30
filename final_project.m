%% final_project.m
% AA 222 - Engineering Design Optimization
%
% Final Project
%
% Author: Tamas Kis
% Last Update: 2022-05-30



%% SCRIPT SETUP

% clears Workspace and Command Window, closes all figures
clear; clc; close all;

% adds path to all functions
addpath('rocketfunctions');
addpath('models');
addpath(genpath('optimizationtoolbox'));



%% PARAMETERS

% loads rocket parameters
rocket = rocket_parameters;

% loads physical parameters
physical = physical_parameters;



%% LAUNCH CONDITIONS AND GOALS

% wind speed [m/s]
w = 8;

% target apogee [m]
target_apogee = 1140;



%% OPTIMIZATION

% optimizes configuration for 0 different wind speeds
[theta0_0,m_ballast_0] = optimize_config(0,target_apogee);
[theta0_1,m_ballast_1] = optimize_config(1,target_apogee);
[theta0_2,m_ballast_2] = optimize_config(2,target_apogee);
[theta0_3,m_ballast_3] = optimize_config(3,target_apogee);
[theta0_4,m_ballast_4] = optimize_config(4,target_apogee);
[theta0_5,m_ballast_5] = optimize_config(5,target_apogee);
[theta0_6,m_ballast_6] = optimize_config(6,target_apogee);
[theta0_7,m_ballast_7] = optimize_config(7,target_apogee);
[theta0_8,m_ballast_8] = optimize_config(8,target_apogee);
tic;[theta0_9,m_ballast_9] = optimize_config(9,target_apogee);toc

% generates trajectories
[x0,y0] = simulate_trajectory(theta0_0,m_ballast_0,0,rocket,physical);
[x1,y1] = simulate_trajectory(theta0_1,m_ballast_1,1,rocket,physical);
[x2,y2] = simulate_trajectory(theta0_2,m_ballast_2,2,rocket,physical);
[x3,y3] = simulate_trajectory(theta0_3,m_ballast_3,3,rocket,physical);
[x4,y4] = simulate_trajectory(theta0_4,m_ballast_4,4,rocket,physical);
[x5,y5] = simulate_trajectory(theta0_5,m_ballast_5,5,rocket,physical);
[x6,y6] = simulate_trajectory(theta0_6,m_ballast_6,6,rocket,physical);
[x7,y7] = simulate_trajectory(theta0_7,m_ballast_7,7,rocket,physical);
[x8,y8] = simulate_trajectory(theta0_8,m_ballast_8,8,rocket,physical);
[x9,y9] = simulate_trajectory(theta0_9,m_ballast_9,9,rocket,physical);

% apogee [m]
apogee0 = max(y0);
apogee1 = max(y1);
apogee2 = max(y2);
apogee3 = max(y3);
apogee4 = max(y4);
apogee5 = max(y5);
apogee6 = max(y6);
apogee7 = max(y7);
apogee8 = max(y8);
apogee9 = max(y9);

% drift [m]
drift0 = abs(x0(end));
drift1 = abs(x1(end));
drift2 = abs(x2(end));
drift3 = abs(x3(end));
drift4 = abs(x4(end));
drift5 = abs(x5(end));
drift6 = abs(x6(end));
drift7 = abs(x7(end));
drift8 = abs(x8(end));
drift9 = abs(x9(end));

% table
theta0_table = [theta0_0,theta0_1,theta0_2,theta0_3,theta0_4,theta0_5,...
    theta0_6,theta0_7,theta0_8,theta0_9];
m_ballast_table = [m_ballast_0,m_ballast_1,m_ballast_2,m_ballast_3,...
    m_ballast_4,m_ballast_5,m_ballast_6,m_ballast_7,m_ballast_8,...
    m_ballast_9];
apogee_table = [apogee0,apogee1,apogee2,apogee3,apogee4,apogee5,apogee6,...
    apogee7,apogee8,apogee9];
drift_table = [drift0,drift1,drift2,drift3,drift4,drift5,drift6,drift7,...
    drift8,drift9];
T = table((0:9)',theta0_table',m_ballast_table',apogee_table',...
    drift_table');
T.Properties.VariableNames = ["Wind Speed [m/s]","Launch Angle [°]",...
    "Ballast Mass [kg]","Apogee [m]","Drift [m]"];
T

% plots trajectories
figure('Position',[540,100,700,600]);
hold on;
plot([-1000,400],[target_apogee,target_apogee],'k--','LineWidth',1.5);
plot([-1000,400],[1000,1000],'r--','LineWidth',1.5);
plot([-200,200],[0,0],'Color',[0.133,0.545,0.133],'LineWidth',2);
plot(x0,y0,'LineWidth',1.5,'Color',[0.5,0.5,0.5]);
plot(x1,y1,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x2,y2,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x3,y3,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x4,y4,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x5,y5,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x6,y6,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x7,y7,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x8,y8,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
plot(x9,y9,'LineWidth',1.5,'Color',[0.5,0.5,0.5],'HandleVisibility','off');
grid on;
axis equal;
xlim([-1000,400]);
ylim([0,1200]);
xlabel('$x\;[\mathrm{m}]$','Interpreter','latex','FontSize',18);
ylabel('$y\;[\mathrm{m}]$','Interpreter','latex','FontSize',18);
title({'\textbf{Trajectories for 10 Different Wind Conditions}',...
    '0 to 9 m/s'},'Interpreter','latex','FontSize',20);
legend('target altitude','disqualification altitude','landing zone',...
    'rocket trajectories','Interpreter','latex','FontSize',14,...
    'Location','southoutside');
hold off;