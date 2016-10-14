% (c) Alvaro Sanchez Gonzalez 2014
classdef AbstractAcquisitionDevice<handle
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        deviceInfo
        acquisitionDevicesHand
        exposure
        
    end
    
    methods
        function o=AbstractAcquisitionDevice(deviceInfo)
            o.deviceInfo=deviceInfo;
            MessageSystem.get().printMessage('ACQUISITION',sprintf('Initialized %s ',o.deviceInfo.name),true);
            o.initialize();
        end
        
        function mode=getMode(o)
            mode=getNameMode(o.deviceInfo.type);
        end
        
        function acquire(o)
            try
                MessageSystem.get().printMessage('ACQUISITION',sprintf('Acquiring %s (Exposure %g ms)',o.deviceInfo.name,o.exposure),false);
            	o.acquisition();           
                MessageSystem.get().printMessage('ACQUISITION',sprintf('Acquired %s (Exposure %g ms)',o.deviceInfo.name,o.exposure),true);
            catch error
                getReport(error)
                MessageSystem.get().printMessage('ERROR',sprintf('Error to acquire from %s',o.deviceInfo.name),true);
            end
        end
    end
    
    methods (Static)
        initialize(o);
        resetBuffer(o);
        acquisition(o);
        retrieve(o);       
        retrieveReduced(o);
        setExposure(o);
        getExposure(o);
        isStillValid(o);
        show(o);
    end
    
end

