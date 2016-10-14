% (c) Alvaro Sanchez Gonzalez 2014
classdef DisguiseForMultipleUseAsSingle<AbstractUseClass
    %POSITIONDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    

    properties
        dim
        multipleUseController
    end
    
    methods
        function o = DisguiseForMultipleUseAsSingle(stageInfo,multipleUseController,stagesHand,dim)
            o = o@AbstractUseClass(stageInfo,[],stagesHand);
            o.multipleUseController=multipleUseController;
            o.dim=dim;            
        end
        
        function unit = units(o)
            unit = o.multipleUseController.units();
        end
        
        function setPosition(o,varPosition)  
            o.multipleUseController.setPositionDim(varPosition,o.dim);
        end
        
        function varPosition=position(o)
            varPosition=o.multipleUseController.positionDim(o.dim);
        end
        
        function minVarPos=minPosition(o)
            minVarPos=o.multipleUseController.minPositionDim(o.dim);
        end
        
        function maxVarPos=maxPosition(o)
            maxVarPos=o.multipleUseController.maxPositionDim(o.dim);
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            stagePosition=o.multipleUseController.varPos2stagePos(varPosition);
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            varPosition=o.multipleUseController.stagePos2varPos(stagePosition);
        end

    end   
end

