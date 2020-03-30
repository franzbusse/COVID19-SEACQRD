%% Corona
%
% Script to display Virus Data.
% Will also start hosting a model & sim...
% Prep:
% 1. Import Death data, save as table D.
% 2. Import confirmed case data, save as table C.
% 3. Save: >> save CoronaData D C
% Then run this script
%
% by Franz Busse, Mar 2020
%% --------------------------------------------- %%
path('TheHood',path);
MyHeader

%% User Settings:
datafile = 'CoronaData.mat';
t1 = datetime(2020,1,22);
countries = {'US','China','Korea, South','Germany','Italy','Iran','Spain','France'};
pops = [327.2,1386,51.47,82.79,60.48,81.16,46.66,66.99]*1e6;
subs = [2 1 3];
USfc = 34157;
DoHubei = 1;

%% Setup:
%Load data:
load(datafile);
N = length(countries);
Nd = size(D,2);
Nc = size(C,2);
Nd = min([Nc Nd]) - 4;

%Dates:
dateD = t1 + caldays(0:Nd-1);

% Memory:
TotD = NaN(Nd,N);
TotC = NaN(Nd,N);
DayD = NaN(Nd-1,N);
DayC = NaN(Nd-1,N);
CFR = NaN(Nd,N);
Crude = NaN(Nd,N);

%Comparison:
USfluppm = (USfc/pops(1))*1e6;

if(DoHubei)
    countries(2) = {'Hubei'};
    pops(2) = 58.5e6;
end

for i = 1:N
    %Find particular country:
    if(i==2 && DoHubei)
        %China: Hubei only!
        Temps = D(strcmp(D.ProvinceState,countries(i)),:);
    else
        Temps = D(strcmp(D.CountryRegion,countries(i)),:);
    end
    
    %Remove Counties (in the US):
        Temps = Temps(~contains(Temps.ProvinceState,','),:);
    
    TotD(:,i) = sum(Temps{:,5:end},1)';
    DayD(:,i) = diff(TotD(:,i));
    
    %Cases:
    %Find particular country:
    if(i==2 && DoHubei)
        %China: Hubei only!
        Temps = C(strcmp(C.ProvinceState,countries(i)),:);
    else
    Temps = C(strcmp(C.CountryRegion,countries(i)),:);
    end
    
    %Remove Counties (in the US):
        Temps = Temps(~contains(Temps.ProvinceState,','),:);

    
    TotC(:,i) = sum(Temps{:,5:end},1)';
    DayC(:,i) = diff(TotC(:,i));
    
    CFR(:,i) = (TotD(:,i)./TotC(:,i))*100;
    Crude(:,i) = (TotD(:,i)./pops(i))*1e6;
    
end

save RealData countries Crude

%% Display Results:
if(1)
    figure
    for i = 1:N
        plot(dateD,TotD(:,i));
        hold on;
    end
    grid on;
    ylabel('Cumulative Deaths');
    vgfig
    legend(countries,'Location','northwest');
end
if(1)
    figure
    for i = 1:N
        plot(dateD,TotC(:,i));
        hold on;
    end
    grid on;
    ylabel('Cumulative Cases');
    vgfig
    legend(countries,'Location','northwest');
end

if(1)
    figure
    for i = 1:N
        plot(dateD,CFR(:,i));
        hold on;
    end
    grid on;
    ylabel('CFR (%)');
    vgfig
    legend(countries,'Location','northwest');
end
if(1)
    figure
    for i = 1:N
        plot(dateD,Crude(:,i));
        hold on;
    end
    plot([dateD(1) dateD(end)],[USfluppm USfluppm],'k:');
    grid on;
    ylabel('Crude Fatality (ppm)');
    vgfig
    legend(countries,'Location','northwest');
end

if(0)
    figure
    for i = 1:N
        plot(dateD(2:end),DayD(:,i));
        hold on;
    end
    grid on;
    ylabel('Daily Deaths');
    vgfig
end

if(1)
    subc = countries(subs);
    subD = DayD(:,subs);
    
    figure
    bar(dateD(2:end),subD);%,'stacked');
    grid on;
    ylabel('Daily Deaths');
    legend(subc,'Location','northwest');
    vgfig
end
