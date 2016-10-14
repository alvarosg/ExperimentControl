% (c) Alvaro Sanchez Gonzalez 2014
classdef OceanOpticsRemoteSpectrometerAcquisitionDevice<AbstractAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        window
        spectrum
        ip
        tcpObj
    end
    
    methods
        function o=OceanOpticsRemoteSpectrometerAcquisitionDevice(deviceInfo)
            o = o@AbstractAcquisitionDevice(deviceInfo);              
        end
        
        function initialize(o)
            o.setExtraParam(o.deviceInfo.extraparam)
            o.tcpObj=MOIP.connect('client',o.ip);
            o.exposure=100;
            %o.setExposure(o.exposure);
            o.window=SpectrumPlotWindow(o);
        end
        
        function show(o)
            if(isvalid(o.window))
                figure(o.window.window);
            else
                o.window=SpectrumPlotWindow(o);
            end
        end
        
        function reconnect(o)
            o.tcpObj=MOIP.connect('client',o.ip);
        end
        
        function setExposure(o,msExposure)
            o.exposure=msExposure;
            rollingAvg=round(o.exposure/100); %100 is the inverse of 10 pictures/second, in ms.
            rollingAvg=max(1,rollingAvg);
                       
            MOIP.eval(o.tcpObj,sprintf('remoteSpectrometer.gui.rolling_ave_num.value=%d',rollingAvg),true);
            MOIP.eval(o.tcpObj,'remoteSpectrometer.resetRollingAvePushed();',true);
        end
        
        function msExposure = getExposure(o)
            msExposure=o.exposure;
        end
        
        function setExtraParam(o,extraparam)
            o.ip=extraparam;            
            o.deviceInfo.extraparam=extraparam;            
        end
                
        function resetBuffer(o)                  
            o.spectrum.avg=0;
            o.spectrum.std=0;
            o.spectrum.count=0;  
            o.spectrum.exposure=o.exposure;
        end
        function acquisition(o)              
            [spectrum,o.spectrum.wl,o.spectrum.timestamp,o.spectrum.params]=MOIP.eval(o.tcpObj,'CurrentSpectrum(remoteSpectrometer)',true);
            %o.spectrum.wl=700:1:900;
            %o.spectrum.wl=o.spectrum.wl';
            %spectrum=rand(size(o.spectrum.wl));
            if(o.spectrum.count==0)
                o.spectrum.avg=double(spectrum);
                o.spectrum.std=double(spectrum).^2;
            else
                o.spectrum.avg=o.spectrum.avg+double(spectrum);
                o.spectrum.std=o.spectrum.std+double(spectrum).^2;
            end           
            o.spectrum.count=o.spectrum.count+1;            
        end
        function spectrum=retrieve(o)
            spectrum=o.spectrum; %Create a copy
            spectrum=o.normalize(spectrum);         
        end
        
        function spectrum=retrieveReduced(o)
            spectrum=o.spectrum; %Create a copy
            spectrum=o.normalize(spectrum);
        end
        
        
        function spectrum=normalize(o,spectrum)
            spectrum.avg=spectrum.avg/spectrum.count;
                    
            if(spectrum.count>1) %Calculate the standard deviation only if there is more than one image (otherwise it is 0)
                spectrum.std=sqrt(1/(spectrum.count-1)*(spectrum.std-spectrum.count*spectrum.avg.^2));   %sd= sqrt(1/(N-1)*(sum (xi^2)-N*(mean(x)^2))
            else
                spectrum.std=0;
            end 
        end        
        
        function state=isStillValid(o)
            state=isvalid(o);
        end
        
        function delete(o)
            delete(o.window);
        end
    end    
end
