% (c) Alvaro Sanchez Gonzalez 2014
classdef TranslationTestStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
    end
    
    methods
        function o = TranslationTestStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            disp('Translation Stage Initialized');
            o.pos=1600;
        end
        function destroy(o)
            disp('Translation Stage Destroyed');
        end
        function outPosition=gotoPosition(o,position)
            disp(['Moving to ' num2str(position)]);
            outPosition=position;
        end

        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=100e3;  
        end
        
        function updatePosition(o)
        end
    end    
end

