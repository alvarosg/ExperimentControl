% (c) Alvaro Sanchez Gonzalez 2014
classdef EllipticityUseClass<AbstractUseClass
    %INTENSITYDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        extraoffset
    end
    
    methods
        function o = EllipticityUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
            o.extraoffset=0;
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            %Convert time in fs to position in nm
            offset=str2num(o.stageInfo.extraparam)+o.extraoffset;
            stagePosition=offset+varPosition;
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            %Convert time in fs to position in nm
            offset=str2num(o.stageInfo.extraparam)+o.extraoffset;
            varPosition=stagePosition-offset;
        end
        function set0(o)
            o.setPosition(0);
        end
        function save0(o)
            position=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(position));
            o.stageInfo.extraparam=num2str(position);
            o.stageController.stageInfo.extraparam=num2str(position);
        end
        
        function changeExtraOffset(o,extraoffset)
            o.extraoffset=extraoffset;
            o.setPosition(o.lastPos);
        end
        
        function min=minPosition(o)
            min=0;
        end
        
        function max=maxPosition(o)
            max=100;
        end
    end   
end

