% (c) Alvaro Sanchez Gonzalez 2014
classdef MetadataListWindow<handle

    properties
        pushAddBefore
        pushAddAfter
        pushRemove
        
        comboField
        editName
        editVariable

        parentC
        metadataHand        
    end
    
    methods
        function o =  MetadataListWindow(parentC,metadataHand)
            o.parentC=parentC;
            o.metadataHand=metadataHand;
            hp = uipanel('Parent',o.parentC,'Title','Metadata Fields List','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            grid = uigridcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[3,1,2]);
            hghv1 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv2 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv3 = uiflowcontainer('v0','Parent',grid,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            
            hghv1h1 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv1h2 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv2h1 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv2h2 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv3h1 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv3h2 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
                                          
            uicontrol('Parent',hghv1h1,'style','text','string','Current Stage');
            o.comboField=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboField,'Callback',@(s,e)changedComboField(o,s,e))
            
            o.pushAddBefore=uicontrol('Parent',hghv1h2,'style','push','string','Add Before');
            set(o.pushAddBefore,'Callback',@(s,e)pushedAddBefore(o,s,e))
            o.pushAddAfter=uicontrol('Parent',hghv1h2,'style','push','string','Add After');
            set(o.pushAddAfter,'Callback',@(s,e)pushedAddAfter(o,s,e))
            o.pushRemove=uicontrol('Parent',hghv1h2,'style','push','string','Remove');
            set(o.pushRemove,'Callback',@(s,e)pushedRemove(o,s,e))
            
            uicontrol('Parent',hghv2h1,'style','text','string','Name')
            o.editName=uicontrol('Parent',hghv3h1,'style','edit','BackgroundColor','white');
            set(o.editName,'Callback',@(s,e)changedEdit(o,s,e))
            
                        
            uicontrol('Parent',hghv2h2,'style','text','string','Variable Name')
            o.editVariable=uicontrol('Parent',hghv3h2,'style','edit','BackgroundColor','white');
            set(o.editVariable,'Callback',@(s,e)changedEdit(o,s,e))                       
                        
            updateBoxes(o);
        end      
        
        function pushedAddBefore(o,s,e)
            i=get(o.comboField,'Value');
            pushedAddIndex(o,s,e,i);
            set(o.comboField,'Value',i);
            updateBoxes(o);
        end
        
        function pushedAddAfter(o,s,e)
            if(o.metadataHand.count()==0)
                i=0;
            else
                i=get(o.comboField,'Value');
            end
            pushedAddIndex(o,s,e,i+1);
            set(o.comboField,'Value',max([i+1 1]));
            updateBoxes(o);
        end
        
        function pushedAddIndex(o,s,e,ind)
            name=get(o.editName,'String');
            varname=get(o.editVariable,'String');
            o.metadataHand.addFieldInd(ind,name,varname);
            updateBoxes(o);
        end
        
  

        function pushedRemove(o,s,e)
            i=get(o.comboField,'Value');
            o.metadataHand.removeFieldInd(i);
            set(o.comboField,'Value',max([i-1 1]));
            updateBoxes(o);
        end
        
        function changedComboField(o,s,e)
            updateBoxes(o);
        end
        
        function changedEdit(o,s,e)
            name=get(o.editName,'String');
            varname=get(o.editVariable,'String');
            
            i=get(o.comboField,'Value');
            o.metadataHand.editField(i,name,varname);           
            updateBoxes(o);
        end
        
        function updateBoxes(o)
            fields=o.metadataHand.getFields();
            if(o.metadataHand.count()>0)
                for i=1:o.metadataHand.count();
                    names{i}=[num2str(i) ' - ' fields{i}.name];
                end
                set(o.comboField,'String',names);
                i=get(o.comboField,'Value');
                set(o.editName,'String',fields{i}.name);
                set(o.editVariable,'String',fields{i}.varname);
            else
                set(o.comboField,'String','(empty)');
            end
        end
    end    
end

