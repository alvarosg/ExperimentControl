% (c) Alvaro Sanchez Gonzalez 2014
classdef ScanVariablePanel<handle
    %GENERICUSEPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scanVariable
        parentC
        textSteps
        textInterval
        editStart
        editEnd
        editStep
        checkReorder

        updateList
    end
    
    methods
        function o=ScanVariablePanel(parentC,scanVariable)
            o.scanVariable=scanVariable;
            o.parentC=parentC;
            o.updateList={};
            
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1], 'HorizontalWeight',[1]);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[2,1], 'VerticalWeight',[1 1]);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,5], 'HorizontalWeight',[1 2 1 1 1]);
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,6], 'HorizontalWeight',[1 1 1 1 1 1]);
                       
            uicontrol('Parent',hghv1h1,'style','text','string',sprintf('Interval (%s)',o.scanVariable.controller.units()));  
            o.textInterval=uicontrol('Parent',hghv1h1,'style','text');
            uicontrol('Parent',hghv1h1,'style','text','string',sprintf('Steps')); 
            o.textSteps=uicontrol('Parent',hghv1h1,'style','text');
            
            o.checkReorder=uicontrol('Parent',hghv1h1,'style','check','string',sprintf('Reorder')); 
            set(o.checkReorder,'Callback',@(s,e)checkedReorder(o,s,e))
            
            uicontrol('Parent',hghv1h2,'style','text','string',sprintf('Start (%s)',o.scanVariable.controller.units()));
            o.editStart=uicontrol('Parent',hghv1h2,'style','edit','BackgroundColor','white'); 
            set(o.editStart,'Callback',@(s,e)changedEdit(o,s,e))
                                 
            uicontrol('Parent',hghv1h2,'style','text','string',sprintf('Step (%s)',o.scanVariable.controller.units()));
            o.editStep=uicontrol('Parent',hghv1h2,'style','edit','BackgroundColor','white');
            set(o.editStep,'Callback',@(s,e)changedEdit(o,s,e))
            
            uicontrol('Parent',hghv1h2,'style','text','string',sprintf('End (%s)',o.scanVariable.controller.units()));
            o.editEnd=uicontrol('Parent',hghv1h2,'style','edit','BackgroundColor','white');
            set(o.editEnd,'Callback',@(s,e)changedEdit(o,s,e))
            
            
            
            update(o,true);
        end
        
        function changedEdit(o,s,e)
            vstart=str2num(get(o.editStart,'string'));
            vend=str2num(get(o.editEnd,'string'));
            vstep=str2num(get(o.editStep,'string'));
            o.scanVariable.setPositions(vstart,vend,vstep);
            update(o,true);
        end
        
        function checkedReorder(o,s,e)
            o.scanVariable.setReorder(get(o.checkReorder,'Value'));
            update(o,true);
        end
        

        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            set(o.checkReorder,'Value',o.scanVariable.reorder);
            set(o.editStart,'string',num2str(o.scanVariable.minVal));
            set(o.editEnd,'string',num2str(o.scanVariable.maxVal));
            set(o.editStep,'string',num2str(o.scanVariable.step));
            set(o.textSteps,'string',sprintf('%i',o.scanVariable.steps()));
            set(o.textInterval,'string',sprintf('(%g,%g)',o.scanVariable.controller.minPosition(),o.scanVariable.controller.maxPosition()));
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(true);
                end
            end
        end
    end
    
end

