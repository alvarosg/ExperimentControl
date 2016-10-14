% (c) Alvaro Sanchez Gonzalez 2014
classdef StagesPositionRecorderAcquisitionDevice<AbstractAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        stageControllerPanel
        positions
    end
    
    methods
        function o=StagesPositionRecorderAcquisitionDevice(deviceInfo,stageControllerPanel)
            o = o@AbstractAcquisitionDevice(deviceInfo);  
            o.stageControllerPanel=stageControllerPanel;
            
        end
        
        function initialize(o)
            o.setExtraParam(o.deviceInfo.extraparam)
            o.exposure=0;
        end
        
        function delete(o)
        end    
        
        function destroy(o)
        end         
        
        function setExposure(o,msExposure)
            o.exposure=0;
        end
        
        function msExposure = getExposure(o)
            msExposure=o.exposure;
        end
        
        function setExtraParam(o,extraparam)       
            o.deviceInfo.extraparam=extraparam;            
        end
                
        function resetBuffer(o)                  
            o.positions={}; 
        end
        function acquisition(o)
            o.positions={};
            for i=1:length(o.stageControllerPanel.initElements)
                if (~ischar(o.stageControllerPanel.initElements{i}.stageController))
                    o.positions{i}.stageInfo=o.stageControllerPanel.initElements{i}.stageController.stageInfo;
                    o.positions{i}.stagePos=o.stageControllerPanel.initElements{i}.stageController.position();  
                    o.positions{i}.stageUnits=StageTypes.getNameUnits(o.positions{i}.stageInfo.type);
                else    
                    o.positions{i}.stageInfo=o.stageControllerPanel.initElements{i}.useController.stageInfo;
                    o.positions{i}.stagePos='N/A';  
                    o.positions{i}.stageUnits='N/A';
                end
                if(~strcmp(o.positions{i}.stageInfo.use,'external'))                    
                    o.positions{i}.usePos=o.stageControllerPanel.initElements{i}.useController.position();
                    o.positions{i}.useUnits=StageUses.getNameUnits(o.positions{i}.stageInfo.use);
                else
                    o.positions{i}.usePos='N/A';
                    o.positions{i}.useUnits='N/A';
                end
            end           
        end
        function positions=retrieve(o)
            positions=o.positions; %Create a copy    
        end
        
        function positions=retrieveReduced(o)
            positions=o.positions; %Create a copy
        end
        
        function show(o)
        end
               
        
        function state=isStillValid(o)
            state=true;
        end
    end    
end
