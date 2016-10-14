% (c) Alvaro Sanchez Gonzalez 2014
classdef ThorlabsFW102CStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        data
        path='C:\matlab_repository\lib_alvaro\ExperimentControl\Classes\Stages\FW102C\MoveFW102C.exe';
    end
    
    methods
        function o = ThorlabsFW102CStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            command=[o.path ' ' o.serial(4:end)];
            [status, ~] = dos(command);
            if(status>=1 && status<=6)      
                o.pos=status;
            else
                error('Not possible to communicate');
            end
        end
        function destroy(o)
        end
        function outPosition=gotoPosition(o,position)
            command=[o.path ' ' o.serial(4:end) ' ' num2str(position)];
            [status, ~] = dos(command);
            if(status>=1 && status<=6)      
                outPosition=status;
            else
                outPosition=-1;
                error('Not possible to communicate');
            end
        end
        
        function updatePosition(o)
            command=[o.path ' ' o.serial(4:end)];
            [status, ~] = dos(command);
            if(status>=1 && status<=6)      
                o.pos=status;
            else
                error('Not possible to communicate');
            end
        end
               
        function minPos=minPosition(o)
            minPos=1;            
        end
        function maxPos=maxPosition(o)
            maxPos=6;  
        end
        
        function home(o)
        end
    end    
end

