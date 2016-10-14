% (c) Alvaro Sanchez Gonzalez 2014
classdef OWISTranslationStageClass<AbstractStageClass
    %OWIS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        serialObj
        data
        cmds %serial command strings
    end
    
    methods
        function o = OWISTranslationStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial; %actually a COMport here
            o.initialize;
        end
  
        function initialize(o)
            o.serialObj = serial('COM5','BaudRate',115200);
            fopen(o.serialObj);
            o.cmds.home = 'G28\n';
            o.cmds.stop = 'M0\n';
            o.cmds.getPos_FeedRate = 'M114\n';
            o.cmds.AbsMode = 'G90\n';
            o.cmds.goTo = 'G0';
            fprintf(o.serialObj,o.cmds.AbsMode);
            %Arduino sends back the command that was just sent, so we need
            %to get it out of the buffer
            for ii = 1:4
                tmp{ii} = fscanf(o.serialObj);
            end
            o.updatePosition;
        end
        function destroy(o)
            fclose(o.serialObj);
            delete(o.serialObj);
        end
        function outPosition=gotoPosition(o,position)
            fprintf(o.serialObj,[o.cmds.goTo ' X' num2str(round(position/5)) '\n']);
            %get command out of buffer
            for ii = 1:4
                tmp{ii} = fscanf(o.serialObj);
            end
            abortTimer = tic;
            while abs(o.pos - round(position))>5 && toc(abortTimer)<40
                updatePosition(o)
                pause(0.5)
            end
            outPosition = o.pos;
        end
        
        
        function updatePosition(o)
            pause(0.05) %pause to let serial port catch up
            fprintf(o.serialObj,o.cmds.getPos_FeedRate);
            pause(0.05)
            for ii = 1:8
                tmp{ii} = fscanf(o.serialObj);
            end
            o.pos = 5*str2double(tmp{3}(2:end));
        end
               
        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=60e3; %40 mm in um  
        end
        
        function home(o)
            home@AbstractStageClass(o);
            MessageSystem.get().printMessage('STAGE',sprintf('Homing %s',o.stageInfo.name),false);
%             fprintf(o.serialObj,o.cmds.home);
            MessageSystem.get().printMessage('STAGE',sprintf('%s homed',o.stageInfo.name),true); 
            updatePosition(o)
        end
    end    
end

