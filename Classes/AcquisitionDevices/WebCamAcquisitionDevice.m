% (c) Alvaro Sanchez Gonzalez 2014
classdef WebCamAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function o=WebCamAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
        end
        
        function initialize(o)
            o.cameraController=CameraViewerStd('WinVideo.Controller','XUVFlatFieldGratSpectrViewer',figure,o.deviceInfo.name);
        end
        
        function setExposure(o,msExposure)
            o.cameraController.camera.exposure.value=msExposure;
            o.exposure=o.cameraController.camera.exposure.value;
            if(o.exposure<0)
                o.exposure=0;
            end
        end
        function msExposure = getExposure(o)
            o.exposure=o.cameraController.camera.exposure.value;
            if(o.exposure<0)
                o.exposure=0;
            end
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
