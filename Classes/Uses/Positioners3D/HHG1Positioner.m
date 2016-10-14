% (c) Alvaro Sanchez Gonzalez 2014
classdef HHG1Positioner<Positioner3D
    %INTENSITYDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        thorlabsstages
    end
    
    methods
        function o = HHG1Positioner(stageInfo,stagesHand)
            o = o@Positioner3D(stageInfo,stagesHand);
            o.extraoffset=0;
            %% Thorlabs stages
            stageInfo.name='HHG1 X';
            stageInfo.serial='83841538';
            stageInfo.type='thortrans';
            o.thorlabsstages{1}=ThorlabsTranslationStageClass(stageInfo);
            %o.thorlabsstages{1}=TranslationTestStageClass(stageInfo);
            
            stageInfo.name='HHG1 Y';
            stageInfo.serial='83841586';
            stageInfo.type='thortrans';
            o.thorlabsstages{2}=ThorlabsTranslationStageClass(stageInfo);
            %o.thorlabsstages{2}=TranslationTestStageClass(stageInfo);
            
            stageInfo.name='HHG1 Z';
            stageInfo.serial='83840867';
            stageInfo.type='thortrans';
            o.thorlabsstages{3}=ThorlabsTranslationStageClass(stageInfo);
            %o.thorlabsstages{3}=TranslationTestStageClass(stageInfo);
                        
        end
        
        function setPositionStages(o,stagePos)
            for i=1:3
                o.thorlabsstages{i}.setPosition(stagePos(i));
            end
        end
        function setPositionStagesDim(o,stagePos,dim)
            if dim > 0 && dim <4
                o.thorlabsstages{dim}.setPosition(stagePos);  
            end
        end
        function position=positionStages(o)
            for i=1:3
                position(i)=o.thorlabsstages{i}.position();
            end           
        end
        function position=positionStagesDim(o,dim)
            if dim > 0 && dim <4
                position=o.thorlabsstages{dim}.position();  
            end
        end
        
        function minPos=minPositionStages(o)
            for i=1:3
                minPos(i)=o.thorlabsstages{i}.minPosition();
            end 
        end
        function minPos=minPositionStagesDim(o,dim)
            if dim > 0 && dim <4
                minPos=o.thorlabsstages{dim}.minPosition();  
            end
        end
        function maxPos=maxPositionStages(o)
            for i=1:3
                maxPos(i)=o.thorlabsstages{i}.maxPosition();
            end 
        end
        function maxPos=maxPositionStagesDim(o,dim)
            if dim > 0 && dim <4
                maxPos=o.thorlabsstages{dim}.maxPosition();  
            end
        end
        
        function destroy(o)
            for i=1:3
                delete(o.thorlabsstages{i});
            end
        end
        
        function delete(o)
            for i=1:3
                delete(o.thorlabsstages{i});
            end
        end        
    end   
end