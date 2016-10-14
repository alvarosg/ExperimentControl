% (c) Alvaro Sanchez Gonzalez 2014

metadataHand=MetadataListHandler('C:/config/MetadataFields.mat');

fig=figure('name','Devices List','NumberTitle','off','position',[100 600 500 100]);
set(fig, 'menubar', 'none');
vg1 = uiflowcontainer('v0','Parent',fig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
MetadataListWindow(vg1,metadataHand);
