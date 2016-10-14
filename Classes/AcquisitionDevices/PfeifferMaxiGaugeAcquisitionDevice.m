% (c) Alvaro Sanchez Gonzalez 2014
classdef PfeifferMaxiGaugeAcquisitionDevice<AbstractAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        port
        serialPort
        pressures
    end
    
    methods
        function o=PfeifferMaxiGaugeAcquisitionDevice(deviceInfo)
            o = o@AbstractAcquisitionDevice(deviceInfo);  
            
        end
        
        function initialize(o)
            o.setExtraParam(o.deviceInfo.extraparam)
            o.port=o.deviceInfo.extraparam;
            o.serialPort = serial(o.port,'BaudRate',9600);
            fopen(o.serialPort);
            o.exposure=0;
        end
        
        function delete(o)
            fclose(o.serialPort);
        end    
        
        function destroy(o)
            fclose(o.serialPort);
        end 
        
        function reconnect(o)
            if(isvalid(o.serialPort))
                fclose(o.serialPort);
            end
            o.serialPort = serial(o.port,'BaudRate',9600);
            fopen(o.serialPort);
        end
        
        function setExposure(o,msExposure)
            o.exposure=msExposure;
        end
        
        function msExposure = getExposure(o)
            msExposure=o.exposure;
        end
        
        function setExtraParam(o,extraparam)
            o.port=extraparam;            
            o.deviceInfo.extraparam=extraparam;            
        end
                
        function resetBuffer(o)                  
            o.pressures.avg=0; 
            o.pressures.std=0; 
            o.pressures.count=0; 
        end
        function acquisition(o)
            
            for i=1:6
                pressures(i)=o.getPressureIndex(i);
            end

            if(o.pressures.count==0)
                o.pressures.avg=double(pressures);
                o.pressures.std=double(pressures).^2;
            else
                o.pressures.avg=o.pressures.avg+double(pressures);
                o.pressures.std=o.pressures.std+double(pressures).^2;
            end
            o.pressures.count=o.pressures.count+1;
            
        end
        function pressures=retrieve(o)
            pressures=o.pressures; %Create a copy
            pressures=o.normalize(pressures);       
        end
        
        function pressures=retrieveReduced(o)
            pressures=o.pressures; %Create a copy
            pressures=o.normalize(pressures);
        end
        
        
        function pressures=normalize(o,pressures)
            pressures.avg=pressures.avg/pressures.count;
                    
            if(pressures.count>1) %Calculate the standard deviation only if there is more than one image (otherwise it is 0)
                pressures.std=sqrt(1/(pressures.count-1)*(pressures.std-pressures.count*pressures.avg.^2));   %sd= sqrt(1/(N-1)*(sum (xi^2)-N*(mean(x)^2))
            else
                pressures.std=0;
            end 
        end        
        
        function state=isStillValid(o)
            state=isvalid(o.serialPort);
        end
        
        function show(o)
        end  
        
        function pressure=getPressureIndex(o,i)
            fprintf(o.serialPort, sprintf('PR%d\n',i));
            fscanf(o.serialPort);
            fprintf(o.serialPort, '%c',5);
            tmp=fscanf(o.serialPort);
            if(tmp(1)=='0')
                pressure=str2double(tmp(3:end));
            else
                pressure=NaN;
            end
        end
    end    
end
