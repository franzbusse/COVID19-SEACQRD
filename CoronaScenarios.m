% CoronaScenarios
%
% Defines scenarios: parameters, initial conditions, and other factors
% for the model.
%
% By F. Busse, Mar 2020
%% ------------------------------------------------------------ %%
function [x,p] = CoronaScenarios(K)

E = 0;
A = 0;
C = 0.00001;
Q = 0;
R = 0;
D = 0;

%Population:
lamda	= 0.00;		%recruitment rate (birth rate)
mu		= lamda;	%natural death rate

%Disease:
switch(K)
	case 1
		%Seasonal Flu model
		beta_c		= 1.3/3;		%Contact rate while symptomatic
		beta_q		= 0.0;			%Leaking from quarantine
		beta_a		= 1.3/3;		%Contact rate while asymptomatic (high!)
		gamma_c		= 1/3;			%recovery rate (1/r is the infectious period)
		gamma_q		= gamma_c;		%Recovery rate from quarantine (faster?)
		gamma_a		= gamma_c;		%Recovery rate from asymptomatic (same, or 0?)
		d_c			= 0.0001;		%disease death rate
		d_q			= d_c;			%disease death rate from quarantine (lower?)
		d_a			= 0;			%disease death rate from asymptomatic
		tau			= 0;			%1/Incubation preiod before contagious (No, this is actually "latency")
		rho			= 0;			%1/Asymptomatic period
		%Behavior:
		chi			= 0;			%Quarantine rate
		alpha_s		= 0;			%Drop in beta as S grows
		alpha_c		= 0;			%Drop in beta as C grows (fear)
		alpha_sc	= 0;			%Drop in beta as SxC grows. Huh.
	case 2
		%What everyone else thinks Corona Virus is.
		C = 0.00001;
		beta_c		= 2.5/10;		%Contact rate while symptomatic
		beta_q		= 0.0;			%Leaking from quarantine
		beta_a		= 2.5/10;		%Contact rate while asymptomatic (high!)
		gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
		gamma_q		= gamma_c;		%Recovery rate from quarantine (faster?)
		gamma_a		= gamma_c;		%Recovery rate from asymptomatic (same, or 0?)
		d_c			= 0.001;		%disease death rate
		d_q			= d_c;			%disease death rate from quarantine (lower?)
		d_a			= 0;			%disease death rate from asymptomatic
		tau			= 1/2;			%1/Incubation preiod before contagious (No, this is actually "latency")
		rho			= 1/3;			%1/Asymptomatic period
		%Behavior:
		chi			= 0.0;			%Quarantine rate
		alpha_s		= 0;			%Drop in beta as S grows
		alpha_c		= 0;			%Drop in beta as C grows (fear)
		alpha_sc	= 0;			%Drop in beta as SxC grows. Huh.
	case 3
		%Flatten the curve example
		C = 0.00002;
		beta_c		= 2.5/10;		%Contact rate while symptomatic
		beta_q		= 0.0;			%Leaking from quarantine
		beta_a		= 2.5/10;		%Contact rate while asymptomatic (high!)
		gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
		gamma_q		= gamma_c;		%Recovery rate from quarantine (faster?)
		gamma_a		= gamma_c;		%Recovery rate from asymptomatic (same, or 0?)
		d_c			= 0.002;		%disease death rate
		d_q			= d_c;			%disease death rate from quarantine (lower?)
		d_a			= 0;			%disease death rate from asymptomatic
		tau			= 1/2;			%1/Incubation preiod before contagious (No, this is actually "latency")
		rho			= 1/3;			%1/Asymptomatic period
		%Behavior:
		chi			= 0.0;			%Quarantine rate
		alpha_s		= 0;			%Drop in beta as S grows
		alpha_c		= 0;			%Drop in beta as C grows (fear)
		alpha_sc	= 0;			%Drop in beta as SxC grows. Huh.
	case {4,5,6,7,8,9,10,11}
		%case 4 (US)
		C = 0.0000013;
		beta_c		= 5/10;		%Contact rate while symptomatic
		beta_a		= 5/10;		%Contact rate while asymptomatic (high!)
		gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
		d_c			= 0.004;		%disease death rate
		
		%Common attributes
		rho			= 1/3;			%Asymptomatic period
		chi			= 0;			
		alpha_c		= 0;			
		%
		beta_q		= 0;			
		gamma_q		= gamma_c;		
		gamma_a		= gamma_c;		
		d_q			= d_c;			
		d_a			= 0;			
		tau			= 1/2;			
		alpha_s		= 0;					
		alpha_sc	= 0;	
		switch(K)
			case 5
				%Hubei
				C = 0.00014;
				beta_c		= 2.5/10;		%Contact rate while symptomatic
				beta_a		= 2.5/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
				chi = 0.0;
			case 6
				%South Korea
				C = 0.000013;
				beta_c		= 2/10;%1.3/12;		%Contact rate while symptomatic
				beta_a		= 2/10;%2.8/12;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
				chi = 0.06;
			case 7
				%Germany
				C = 0.000009;
				beta_c		= 5/10;		%Contact rate while symptomatic
				beta_a		= 5/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
			case 8
				%Italy
				C = 0.000038;
				beta_c		= 3.8/10;		%Contact rate while symptomatic
				beta_a		= 4.5/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
			case 9
				%Iran
				C = 0.00001;
				beta_c		= 4/10;		%Contact rate while symptomatic
				beta_a		= 4/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
			case 10
				%Spain
				C = 0.000035;
				beta_c		= 6/10;		%Contact rate while symptomatic
				beta_a		= 6.5/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
			case 11
				%France
				C = 0.0000005;
				beta_c		= 4.5/10;		%Contact rate while symptomatic
				beta_a		= 5/10;		%Contact rate while asymptomatic (high!)
				gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
				d_c			= 0.004;		%disease death rate
		end
		case 12
		%Flatten the curve example
		C = 0.00002;
		beta_c		= 1.5/10;		%Contact rate while symptomatic
		beta_q		= 0.0;			%Leaking from quarantine
		beta_a		= 2/10;		%Contact rate while asymptomatic (high!)
		gamma_c		= 1/10;			%recovery rate (1/r is the infectious period)
		gamma_q		= gamma_c;		%Recovery rate from quarantine (faster?)
		gamma_a		= gamma_c;		%Recovery rate from asymptomatic (same, or 0?)
		d_c			= 0.002;		%disease death rate
		d_q			= d_c;			%disease death rate from quarantine (lower?)
		d_a			= 0;			%disease death rate from asymptomatic
		tau			= 1/2;			%1/Incubation preiod before contagious (No, this is actually "latency")
		rho			= 1/3;			%1/Asymptomatic period
		%Behavior:
		chi			= 0.0;			%Quarantine rate
		alpha_s		= 0;			%Drop in beta as S grows
		alpha_c		= 0;			%Drop in beta as C grows (fear)
		alpha_sc	= 0;			%Drop in beta as SxC grows. Huh.
				
		
end

S = 1-C;

x = [S;E;A;C;Q;R;D];
p = [lamda;mu;beta_c;beta_q;beta_a;chi;...
	gamma_c;gamma_q;gamma_a;d_c;d_q;d_a;tau;rho;alpha_s;alpha_c;alpha_sc];

return
%% -------------------- THE END ---------------- %%
