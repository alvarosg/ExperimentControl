% (c) Alvaro Sanchez Gonzalez 2014
classdef SetScanAcquisitionPanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        acquisitionControllerPanel  
        
        checkDevices
         
        pushAdd
        textTotalSteps
        controlContainer
        comboStage
        
        added
        addedElements
        
        updateList
      
    end
    
    methods
        function o = SetScanAcquisitionPanel(parentC,acquisitionControllerPanel)
            o.parentC=parentC;
            o.acquisitionControllerPanel=acquisitionControllerPanel;
            
            hp = uipanel('Parent',o.parentC,'Title','Acquisition Devices','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hgv1 = uiflowcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
             
            for i=1:length(o.acquisitionControllerPanel.initElements)
                o.checkDevices{i}=uicontrol('Parent',hgv1,'style','check','string',o.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.name);
                set(o.checkDevices{i},'Callback',@(s,e)checkChanged(o,s,e))
            end            
            update(o,true)
        end            
        function checkChanged(o,s,e)
            for i=1:length(o.acquisitionControllerPanel.initElements)
                if (s==o.checkDevices{i})
                    o.acquisitionControllerPanel.initElements{i}.acquire=get(o.checkDevices{i},'value');
                end
            end
            o.update(true);
        end
         
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
         
        function update(o,updateAll)
            for i=1:length(o.acquisitionControllerPanel.initElements)
                set(o.checkDevices{i},'value',o.acquisitionControllerPanel.initElements{i}.acquire);
            end
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
    end
end

