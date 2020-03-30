%Function: Preps figures for viewgraphs
%
%	vgfig2(font,linewidth,sizefig)
%
% Adjusts current figure for viewgraphs
%
% Inputs:
%	font	= Point size for: [axes labels titles] (14,14,14)
%	linewidth	= Width for lines (1.5)
%	sizefig		= Figure pages size inches (current size)
% Outputs: none
%
% Ed Baranoski, copyright 1996
%   --created 8/96, ejb
% Vastly modified by F. Busse, Aug 2003

%% +------------------------------------------------------------+ %%
function vgfig(font,linewidth,sizefig)

%First step:
set(gcf,'Units','inches');

% setup default fontsizes
if (nargin<1 || isempty(font))
	font=[12 14 16];
end
if (nargin<2 || isempty(linewidth))
	linewidth=1.5;
end
if (nargin<3)
    t = get(gcf,'Position');
	sizefig = t(3:4);
end

%% Fonts:
axesfont=font(1);
if length(font)<2,
	labelfont=axesfont;
else
	labelfont=font(2);
end
if length(font)<3,
	titlefont=labelfont;
else
	titlefont=font(3);
end

%% Find children & edit:
texts = findall(gcf,'Type','text');
for k = 1:length(texts)
    set(texts(k),'FontSize',labelfont,'FontWeight','bold',...
		'FontName','Arial');
end
liness = findall(gcf,'Type','line');
for k = 1:length(liness)
    set(liness(k),'LineWidth',linewidth);
end
axess = findall(gcf,'Type','axes');
for k = 1:length(axess)
    set(axess(k),'LineWidth',linewidth,'Fontsize',axesfont,...
		'FontWeight','bold','FontName','Arial');
end
set(get(gca,'Title'),'FontSize',titlefont)

%% Rescale figure
cursiz = get(gcf,'Position');
newsize = cursiz;
newsize(3:4) = sizefig;
newsize(1:2) = cursiz(1:2) - (newsize(3:4)-cursiz(3:4));
pos=get(gcf,'PaperPosition');
newpos = pos;
newpos(3:4) = sizefig;
newpos(1:2) = [1 1];
set(gcf,'PaperPosition',newpos)
set(gcf,'Position',newsize)

return
%% -------------- THE END --------- %%