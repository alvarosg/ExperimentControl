% (c) Alvaro Sanchez Gonzalez 2014
classdef TektronixTDS620AWaveformAcquisitionDevice<TektronixTDS620AAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
    end
    
    methods
        function o=TektronixTDS620AWaveformAcquisitionDevice(deviceInfo)
            o = o@TektronixTDS620AAcquisitionDevice(deviceInfo);              
        end
      
           
        function acquisition(o)
            o.controller.read_scale();
            [traces, t]=o.controller.single_acq();

            if(o.values.count==0)
                o.values.t=t;
                o.values.t_units='s';
                o.values.units='V';
                o.values.avg=traces;
                o.values.std=traces.^2;
            else
                o.values.avg=o.values.avg+traces;
                o.values.std=o.values.std+traces.^2;
            end
            o.values.count=o.values.count+1;
            
        end
     
    end    
end
