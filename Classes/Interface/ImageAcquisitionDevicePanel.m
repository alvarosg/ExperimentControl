% (c) Alvaro Sanchez Gonzalez 2014
classdef ImageAcquisitionDevicePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        parentC
        editNumShotsSingle
        editNumShotsScan
        editExtraParam
        pushSetBoxes
        updateList   
        boxesFig
        boxesWindow
        cropWindow
        acquisitionDevicesHand 
        
    end
    
    methods
        function o=ImageAcquisitionDevicePanel(parentC,controller,acquisitionDevicesHand)
            o.controller=controller;
            o.parentC=parentC;
            o.updateList={};
            o.acquisitionDevicesHand=acquisitionDevicesHand;
                       
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[2,5], 'HorizontalWeight',[1 0.5 2 4 2]);            
            
            uicontrol('Parent',hgh,'style','text','string','Shots Single'); 
            o.editNumShotsSingle=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white'); 
            set(o.editNumShotsSingle,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hgh,'style','text','string',AcquisitionTypes.getNameExtraParamInfo(o.controller.deviceInfo.type));            
            o.editExtraParam=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white','string',controller.deviceInfo.extraparam);
            set(o.editExtraParam,'Callback',@(s,e)changedExtraParam(o,s,e))
            
            o.pushSetBoxes=uicontrol('Parent',hgh,'style','push','string','Set Boxes');
            set(o.pushSetBoxes,'Callback',@(s,e)pushedSetBoxes(o,s,e))
            
            uicontrol('Parent',hgh,'style','text','string','Shots Scan'); 
            o.editNumShotsScan=uicontrol('Parent',hgh,'style','edit','BackgroundColor','white'); 
            set(o.editNumShotsScan,'Callback',@(s,e)changedEdit(o,s,e))
            
            o.boxesWindow=0;
            o.cropWindow=0;
            o.boxesFig=0;
            
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
                       
            if(o.boxesFig~=0)
                o.boxesWindow.updateBoxes(false);
                o.cropWindow.updateBoxes(false);
                o.boxesWindow.drawBoxes();
                o.cropWindow.drawRectangle();
            end
                                                          
            update(o,true);
        end
        
        function pushedSetBoxes(o,s,e)
            if(o.boxesFig==0 || ~ishandle(o.boxesFig))
                if(~ishandle(o.boxesFig))
                    o.boxesWindow.deleteBoxes();
                    o.cropWindow.deleteRectangle();
                end
                o.boxesFig=figure('name','Set Boxes and Crop Rectangle','NumberTitle','off','position',[100 600 900 200]);
                set(o.boxesFig, 'menubar', 'none');
                vg1 = uiflowcontainer('v0','Parent',o.boxesFig,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
                o.boxesWindow=BoxesWindow(vg1,o.controller.boxesHand,o.controller.getAxes());
                o.cropWindow=CropRectangleWindow(vg1,o.controller.cropHand,o.controller.getAxes());
            else
                figure(o.boxesFig);
            end
            
           
            
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
        
        function delete(o)
            if(ishandle(o.boxesFig))
                delete(o.boxesFig)
            end
        end           
    end
    
end

