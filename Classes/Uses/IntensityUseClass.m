% (c) Alvaro Sanchez Gonzalez 2014
classdef IntensityUseClass<AbstractUseClass
    %INTENSITYDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        extraoffset
    end
    
    methods
        function o = IntensityUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
            o.extraoffset=0;
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            %Convert time in fs to position in nm
            extraParam=str2num(o.stageInfo.extraparam);
            offset=extraParam(1)+o.extraoffset;
            stagePosition=offset+o.intensityToAngle(varPosition,extraParam(2))/2;
        end       
        
        function varPosition=stagePos2varPos(o,stagePosition)
            %Convert time in fs to position in nm
            extraParam=str2num(o.stageInfo.extraparam);
            offset=extraParam(1)+o.extraoffset;
            varPosition=o.angleToIntensity(2*(stagePosition-offset),extraParam(2));
        end
        function set0(o)
            o.setPosition(100);
        end
        function save0(o)
            position=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(position));
            extraParam=str2num(o.stageInfo.extraparam);
            o.stageInfo.extraparam=num2str([position,extraParam(2)]);
            o.stageController.stageInfo.extraparam=num2str([position,extraParam(2)]);
        end
        
        function min=minPosition(o)
            extraParam=str2num(o.stageInfo.extraparam);
            min=extraParam(2);
        end
        
        function max=maxPosition(o)
            max=100;
        end
        
        function changeExtraOffset(o,extraoffset)
            o.extraoffset=extraoffset;
            o.setPosition(o.lastPos);
        end
        
        function intensity=angleToIntensity(o,angle,contrast)
            intensity=(cosd(angle)).^2*(100-contrast)+contrast;
        end
        
        function angle=intensityToAngle(o,intensity,contrast)
            angle=acosd(sqrt((intensity-contrast)/(100-contrast)));
        end
    end   
end

