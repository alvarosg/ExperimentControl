% (c) Alvaro Sanchez Gonzalez 2014
classdef DiscretePositionsUsePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        parentC
        textPosition
        
        push
        pushSave
        updateList
        checkLock
    end
    
    methods
        function o=DiscretePositionsUsePanel(parentC,controller)
            o.controller=controller;
            o.parentC=parentC;
            o.updateList={};
            
            labels=o.controller.labels;
            
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1], 'HorizontalWeight',[1],'Margin',1);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[2,1], 'VerticalWeight',[1 4],'Margin',1);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1],'Margin',1);
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 0.3 0.3],'Margin',1);
            hghv1h2v1= uigridcontainer('v0','Parent',hghv1h2,'Units','norm','Position',[0,0,1,1],'GridSize',[length(labels),1],'Margin',1);
            hghv1h2v2= uigridcontainer('v0','Parent',hghv1h2,'Units','norm','Position',[0,0,1,1],'GridSize',[length(labels),1],'Margin',1);
            hghv1h2v3= uigridcontainer('v0','Parent',hghv1h2,'Units','norm','Position',[0,0,1,1],'GridSize',[length(labels),1],'Margin',1);
            
            uicontrol('Parent',hghv1h1,'style','text','string',sprintf('Position'));  
            o.textPosition=uicontrol('Parent',hghv1h1,'style','text');  
            
            for i=1:length(o.controller.labels)
                o.push{i}=uicontrol('Parent',hghv1h2v1,'style','push','string',o.controller.labels{i});
                set(o.push{i},'Callback',@(s,e)pushed(o,s,e))
                o.pushSave{i}=uicontrol('Parent',hghv1h2v2,'style','push','string','Save');
                set(o.pushSave{i},'Callback',@(s,e)pushedSave(o,s,e))
            end
            
            
            o.checkLock=uicontrol('Parent',hghv1h2v3,'style','check','string','','Value',true);
            set(o.checkLock,'Callback',@(s,e)checkedLock(o,s,e))
                        
            update(o,true);
            
            o.checkedLock(0,0);
        end
        
        function pushed(o,s,e)
            o.controller.setPosition(get(s,'String'));
            update(o,true);
        end   
        
        function pushedSave(o,s,e)

            ind=[];
            for i=1:length(o.pushSave)
                if(s==o.pushSave{i})
                    ind=i;
                    break;
                end         
            end

            if(~isempty(ind))
                o.controller.save(ind);
            end
            update(o,true);
        end
        
        
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            position=o.controller.position();
            set(o.textPosition,'string',position);
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
        
        function checkedLock(o,s,e)
            if(get(o.checkLock,'Value'))
                for i=1:length(o.pushSave)
                    set(o.pushSave{i},'Enable','off')
                end
            else
                for i=1:length(o.pushSave)
                    set(o.pushSave{i},'Enable','on')
                end
            end
        end
    end
    
end

