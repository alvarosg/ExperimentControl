% (c) Alvaro Sanchez Gonzalez 2014
classdef ThorlabsRotationStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        controller
        data
    end
    
    methods
        function o = ThorlabsRotationStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            o.controller = MGMotorControl_XiHHG('WindowStyle','Docked');
            o.data = guidata(o.controller);
            set(o.controller,'name',o.stageInfo.name,'numbertitle','off')
            set(o.data.serial,'String',o.serial)
            MGMotorControl_XiHHG('start_control_Callback', o.controller, [], o.data);      
            o.pos=o.data.activex1.GetPosition_Position(0);
        end
        function destroy(o)
            delete(o.controller);
        end
        function outPosition=gotoPosition(o,position)
            o.data.activex1.SetAbsMovePos(0, position);
            drawnow
            o.data.activex1.MoveAbsolute(0, true);
            outPosition=o.data.activex1.GetPosition_Position(0);
        end
        
        function updatePosition(o)
            o.pos=o.data.activex1.GetPosition_Position(0);
        end
               
        function minPos=minPosition(o)
            minPos=o.data.activex1.GetStageAxisInfo_MinPos(0);            
        end
        function maxPos=maxPosition(o)
            maxPos=o.data.activex1.GetStageAxisInfo_MaxPos(0);  
        end
        
        function home(o)
            home@AbstractStageClass(o)
            MessageSystem.get().printMessage('STAGE',sprintf('Homing %s',o.stageInfo.name),false);
            o.data.activex1.MoveHome(0,1);
            MessageSystem.get().printMessage('STAGE',sprintf('%s homed',o.stageInfo.name),true);
            o.pos=o.data.activex1.GetPosition_Position(0)*1e3;
        end
    end    
end

