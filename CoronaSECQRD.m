%% CoronaSim
%
% Script to simulate SIR model of disease spread
% S:	Susceptible population
% I:	Infected population
% R:	Recovered population
%
% by Franz Busse, Mar 2020
%% --------------------------------------------- %%
path('TheHood',path);
MyHeader

%% User settings:
STUDY = 4;	%1: single case, 2: compare 2 cases, 3: 2Dsweep
Dcase = 4;	%1 = seasonal flu, 2 = Corona
N = 300; %Time steps (days)
FC = 1:8;

% Reaction model:
StartMit = Inf;	%Time when instigate changes.
mitfact = 0.1;
mitdur = 100;

%% Setup:
load RealData

%Load up vectors:
switch(STUDY)
	case 1
		var1 = 1;
		var2 = 1;
	case 2
		var1 = [3 12];
		var2 = 1;	
	case 3
		var1 = [1 .8 .5 .3 .1 .05];
		var2 = [1 .8 .5 .3 .1 .05];
		%var2 = [21 42 90 180];
	case 4
		%var1 = 4:4+Nc;
		var1 = 3+FC;
		var2 = 1;
	case 5
		var1 = [1 .1];
		var2 = 0;
end

Nvar1 = length(var1);
Nvar2 = length(var2);

time = 1:N;
Cases = NaN(Nvar1,N);
Deaths = NaN(Nvar1,N);
FOM = NaN(Nvar1,Nvar2);
%Additional Disease Data input
if(FC>0)
	Allaxx = [30 3; 40 50; 35 4; 20 3; 35 120; 40 25; 25 65; 40 20];
	axx = Allaxx(FC,:);
	countries = countries(FC);
	Crude = Crude(:,FC);
	Nc = length(countries);
	Rdeath = NaN(size(Crude));
	for i = 1:Nc
		temp =  Crude(Crude(:,i)>0,i);
		nt = length(temp);
		Rdeath(1:nt,i) = temp;
	end
end

%% Run sim:
fprintf('iv1 iv2   R_0    Dead      CFR  \n');
fprintf('--------------------------------\n');
for iv1 = 1:Nvar1
	for iv2 = 1:Nvar2
		
		%Set study parameters
		if(STUDY==2||STUDY==4)
			Dcase = var1(iv1);
		end
		if(STUDY==3)
			mitfact = var1(iv1);
			mitfact2 = var2(iv2);
			%mitdur = var2(iv2);
		end
		if(STUDY==5)
			mitfact = 1;%var1(iv1);
			mitfact2 = var1(iv1);
			%mitfact = var2(iv2);
			%mitdur = var2(iv2);
		end
		
		%Initialize run
		x = NaN(7,N);
		[x(:,1),param] = CoronaScenarios(Dcase);
		fprintf('%2d  %2d  %5.2f',iv1,iv2,param(3)/param(7));
		
		for k = 2:N
			
			%Reaction
			if(k==StartMit)
				param(3) = param(3)*mitfact;
				param(5) = param(5)*mitfact2;
			end
% 			if(k==StartMit + mitdur)
% 				%Return to normal
% 				param(3) = param(3)*(.5/mitfact);
% 				param(5) = param(5)*(1/mitfact);
% 			end
			
			%Solve ODEs
			x(:,k) = RK_SECQRD(x(:,k-1),param);
			
			%Check for eradication
 			if(x(4,k)<x(4,1)*.5)
				break
			end
		end
		
		fprintf('   %5.2f%%',x(7,k)*100);
		fprintf('   %5.2f%% \n',(x(7,k)/x(6,k))*100);
		
		Cases(iv1,:) = x(4,:) + x(3,:) + x(5,:);
		Deaths(iv1,:) = x(7,:);
		
		FOM(iv1,iv2) = x(7,k);
	end
end

%% Display results
if(STUDY == 1)
	% Overall disease dynamic & zoom in
	for j = 1:2
		figure
		plot(time,x(1,:),'b');
		hold on;
		plot(time,x(2,:),'Color',[.4 .4 .4]);
		plot(time,x(3,:),'Color',[.4 0 0]);
		plot(time,x(4,:),'r');
		plot(time,x(5,:),'Color',[.65 .7 .65]);
		plot(time,x(6,:),'Color',[0 .4 0]);
		plot(time,x(7,:),'k');
		grid on;
		vgfig;
		xlabel('Time (days)');
		ylabel('Population');
		
	end
	axis([0 Inf 0 .02]);
	if(FC>0)
		figure
		plot(time,Deaths(1,:)*1e6,'k');
		hold on;
		plot(Rdeath);
		axis([0 axx(1) 0 axx(2)]);grid on;
		vgfig
	end
end
if(STUDY==4)
	% Plot comparison with countries.
	figure
	for i = 1:Nc
		plot(time,Deaths(i,:)*1e6,'k');
		hold on;
		plot(Rdeath(:,i));
	end
	%
	grid on;
	xlabel('Time (days)');
	ylabel('Deaths (ppm)');
	vgfig
	legend([{'Simulation'},countries],'Location','northwest');
	axis([0 axx(1) 0 axx(2)]);
	if(Nc==8)
		SubCountries(Rdeath,Deaths,countries,Allaxx)
	end
end

if(STUDY==2||STUDY==5)
	figure
	plot(time,Cases(1,:)*100,'r');
	hold on;
	grid on;
	plot(time,Cases(2,:)*100,'b');
	vgfig;
	xlabel('Time (days)');
	ylabel('Contagious Community (%)');
	legend({'Normal','Mitigated'},'Location','northeast');
	%
	figure
	plot(time,Deaths(1,:)*1e6,'r');
	hold on;
	grid on;
	plot(time,Deaths(2,:)*1e6,'b');
	vgfig;
	xlabel('Time (days)');
	ylabel('Deaths (ppm)');
end

if(STUDY==3)
	figure
	image(FOM*100,'CDataMapping','scaled');
	set(gca,'YDir','normal','XTick',1:Nvar2,'YTick',1:Nvar1,'XTickLabel',{var2},'YTickLabel',{var1});
	vgfig;
	colorbar;
	ylabel('Symptomatic Reduction');
	xlabel('Asymptomatic Reduction');
end


%% ---------------- THE END ---------------- %%