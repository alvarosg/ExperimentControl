% (c) Alvaro Sanchez Gonzalez 2014
classdef TektronixTDS620AAcquisitionDevice<AbstractAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        controller
        channels
        values
    end
    
    methods
        function o=TektronixTDS620AAcquisitionDevice(deviceInfo)
            o = o@AbstractAcquisitionDevice(deviceInfo);  
            
        end
        
        function initialize(o)            
            o.controller=TekScopePulseTrainMon;
            o.setExtraParam(o.deviceInfo.extraparam)
            o.exposure=0;
        end
        
        function delete(o)
            delete(o.controller.container.Parent)
            delete(o.controller);
        end    
        
        function destroy(o)
            delete(o.controller.container.Parent)
            delete(o.controller);
        end 
        
        function setExposure(o,msExposure)
            o.exposure=msExposure;
        end
        
        function msExposure = getExposure(o)
            msExposure=o.exposure;
        end
        
        function setExtraParam(o,extraparam)
            o.channels=str2num(extraparam);            
            o.deviceInfo.extraparam=extraparam;
            
            for i=1:4
                if(~isempty(find(o.channels==i)))
                    set(o.controller.channels.checkboxes(i),'value',true);
                else
                    set(o.controller.channels.checkboxes(i),'value',false);
                end
            end
            
            o.controller.channels_changed();
        end
                
        function resetBuffer(o)                  
            o.values.avg=0; 
            o.values.std=0; 
            o.values.count=0; 
            o.values.channels=o.channels;
        end

        function values=retrieve(o)
            values=o.values; %Create a copy
            values=o.normalize(values);       
        end
        
        function values=retrieveReduced(o)
            values=o.values; %Create a copy
            values=o.normalize(values);
        end
        
        
        function values=normalize(o,values)
            values.avg=values.avg/values.count;
                    
            if(values.count>1) %Calculate the standard deviation only if there is more than one image (otherwise it is 0)
                values.std=sqrt(1/(values.count-1)*(values.std-values.count*values.avg.^2));   %sd= sqrt(1/(N-1)*(sum (xi^2)-N*(mean(x)^2))
            else
                values.std=0;
            end 
        end        
        
        function state=isStillValid(o)
            state=isvalid(o.controller.container);
        end    
        
        function show(o)
            figure(o.controller.container.Parent)
        end           
    end    
    
    methods (Static)
        acquisition(o);
    end
end
