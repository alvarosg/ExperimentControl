% (c) Alvaro Sanchez Gonzalez 2014

stagesHand=StagesListHandler('C:/config/Stages.mat');

fig=figure('name','Stages List','NumberTitle','off','position',[100 600 700 100]);
set(fig, 'menubar', 'none');
vg1 = uiflowcontainer('v0','Parent',fig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
StagesListWindow(vg1,stagesHand);
