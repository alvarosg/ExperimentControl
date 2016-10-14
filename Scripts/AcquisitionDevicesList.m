% (c) Alvaro Sanchez Gonzalez 2014


devicesHand=AcquisitionDeviceListHandler('C:/config/AcquisitionDevices.mat');

fig=figure('name','Devices List','NumberTitle','off','position',[100 600 700 100]);
set(fig, 'menubar', 'none');
vg1 = uiflowcontainer('v0','Parent',fig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
AcquisitionDeviceListWindow(vg1,devicesHand);
