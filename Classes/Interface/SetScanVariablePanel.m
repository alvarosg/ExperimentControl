% (c) Alvaro Sanchez Gonzalez 2014
classdef SetScanVariablePanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        stageControllerPanel  
         
        pushAdd
        controlContainer
        comboStage
        
        added
        addedElements
        
        availableElements
        
        updateList
      
    end
    
    methods
        function o = SetScanVariablePanel(parentC,stageControllerPanel)
            o.parentC=parentC;
            o.stageControllerPanel=stageControllerPanel;
            
            hp = uipanel('Parent',o.parentC,'Title','Variables','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hgv1 = uigridcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'GridSize',[2,1], 'VerticalWeight',[1 8]);
            hghv1h1 = uigridcontainer('v0','Parent',hgv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[4,2]);
            o.controlContainer = uigridcontainer('v0','Parent',hgv1,'Units','norm','Position',[0,0,1,1],'GridSize',[4,1]);
            
            o.comboStage=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboStage,'Callback',@(s,e)comboChanged(o,s,e))
            
            o.pushAdd=uicontrol('Parent',hghv1h1,'style','push','string','Add');
            set(o.pushAdd,'Callback',@(s,e)pushedAdd(o,s,e))           
            
            counter=0;
            
            names=[];
            
            
            for index=1:length(o.stageControllerPanel.initElements);
                if(StageUses.getNameScannable(o.stageControllerPanel.initElements{index}.useController.stageInfo.use))
                    if (strcmp(o.stageControllerPanel.initElements{index}.useController.stageInfo.use,'pos3D')) 
                        axisnames={'Axis X','Axis Y' 'Axis Z'};
                        for j=1:3
                            counter=counter+1;
                            names{counter}=[sprintf('%s - %s',o.stageControllerPanel.initElements{index}.useController.stageInfo.name,axisnames{j})];
                            if(~any(strcmp(fieldnames(o.stageControllerPanel.initElements{index}),'scanVariable')) || length(o.stageControllerPanel.initElements{index}.scanVariable)<3)                    
                                o.stageControllerPanel.initElements{index}.scanVariable{j}=ScanVariable(o.stageControllerPanel.initElements{index}.useController.singleUseController(j));
                                o.stageControllerPanel.initElements{index}.scanVariable{j}.controller.stageInfo.name=names{counter};
                            end    
                            o.availableElements{counter}.scanVariable=o.stageControllerPanel.initElements{index}.scanVariable{j};
                        end                        
                    else                        
                        counter=counter+1;
                        names{counter}=[o.stageControllerPanel.initElements{index}.useController.stageInfo.name];
                        if(~any(strcmp(fieldnames(o.stageControllerPanel.initElements{index}),'scanVariable')))                    
                            o.stageControllerPanel.initElements{index}.scanVariable=ScanVariable(o.stageControllerPanel.initElements{index}.useController);
                        end
                        o.availableElements{counter}.scanVariable=o.stageControllerPanel.initElements{index}.scanVariable;                        
                    end
                end
            end
           
            set(o.comboStage,'string',names);
            
            update(o,true)
        end
        
        function pushedAdd(o,s,e,ind)
            index=get(o.comboStage,'Value');
            if(isempty(find(o.added==index)))
                pos=length(o.added)+1;
                o.added(pos)=index;                               

                o.addedElements{pos}.scanVariable=o.availableElements{index}.scanVariable;
                
                o.addedElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',o.addedElements{pos}.scanVariable.controller.stageInfo.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                panel=ScanVariablePanel(o.addedElements{pos}.panels,o.addedElements{pos}.scanVariable);
                panel.addUpdateList(o);

            else
                pos=find(o.added==index);
                delete(o.addedElements{pos}.panels);
                o.addedElements(pos)=[];   
                o.added(pos)=[];
            end
            update(o,true);
        end
       
        function comboChanged(o,s,e)
            o.update(true);
        end
        
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            index=get(o.comboStage,'Value');
            
            if(isempty(find(o.added==index)))
                set(o.pushAdd,'String','Add');
            else
                set(o.pushAdd,'String','Delete');
            end

            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
        
        function delete(o)
            for i=1:length(o.added())
            end
        end
    end
end

