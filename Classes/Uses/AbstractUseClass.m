% (c) Alvaro Sanchez Gonzalez 2014
classdef AbstractUseClass<handle
    %ABSTRACTUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageController
        stageInfo
        stagesHand
        lastPos
    end
    
    methods
        function o = AbstractUseClass(stageInfo,stageController,stagesHand)            
            o.stageController=stageController;
            o.stageInfo=stageInfo;
            o.stagesHand=stagesHand;
            if (length(stageController)>0) && (~strcmp(stageInfo.name,'IR Block'))
                o.stageController.home();
            end
        end
        
        function unit = units(o)
            unit = StageUses.getNameUnits(o.stageInfo.use);
        end
        
        function setPosition(o,varPosition) 
            
            if(~ischar(varPosition))            
                if(varPosition<o.minPosition)
                    varPosition=o.minPosition;                
                elseif( varPosition>o.maxPosition)
                    varPosition=o.maxPosition;
                end   
            end
                        
            o.lastPos=varPosition;
            stagePos=o.varPos2stagePos(varPosition);
            o.stageController.setPosition(stagePos);
            position=o.position();
            if (~ischar(position))
                pos=sprintf('%g',position);
            else
                pos=position;
            end
            MessageSystem.get().printMessage('USE',sprintf('Moved %s to %s %s',o.stageInfo.name,pos, StageUses.getNameUnits(o.stageInfo.use)),true);                        
            UseMovementMixer.MoveExtraStages(o,varPosition);
        end
        
        function varPosition=position(o)
            stagePosition= o.stageController.position();
            varPosition=o.stagePos2varPos(stagePosition);
            o.lastPos=varPosition;
        end
        
        function minVarPos=minPosition(o)
            stagePosition= o.stageController.minPosition();
            minVarPos=o.stagePos2varPos(stagePosition);
        end
        
        function maxVarPos=maxPosition(o)
            stagePosition= o.stageController.maxPosition();
            maxVarPos=o.stagePos2varPos(stagePosition);
        end
    end
    
    methods (Abstract)
        stagePosition=varPos2stagePos(o,varPosition)
        varPosition=stagePos2varPos(o,stagePosition)
    end
    
end

