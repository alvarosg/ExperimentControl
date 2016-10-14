% (c) Alvaro Sanchez Gonzalez 2014
classdef AbstractStageClass<handle
    %ABSTRACTSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageInfo
        pos
    end
    
    methods
        function o = AbstractStageClass(stageInfo) 
            o.stageInfo=stageInfo;
            MessageSystem.get().printMessage('STAGE',sprintf('Initialized %s ',o.stageInfo.name),true);
        end
        
        function delete(o)
           o.destroy();
        end 
        
        function unit=units(o)
            unit = StageTypes.getNameUnits(o.stageInfo.type);
        end
        
        function setPositionRel(o,relPosition)
            currPosition=o.position();
            o.setPosition(currPosition+relPosition);
        end
        
        function setPosition(o,position)
            if(position<o.minPosition)
                position=o.minPosition;                
            elseif( position>o.maxPosition)
                position=o.maxPosition;
            end       
            
            try
                MessageSystem.get().printMessage('STAGE',sprintf('Moving %s to %g %s',o.stageInfo.name,position, StageTypes.getNameUnits(o.stageInfo.type)),false);            
                position=o.gotoPosition(position);
            catch error
                getReport(error)
                MessageSystem.get().printMessage('ERROR',sprintf('Error moving %s to %g %s',o.stageInfo.name,position, StageTypes.getNameUnits(o.stageInfo.type)),true);
            end
            
            StageMovementMixer.MoveExtraStages(o,position)
            
            if(position<o.minPosition)
                position=o.minPosition;                
            elseif( position>o.maxPosition)
                position=o.maxPosition;
            end                   
            MessageSystem.get().printMessage('STAGE',sprintf('Moved %s to %g %s',o.stageInfo.name,position, StageTypes.getNameUnits(o.stageInfo.type)),true);
            o.pos=position;
        end
        
        function position=position(o)   
            o.updatePosition();
            position=o.pos;
        end
        
        function home(o)
            
        end
    end
    
    methods (Abstract)
        destroy(o)
        outPosition=gotoPosition(o,position)       
        minPos=minPosition(o)
        maxPos=maxPosition(o)
        updatePosition(o)
    end
    
end

