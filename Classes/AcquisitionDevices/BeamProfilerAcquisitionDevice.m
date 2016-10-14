% (c) Alvaro Sanchez Gonzalez 2014
classdef BeamProfilerAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function o=BeamProfilerAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
            o.exposure=0;
        end
        
        function initialize(o)
            o.cameraController=BeamProfiler('WinVideo.Controller');
        end
        
        function setExposure(o,msExposure)
            o.exposure=msExposure;
        end
        function msExposure = getExposure(o)
            msExposure=o.exposure;
        end
        
        function show(o)
            figure(o.cameraController.Parent)
        end 
        
        function delete(o)
            delete(o.cameraController.Parent)
        end
    end
    
end
