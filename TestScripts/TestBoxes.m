% (c) Alvaro Sanchez Gonzalez 2014
clear all
close all
clc

%load clown
%figure;
%axis=gca;
%imagesc(X);

boxHand=BoxesHandler('Boxes.mat');
rectangleHand=CropRectangleHandler('CropRectangle.mat');

lala.name='webCam';
camera=WebCamAcquisitionDevice(lala);


fig=figure('name','Set Boxes and Crop Rectangle','NumberTitle','off','position',[100 600 900 200]);
set(fig, 'menubar', 'none');
vg1 = uiflowcontainer('v0','Parent',fig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
BoxesWindow(vg1,boxHand,camera.getAxes());
CropRectangleWindow(vg1,rectangleHand,camera.getAxes());


