% (c) Alvaro Sanchez Gonzalez 2014
classdef PixelFlyViewerAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function o=PixelFlyViewerAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
        end
        
        function initialize(o)
            o.cameraController=CameraViewerStd('PFUSB.Controller','XUVFlatFieldGratSpectrViewer',figure,o.deviceInfo.name);
        end
        
        function  setExposure(o,msExposure)
            o.cameraController.camera.ext_shutter.Value=msExposure;
            o.exposure=o.cameraController.camera.ext_shutter.Value;
        end
        function msExposure = getExposure(o)
            o.exposure=o.cameraController.camera.exposure_ms.Value;
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
