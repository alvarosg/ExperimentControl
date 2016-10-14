% (c) Alvaro Sanchez Gonzalez 2014
classdef PiezoTestStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        controller
    end
    
    methods
        function o = PiezoTestStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)                  
            o.pos=0;
        end
        function destroy(o)
        end
        function outPosition=gotoPosition(o,position)
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

