% (c) Alvaro Sanchez Gonzalez 2014
classdef LocalDevicePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        parentC
        editNumShotsSingle
        editNumShotsScan
        editExtraParam
        updateList   
        acquisitionDevicesHand 
        
    end
    
    methods
        function o=LocalDevicePanel(parentC,controller,acquisitionDevicesHand)
            o.parentC=parentC;
            o.controller=controller;
            o.updateList={};
            o.acquisitionDevicesHand=acquisitionDevicesHand;                       
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[2,4], 'HorizontalWeight',[1 0.5 2 6]);            
            
            uicontrol('Parent',hgh,'style','text','string','Shots Single'); 
            o.editNumShotsSingle=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white'); 
            set(o.editNumShotsSingle,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hgh,'style','text','string',AcquisitionTypes.getNameExtraParamInfo(o.controller.deviceInfo.type));            
            o.editExtraParam=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white','string',o.controller.deviceInfo.extraparam);
            set(o.editExtraParam,'Callback',@(s,e)changedExtraParam(o,s,e))            
            
            uicontrol('Parent',hgh,'style','text','string','Shots Scan'); 
            o.editNumShotsScan=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white'); 
            set(o.editNumShotsScan,'Callback',@(s,e)changedEdit(o,s,e))
            
            o.changedExtraParam(0,0);
            update(o,true);
        end        
        
        function changedEdit(o,s,e)
            shots=[];
            shots(1)=str2num(get(o.editNumShotsSingle,'string'));
            shots(2)=str2num(get(o.editNumShotsScan,'string'));
            o.acquisitionDevicesHand.setShotsByName(o.controller.deviceInfo.name,shots);
            o.controller.deviceInfo.shots=shots;
            update(o,true);
        end
        
        function changedExtraParam(o,s,e)                       
            o.controller.setExtraParam(get(o.editExtraParam,'string'));
            o.acquisitionDevicesHand.setExtraParamByName(o.controller.deviceInfo.name,o.controller.deviceInfo.extraparam);
            set(o.editExtraParam,'string',o.controller.deviceInfo.extraparam);                                                                                 
            update(o,true);
        end
        
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)    
            set(o.editNumShotsSingle,'string',num2str(o.controller.deviceInfo.shots(1)))
            set(o.editNumShotsScan,'string',num2str(o.controller.deviceInfo.shots(2)))
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
    end
    
end

