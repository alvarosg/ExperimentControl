% (c) Alvaro Sanchez Gonzalez 2014
classdef ScanVariable<handle
    %SCANVARIABLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        positions
        scanOrder
        minVal
        maxVal
        step
        reorder
    end
    
    methods
        function o=ScanVariable(controller)
            o.minVal=controller.minPosition();
            o.maxVal=controller.maxPosition();
            o.controller=controller;
            o.step=(o.maxVal-o.minVal)/10;
            o.reorder=false;
            o.setPositions(o.minVal,o.maxVal,o.step);
        end
        
        function setPositions(o,minVal,maxVal,step)
            minPos=o.controller.minPosition();
            maxPos=o.controller.maxPosition();
            minVal=max([minPos,minVal]);
            maxVal=max([minPos,maxVal]);
            minVal=min([maxPos,minVal]);
            maxVal=min([maxPos,maxVal]);
            if(minVal>maxVal)
                step=-1*abs(step);
            else
                step=abs(step);
            end
            o.positions=minVal:step:maxVal;
            o.minVal=o.positions(1);
            o.maxVal=o.positions(end);
            o.step=step;
            
            N=length(o.positions);
            if(o.reorder)
                if(rem(N,2)==1)
                    o.scanOrder=[1:2:N N-1:-2:2];
                else
                    o.scanOrder=[1:2:N N:-2:2];
                end
            else
                o.scanOrder=1:N;
            end
        end
        
        function nSteps=steps(o)
            nSteps=length(o.positions);
        end
        
        function setReorder(o,reorder)
            o.reorder=reorder;
            o.setPositions(o.minVal,o.maxVal,o.step);
        end
        
        function setPositionIndex(o,index)
            o.controller.setPosition(o.positions(o.scanOrder(index)));
        end
    end
    
    methods (Static)
        function positionIndices=StagesIteration2PositionIndices(stageIteration,scanVariables)
            positionIndices=zeros(size(stageIteration));
            for i=1:length(scanVariables)
                positionIndices(i)=scanVariables{i}.scanOrder(stageIteration(i));
            end
        end
    end
    
end

