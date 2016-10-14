% (c) Alvaro Sanchez Gonzalez 2014
classdef PiezoStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        controller
    end
    
    methods
        function o = PiezoStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            o.controller=PIE816;                   
            o.pos=o.gotoPosition(0);
        end
        function destroy(o)
            win=o.controller.container.Parent;
            delete(o.controller);
            delete(win);
        end
        function outPosition=gotoPosition(o,position)
            o.controller.set_piezo_voltage_abs(position)
            pause(.1)
            outPosition=position;
        end
               
        function updatePosition(o)
        end
        
        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=100;  
        end
    end    
end

