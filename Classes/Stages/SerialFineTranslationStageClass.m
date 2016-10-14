% (c) Alvaro Sanchez Gonzalez 2014
classdef SerialFineTranslationStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        controller
    end
    
    methods
        function o = SerialFineTranslationStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize();
        end
  
        function initialize(o)
            %delete(instrfindall);
            %instrreset
            o.controller = serial(o.serial,...
                'BaudRate',115200,...
                'DataBits', 8, ...
                'Parity', 'none',...
                ...%'StopBits', 1,...
                'FlowControl', 'hardware');            
            fopen(o.controller);
            fprintf(o.controller, 'SVO 1 1\n');
            pause(0.3)
            fprintf(o.controller, 'POS? 1\n');
            tmp=fscanf(o.controller);
            o.pos=round(str2double(tmp(3:end)));
            
        end
        function destroy(o)
            delete(o.controller);
        end
        
        function delete(o)
            fclose(o.controller);
        end
        
        function outPosition=gotoPosition(o,position)
            fprintf(o.controller, sprintf('MOV 1 %.2f\n', position));
            pause(0.3)
            %fprintf(o.controller, 'ERR?\n');
            %tmp=fscanf(o.controller)
            fprintf(o.controller, 'POS? 1\n');
            tmp=fscanf(o.controller);
            outPosition = round(str2double(tmp(3:end))*1000)/1000;     
        end
               
        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=250;  
        end
        function updatePosition(o)
        end
    end    
end

