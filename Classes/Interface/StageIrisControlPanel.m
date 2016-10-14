% (c) Alvaro Sanchez Gonzalez 2014
classdef StageIrisControlPanel<handle
    %STAGEVARIABLECONTROLPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageControllerPanel
        useControllerPanel
        parentC
        
    end
    
    methods
        function o=StageIrisControlPanel(parentC,stageController,useController)            
            o.parentC=parentC;
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            o.stageControllerPanel=GenericUsePanel(hgh,stageController);
            o.useControllerPanel=IrisUsePanel(hgh,useController);
            o.stageControllerPanel.addUpdateList(o.useControllerPanel)
            o.useControllerPanel.addUpdateList(o.stageControllerPanel)
        end
    end
end

