% (c) Alvaro Sanchez Gonzalez 2014
classdef IrisUseClass<AbstractUseClass
    %INTENSITYDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        extraoffset
    end
    
    methods
        function o = IrisUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
            o.extraoffset=0;
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            extraParam=str2num(o.stageInfo.extraparam);
            open = extraParam(1);
            closed = extraParam(2);
            direction = extraParam(3);
            stagePosition = varPosition;
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            extraParam=str2num(o.stageInfo.extraparam);
            open = extraParam(1);
            closed = extraParam(2);
            direction = extraParam(3);
            varPosition = stagePosition;
                    
        end
        function set0(o)
            o.setPosition(100);
        end
        function saveOpen(o)
            openclosed=str2num(o.stageInfo.extraparam);
            openclosed(1)=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(openclosed));
            o.stageInfo.extraparam=num2str(openclosed);
            o.stageController.stageInfo.extraparam=num2str(openclosed);
        end
        
        function saveClosed(o)
            openclosed=str2num(o.stageInfo.extraparam);
            openclosed(2)=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(openclosed));
            o.stageInfo.extraparam=num2str(openclosed);
            o.stageController.stageInfo.extraparam=num2str(openclosed);
        end
        
        function min=minPosition(o)
            min=0;
        end
        
        function max=maxPosition(o)
            max=360;
        end
        
    end   
end

