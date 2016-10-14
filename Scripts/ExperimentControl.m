% (c) Alvaro Sanchez Gonzalez 2014
clc

fig=figure('name','Experiment Control','NumberTitle','off','position',[50 50 1200 900]);
set(fig, 'menubar', 'none');
o = ExperimentControlWindow(fig,'C:\config','L:\reddragon\XiHHG\RawData');
