% (c) Alvaro Sanchez Gonzalez 2014
classdef AbstractMultiStageClass<handle
    %ABSTRACTSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageInfo
        pos
        dim
    end
    
    methods
        function o = AbstractMultiStageClass(stageInfo) 
            o.stageInfo=stageInfo;
            MessageSystem.get().printMessage('MULTISTAGE',sprintf('Initialized %s ',o.stageInfo.name),true);
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
        
        function setPositionRelDim(o,relPosition,dim)
            if(dim>=1 && dim<=o.dim )
                currPosition=o.position();
                o.setPositionDim(currPosition(dim)+relPosition,dim);
            end
        end
        
        function setPosition(o,position)
            for i=1:o.dim
                o.setPositionDim(position(i),i);
            end
        end
        
        function setPositionDim(o,position,dim)
            if(dim>=1 && dim<=o.dim )
                minPosition=o.minPosition();
                maxPosition=o.maxPosition();
                if(position<minPosition(dim))
                    position=minPosition(dim);                
                elseif( position>maxPosition(dim))
                    position=maxPosition(dim);
                end       

                try
                    MessageSystem.get().printMessage('STAGE',sprintf('Moving %s (Axis %d) to %g %s',o.stageInfo.name,dim,position, StageTypes.getNameUnits(o.stageInfo.type)),false);            
                    position=o.gotoPosition(position,dim);
                catch error
                    getReport(error)
                    MessageSystem.get().printMessage('ERROR',sprintf('Error moving %s (Axis %d) to %g %s',o.stageInfo.name,dim,position, StageTypes.getNameUnits(o.stageInfo.type)),true);
                end
                
                if(position<minPosition(dim))
                    position=minPosition(dim);                
                elseif( position>maxPosition(dim))
                    position=maxPosition(dim);
                end                   
                MessageSystem.get().printMessage('STAGE',sprintf('Moved %s (Axis %d) to %g %s',o.stageInfo.name,dim,position, StageTypes.getNameUnits(o.stageInfo.type)),true);
                o.pos(dim)=position;
                
                StageMovementMixer.MoveExtraStages(o,o.pos)
            end
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
        outPosition=gotoPosition(o,position,dim)       
        minPos=minPosition(o)
        maxPos=maxPosition(o)
        updatePosition(o)
    end
    
end

