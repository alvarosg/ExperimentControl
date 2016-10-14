% (c) Alvaro Sanchez Gonzalez 2014
classdef AcquisitionDeviceListWindow<handle

    properties
        pushAddBefore
        pushAddAfter
        pushRemove
        
        comboDevice
        editName
        editVariable
        comboType
        textExtraPar
        editExtraPar

        parentC
        devicesHand        
    end
    
    methods
        function o =  AcquisitionDeviceListWindow(parentC,devicesHand)
            o.parentC=parentC;
            o.devicesHand=devicesHand;
            hp = uipanel('Parent',o.parentC,'Title','Devices List','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            grid = uigridcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'GridSize',[1,4], 'HorizontalWeight',[3,1,2,4]);
            hghv1 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv2 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv3 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv4 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            
            hghv1h1 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv1h2 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv2h1 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv2h2 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv2h3 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv3h1 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv3h2 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv3h3 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv4h1 = uiflowcontainer('v0','Parent',hghv4,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv4h2 = uiflowcontainer('v0','Parent',hghv4,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
                  
            uicontrol('Parent',hghv1h1,'style','text','string','Current Stage');
            o.comboDevice=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboDevice,'Callback',@(s,e)changedComboDevice(o,s,e))
            
            o.pushAddBefore=uicontrol('Parent',hghv1h2,'style','push','string','Add Before');
            set(o.pushAddBefore,'Callback',@(s,e)pushedAddBefore(o,s,e))
            o.pushAddAfter=uicontrol('Parent',hghv1h2,'style','push','string','Add After');
            set(o.pushAddAfter,'Callback',@(s,e)pushedAddAfter(o,s,e))
            o.pushRemove=uicontrol('Parent',hghv1h2,'style','push','string','Remove');
            set(o.pushRemove,'Callback',@(s,e)pushedRemove(o,s,e))
            
            uicontrol('Parent',hghv2h1,'style','text','string','Name')
            o.editName=uicontrol('Parent',hghv3h1,'style','edit','BackgroundColor','white');
            set(o.editName,'Callback',@(s,e)changedEdit(o,s,e))
            
            uicontrol('Parent',hghv2h2,'style','text','string','Type')
            o.comboType=uicontrol('Parent',hghv3h2,'style','popupmenu','BackgroundColor','white','string',AcquisitionTypes.strings);
            set(o.comboType,'Callback',@(s,e)changedEdit(o,s,e))
                        
            uicontrol('Parent',hghv2h3,'style','text','string','Variable Name')
            o.editVariable=uicontrol('Parent',hghv3h3,'style','edit','BackgroundColor','white');
            set(o.editVariable,'Callback',@(s,e)changedEdit(o,s,e))
            
            
            o.textExtraPar=uicontrol('Parent',hghv4h1,'style','text');
            o.editExtraPar=uicontrol('Parent',hghv4h2,'style','edit','BackgroundColor','white');
            set(o.editExtraPar,'Callback',@(s,e)changedEdit(o,s,e))
            
            
            updateBoxes(o);
        end      
        
        function pushedAddBefore(o,s,e)
            i=get(o.comboDevice,'Value');
            pushedAddIndex(o,s,e,i);
            set(o.comboDevice,'Value',i);
            updateBoxes(o);
        end
        
        function pushedAddAfter(o,s,e)
            if(o.devicesHand.count()==0)
                i=0;
            else
                i=get(o.comboDevice,'Value');
            end
            pushedAddIndex(o,s,e,i+1);
            set(o.comboDevice,'Value',max([i+1 1]));
            updateBoxes(o);
        end
        
        function pushedAddIndex(o,s,e,ind)
            name=get(o.editName,'String');
            varname=get(o.editVariable,'String');
            type=AcquisitionTypes.names{get(o.comboType,'Value')};
            extraParam=get(o.editExtraPar,'String');
            o.devicesHand.addDeviceInd(ind,name,type,varname,extraParam,[1 1]);
            updateBoxes(o);
        end
        
  

        function pushedRemove(o,s,e)
            i=get(o.comboDevice,'Value');
            o.devicesHand.removeDeviceInd(i);
            set(o.comboDevice,'Value',max([i-1 1]));
            updateBoxes(o);
        end
        
        function changedComboDevice(o,s,e)
            updateBoxes(o);
        end
        
        function changedEdit(o,s,e)
            name=get(o.editName,'String');
            varname=get(o.editVariable,'String');
            type=AcquisitionTypes.names{get(o.comboType,'Value')};
            extraParam=get(o.editExtraPar,'String');
            
            i=get(o.comboDevice,'Value');
            o.devicesHand.editDevice(i,name,type,varname,extraParam,-1);           
            updateBoxes(o);
        end
        
        function updateBoxes(o)
            devices=o.devicesHand.getDevices();
            if(o.devicesHand.count()>0)
                for i=1:o.devicesHand.count();
                    names{i}=[num2str(i) ' - ' devices{i}.name];
                end
                set(o.comboDevice,'String',names);
                i=get(o.comboDevice,'Value');
                set(o.editName,'String',devices{i}.name);
                set(o.editVariable,'String',devices{i}.varname);
                set(o.comboType,'Value',AcquisitionTypes.getNameIndex(devices{i}.type));
                set(o.editExtraPar,'String',devices{i}.extraparam);
            else
                set(o.comboDevice,'String','(empty)');
            end
            set(o.textExtraPar,'String',AcquisitionTypes.extraParamInfo(get(o.comboType,'Value')));
        end
    end    
end

