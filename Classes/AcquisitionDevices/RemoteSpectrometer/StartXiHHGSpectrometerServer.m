% (c) Alvaro Sanchez Gonzalez 2014
MOIP.connect('server');
remoteSpectrometer=SpectrometerAcquirer('OmniDriver.Controller');
set(remoteSpectrometer.controller.gui.opened,'Value',1);
remoteSpectrometer.controller.set_online(get(remoteSpectrometer.controller.gui.opened,'Value'));