% (c) Alvaro Sanchez Gonzalez 2014
classdef Positioner3DControlPanel<handle
    %STAGEVARIABLECONTROLPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        useControllerPanelList
        %pushLoad
        %pushSave
        parentC
        %checkLock        
        stageControllerPanel
        useController
    end
    
    methods
        function o=Positioner3DControlPanel(parentC,useController)            
            o.parentC=parentC;
            o.useController=useController;
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 1]);

            o.useControllerPanelList{1}=IndividualAxisPanel(hgh,useController.singleUseController(1),'X axis');
            o.useControllerPanelList{2}=IndividualAxisPanel(hgh,useController.singleUseController(2),'Y axis');
            o.useControllerPanelList{3}=IndividualAxisPanel(hgh,useController.singleUseController(3),'Z axis');
            o.stageControllerPanel=o.useControllerPanelList{1};
            
            
            %hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[3,1], 'VerticalWeight',[1 1 1]);
            %o.pushLoad=uicontrol('Parent',hghv1,'style','push','string','Load 0');
            %set(o.pushLoad,'Callback',@(s,e)pushedLoad(o,s,e))
            %o.pushSave=uicontrol('Parent',hghv1,'style','push','string','Save 0');
            %set(o.pushSave,'Callback',@(s,e)pushedSave(o,s,e))
            %o.checkLock=uicontrol('Parent',hghv1,'style','check','string','Lock Save','Value',true);
            %set(o.checkLock,'Callback',@(s,e)checkedLock(o,s,e))
            
            %o.checkedLock(0,0);
        end
%         function pushedLoad(o,s,e)
%             o.useControllerPanel.controller.set0();
%             o.useControllerPanel.update(true);
%         end
%         function pushedSave(o,s,e)
%             o.useControllerPanel.controller.save0();
%             o.useControllerPanel.update(true);
%         end
%         function checkedLock(o,s,e)
%             if(get(o.checkLock,'Value'))
%                 set(o.pushSave,'Enable','off')
%             else
%                 set(o.pushSave,'Enable','on')
%             end
%         end
        function destroy(o)
            delete(o.useController);
        end

        function delete(o)
            delete(o.useController);
        end           
    end
end

