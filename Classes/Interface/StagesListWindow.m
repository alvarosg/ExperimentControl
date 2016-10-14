% (c) Alvaro Sanchez Gonzalez 2014
classdef StagesListWindow<handle

    properties
        pushAddBefore
        pushAddAfter
        pushRemove
        
        comboStage
        editName
        editSerial
        comboType
        comboUse
        textExtraPar
        editExtraPar

        parentC

        stagesHand        
    end
    
    methods
        function o = StagesListWindow(parentC,stagesHand)
            o.parentC=parentC;
            o.stagesHand=stagesHand;
            hp = uipanel('Parent',o.parentC,'Title','Stages List','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
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
            o.comboStage=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboStage,'Callback',@(s,e)changedComboStage(o,s,e))
            
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
            o.comboType=uicontrol('Parent',hghv3h2,'style','popupmenu','BackgroundColor','white','string',StageTypes.strings);
            set(o.comboType,'Callback',@(s,e)changedEdit(o,s,e))
                        
            uicontrol('Parent',hghv2h3,'style','text','string','Serial Number')
            o.editSerial=uicontrol('Parent',hghv3h3,'style','edit','BackgroundColor','white');
            set(o.editSerial,'Callback',@(s,e)changedEdit(o,s,e))
            
            uicontrol('Parent',hghv4h1,'style','text','string','Use as')
            o.comboUse=uicontrol('Parent',hghv4h1,'style','popupmenu','BackgroundColor','white','string',StageUses.strings);
            set(o.comboUse,'Callback',@(s,e)changedEdit(o,s,e))
            
            o.textExtraPar=uicontrol('Parent',hghv4h2,'style','text');
            o.editExtraPar=uicontrol('Parent',hghv4h2,'style','edit','BackgroundColor','white');
            set(o.editExtraPar,'Callback',@(s,e)changedEdit(o,s,e))
            
            
            updateBoxes(o);
        end      
        
        function pushedAddBefore(o,s,e)
            i=get(o.comboStage,'Value');
            pushedAddIndex(o,s,e,i);
            set(o.comboStage,'Value',i);
            updateBoxes(o);
        end
        
        function pushedAddAfter(o,s,e)
            if(o.stagesHand.count()==0)
                i=0;
            else
                i=get(o.comboStage,'Value');
            end
            pushedAddIndex(o,s,e,i+1);
            set(o.comboStage,'Value',max([i+1 1]));
            updateBoxes(o);
        end
        
        function pushedAddIndex(o,s,e,ind)
            name=get(o.editName,'String');
            serial=get(o.editSerial,'String');
            type=StageTypes.names{get(o.comboType,'Value')};
            use=StageUses.names{get(o.comboUse,'Value')};
            extraParam=get(o.editExtraPar,'String');
            o.stagesHand.addStageInd(ind,name,serial,type,use,extraParam);
            updateBoxes(o);
        end
        
  

        function pushedRemove(o,s,e)
            i=get(o.comboStage,'Value');
            o.stagesHand.removeStageInd(i);
            set(o.comboStage,'Value',max([i-1 1]));
            updateBoxes(o);
        end
        
        function changedComboStage(o,s,e)
            updateBoxes(o);
        end
        
        function changedEdit(o,s,e)
            name=get(o.editName,'String');
            serial=get(o.editSerial,'String');
            type=StageTypes.names{get(o.comboType,'Value')};
            use=StageUses.names{get(o.comboUse,'Value')};
            extraParam=get(o.editExtraPar,'String');
            i=get(o.comboStage,'Value');
            o.stagesHand.editStage(i,name,serial,type,use,extraParam);           
            updateBoxes(o);
        end
        
        function updateBoxes(o)
            stages=o.stagesHand.getStages();
            if(o.stagesHand.count()>0)
                for i=1:o.stagesHand.count();
                    names{i}=[num2str(i) ' - ' stages{i}.name];
                end
                set(o.comboStage,'String',names);
                i=get(o.comboStage,'Value');
                set(o.editName,'String',stages{i}.name);
                set(o.editSerial,'String',stages{i}.serial);
                set(o.comboType,'Value',StageTypes.getNameIndex(stages{i}.type));
                set(o.comboUse,'Value',StageUses.getNameIndex(stages{i}.use));
                set(o.editExtraPar,'String',stages{i}.extraparam);
            else
                set(o.comboStage,'String','(empty)');
            end
            set(o.textExtraPar,'String',StageUses.extraParamInfo(get(o.comboUse,'Value')));
        end
    end    
end

