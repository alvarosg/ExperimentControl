% (c) Alvaro Sanchez Gonzalez 2014
classdef StageVariableControlPanel<handle
    %STAGEVARIABLECONTROLPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageControllerPanel
        useControllerPanel
        pushLoad
        pushSave
        parentC
        checkLock
        
    end
    
    methods
        function o=StageVariableControlPanel(parentC,stageController,useController)            
            o.parentC=parentC;
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 0.5]);
            o.stageControllerPanel=GenericUsePanel(hgh,stageController);
            o.useControllerPanel=GenericUsePanel(hgh,useController);
            o.stageControllerPanel.addUpdateList(o.useControllerPanel)
            o.useControllerPanel.addUpdateList(o.stageControllerPanel)
            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[3,1], 'VerticalWeight',[1 1 1]);
            o.pushLoad=uicontrol('Parent',hghv1,'style','push','string','Load 0');
            set(o.pushLoad,'Callback',@(s,e)pushedLoad(o,s,e))
            o.pushSave=uicontrol('Parent',hghv1,'style','push','string','Save 0');
            set(o.pushSave,'Callback',@(s,e)pushedSave(o,s,e))
            o.checkLock=uicontrol('Parent',hghv1,'style','check','string','Lock Save','Value',true);
            set(o.checkLock,'Callback',@(s,e)checkedLock(o,s,e))
            
            o.checkedLock(0,0);
        end
        function pushedLoad(o,s,e)
            o.useControllerPanel.controller.set0();
            o.useControllerPanel.update(true);
        end
        function pushedSave(o,s,e)
            o.useControllerPanel.controller.save0();
            o.useControllerPanel.update(true);
        end
        function checkedLock(o,s,e)
            if(get(o.checkLock,'Value'))
                set(o.pushSave,'Enable','off')
            else
                set(o.pushSave,'Enable','on')
            end
        end
    end
end

