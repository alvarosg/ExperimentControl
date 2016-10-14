% (c) Alvaro Sanchez Gonzalez 2014
classdef InOutRotUseClass<AbstractUseClass
    %POSITIONDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        c=300;
    end
    
    properties

    end
    
    methods
        function o = InOutRotUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            %Convert in or out to position in nm
            extraparam=str2num(o.stageInfo.extraparam);
            if (strcmp(varPosition,'in'))
                stagePosition=extraparam(1);
            elseif (strcmp(varPosition,'out'))
                stagePosition=extraparam(2);
            end
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            stagePosition=stagePosition;
            extraparam=str2num(o.stageInfo.extraparam);
            if (abs(stagePosition-extraparam(1))<0.5)
                varPosition='in';
            elseif (abs(stagePosition-extraparam(2))<0.5)
                varPosition='out';
            else
                varPosition='intermediate';
            end
        end

        function saveIn(o)
            inout=str2num(o.stageInfo.extraparam);
            inout(1)=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(inout));
            o.stageInfo.extraparam=num2str(inout);
            o.stageController.stageInfo.extraparam=num2str(inout);
        end
        
        function saveOut(o)
            inout=str2num(o.stageInfo.extraparam);
            inout(2)=o.stageController.position();
            o.stagesHand.setExtraParamByName(o.stageInfo.name,num2str(inout));
            o.stageInfo.extraparam=num2str(inout);
            o.stageController.stageInfo.extraparam=num2str(inout);
        end
    end   
end

