% (c) Alvaro Sanchez Gonzalez 2014
classdef VoltageDelayUseClass<AbstractUseClass
    %POSITIONDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        c=300;
    end
    
    properties

    end
    
    methods
        function o = VoltageDelayUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            %Convert time in fs to position in nm
            stagePosition=str2num(o.stageInfo.extraparam)+varPosition;
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            %Convert time in fs to position in nm
            varPosition=stagePosition-str2num(o.stageInfo.extraparam);
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
    end   
end

