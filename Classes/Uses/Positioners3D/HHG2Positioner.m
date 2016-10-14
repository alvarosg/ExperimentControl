% (c) Alvaro Sanchez Gonzalez 2014
classdef HHG2Positioner<Positioner3D
    %INTENSITYDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        verticalstage
        multistage
    end
    
    methods
        function o = HHG2Positioner(stageInfo,stagesHand)
            o = o@Positioner3D(stageInfo,stagesHand);
            o.extraoffset=0;
            %% Vertical stage thorlabs
            stageInfo.name='HHG2 Vertical Stage';
            stageInfo.serial='83841566';
            stageInfo.type='thortrans';

            o.verticalstage=ThorlabsTranslationStageClass(stageInfo);
            %o.verticalstage=TranslationTestStageClass(stageInfo);

            %% Smaract stages
            stageInfo.name='Translation Sample';
            stageInfo.serial='usb:ix:0';
            stageInfo.type='smaract';

            o.multistage=SmarActMultiStageClass(stageInfo);
                        
        end
        
        function setPositionStages(o,stagePos)
            o.multistage.setPosition([stagePos(3),stagePos(1)]);
            o.verticalstage.setPosition(stagePos(2));
        end
        function setPositionStagesDim(o,stagePos,dim)
            if(dim==1)
                o.multistage.setPositionDim(stagePos,2);
            elseif (dim==2)
                o.verticalstage.setPosition(stagePos);
            elseif (dim==3)
                o.multistage.setPositionDim(stagePos,1);
            end           
        end
        function position=positionStages(o)
            posSmar=o.multistage.position();
            position=[posSmar(2),o.verticalstage.position(),posSmar(1)];            
        end
        function position=positionStagesDim(o,dim)
            if(dim==1)
                position=o.multistage.position();
                position=position(2);
            elseif (dim==2)
                position=o.verticalstage.position();
            elseif (dim==3)
                position=o.multistage.position();
                position=position(1);
            end  
        end
        
        function minPos=minPositionStages(o)
            posSmar=o.multistage.minPosition();
            minPos=[posSmar(2),o.verticalstage.minPosition(),posSmar(1)]; 
        end
        function minPos=minPositionStagesDim(o,dim)
            if(dim==1)
                position=o.multistage.minPosition();
                minPos=position(2);
            elseif (dim==2)
                minPos=o.verticalstage.minPosition();
            elseif (dim==3)
                position=o.multistage.minPosition();
                minPos=position(1);
            end
        end
        function maxPos=maxPositionStages(o)
            posSmar=o.multistage.minPosition();
            maxPos=[posSmar(2),o.verticalstage.minPosition(),posSmar(1)]; 
        end
        function maxPos=maxPositionStagesDim(o,dim)
            if(dim==1)
                position=o.multistage.maxPosition();
                maxPos=position(2);
            elseif (dim==2)
                maxPos=o.verticalstage.maxPosition();
            elseif (dim==3)
                position=o.multistage.maxPosition();
                maxPos=position(1);
            end
        end
        
        function destroy(o)
            delete(o.verticalstage);
            delete(o.multistage);
        end
        
        function delete(o)
            delete(o.verticalstage);
            delete(o.multistage);
        end
        
    end   
end

