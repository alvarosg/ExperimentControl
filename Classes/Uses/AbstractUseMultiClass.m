% (c) Alvaro Sanchez Gonzalez 2014
classdef AbstractUseMultiClass<handle
    %ABSTRACTUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageInfo
        stagesHand
        lastPos   
        num
        singleusecontrollers
    end
    
    methods
        function o = AbstractUseMultiClass(stageInfo,stagesHand,num)            
            o.stageInfo=stageInfo;
            o.stagesHand=stagesHand;
            o.num=num;
            
            for i=1:o.num
                auxStageInfo.name=sprintf('Axis %d',i);
                auxStageInfo.serial='';
                auxStageInfo.type=o.stageInfo.type;
                auxStageInfo.use=o.stageInfo.use;
                auxStageInfo.extraparam='';
                o.singleusecontrollers{i}=DisguiseForMultipleUseAsSingle(auxStageInfo,o,stagesHand,i);
            end
            
        end
        
        function unit = units(o)
            unit = StageUses.getNameUnits(o.stageInfo.use);
        end
        
        function controller = singleUseController(o,dim)
            if (dim>0 && dim<=o.num)
                controller=o.singleusecontrollers{dim};
            else
                controller=[];
            end
        end
        
        function setPosition(o,varPosition)              
            for i=1:o.dim
                o.setPositionDim(varPosition(i),i);
            end
        end
        
        function setPositionDim(o,varPosition,dim)  
            
            if(~ischar(varPosition))      
                if(varPosition<o.minPositionDim(dim))
                    varPosition=o.minPositionDim(dim);                
                elseif( varPosition>o.maxPositionDim(dim))
                    varPosition=o.maxPositionDim(dim);
                end 
            end
            
            o.lastPos(dim)=varPosition;
            stagePos=o.varPos2stagePos(varPosition);
            o.setPositionStagesDim(stagePos,dim);
            position=o.positionDim(dim);
            if (~ischar(position))
                pos=sprintf('%g',position);
            else
                pos=position;
            end
            MessageSystem.get().printMessage('USE',sprintf('Moved %s axis %d to %s %s',o.stageInfo.name,dim,pos, StageUses.getNameUnits(o.stageInfo.use)),true);                        
            UseMovementMixer.MoveExtraStages(o,o.lastPos);
        end
        
        function varPosition=position(o)
            stagePosition= o.positionStages();
            varPosition=o.stagePos2varPos(stagePosition);
            o.lastPos=varPosition;
        end
        
        function varPosition=positionDim(o,dim)
            stagePosition= o.positionStagesDim(dim);
            varPosition=o.stagePos2varPos(stagePosition);
            o.lastPos=varPosition;
        end
        
        function minVarPos=minPosition(o)
            stagePosition= o.minPositionStages();
            minVarPos=o.stagePos2varPos(stagePosition);
        end
        
        function maxVarPos=maxPosition(o)
            stagePosition= o.maxPositionStages();
            maxVarPos=o.stagePos2varPos(stagePosition);
        end
        
        function minVarPos=minPositionDim(o,dim)
            stagePosition= o.minPositionStagesDim(dim);
            minVarPos=o.stagePos2varPos(stagePosition);
        end
        
        function maxVarPos=maxPositionDim(o,dim)
            stagePosition= o.maxPositionStagesDim(dim);
            maxVarPos=o.stagePos2varPos(stagePosition);
        end
        
    end
    
    methods (Abstract)
        stagePosition=varPos2stagePos(o,varPosition)
        varPosition=stagePos2varPos(o,stagePosition)
        setPositionStages(o,stagePos)
        setPositionStagesDim(o,stagePos,dim)
        position=positionStages(o)
        position=positionStagesDim(o,dim)
        minPos=minPositionStages(o)
        maxPos=maxPositionStages(o)
        minPos=minPositionStagesDim(o,dim)
        maxPos=maxPositionStagesDim(o,dim)
    end
    
end

