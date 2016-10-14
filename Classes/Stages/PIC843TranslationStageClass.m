% (c) Alvaro Sanchez Gonzalez 2014
classdef PIC843TranslationStageClass<AbstractStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serial
        controller
    end
    
    methods
        function o = PIC843TranslationStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            o.controller = C843_GCS_Controller();
            o.controller = o.controller.Connect(1);
            o.controller = o.controller.InitializeController();
            o.controller.qIDN();
            o.controller.CST(o.serial,'M-403.4PD');
            o.controller.INI(o.serial);
            o.controller.FNL(o.serial)
            bReferencing = 1;
            while(bReferencing)
                pause(.1);
                bReferencing = (o.controller.IsReferencing('1')==1);
            end                        
            o.pos=o.controller.qPOS(o.serial)*1e3;
        end
        function destroy(o)
            delete(o.controller);
        end
        
        
        function outPosition=gotoPosition(o,position)
            o.controller.MOV(o.serial,position/1e3);
            ismoving = 1;
            while(ismoving)
                pause(0.1);
                ismoving = (o.controller.IsMoving(o.serial)==1);
                temp = o.controller.qPOS(o.serial);
            end
            outPosition=o.controller.qPOS(o.serial)*1e3;
        end
              
        function updatePosition(o)
        end
        
        function minPos=minPosition(o)
            minPos=0;            
        end
        function maxPos=maxPosition(o)
            maxPos=100e3;  
        end
    end    
end

