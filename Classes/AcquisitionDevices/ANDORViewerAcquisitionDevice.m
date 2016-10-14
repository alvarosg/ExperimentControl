% (c) Alvaro Sanchez Gonzalez 2014
classdef ANDORViewerAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function o=ANDORViewerAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
        end
        
        function initialize(o)
            o.cameraController=CameraViewerStd('ANDOR.Controller','XUVFlatFieldGratSpectrViewer',figure,o.deviceInfo.name);
        end
        
        function  setExposure(o,msExposure)
             o.cameraController.camera.gui.exposure.Value=msExposure;
            o.exposure= o.cameraController.camera.gui.exposure.Value;
        end
        function msExposure = getExposure(o)
            o.exposure= o.cameraController.camera.gui.exposure.Value;
            msExposure=o.exposure;
        end
        
        function show(o)
            figure(o.cameraController.container.Parent)
        end 
        
        function delete(o)
            delete(o.cameraController.container.Parent)
        end
    end
    
end
