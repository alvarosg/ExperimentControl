% (c) Alvaro Sanchez Gonzalez 2014
classdef RotationTestStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
    end
    
    methods
        function o = RotationTestStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            disp('Rotation Stage Initialized');
            o.pos=90;
        end
        function destroy(o)
            disp('Translation Stage Destroyed');
        end
        function outPosition=gotoPosition(o,position)
            disp(['Rotating to ' num2str(position)]);
            outPosition=position;
        end
               
        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=360;  
        end
        function updatePosition(o)
        end
    end    
end

