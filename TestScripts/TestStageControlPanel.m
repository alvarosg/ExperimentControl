% (c) Alvaro Sanchez Gonzalez 2014
clear all
close all
clc


stagesHand=StagesListHandler('Stages.mat');

fig=figure('name','Stages List','NumberTitle','off','position',[200 000 700 800]);
set(fig, 'menubar', 'none');
vg1 = uiflowcontainer('v0','Parent',fig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
StageControllerPanel(vg1,stagesHand);
