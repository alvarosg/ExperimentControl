% open matlab as server
MOIP.connect('server');
% start slow loop
slow_loop=CEP.slowloop([],'OmniDriver.Controller','C:\Users\reddragon\Documents\idler_slowloop_settings.mat');
