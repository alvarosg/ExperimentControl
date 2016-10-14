% (c) Alvaro Sanchez Gonzalez 2014
classdef UseMovementMixer
    %STAGEMOVEMENTMIXER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        function MoveExtraStages(controller,varPosition)
            
            if(strcmp(controller.stageInfo.name,'IR Intensity'))
                initializedControllers=getappdata(0,'StageControllerPanel');     
                if (~isempty(initializedControllers))
                    initializedControllers=initializedControllers.initElements;                     
                    extraParam=str2num(controller.stageInfo.extraparam);
                    contrast=extraParam(2);
                    inAngle=controller.intensityToAngle(varPosition,contrast);
                    
                    outAngle=atand(sqrt(contrast/100)*sind(inAngle)/cosd(inAngle));
                    %outAngle=0;

                    for j=1:length(initializedControllers)
                        if(~isempty(initializedControllers{j}.useController) && strcmp(initializedControllers{j}.useController.stageInfo.name,'IR Ellipticity'))
                            initializedControllers{j}.useController.changeExtraOffset(outAngle);
                            initializedControllers{j}.panelClass.stageControllerPanel.update(true);                                                                                
                        end
                    end                                                        
                end
            end
            
            if(strcmp(controller.stageInfo.name,'IR Ellipticity'))
                initializedControllers=getappdata(0,'StageControllerPanel');     
                if (~isempty(initializedControllers))
                    initializedControllers=initializedControllers.initElements; 
                   
                    for i=1:length(initializedControllers)
                        if(~isempty(initializedControllers{i}.useController) && strcmp(initializedControllers{i}.stageController.stageInfo.name,'IR Polarization'))
                            initializedControllers{i}.useController.changeExtraOffset(varPosition/2+controller.extraoffset/2);
                            initializedControllers{i}.panelClass.stageControllerPanel.update(true);
                        end
                    end                                                                                                                                             
                end
            end
            %{
            if(strcmp(controller.stageInfo.name,'IR Polarization'))
                initializedControllers=getappdata(0,'StageControllerPanel');     
                if (~isempty(initializedControllers))
                    initializedControllers=initializedControllers.initElements; 
                   
                    for i=1:length(initializedControllers)
                        if(~isempty(initializedControllers{i}.useController) && ~strcmp(initializedControllers{i}.stageController,'null') && strcmp(initializedControllers{i}.stageController.stageInfo.name,'Spectral Interference Polarization Compensation'))
                            initializedControllers{i}.useController.setPosition(varPosition); %Changed to -varPosition 05/10/2015 by Emma to correct the SI waveplated in the correct direction
                            initializedControllers{i}.panelClass.stageControllerPanel.update(true);
                        end
                    end                                                                                                                                             
                end
            end
            %}
        end
    end    
end

