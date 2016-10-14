classdef OOSpectrometerAcquisitionDevice<AbstractAcquisitionDevice
    properties
        Acquirer
        spectrum
    end
    
    methods
        function o = OOSpectrometerAcquisitionDevice(deviceInfo)
            o = o@AbstractAcquisitionDevice(deviceInfo);
            o.setExtraParam(o.deviceInfo.extraparam);
        end
        
        
        function initialize(o)
            o.Acquirer = SpectrometerAcquirer('OmniDriver.ICTB_Controller');
            o.exposure = 0;
        end
        
        function setExtraParam(o,extraparam)    
            o.deviceInfo.extraparam = extraparam;
        end
        
        function acquisition(o)
            [intensity,lambda,timestamp,params] = o.Acquirer.acquire;
            o.spectrum.wl = lambda;
            o.spectrum.exposure = params.int_time_ms;
            o.exposure = params.int_time_ms;
            
            if(o.spectrum.count==0)
                o.spectrum.avg=double(intensity);
                o.spectrum.std=double(intensity).^2;
            else
                o.spectrum.avg=o.spectrum.avg+double(intensity);
                o.spectrum.std=o.spectrum.std+double(intensity).^2;
            end
            
            o.spectrum.count=o.spectrum.count+1;
            o.spectrum.params(o.spectrum.count) = params;
            o.spectrum.timestamp(o.spectrum.count) = timestamp;
            
            o.spectrum.single_shot_spectra(o.spectrum.count,:) = intensity;
        end
        
        function resetBuffer(o)
            o.spectrum.avg=0;
            o.spectrum.std=0;    
            o.spectrum.count=0;
            o.spectrum.single_shot_spectra=[];
            o.spectrum.exposure=o.getExposure();
            o.exposure = getExposure(o);
        end
        function spectrum = retrieve(o)
            spectrum = o.spectrum;
        end
       
        
        function spectrum=retrieveReduced(o)
            spectrum = o.spectrum;
        end
        
        function setExposure(o,msExposure)
            o.Acquirer.controller.setIntTime(msExposure);
            o.spectrum.exposure = msExposure;
            o.exposure = msExposure;
        end
        
        function msExposure = getExposure(o)
            msExposure = o.Acquirer.controller.getIntTime;
        end
        
        function delete(o)
            parent = o.Acquirer.container.Parent;
            delete(parent);
%             try 
%                 delete(o.Acquirer);
%             catch
%             end
        end
    end
     
    
end