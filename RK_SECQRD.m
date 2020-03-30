% Function: General ODE solver
%
%	[state] = RungeKutta(ode_fun,time,state,DT,RK,varargin)
%
% Performs 2nd or 4th order Runge Kutta integration.
% Formatted to match MATLAB's ode45 basic argument
% structure.
%
% Inputs:
%	state		= initial stae for ODE
%	DT			= time step
%	RK			= Order (2 or 4)
%	--Other inputs to the ode function, in order--
% Outputs:
%	state		= propagated state function by DT
%
% By F. Busse, Oct. 2004, modified Mar. 2018
%+----------------------------------------------------------+
function [state] = RK_SECQRD(state,param,RK,DT)

%% Setup:
if(nargin<3||isempty(RK))
    RK = 4;
end
if(nargin<4||isempty(DT))
    DT = 1;
end


%% Runge Kutta routine:
if(RK==4)
    %4th order RK routine
    k1 = DT*SIR_fun(state,param);
    k2 = DT*SIR_fun(state+0.5*k1,param);
    k3 = DT*SIR_fun(state+0.5*k2,param);    
    k4 = DT*SIR_fun(state+k3,param);
    state = state + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
else
    %2nd order RK routine
    k1 = DT*SIR_fun(state,param);
    k2 = DT*SIR_fun(state + k1,param);
    state = state + (1/2)*(k1 + k2);
end

return

%% ODE_FUN
function xdot = SIR_fun(x,param)

%Unpack state:
S = x(1);
E = x(2);
A = x(3);
C = x(4);
Q = x(5);
R = x(6);
D = x(7);

%Unpack parameters:
%param = [lamda;mu;beta_c;beta_q;beta_a;chi;...
%	gamma_c;gamma_q;gamma_a;d_c;d_q;d_a;tau;rho;alpha_s;alpha_c;alpha_sc];
lamda		= param(1);
mu			= param(2);
beta_c		= param(3);
beta_q		= param(4);
beta_a		= param(5);
chi			= param(6);
gamma_c		= param(7);
gamma_q		= param(8);
gamma_a		= param(9);
d_c			= param(10);
d_q			= param(11);
d_a			= param(12);
tau			= param(13);
rho			= param(14);
alpha_s		= param(15);
alpha_c		= param(16);
alpha_sc	= param(17);

% --- Run Calculations
bSC = beta_a*S*A + beta_c*S*C + beta_q*S*Q;
bSC = bSC/(1 + alpha_s*S + alpha_c*(C+Q) + alpha_sc*S*C);

Sdot = lamda - mu*S - bSC;
if(tau==0)
	Edot = 0;
	Ain = bSC;
else
	Edot = bSC - tau*E  - mu*E;
	Ain = tau*E;
end
if(rho==0)
	Adot = 0;
	Cin = Ain;
else
	Adot = Ain - gamma_a*A  - d_a*A - rho*A - mu*A;
	Cin = rho*A;
end
Cdot = Cin - gamma_c*C - d_c*C - chi*C - mu*C;	
Qdot = chi*C - d_q*Q - gamma_q*Q  - mu*Q;
Rdot = gamma_c*C + gamma_q*Q + gamma_a*A - mu*R; 
Ddot = d_a*A + d_c*C + d_q*Q;

% --- Compile and send back:
xdot = [Sdot;Edot;Adot;Cdot;Qdot;Rdot;Ddot];

return
%% -------------- THE END ----------------- %%