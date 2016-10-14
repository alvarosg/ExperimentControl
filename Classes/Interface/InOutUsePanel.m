% (c) Alvaro Sanchez Gonzalez 2014
classdef InOutUsePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        parentC
        textPosition
        
        pushIn
        pushOut
        pushSaveIn
        pushSaveOut
        updateList
        checkLock
    end
    
    methods
        function o=InOutUsePanel(parentC,controller)
            o.controller=controller;
            o.parentC=parentC;
            o.updateList={};
            
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1], 'HorizontalWeight',[1]);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[3,1], 'VerticalWeight',[1 1 1]);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 0.3]);
            hghv1h3 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 0.3]);
            
            uicontrol('Parent',hghv1h1,'style','text','string',sprintf('Position'));  
            o.textPosition=uicontrol('Parent',hghv1h1,'style','text');  
            
            o.pushIn=uicontrol('Parent',hghv1h2,'style','push','string','In');
            set(o.pushIn,'Callback',@(s,e)pushedIn(o,s,e))
            o.pushOut=uicontrol('Parent',hghv1h2,'style','push','string','Out');
            set(o.pushOut,'Callback',@(s,e)pushedOut(o,s,e))
            
            o.pushSaveIn=uicontrol('Parent',hghv1h3,'style','push','string','Save In');
            set(o.pushSaveIn,'Callback',@(s,e)pushedSaveIn(o,s,e))
            o.pushSaveOut=uicontrol('Parent',hghv1h3,'style','push','string','Save Out');
            set(o.pushSaveOut,'Callback',@(s,e)pushedSaveOut(o,s,e))
            
            o.checkLock=uicontrol('Parent',hghv1h3,'style','check','string','','Value',true);
            set(o.checkLock,'Callback',@(s,e)checkedLock(o,s,e))
                        
            update(o,true);
            
            o.checkedLock(0,0);
        end
        
        function pushedIn(o,s,e)
            o.controller.setPosition('in');
            update(o,true);
        end   
        function pushedOut(o,s,e)
            o.controller.setPosition('out');
            update(o,true);
        end 
        
        function pushedSaveIn(o,s,e)
            o.controller.saveIn();
            update(o,true);
        end
        
        function pushedSaveOut(o,s,e)
            o.controller.saveOut();
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
                set(o.pushSaveIn,'Enable','off')
                set(o.pushSaveOut,'Enable','off')
            else
                set(o.pushSaveIn,'Enable','on')
                set(o.pushSaveOut,'Enable','on')
            end
        end
    end
    
end

