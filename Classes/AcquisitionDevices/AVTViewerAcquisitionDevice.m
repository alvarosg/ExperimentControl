% (c) Alvaro Sanchez Gonzalez 2014
classdef AVTViewerAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function o=AVTViewerAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
        end
        
        function initialize(o)
            % 2/10/2014 changed from AVT to GENTL by Dane
            o.cameraController=CameraViewerStd('GENTL.Controller','XUVFlatFieldGratSpectrViewer',figure,o.deviceInfo.name);
        end
        
        function  setExposure(o,msExposure)
            o.cameraController.camera.ext_shutter.Value=msExposure;
            o.exposure=o.cameraController.camera.ext_shutter.Value;
        end
        function msExposure = getExposure(o)
            o.exposure=o.cameraController.camera.ext_shutter.Value;
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
