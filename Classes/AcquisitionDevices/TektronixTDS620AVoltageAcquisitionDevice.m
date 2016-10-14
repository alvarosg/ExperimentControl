% (c) Alvaro Sanchez Gonzalez 2014
classdef TektronixTDS620AVoltageAcquisitionDevice<TektronixTDS620AAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
    end
    
    methods
        function o=TektronixTDS620AVoltageAcquisitionDevice(deviceInfo)
            o = o@TektronixTDS620AAcquisitionDevice(deviceInfo);  
            
        end
      
           
        function acquisition(o)
            o.controller.read_scale();
            [traces, ~]=o.controller.single_acq();
            values=max(traces,[],1)-min(traces,[],1);

            if(o.values.count==0)
                o.values.avg=values;
                o.values.std=values.^2;
            else
                o.values.avg=o.values.avg+values;
                o.values.std=o.values.std+values.^2;
            end
            o.values.count=o.values.count+1;
            
        end
     
    end    
end
