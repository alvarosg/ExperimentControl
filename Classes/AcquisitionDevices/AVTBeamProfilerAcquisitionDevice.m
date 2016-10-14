% (c) Alvaro Sanchez Gonzalez 2014
classdef AVTBeamProfilerAcquisitionDevice<ImageAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function o=AVTBeamProfilerAcquisitionDevice(deviceInfo)
            o = o@ImageAcquisitionDevice(deviceInfo);
        end
        
        function initialize(o)
            % 2/10/2014 changed from AVT to GENTL by Dane
            o.cameraController=CameraViewerStd('GENTL.Controller','BeamProfileViewer',figure,o.deviceInfo.name);
            set(o.cameraController.processor.flatten_colour,'Value',1);

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
