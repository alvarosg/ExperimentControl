% (c) Alvaro Sanchez Gonzalez 2014
classdef ExtraAcquisition
    %STAGEMOVEMENTMIXER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        function AcquireExtra(dataLabeler,stageIteration,maxStageIteration)
            
            if(~isempty(getappdata(0,'NoIRRef')) && getappdata(0,'NoIRRef')==true)
                %Take a picture with the IR blocked after each time scan
                initializedControllers=getappdata(0,'StageControllerPanel'); 
                initializedAcquisition=getappdata(0,'AcquisitionControllerPanel'); 
                if(~isempty(initializedControllers) && ~isempty(initializedAcquisition))
                    initializedControllers=initializedControllers.initElements;
                    if(stageIteration(end)==maxStageIteration(end))
                        for j=1:length(initializedControllers)
                            if(strcmp(initializedControllers{j}.useController.stageInfo.name,'IR Block'))
                                initializedControllers{j}.useController.setPosition('in');
                                initializedControllers{j}.panelClass.stageControllerPanel.update(true);      

                                dataTaker=DataTaker(initializedAcquisition,true);
                                name=fullfile(dataLabeler.getFullPathFolder(),'data.mat');
                                dataTaker.TakeData(name);
                                delete(dataTaker); 

                                initializedControllers{j}.useController.setPosition('out');
                                initializedControllers{j}.panelClass.stageControllerPanel.update(true);   
                            end
                        end 
                    end
                end
            end
        end
    end    
end

