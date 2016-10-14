% (c) Alvaro Sanchez Gonzalez 2014
classdef IrisUsePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        parentC
        textPosition
        textInterval
        editPosition
        editIncrement
        pushIncrease
        pushDecrease
        updateList
    end
    
    methods
        function o=IrisUsePanel(parentC,controller)
            o.controller=controller;
            o.parentC=parentC;
            o.updateList={};
            
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1], 'HorizontalWeight',[1]);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[4,1], 'VerticalWeight',[1 1 1 1]);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            hghv1h3 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            hghv1h4 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,4], 'HorizontalWeight',[1.1 0.6 0.2 0.2]);
            
            uicontrol('Parent',hghv1h1,'style','text','string',sprintf('Position (%s)',o.controller.units()));            
            uicontrol('Parent',hghv1h2,'style','text','string',sprintf('Interval (%s)',o.controller.units()));            
            uicontrol('Parent',hghv1h3,'style','text','string',sprintf('Set Position (%s)',o.controller.units()));             
            uicontrol('Parent',hghv1h4,'style','text','string',sprintf('Increments (%s)',o.controller.units())); 
            
            o.textPosition=uicontrol('Parent',hghv1h1,'style','text');  
            o.textInterval=uicontrol('Parent',hghv1h2,'style','text');
            o.editPosition=uicontrol('Parent',hghv1h3,'style','edit','BackgroundColor','white'); 
            set(o.editPosition,'Callback',@(s,e)changedEdit(o,s,e))
            o.editIncrement=uicontrol('Parent',hghv1h4,'style','edit','BackgroundColor','white','string',1);
            o.pushDecrease=uicontrol('Parent',hghv1h4,'style','push','string','<');
            set(o.pushDecrease,'Callback',@(s,e)pushedDecrease(o,s,e))
            o.pushIncrease=uicontrol('Parent',hghv1h4,'style','push','string','>');
            set(o.pushIncrease,'Callback',@(s,e)pushedIncrease(o,s,e))
            
            update(o,true);
        end
        
        function changedEdit(o,s,e)
            position=str2num(get(o.editPosition,'string'));
            if(~isempty(position))
                o.controller.setPosition(position);
                update(o,true);
            end
        end
        
        function pushedDecrease(o,s,e)
            increment=str2num(get(o.editIncrement,'string'));
            if(~isempty(increment))
                position=o.controller.position();
                o.controller.setPosition(position-increment(1));
                update(o,true);
            end
        end
        
        function pushedIncrease(o,s,e)
            increment=str2num(get(o.editIncrement,'string'));
            if(~isempty(increment))
                position=o.controller.position();
                o.controller.setPosition(position+increment(1));
                update(o,true);
            end
        end
        
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            position=o.controller.position();
            set(o.textPosition,'string',sprintf('%7.3f',position));
            %set(o.editPosition,'string',num2str(position));
            set(o.textInterval,'string',sprintf('(%g,%g)',o.controller.minPosition(),o.controller.maxPosition()));
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
    end
    
end

